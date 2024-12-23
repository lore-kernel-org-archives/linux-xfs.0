Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884EE13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991813; cv=none; b=QheaTMrHW3+FYdo++62VUgrebuYi9BpILREHq3TgQToqHGuMHHxyA1OTy13qFyvdrJZW9bmAweP1PyYCTQe7WwpOuvu41k5BIrS8Dl+T7pjUYS7q+XtIopXM5CfC660b/eQbWYkhTMRezTHKeezV4HdvqAZQ1gvkocYG8tccKMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991813; c=relaxed/simple;
	bh=mNjEjCuFkhKyGFh6v+1A0qG1Mkn8HagsyyjHcEtC20E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CHOHeM7dGaPj8a9kNcM0G1EweRNFTf91uYZS+N/eeVx2NYLrPSp3XvXCFbfROkLQ5WpeB8TPksTIYGoJeEqv76QBe4TN/NB0gVkJBznh8S+E7L1nNgqGlVFLkE/MBhnTZs17s2Mit229fi8W6pXz/nET9H6lrQT6xHBrytRmR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pxtblP2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pxtblP2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E378C4CED3;
	Mon, 23 Dec 2024 22:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991813;
	bh=mNjEjCuFkhKyGFh6v+1A0qG1Mkn8HagsyyjHcEtC20E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pxtblP2rc5Kyfqf8b63z9MRXpVd/1iIXdx5CpGgFSPtSSIrs/DRP7i0LIqfXvulES
	 kPN+DKvY2Nl8oCD1KT6XybZQIp0h0W9m4imRiI8WE4rXKNJy95bvOW0mldFdmjk9BH
	 hdlRcO2H4wgj1gwc8R2fRr3ETKj4VTapa9Qhn82a6Y2ebEzpI7eqnxUhiTv2N47U8k
	 TLbV5MNgrWK06o9MnopoSwIwlqRahalwh6XJtW/SnuYuSM07KGxPr+43G7zuQqq043
	 HGvq0NoWxdA0rdEPTNxWD6Or/DQw4muUfA9jcYAKk7aBJbSwOoOoGwCyHItwp+sUGV
	 A9Lz47pxnaafw==
Date: Mon, 23 Dec 2024 14:10:12 -0800
Subject: [PATCH 46/52] xfs: switch to multigrain timestamps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: josef@toxicpanda.com, rdunlap@infradead.org, jlayton@kernel.org,
 brauner@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943195.2295836.1992434893339325700.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jeff Layton <jlayton@kernel.org>

Source kernel commit: 1cf7e834a6fb84de9d1e038d6cf4c5bd0d202ffa

Enable multigrain timestamps, which should ensure that there is an
apparent change to the timestamp whenever it has been written after
being actively observed via getattr.

Also, anytime the mtime changes, the ctime must also change, and those
are now the only two options for xfs_trans_ichgtime. Have that function
unconditionally bump the ctime, and ASSERT that XFS_ICHGTIME_CHG is
always set.

Finally, stop setting STATX_CHANGE_COOKIE in getattr, since the ctime
should give us better semantics now.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # documentation bits
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20241002-mgtime-v10-9-d1c4717f5284@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_trans_inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 45b513bc5ceb40..90eec4d3592dea 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -59,12 +59,12 @@ xfs_trans_ichgtime(
 	ASSERT(tp);
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
-	tv = current_time(inode);
+	/* If the mtime changes, then ctime must also change */
+	ASSERT(flags & XFS_ICHGTIME_CHG);
 
+	tv = inode_set_ctime_current(inode);
 	if (flags & XFS_ICHGTIME_MOD)
 		inode_set_mtime_to_ts(inode, tv);
-	if (flags & XFS_ICHGTIME_CHG)
-		inode_set_ctime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_ACCESS)
 		inode_set_atime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)

