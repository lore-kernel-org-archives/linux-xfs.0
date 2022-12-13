Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D9EC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbiLMRa4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236300AbiLMRai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7D323168
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nn5AV0iauh40sGcbOOXIUaQzVDgF5CNNvId9f7BzBCg=;
        b=cojLhd5zAJMHSNXi1rVZiA5Un1lCpaIyfVNiDQCEj7cXvDh2qlx4pf247P1CTy1lBkt9AI
        L8iSaoZ8lxTYSQ4mj2BZbMAvVSUJnSjTYDYPUdYHeK7oImTfDt8B3dIQl+ehK3tUK8KeI0
        l9yvboS/j69Bv6PrrlfJm/0tT84SOjM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-461-7MbkDHmdPR2S4zhr4-DkQg-1; Tue, 13 Dec 2022 12:29:44 -0500
X-MC-Unique: 7MbkDHmdPR2S4zhr4-DkQg-1
Received: by mail-ed1-f72.google.com with SMTP id m18-20020a056402511200b0046db14dc1c9so7719440edd.10
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nn5AV0iauh40sGcbOOXIUaQzVDgF5CNNvId9f7BzBCg=;
        b=tfe5roweHZSCwrT8Xmqpb8eF8Iwd9PhQE08ErCvhr4wS/MfdgcOhB41nw1X03p/B+1
         CTHOPTzHQIcRVNT+Riy+NqMsj1vHkGi93P3GEvIl16K8dLa35AFwVV648te6HkrUNUgM
         SNwtS36YgBPr2v0/jJaA4BuLjRAO1aRHWX37IBOO8914K5zQUlVR0k4ELZauNHB2N0io
         3PrpOKm0iE5MDpHYV+PTVkusV0gy3USBKuTUesF/9dajWrxa3ilgQzddcZtW4Hn8jbWx
         SDj+3j6nJRce4tChoT7ja+xQUYWteM3teP3wnJsUbD9ivvsLCA2vN0S8bie/GI+ShOXe
         GcFw==
X-Gm-Message-State: ANoB5plNFC2DIiWR8kxjkOsRHeFLLqr1YwGsgL/c6m2iYQ0ozexPYIYs
        L+AqZmXRTRIHApoAOyD/RqJHlgxITjTaqXopsLA6sR1E52PgUufZM9b+8icCNk7mgCQfDb49BJp
        QaVlK92xoU36H4Nx/mmBxehHAEiOPD6gOjwyos71Uag708BO3uWwsktRufnh8Z184zvdXGz4=
X-Received: by 2002:a05:6402:e06:b0:461:9764:15f0 with SMTP id h6-20020a0564020e0600b00461976415f0mr18787471edh.38.1670952583242;
        Tue, 13 Dec 2022 09:29:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6qdM1QaM3TVFAFyYeHnK+MxQfi4OtkyAMx8DAcTi2ppVi2HCox+UIpJMvIS8HSe3W6ErI54w==
X-Received: by 2002:a05:6402:e06:b0:461:9764:15f0 with SMTP id h6-20020a0564020e0600b00461976415f0mr18787454edh.38.1670952582994;
        Tue, 13 Dec 2022 09:29:42 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:42 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 05/11] xfs: add inode on-disk VERITY flag
Date:   Tue, 13 Dec 2022 18:29:29 +0100
Message-Id: <20221213172935.680971-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add flag to mark inodes which have fs-verity enabled on them (i.e.
descriptor exist and tree is built).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/xfs_inode.c         | 2 ++
 fs/xfs/xfs_iops.c          | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2b76e646e6f14..6950a4ef19967 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1073,16 +1073,18 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
 #define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
+#define XFS_DIFLAG2_VERITY_BIT	5	/* inode sealed by fsverity */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
+#define XFS_DIFLAG2_VERITY	(1 << XFS_DIFLAG2_VERITY_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_VERITY)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f08a2d5f96ad4..8d9c9697d3619 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -636,6 +636,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_VERITY_FL;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9c90cfcecabc2..b229d25c1c3d6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1236,6 +1236,8 @@ xfs_diflags_to_iflags(
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_VERITY_FL)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by
-- 
2.31.1

