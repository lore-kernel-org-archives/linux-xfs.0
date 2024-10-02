Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C2F2F22
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832285; cv=none; b=Z6geyesI+tySvBvgzIUYICzGwOkx76Eh3ep20y5vm8OZ3LYNrVdT0cHBksPnLXf7WVIu5lXKDyH8+6JHwWdRQJPQ6z3vuoODb2Ik8+ZGq7cTR+3F4e5oSBUsL9+xxBKsAdjaUdmXR1gVC5EuX2stwBmntxNXUDWqR2xkNbSGaig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832285; c=relaxed/simple;
	bh=HfbJxkYhByTO6MYbT9kfVXDf7LIZUrb5Z+2VmLErGlo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qviyaHlclsyLFpLpdN9S1ZVQRhkB4003LQKtZ9ruUdbks1if3uYGdHrc4xaeYC1drgSxsLM5op8RzQnfvw206GC7ghXHdpe7OilmHOmPnoZB8msM5q2PHZVhZR9gXv5GADtmdBCuGDNCa8wmBE88BcG7T/o7qv7XqhMTWfIZN3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVInezor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVInezor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40034C4CEC6;
	Wed,  2 Oct 2024 01:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832285;
	bh=HfbJxkYhByTO6MYbT9kfVXDf7LIZUrb5Z+2VmLErGlo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dVInezorq5tuqnA9ZxY9mg6pXuiQxW63QbEJARaJn2Q6Nd/BBwQS0L9KchqwbqnLV
	 MZHrTY5G02Af2vsc46YAH4Km33Ygf7ufCnt89KDea9aT0BDfbue7UJH5xPG9T9KufH
	 CTwebRgQ3tBGS9B3rmCZjLOYlhvpbRitDORNC9L0TZYmYwz5XeYJbUbKbig/T0oHJa
	 lOFAjKL/8qObzh7Qg3y5alWpK/Z9cYmxvRdTNR2lWhZRIOIsTVkgT1GAhkYq4/xdW7
	 RnYBiEpKXkVfIdujxf/fWQlhy/I5bbF6eZLEesoDEVJr2JZOkfoM0KvrSYNZQNWK5Z
	 hWjEv8q333J4w==
Date: Tue, 01 Oct 2024 18:24:44 -0700
Subject: [PATCH 1/4] xfs_db: port the unlink command to use libxfs_droplink
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103046.4038482.15065839752033832714.stgit@frogsfrogsfrogs>
In-Reply-To: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port this command to use the libxfs droplink implementation instead of
opencoding it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index d57ead4f1..8c7f4932f 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -1142,21 +1142,6 @@ unlink_help(void)
 	));
 }
 
-static void
-droplink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	libxfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	if (inode->i_nlink != XFS_NLINK_PINNED)
-		drop_nlink(VFS_I(ip));
-
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 static int
 remove_child(
 	struct xfs_mount	*mp,
@@ -1206,13 +1191,17 @@ remove_child(
 
 	if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		/* drop ip's dotdot link to dp */
-		droplink(tp, dp);
+		error = -libxfs_droplink(tp, dp);
+		if (error)
+			goto out_trans;
 	} else {
 		libxfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	}
 
 	/* drop dp's link to ip */
-	droplink(tp, ip);
+	error = -libxfs_droplink(tp, ip);
+	if (error)
+		goto out_trans;
 
 	error = -libxfs_dir_removename(tp, dp, &xname, ip->i_ino, resblks);
 	if (error)

