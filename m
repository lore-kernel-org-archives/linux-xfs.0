Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4178DC74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCQLIp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCQLIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:44 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EECC26CFF
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:42 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so4862266wmb.5
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zs1zoKvdKc411P0VlWS94lq85UVPmglODGE22wnBLL0=;
        b=hPq21VOW27ICQSWdwo09UFVbxEe9f/L2NH4FEWOdY9ONOSNeZ5frR/XRW2SP0ZEHi6
         NULrOKtrHd62fLGFVD69MKsCJIFpJAl/Nw+w50G15SpFT2BYjHIcgKmCT2HWZOH002Kf
         7bLeCApuNPGQekUY0xlbBfx26pmDq4hr19eKjLLANxKo//d2IYmKMB+KSf1Lmt5S1klH
         5R+8iA66C5fBpEJSAoYqZibjFSXoI2I0EjAUbMwuLy4udOFoQ8df5uYKf3dS6JDMBTRL
         upEDAbOAAczBWNRo5wISm/i/TEwuKREp4o1GCmGB7lGifEiJeY6U4naFiXLqgIW4Qqvw
         ru5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zs1zoKvdKc411P0VlWS94lq85UVPmglODGE22wnBLL0=;
        b=YYGGE6SJf9eewE5WR4vFKKeHSEzI8hkbmksSOWaocf05uCi9o35XzNq/44/TqJxthS
         4VWTAEsH4d6+o3AB0KKH5r2ijAms04fa1CQwCCWVMgsZ9Dj5WNlTGaGidOu/L7qPOnFY
         qdhXBkFUAN05Gz4E+5ZdJ2MIC4rRbSWwwciJe6+Yc1MDhskQw2TrUID3PvXqvBYH+Lgg
         Z7eWEMZLuQM6F8xrMm4wcHRIhZpNT4myMhkvRACMnzf7jTXcebZ6ZqoFv8BBBmIoziAU
         EncewKnGRa3GNQ++gx3epSP8jB/2R0r9fqFu4kt2cUHTGi++gTGBhCYCY+MmoGJ7gvhN
         dxYw==
X-Gm-Message-State: AO0yUKXKBpG3SpN0POMSFyW4BxTEigA9rZi8BMpp8cREhcasDEpYTLI9
        /KmIqtOeOBeQIfj3CVjvNrg=
X-Google-Smtp-Source: AK7set/OvtArefb53lVn+tWOUKF4LQDP/ed2J/v/F86HACyjg7ZtEZlEqd167xVEVq7NiT5PD6BYcg==
X-Received: by 2002:a1c:c907:0:b0:3ed:4f7d:f6ee with SMTP id f7-20020a1cc907000000b003ed4f7df6eemr5298936wmb.14.1679051320719;
        Fri, 17 Mar 2023 04:08:40 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:40 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 12/15] attr: add setattr_should_drop_sgid()
Date:   Fri, 17 Mar 2023 13:08:14 +0200
Message-Id: <20230317110817.1226324-13-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

commit 72ae017c5451860443a16fb2a8c243bff3e396b8 upstream.

[backported to 5.10.y, prior to idmapped mounts]

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
---
 fs/attr.c     | 25 +++++++++++++++++++++++++
 fs/internal.h |  5 +++++
 2 files changed, 30 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index 666489157978..c8049ae34a2e 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,31 @@
 
 #include "internal.h"
 
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(inode, inode->i_gid))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
 /*
  * The logic we want is
  *
diff --git a/fs/internal.h b/fs/internal.h
index 0fe920d9f393..d5d9fcdae10c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -197,3 +197,8 @@ int sb_init_dio_done_wq(struct super_block *sb);
  */
 int do_statx(int dfd, const char __user *filename, unsigned flags,
 	     unsigned int mask, struct statx __user *buffer);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(const struct inode *inode);
-- 
2.34.1

