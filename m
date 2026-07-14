Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A01C36A033
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 06:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009026; cv=none; b=HpzuuWhoLgsekDApX4i0x10CLg1XX3bprlseSOvZ2s94ei4POgt9nmW4TUHZqRh+tji4YGXT62X/mBxhTOJR/LgtrpT/Ah/ZblTKxzfZ66vF82AEl0xuqaTXZFy38oUHZfzKYEuEmz2/oAnqE5YqTklww5nZifDIYYB3K7Z0hNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009026; c=relaxed/simple;
	bh=H04BTfdo0495sRG3D9WLgcHE5VDpQZDjYdd6OMe/mcg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tV72JcgOVGbRg21sopNES/DeSZ0mH3bGD82CyxEakiLAyWeyKaPUruAr9ZGOCirWBqxjma0kT0HtU6Np2ssLApw8bxVtQIV30CPmUnxOHp3DLcoq0XgJ0OYP/2kSGjbNFIviILg/+ydV9AuSaBQrN1WC8X14A2u1RGgdQtTnFNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJ3XafZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJ3XafZp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2C0FE1F000E9;
	Tue, 14 Jul 2026 06:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009025;
	bh=nbyG3Db0TteVr/Mj2aR+GzZ5ZhVZmxg00KFvw+uvJBQ=;
	h=Date:From:To:Cc:Subject;
	b=ZJ3XafZpO2yp8H3z2s0A+tom7sPku8E29qCw9nReocjnwhiBpFku9fTXysYziISOI
	 mO9QQjFTQLFaszpliQraZau+TLZ1X1jvBZmhVrju7xvVLps4fjMzLNS2GUmpKrUMQQ
	 +feMF/rMeRa54olf4GUuWT1tMlxGmdJMnxezaySInvTubkroLvaXAe0bST1VLA+HX+
	 UNlFK4ibAhrhM0xoGMWYPUIiieoVc2iHCazLZJHkQe5mMusXfBGxPQel9utqaTctaO
	 EmktSHeYwLKfnpUTakcMuBlm9LCJ3EbWjYS8W9K9hCxk1XOTAeSy/7O1XBy6UT6882
	 aO6RVmhgAQT/Q==
Date: Mon, 13 Jul 2026 23:03:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: resample the data fork mapping after cycling ILOCK
Message-ID: <20260714060344.GA7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

xfs_reflink_fill_{cow_hole,delalloc} are both presented with an inode,
a data fork mapping, and a cow fork mapping.  Unfortunately, these two
helpers cycle the ILOCK to grab a transaction, which means that the
mappings are stale as soon as we reacquire the ILOCK.  Currently we
refresh the cow fork mapping by re-calling xfs_find_trim_cow_extent, but
we don't refresh the data fork mapping beforehand, which means that the
xfs_bmap_trim_cow in that function queries the refcount btree about the
wrong physical blocks and returns an inaccurate value in *shared.

If *shared is now false, the directio write proceeds with a stale data
fork mapping.  Fix this by querying the data fork mapping if the
sequence counter changes across the ILOCK cycle.

Cc: <hch@lst.de>
Cc: <stable@vger.kernel.org> # v4.11
Fixes: 3c68d44a2b49a0 ("xfs: allocate direct I/O COW blocks in iomap_begin")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d81510912be58b..489ecd4cf10aff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -440,6 +440,7 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
+	unsigned int		seq_before = READ_ONCE(ip->i_df.if_seq);
 	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
@@ -465,6 +466,22 @@ xfs_reflink_fill_cow_hole(
 
 	*lockmode = XFS_ILOCK_EXCL;
 
+	/*
+	 * The data fork mapping may have changed while we dropped the ILOCK
+	 * (a racing O_DIRECT writer under IOLOCK_SHARED can complete a full
+	 * CoW cycle including xfs_reflink_end_cow(), which remaps this offset
+	 * and drops the refcount of the old shared block).  Re-read it so the
+	 * shared-status recheck below and the caller's in-place iomap both
+	 * operate on the current mapping rather than a stale physical block.
+	 */
+	if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, imap->br_startoff,
+				imap->br_blockcount, imap, &nimaps, 0);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
 	if (error || !*shared)
 		goto out_trans_cancel;
@@ -511,6 +528,8 @@ xfs_reflink_fill_delalloc(
 	bool			found;
 
 	do {
+		unsigned int	seq_before = READ_ONCE(ip->i_df.if_seq);
+
 		xfs_iunlock(ip, *lockmode);
 		*lockmode = 0;
 
@@ -521,6 +540,23 @@ xfs_reflink_fill_delalloc(
 
 		*lockmode = XFS_ILOCK_EXCL;
 
+		/*
+		 * The data fork mapping may have changed while we dropped the
+		 * ILOCK (a racing O_DIRECT writer under IOLOCK_SHARED can
+		 * complete a full CoW cycle including xfs_reflink_end_cow(),
+		 * which remaps this offset and drops the refcount of the old
+		 * shared block).  Re-read it so the shared-status recheck
+		 * below and the caller's in-place iomap both operate on the
+		 * current mapping rather than a stale physical block.
+		 */
+		if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
+			nimaps = 1;
+			error = xfs_bmapi_read(ip, imap->br_startoff,
+					imap->br_blockcount, imap, &nimaps, 0);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
 				&found);
 		if (error || !*shared)
