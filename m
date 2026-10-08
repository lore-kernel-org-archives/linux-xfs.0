Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB93A311597;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423571; cv=none; b=frSrW0/qTfuojYuh3Wv8FNm2S85VjtjNm3Yt7jZaAkAKWRAFCVBhi8dDyLEU3ExUT4Id/W0RIU7bO/AKBZTsIJY7XEhxTs/C0rfJkPTzvzi4lKCpJm/+xgIJFWuI/uvE28CZTHu7CmiFU4iOFdnWa+SsYyHBJblI7cqr4LMJKxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423571; c=relaxed/simple;
	bh=IWvscPqZD+2FUUBIFhh4IW8VGsM/ztweP+mTXjTQtTk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JvWUyiq5E3yeF3/nBbLlU4qiMlUTTqUd5CZ5vhb7t8lwXxLIbT360pGlXwVa0SCGWp+fiTe1zxuc5bcikpEwzwuk7YxqswWVxJSc2awUU4fsjWDcztKqBoobA/e7IvHtWlP3C+c1tu0rvYDp03lPQORutml2gG96WUKvtkaBPJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCXDIZH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCXDIZH6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BEB5C4AF68;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791423571;
	bh=IWvscPqZD+2FUUBIFhh4IW8VGsM/ztweP+mTXjTQtTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FCXDIZH6GGWnrecCvZEL+uH1UHNwBnWn+o1D911y9uTLkUwqij1jf8Hg7Xv94Nk9T
	 J2l2j4bSZ2EQX27br+k4Z6OP3daeT3yKgwtixl8LrzJtTDk0HrCndAzNXzl3QsB1Sb
	 0nqwh9qTxqHJqbyQ8uj45vjuZYpZareh9wNPxt+6lRW6DMvgpKCXRrrmPfsIUfJPoE
	 nwPUpcKWb1Q4bt/759PkYarlkvqlafggavfpPtU4Iy0SxHBQd1BeAgIGxAFAUDqOUY
	 xgAhURfRYScccRLaiAt4/psXu35STvTVqS46ZiDhhALf0+AKDSixyFrLnF/5zIaCH9
	 7IbDsMml95dtg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E082CA600E;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 08 Oct 2026 10:39:35 +0900
Subject: [PATCH 6/8] xfs: take the invalidate lock while mapping a pNFS
 layout
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-xfs-nfsd-map-blocks-v1-6-560026cdccb6@samsung.com>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791423569; l=2829;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=SoGkSsdBo1AOVeWmqni0fhA8dhue93sMO/J/2znJBnc=;
 b=FF7P8INtI1xHVpfqff95P6sYa6WY/b3VoJAQq6gbQdMlJ3Z2jYKWaMmFb06HNUlUSFAcRws6s
 woAXXV3vue+DmmN3dNntZuC4Rfd+fknOuWKe8fbPPOmJO9kRWGttHn+
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() flushes and invalidates the page cache of the file
under the iolock and then maps the range, but a write fault takes only
the invalidate lock (XFS_MMAPLOCK_SHARED in __xfs_write_fault()), not
the iolock. A fault on a shared mapping of the file can therefore add a
delalloc extent to the range between the flush and the mapping, which
trips the ASSERT on DELAYSTARTBLOCK, or is handed to nfsd, which warns
about a filesystem that returned a delalloc extent and refuses the
layout.

Take the invalidate lock in exclusive mode together with the iolock, as
__xfs_file_fallocate() does, so that page faults wait until the layout
has been mapped. The next patch maps all extents of a layout under these
locks, which makes the window between the flush and the last mapping
wider.

Not marked for stable: the race needs a process on the server that
writes to a shared mapping of the file while a client gets a layout for
the same range, and the comment above xfs_break_leased_layouts() already
leaves such writers unsynchronized with pNFS clients.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20260519145949.GH9555@frogsfrogsfrogs
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_pnfs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 81e1ae0351..bd6f7d5093 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -116,7 +116,7 @@ xfs_fs_map_update_inode(
 /*
  * Map the extent of a pNFS layout that starts at @offset_fsb, allocating it
  * first if it is a hole in a write layout. The mapping may end before or
- * after @end. Called with the iolock held.
+ * after @end. Called with the iolock and the invalidate lock held.
  */
 static int
 xfs_fs_map_extent(
@@ -225,8 +225,11 @@ xfs_fs_map_blocks(
 	 * similar to direct I/O, except that the synchronization is much more
 	 * complicated.  See the comment near xfs_break_leased_layouts
 	 * for a detailed explanation.
+	 *
+	 * Take the invalidate lock as well, so that page faults cannot add
+	 * delalloc extents to the range while it is being mapped.
 	 */
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	error = -EINVAL;
 	limit = mp->m_super->s_maxbytes;
@@ -262,14 +265,14 @@ xfs_fs_map_blocks(
 		if (error)
 			goto out_unlock;
 	}
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	error = xfs_bmbt_to_iomap(ip, iomaps, &imap, 0, 0, seq);
 	*nr_iomaps = 1;
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	return error;
 }
 

-- 
2.43.0


