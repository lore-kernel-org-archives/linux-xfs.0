Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E034AC4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C020460F37
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhGZLF0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhGZLFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DD0C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:54 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mt6so12540436pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CuqvT/cJSMj5kcRveqXd8IQygFBFWWKqxuz48jlUDJs=;
        b=ERTQmCK2wZrBSM16qvTaN0mfLTLNJVt3jvE9cTaxjo71N6KvOQX4hpe6Llxs1Ecqx5
         aU9ynvT3txnxojYYd5Vdcd+lPoNFrpnyuqa0MeNFwH/wpj3DrtQL3xKQtlhvszGWpFxc
         ARAZRbs3SeDME9F4azn3e2XkFtYb5vLttQf9iZDxE7QZOUEqhLzoJHSba1RA0hkq51EJ
         0QgdYg8Qhl2D2OHDT0GCh+VGBtWRbpIW1SXvxX5ppEvV2fAIh5mmtH0WQYGj7AyvzAXd
         mIrK63gHyHcL9srOG1sakODyKemmbVkB/8XxkkLwngRP8YbZoCI6b+Zk6jQOu6UH6FN9
         LiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CuqvT/cJSMj5kcRveqXd8IQygFBFWWKqxuz48jlUDJs=;
        b=J3v1NqtyXu69u9izFA52kvxQpItE/2A0p1PTVEBkZ3elpoULOQ3VG49G+fvri6wvVc
         qiX4tS8jaeUKJHRiBEicgqz8HsnJ1GUhXx+h2jdGS36ukjCBZLleTCfoB+W3VoCzYH6n
         OO8gsAR6lWaaCM+XV/Cxgb1PMAsYjehjFgxzxOdabX/7uMODb4V+gTVgP0rvKBC8mabe
         IHo+iihgWdPYWVidbUKQIH/xxVOMn8g5mocfOYOiq49/VkPXRLM1Dc20dA+wrIJQ5axv
         wROe3yhLHhPKd9ZU/nyEeSXWcwyR4WjFHPV+hVP50FBP55AT2c41HQejstyENz0giffY
         ihpg==
X-Gm-Message-State: AOAM5312UDFfAi9bF79snW7cWjvdlWIwj1P7IxTp2yggr1oKfahmD8Rc
        Vas9gpiaR/0nAq9lYB0AAW9Kn17s80Y=
X-Google-Smtp-Source: ABdhPJzj/5ZytPzNeaqnAPtopgPuVCVv8fxMKTpOr+T81vvg/S13u57mXuYoF+zLig/TeEsZHjjD3g==
X-Received: by 2002:a17:902:f691:b029:12c:5bf:41cc with SMTP id l17-20020a170902f691b029012c05bf41ccmr7484621plg.68.1627299954105;
        Mon, 26 Jul 2021 04:45:54 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:45:53 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 01/12] xfs: Move extent count limits to xfs_format.h
Date:   Mon, 26 Jul 2021 17:15:30 +0530
Message-Id: <20210726114541.24898-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8cd48a651b96..37cca918d2ba 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1109,6 +1109,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 5c0cc806068b..8908346b1deb 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

