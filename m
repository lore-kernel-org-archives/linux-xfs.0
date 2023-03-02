Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC85C7EE36
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCBUfb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjCBUf2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:28 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F205E38037
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:26 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so4038168pjb.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqrzJFbimxZ2WoVp2Bt8iAhYxULGlkKFADFBXR9h2W4=;
        b=F6wF60EcW1KdHsDkSyBkOPWaZKm8cWsmLjd+KJrm+dbjUhW7ZiqEPH2vo0npKZDbfI
         tRFT5wih1WFBLyFsin9Hzak7a8b4NBoflMFWnMsSqo10Y41hGPr0DHt+4veltHnJyLKr
         LelbNCV6hq52vSsYyRWvm8/H3+2RRIbQvePeRGzBnYIvaxbQeUWqrihp7KSxOsbe4MGV
         gqFVvcJGyaNiZ3OSVHJubbEl4W/5xWcNtR1EMhEHhX5t5wr2ZYhNK2++ch4R/oNkYH4i
         9NGOedmXoZSJ/FmAhK+4Vz1NJr+iEyvCAVXSXgMMI1rU8wJa/0HaRPNlDvamvNsidKDF
         G42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IqrzJFbimxZ2WoVp2Bt8iAhYxULGlkKFADFBXR9h2W4=;
        b=Uz9XCyVXx6E97nWdoYO3L/Ukd7AnDDvaMTfa9z8ueRi1CouBeabwOI29yQvjbmPLzj
         kV+hHOFUUy5ldtnPniy2Aurxc08gXaElIapLswFa3vDPXT61mYWIZQypTx4khZkTVxP3
         8gO8V74d4oIpJGt58YSk8DcoItIt8GDKJnqLal3BjbFbZFrJ8WOVIkogXOPDOCovfmHt
         0/IrUx0yM9c7FEqdZSIYjMhUmPoOxboy/+2EG/Kj9SEa1DZYVlgSGgfgHb46TN3mlb2F
         vv6oIgpmeW06kSsiK9HlJHuK1vrxBVxST+gTOYhdkEwUkZIAPRC56+f1h1cwwn4E/lIe
         yYQg==
X-Gm-Message-State: AO0yUKWV+bJoM7T5Ztf9C13ZAviPKyrr0SCAUm9CcWEv6yeA6GBV7eTg
        yD3yX+w/yFvcp6/AN9vyGz7CWB1WrFrKXw==
X-Google-Smtp-Source: AK7set+B2o4cSJy4u2i/WMHGNdVBciuTGEzxpEAdxp5s7t18GPPo3xBqZq4C05UgTyfiqPe5KJ2iAQ==
X-Received: by 2002:a05:6a20:8c1f:b0:cc:a62f:1a9d with SMTP id j31-20020a056a208c1f00b000cca62f1a9dmr10532626pzh.23.1677789326165;
        Thu, 02 Mar 2023 12:35:26 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:25 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 09/11] attr: add setattr_should_drop_sgid()
Date:   Thu,  2 Mar 2023 12:35:02 -0800
Message-Id: <20230302203504.2998773-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 72ae017c5451860443a16fb2a8c243bff3e396b8 upstream.

[backport to 5.15.y, prior to vfsgid_t]

The current setgid stripping logic during write and ownership change
operations is inconsistent and strewn over multiple places. In order to
consolidate it and make more consistent we'll add a new helper
setattr_should_drop_sgid(). The function retains the old behavior where
we remove the S_ISGID bit unconditionally when S_IXGRP is set but also
when it isn't set and the caller is neither in the group of the inode
nor privileged over the inode.

We will use this helper both in write operation permission removal such
as file_remove_privs() as well as in ownership change operations.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/attr.c     | 28 ++++++++++++++++++++++++++++
 fs/internal.h |  6 ++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index f045431bab1a..965be68ed8fa 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,34 @@
 
 #include "internal.h"
 
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @mnt_userns:	user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(mnt_userns, inode,
+				 i_gid_into_mnt(mnt_userns, inode)))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
 /*
  * The logic we want is
  *
diff --git a/fs/internal.h b/fs/internal.h
index c89814727281..45cf31d7380b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -231,3 +231,9 @@ struct xattr_ctx {
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct xattr_ctx *ctx);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

