Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BF7C28D13
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiHVQ2W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbiHVQ2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:28:15 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5487101;
        Mon, 22 Aug 2022 09:28:12 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k18-20020a05600c0b5200b003a5dab49d0bso6309525wmr.3;
        Mon, 22 Aug 2022 09:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=uYrJzm2OiQQN3lvK2knCDJ6v9s4sNITV4hwedxG7cpk=;
        b=MMI5G096K+Nm3DQo5LfM8EdSA3O5ZEWa02aVVjpnyxNTKjZC+LWjzuSN+544ZtN8Hg
         IdIAAL7dIoYlkhCxbeE2ORfGBbvIuiYAr7PUOAdCBK4j8w6BdkNEEuzsaQ9nN+1cy/39
         hnObl6kGzFspijB50haBeOFgl/lJdm1IswjnqQUsFHBxf/ZPdrvOvMvTlLMmwF3lWny5
         QgrQppjQVuxgMUL0ocLY8nJt/U2h0dS2QfOrziuG8CWGEC02FqIk5+orJQv2dydK6SYy
         EZCAcNHb76rxgIqIAQuqWgO+2YhTM3G/jdKtlV01KGG3K31KqYNYzBy85rjI47Hiy1MV
         ZHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=uYrJzm2OiQQN3lvK2knCDJ6v9s4sNITV4hwedxG7cpk=;
        b=Q43dj6YX0uO64y02QT+lkdWChLITy8PeRLsTq/oLtbwPJkvbdPmmcfByzhJ2R1esEX
         9/VoPdIusiYXOmX5RHELENPtIEw9J7RWFj+/EuroBKc+OdTgHWaVXZS7T5hgEqmw+P7a
         tVap2FKWY9yYlmOl1Kf0umkwPalwyS8iODsZuGFiV76QVweXGiAF6ENWQlx7PeTWC7d1
         5mIWRpOFXAU6i1nooO4OfXBsABDwXgEg+Rc2R5AJqd1jLQnm01JFfWEtGAC2/BuLV+1F
         RcrMsj8nydao3ikP62ylMoHhQAOb8AZ2+8Jg0ZLxP/lBo8jyz/gl8FPgppsnjIA9Kfu0
         KOAw==
X-Gm-Message-State: ACgBeo3Os5QV9lofRGKtYvzpzAS1CTCnY6YBNLTgLcYfk2A7zXFLWXqM
        UoPL95S7TRasXqv2osoEumeqUV+MGW4=
X-Google-Smtp-Source: AA6agR4pSeIjIJoEOKEgWtyeLUD4TD4gkUlyGdsvPkupt0L9VwMQOsyRTw7w02OGV3M6Qfv1ORhNPg==
X-Received: by 2002:a05:600c:a02:b0:39c:97cc:82e3 with SMTP id z2-20020a05600c0a0200b0039c97cc82e3mr15934147wmp.97.1661185691178;
        Mon, 22 Aug 2022 09:28:11 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b00222ed7ea203sm11749229wrr.100.2022.08.22.09.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:28:10 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 CANDIDATE 1/6] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Date:   Mon, 22 Aug 2022 19:27:57 +0300
Message-Id: <20220822162802.1661512-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822162802.1661512-1-amir73il@gmail.com>
References: <20220822162802.1661512-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6ed6356b07714e0198be3bc3ecccc8b40a212de4 upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_ioctl.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 646735aad45d..d973350d5946 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -371,7 +371,7 @@ int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
 	void __user			*ubuf,
-	int				bufsize,
+	size_t				bufsize,
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index bab6a5a92407..416e20de66e7 100644
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
2.25.1

