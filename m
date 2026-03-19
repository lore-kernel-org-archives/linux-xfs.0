Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA05C24BBEE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940179; cv=none; b=VBh1aVlZO6hXxRLC2+ShdKP3TaqaP0BwQZH6bGkv4+mE6OjXkyMM7PkutTlan1sF72GtD4nOwJtJDK8aqsZM13Gn4ZbBTQtTkss5iJ77tACuDH4sPPcY+7VmWnme60ud4FdYkSNA9aoGMT22yFEzRdZVA8j/9Vr8wmnTzCSFS1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940179; c=relaxed/simple;
	bh=LusobrZXLq62PS0Y8pYL4iCRSjCzTW+JHc1ANv5VA5U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L+MbCG8wA476onWjkyMjCK2v9GVcZ7O4NdbK3mkdnnEBgxX270JPLujDtsH+JFIZl8ZEeyuUQS3eWsGzFmYdrLCE12C3UukEOnQypCSLRwu98toD3tCmvL40dj7iUxEtimYxd0gJhvLf2Z3tCJtnF48Bd7Zp1sI9IMrlen9mT+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2CjXI+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2CjXI+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2618CC19424;
	Thu, 19 Mar 2026 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940179;
	bh=LusobrZXLq62PS0Y8pYL4iCRSjCzTW+JHc1ANv5VA5U=;
	h=Date:From:To:Cc:Subject:From;
	b=f2CjXI+BU87rBynJl0/d60Y/jrvuCOdcT3bFwFU/8Ojgp9OQjb+DKZxRKA7xdIQ4E
	 rwl2VtTVA13ZhPSkf4cz//CTojs+NqfkLu5t3YL1WYWvd2HZp8w96MwxChqYx5Xp7W
	 qv4TfqN9eGSpj9Db71xuBoCm1LYzUb21msaS4SClzJIg5dQbfIJlP4V74oRPVd+APW
	 6lhgnK5ZkPdgW1fVdJmD/gybu2ofgiFy0W7Z75XBX/TdqP0JZUTOs6IpTjw58P3kGo
	 RWDGV4CMC7ZOsdTPiFl2yiYa4l0lpm/4LXXuGqwyz2bkNzwWj/YfTl2VEm+PyA8qiN
	 75uehwPtDh3/w==
Date: Thu, 19 Mar 2026 10:09:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: [PATCH 1/2] xfs: don't allow UAF in xlog_recover_iget
Message-ID: <20260319170938.GS1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix this function to avoid touching the passed in ipp argument until
we're 100% certain that we're returning zero.  This avoids creating a
dangling pointer in the caller.  The xfs_irele call in
xfs_attri_recover_work was never correct and should go away.

Cc: <stable@vger.kernel.org> # v5.15
Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_recover.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca4878e..0e91a62348eb79 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1745,21 +1745,23 @@ xlog_recover_iget(
 	xfs_ino_t		ino,
 	struct xfs_inode	**ipp)
 {
+	struct xfs_inode	*ip;
 	int			error;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
 	if (error)
 		return error;
 
-	error = xfs_qm_dqattach(*ipp);
+	error = xfs_qm_dqattach(ip);
 	if (error) {
-		xfs_irele(*ipp);
+		xfs_irele(ip);
 		return error;
 	}
 
-	if (VFS_I(*ipp)->i_nlink == 0)
-		xfs_iflags_set(*ipp, XFS_IRECOVERY);
+	if (VFS_I(ip)->i_nlink == 0)
+		xfs_iflags_set(ip, XFS_IRECOVERY);
 
+	*ipp = ip;
 	return 0;
 }
 
