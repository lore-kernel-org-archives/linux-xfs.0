Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC2AC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiGRUad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiGRUab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DED2CDD8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y9so11659826pff.12
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FcZF8t/KxS0/gN0Zc87TnHtsGBdg6fjR/F4Ko7ZSUXw=;
        b=NHrXX7WaTRckfCa7uxjj+MnNeb6YjtLrmxzjJQjvHPbmSztZ4Rm0RPSeeuWMZgfaXP
         rTPDAT09wRJMlmbjZhWKP+uiU8IY8uWWvVVw5/iG6e52KJ9XNH9peeDBfDhLTUv3oKAp
         fjN+M3kXL4XwGohct39YTSLbcwYzxIAIorkzWiLpYPUwjEsM4177pvkDInJEfbca6Qyd
         eVnsLc/qoq9nRo/3hOcQZRHonpcBohC+LieA2+N6UWdE2GMTh+ABT747ANGOvzpxKl1E
         kJ4hTVr0HzYQsnOlgITZHvH3ip2TgFPuyOUepSpIulj5xQcAmCyMu+qdoo3/Y4aNNXtf
         V24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FcZF8t/KxS0/gN0Zc87TnHtsGBdg6fjR/F4Ko7ZSUXw=;
        b=5JzyRm8baoKKGOz00H29VG81Jrb6sxh6l4OLIfvei5g9DGG5MtRAA6NCpeOLwwHGK7
         jLcdX8rDvBekJt1gncAnFIaz8v+lOiuJZ1ui8EeRdpDWaQCGUsRRKzpjEOW9lT2h+I7e
         F/9n/JS13+MN6dBSTaV1+6jcDq2+ZaJ0ax+9gWdNv7mxZpKz/59GvZaGH/CC6pk5twNN
         6a0EyAjdvhi8nMeBFi4uUk87yDNCItZW+Ybr7plsgA1JJRWVoJB+9fvI2+UOZ4dkFF1P
         sSp2OYoNMBUlSYx4DrL0+asmowlADuYKbWrohcM/Amg+5fRo3fjx5zYbcTqEhtkHvUsK
         qiDQ==
X-Gm-Message-State: AJIora+yT01QXD9HKouFUDJDbF3WQUlXiKB0n9z/zmr9EgzY5+wJAEpp
        V9czS8UHNwzPQ/5KzPiWvDIPvJltSu5myw==
X-Google-Smtp-Source: AGRyM1vcGDiy5C346Xfh+2JSeXkT3hUphZjrb/Pk39O1WQbvzwdrgfgQhUtrymwBxmU1pBNyxk1QCw==
X-Received: by 2002:a65:430a:0:b0:412:1877:7def with SMTP id j10-20020a65430a000000b0041218777defmr26572304pgq.93.1658176230365;
        Mon, 18 Jul 2022 13:30:30 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:29 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 9/9] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Date:   Mon, 18 Jul 2022 13:29:59 -0700
Message-Id: <20220718202959.1611129-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6ed6356b07714e0198be3bc3ecccc8b40a212de4 ]

The "bufsize" comes from the root user.  If "bufsize" is negative then,
because of type promotion, neither of the validation checks at the start
of the function are able to catch it:

	if (bufsize < sizeof(struct xfs_attrlist) ||
	    bufsize > XFS_XATTR_LIST_MAX)
		return -EINVAL;

This means "bufsize" will trigger (WARN_ON_ONCE(size > INT_MAX)) in
kvmalloc_node().  Fix this by changing the type from int to size_t.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_ioctl.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 09269f478df9..fba52e75e98b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -372,7 +372,7 @@ int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
 	void __user			*ubuf,
-	int				bufsize,
+	size_t				bufsize,
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 28453a6d4461..845d3bcab74b 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -38,8 +38,9 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
-	int flags, struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
+		      size_t bufsize, int flags,
+		      struct xfs_attrlist_cursor __user *ucursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.37.0.170.g444d1eabd0-goog

