Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E542C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041F32076E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgDiMdZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgJ2KOd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgJ2KOd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:33 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D314C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:33 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id i26so1940957pgl.5
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ttah+KnBauDQXA8r3dO7gvzvR5vDgdkbnCETl2BO3+U=;
        b=kgDiMdZvhwJvLJRoVzcoWRMyKA7QhD1UJuxh9JTnOFdC3iZ7BPMCBKmePlhfC8LL4O
         tUJdICUUG8ZncY/myxDAi+r1ErapWHnE7DhywIjnwOzsJgF3eAdVsJc57CgzryD5jKM+
         ajqjsGA7UXxmeD4p7Xji7q0tQfkQYIBLOuR4AMwd/JJtMYey9UEC6ZiANFHf+eal/TS4
         Rly/ylJ99CkzbtN68ggy7HKLeMEhT4K7IcTRWtMJ9qPmSDZ0jjbXTYv8nnM3vGyvOWnW
         mR0LStwIHB8wvo0Fa9O74ZA3CYkNrSuEA/Fi4UdBSESETFUksaNZl3tS1EW+/2bABXVE
         u54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ttah+KnBauDQXA8r3dO7gvzvR5vDgdkbnCETl2BO3+U=;
        b=WPCrnOOia6+CqkOqQLlA06Z58n3rrCS+HYDp/+CEEO75C1bBnSAvoEH8wNM9h+9YKL
         LyPktnyVonx4Xy504r5Ryd19R02sooKKJ+IAYcCJDot/NUPHNchgYWbO2XhEJJec8jLR
         u6Y/QTyZIA3LLZuzFXG02e1BE5g86y40fBYiqjE0c5F8OV1uSB475zSh3YgNPs4m10RS
         JuAK265BkFC+0WR4cWzBSA1S11tbf6qP8pT/qv0YxRlCkwAr8lxazEcwQA1VM7f7rNq1
         gHhQ+zOUGDstFydR5IVXtTshhCRQGkXhgNoh23JSMI29hralZJNX25mlhzfh/Zed7eC3
         rONA==
X-Gm-Message-State: AOAM530OparIwWKMBws/pceOYTliurDvCp7CZ8djv+jbuhgk0Lj9nnOP
        pyqSOVIVC/5FZgu9na+vgknyyWQpKws=
X-Google-Smtp-Source: ABdhPJzQ/bNeT87CoCWlmSIc2q2ywA6qa2MXS4NUFjiLp5Ldnxu9R+DFaihcwYv1VfKYcdZOuHnqOw==
X-Received: by 2002:a17:90a:468f:: with SMTP id z15mr3482667pjf.200.1603966472578;
        Thu, 29 Oct 2020 03:14:32 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:31 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V8 03/14] xfs: Check for extent overflow when punching a hole
Date:   Thu, 29 Oct 2020 15:43:37 +0530
Message-Id: <20201029101348.4442-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_item.c         | 15 +++++++++------
 fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fc2b129a2e7..bcac769a7df6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -40,6 +40,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
+/*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 1610d6ad089b..80d828394158 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -439,6 +439,7 @@ xfs_bui_item_recover(
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
+	int				iext_delta;
 	int				error = 0;
 
 	/* Only one mapping operation per BUI... */
@@ -497,12 +498,14 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (bui_type == XFS_BMAP_MAP) {
-		error = xfs_iext_count_may_overflow(ip, whichfork,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
-			goto err_cancel;
-	}
+	if (bui_type == XFS_BMAP_MAP)
+		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
+	else
+		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
+
+	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	if (error)
+		goto err_cancel;
 
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dcd6e61df711..0776abd0103c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1176,6 +1181,11 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
-- 
2.28.0

