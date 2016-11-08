Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753767AbcKHU1h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Nov 2016 15:27:37 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DC6D61BA8
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2016 20:27:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uA8KRbOq005419
        for <linux-xfs@vger.kernel.org>; Tue, 8 Nov 2016 15:27:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 4/4] xfs: implement basic COW fork speculative preallocation
Date: Tue,  8 Nov 2016 15:27:36 -0500
Message-Id: <1478636856-7590-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

COW fork preallocation is currently limited to what is specified by the
COW extent size hint, which is typically much less aggressive than
traditional speculative preallocation added when sufficiently large
files are extended. This type of algorithm is not relevant for COW
reservation since by design, COW reservation never involves extending
the size of a file.

That said, we can be more aggressive with COW fork preallocation given
that we have extended the same inode tagging and reclaim infrastructure
used for post-eof preallocation to support COW fork preallocation. This
provides the ability to reclaim COW fork preallocation in the background
or on demand.

As such, add a simple COW fork speculative preallocation algorithm that
extends COW fork reservations due to file writes out to the next data
fork extent, unshared boundary or the next preexisting extent in the COW
fork, whichever limit we hit first. This provides a prealloc algorithm
that, like post-eof speculative preallocation, is based on the size of
preexisting extents.

XXX: This requires refinements such as throttling, reclaim, etc., as
noted in the comments.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 40bf66c..43936aa 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -540,8 +540,11 @@ xfs_file_iomap_begin_delay(
 	struct xfs_bmbt_irec	got;
 	struct xfs_bmbt_irec	prev;
 	struct xfs_bmbt_irec	imap;	/* for iomap */
+	struct xfs_bmbt_irec	drec;	/* raw data fork record */
 	xfs_extnum_t		idx;
 	int			fork = XFS_DATA_FORK;
+	bool			shared;
+	bool			trimmed;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
@@ -574,11 +577,9 @@ xfs_file_iomap_begin_delay(
 	 */
 	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
 			&got, &prev);
-	imap = got;
+	drec = imap = got;
 	if (!eof && got.br_startoff <= offset_fsb) {
 		if (xfs_is_reflink_inode(ip)) {
-			bool		shared, trimmed;
-
 			/*
 			 * Assume the data extent is shared if an extent exists
 			 * in the cow fork.
@@ -651,6 +652,47 @@ xfs_file_iomap_begin_delay(
 			end_fsb = min(end_fsb, maxbytes_fsb);
 			ASSERT(end_fsb > offset_fsb);
 		}
+	} else if (fork == XFS_COW_FORK && !trimmed) {
+		struct xfs_bmbt_irec	tmp = drec;
+		xfs_extlen_t		len;
+
+		/*
+		 * If we get here, we have a shared data extent without a COW
+		 * fork reservation and the range of the write doesn't cross an
+		 * unshared boundary. To implement COW fork preallocation,
+		 * allocate as much as possible up until the next data fork
+		 * extent, the next data fork unshared boundary or the next
+		 * existing extent in the COW fork.
+		 */
+		ASSERT(shared && offset_fsb >= tmp.br_startoff);
+
+		/*
+		 * Trim the original data fork extent to the start of the write
+		 * and the next unshared boundary. This defines the maximum COW
+		 * fork preallocation. bmapi_reserve_delalloc() will trim to the
+		 * next COW fork extent (got) if one exists.
+		 */
+		len = tmp.br_blockcount - (offset_fsb - tmp.br_startoff);
+		xfs_trim_extent(&tmp, offset_fsb, len);
+		error = xfs_reflink_trim_around_shared(ip, &tmp, &shared,
+						       &trimmed);
+		if (error)
+			goto out_unlock;
+		ASSERT(shared);
+		end_fsb = tmp.br_startoff + tmp.br_blockcount;
+
+		/*
+		 * TODO:
+		 * - Throttling based on low free space conditions (try to
+		 *   refactor into xfs_iomap_prealloc_size()).
+		 * - Associated scan/reclaim mechanism on buffered write ENOSPC.
+		 * - Alignment? Might not want to overlap unshared blocks.
+		 *   bmapi_reserve_delalloc() might do this anyways due to
+		 *   cowextszhint.
+		 * - Adopt similar cowextsz hint behavior as for traditional
+		 *   extsz hint? E.g., cowextsz hint overrides prealloc?
+		 * 	- allocsize mount option?
+		 */
 	}
 
 retry:
-- 
2.7.4

