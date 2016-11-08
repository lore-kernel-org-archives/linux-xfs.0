Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753412AbcKHU1h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Nov 2016 15:27:37 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D8CC61BB2
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2016 20:27:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uA8KRbT8016841
        for <linux-xfs@vger.kernel.org>; Tue, 8 Nov 2016 15:27:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 1/4] xfs: clean up cow fork reservation and tag inodes correctly
Date: Tue,  8 Nov 2016 15:27:33 -0500
Message-Id: <1478636856-7590-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

COW fork reservation is implemented via delayed allocation. The code is
modeled after the traditional delalloc allocation code, but is slightly
different in terms of how preallocation occurs. Rather than post-eof
speculative preallocation, COW fork preallocation is implemented via a
COW extent size hint that is designed to minimize fragmentation as a
reflinked file is split over time.

xfs_reflink_reserve_cow() still uses logic that is oriented towards
dealing with post-eof speculative preallocation, however, and is stale
or not necessarily correct. First, the EOF alignment to the COW extent
size hint is implemented in xfs_bmapi_reserve_delalloc() (which does so
correctly by aligning the start and end offsets) and so is not necessary
in xfs_reflink_reserve_cow(). The backoff and retry logic on ENOSPC is
also ineffective for the same reason, as xfs_bmapi_reserve_delalloc()
will simply perform the same allocation request on the retry. Finally,
since the COW extent size hint aligns the start and end offset of the
range to allocate, the end_fsb != orig_end_fsb logic is not sufficient.
Indeed, if a write request happens to end on an aligned offset, it is
possible that we do not tag the inode for COW preallocation even though
xfs_bmapi_reserve_delalloc() may have preallocated at the start offset.

Kill the unnecessary, duplicate code in xfs_reflink_reserve_cow() and
update the preallocation tag logic to check whether the bmap allocation
actually matches the range that was requested.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a279b4e..b19a7e0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -244,11 +244,9 @@ xfs_reflink_reserve_cow(
 	bool			*shared)
 {
 	struct xfs_bmbt_irec	got, prev;
-	xfs_fileoff_t		end_fsb, orig_end_fsb;
 	int			eof = 0, error = 0;
 	bool			trimmed;
 	xfs_extnum_t		idx;
-	xfs_extlen_t		align;
 
 	/*
 	 * Search the COW fork extent list first.  This serves two purposes:
@@ -285,32 +283,14 @@ xfs_reflink_reserve_cow(
 	if (error)
 		return error;
 
-	end_fsb = orig_end_fsb = imap->br_startoff + imap->br_blockcount;
 
-	align = xfs_eof_alignment(ip, xfs_get_cowextsz_hint(ip));
-	if (align)
-		end_fsb = roundup_64(end_fsb, align);
-
-retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			end_fsb - imap->br_startoff, &got, &prev, &idx, eof);
-	switch (error) {
-	case 0:
-		break;
-	case -ENOSPC:
-	case -EDQUOT:
-		/* retry without any preallocation */
-		trace_xfs_reflink_cow_enospc(ip, imap);
-		if (end_fsb != orig_end_fsb) {
-			end_fsb = orig_end_fsb;
-			goto retry;
-		}
-		/*FALLTHRU*/
-	default:
+			imap->br_blockcount, &got, &prev, &idx, eof);
+	if (error)
 		return error;
-	}
 
-	if (end_fsb != orig_end_fsb)
+	if (imap->br_startoff != got.br_startoff ||
+	    imap->br_blockcount != got.br_blockcount)
 		xfs_inode_set_cowblocks_tag(ip);
 
 	trace_xfs_reflink_cow_alloc(ip, &got);
-- 
2.7.4

