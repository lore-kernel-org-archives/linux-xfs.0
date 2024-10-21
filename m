Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD281EABB8;
	Mon, 21 Oct 2024 10:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507002; cv=none; b=FfukyF7bkipcjeCVI6hbSlJxc6htXmk16xod2w+GcSm30O+TkMYfQStLd5bA2n3xF5Db0/kraCmDSRiLpwnyKjELq7E9tt/t0WvAtCoJ8X1SPgUxuTMAn+fQtvijzqmz3bAei4dIZ6gti4SXdy+v3eiMRR2LcQfJuXO8bcNxPhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507002; c=relaxed/simple;
	bh=uHPsI7MCccMzFsTHdnvq7WMUk2tUE/bwVX7vkI/7a+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=likTtOnC2zRWot7UdUwbwgJzFgp6Brv02bVGd+gjs4wUN4F8iYiF5ksuDgRKhL7LklSvcHfX7biYuMkXK3yDMsk2uBte0pjVaFFtIE/WFYZ9dALQsNTFHKurvh+JYefJevwFlM2qmw56XTLKdFsea7uwvyQonqsJZFJVhX1bISU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LczmKOTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LczmKOTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFA0C4CEC3;
	Mon, 21 Oct 2024 10:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507001;
	bh=uHPsI7MCccMzFsTHdnvq7WMUk2tUE/bwVX7vkI/7a+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LczmKOTKC3eSnzWj/4XJHkXchoIaQ1P3jC0W2DLp6ESfcbqy5/uMKxLzKnErtHHmv
	 A5LjdP+Bnc84KF587rdXOP4vjsSroebyi9ENrNm/A4GcgPtCDiwmY3Zdku/vIP4l2b
	 FZmKWQJ63u64JmCWiXOZ+92dJfHyA9+HwZJoxSws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 026/124] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Mon, 21 Oct 2024 12:23:50 +0200
Message-ID: <20241021102257.737814241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 86de848403abda05bf9c16dcdb6bef65a8d88c41 upstream.

Accessing if_bytes without the ilock is racy.  Remove the initial
if_bytes == 0 check in xfs_reflink_end_cow_extent and let
ext_iext_lookup_extent fail for this case after we've taken the ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_reflink.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -716,12 +716,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);


