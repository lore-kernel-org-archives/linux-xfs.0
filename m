Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F91C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjEZCMs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjEZCMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:12:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B2813A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63F4761834
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49F4C433D2;
        Fri, 26 May 2023 02:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067165;
        bh=WS3H7DHlseftx/27wptXbeqV6sNKZy5Oahqc33QeCxI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=edn6S5wcp53zb5q5YzrfrBTd3UkhF5fQPsFw+T3LWBP7Ujf1N6d2mABbpbAp7nCcZ
         j+WTW5yL07nfNU1/qy6WtLDj/oP8pEFmzOIztkXgCTpBLg1A8vRLbO+RQu2yE22qp5
         i7VLRno9JDpwHoS9vO2gMDVn4Szqp15C0bObGKQqfozLJ9T2ktYNN8iClBsmqE/+nN
         b51N9UKjTzQtDfNDkLkw+WiH3v7DsXm4iPsI7RyZ00S4dYGle6+12f1V2dT+7nH6Lf
         IAZQh8DitxMwLzkvV0sI+I/I9RAfDSCJz2ZnZvvYIWOehBgwBHcB4NP9YsVBiGfUba
         05PL5oZMwxZyA==
Date:   Thu, 25 May 2023 19:12:45 -0700
Subject: [PATCH 11/18] xfs: Add parent pointers to xfs_cross_rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072856.3744191.376181766438274212.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
References: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 967a21045583..c7f5fd6509e9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2869,19 +2869,22 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_parent_defer		*ip1_pptr,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	struct xfs_parent_defer		*ip2_pptr,
+	int				spaceres)
 {
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
 	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
@@ -2950,6 +2953,18 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_replace(tp, ip1_pptr, dp1, name1, dp2,
+				name2, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_replace(tp, ip2_pptr, dp2, name2, dp1,
+				name1, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -3167,10 +3182,10 @@ xfs_rename(
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
-		xfs_iunlock_rename(inodes, num_inodes);
-		return error;
+				src_ip_pptr, target_dp, target_name, target_ip,
+				tgt_ip_pptr, spaceres);
+		nospace_error = 0;
+		goto out_unlock;
 	}
 
 	/*

