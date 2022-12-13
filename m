Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03923C10F1D
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiLMRbA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbiLMRaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11D423149
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dpUw5Y2TLDVtTXCSF2V9Ww7xiFXDGmNlxyIGTd/fNF8=;
        b=G8QBirJ4r4lnstU5I/evCHMCfKYiwFJyprkxm2hE0BQpa4CMDVM5YFoOuWt9HIQRtM4VLw
        mkE8H8MozRNZiHTyCn/dq4Aq3qDp7pFDxOV9afujIvA2v+uKsn3siCV73bWyNHqshLYXja
        h8Hi19N1YgS9ao90+06rw541Jl1cAFA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-D_GN_m_gOb2jL-3U78vVEg-1; Tue, 13 Dec 2022 12:29:43 -0500
X-MC-Unique: D_GN_m_gOb2jL-3U78vVEg-1
Received: by mail-ed1-f72.google.com with SMTP id m18-20020a056402511200b0046db14dc1c9so7719415edd.10
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dpUw5Y2TLDVtTXCSF2V9Ww7xiFXDGmNlxyIGTd/fNF8=;
        b=EJjtAovmRdfZcW6MKbeliAAOc2NOB3tN5LjQvCUmIwFKdeykaqFe4mablA9a0O2TcD
         YdbXExke81BBmoPE0r6glPbxR/X9rUcMxH3Jqf8+7VCv/BYiWkhestowhZNG6fWFd8DI
         wPenLkXilAncLil1woBP0FOaKdZDGgkWMdA8b5yo6ivdsoAzkNsq9eqvyki78o3c5qcF
         rDf3Wu5/OSOeyCG51r8pe3IhlL2ry6HwF8aYsCd1cEG0W6UlXAE2x1Ceemu9gvHiK975
         cv2xF8umeEDAvla7EdojiyRfmnnlAqcCC/4RG38iqyC9j8TJedqMWjfp3FDBonRU1Kmp
         qetw==
X-Gm-Message-State: ANoB5pkkidmE1RwqZUZLcaKMZkVF/iB4RpwN3QN2TBLKE440HhAm6I+r
        O+lirbLX1GcmrNQX9ZzpkBDhIss0pnEn8A4gSV1BB98x/sQpN4nMDYT/w1NktL0BihZ9zeo+C76
        pIdSQA6RoxG7JNX6j9E85GmZIWTBzoIpXQWMQ0ctOP8pOsOLAFMOHFoXYJhnI8f0eTGeea0c=
X-Received: by 2002:aa7:d814:0:b0:46f:d952:a0c with SMTP id v20-20020aa7d814000000b0046fd9520a0cmr8877993edq.20.1670952582375;
        Tue, 13 Dec 2022 09:29:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7PlCjp9cbbaShxk8BtTSop2M36G/FuymBo9yWHBHKi3JC/lYLxCB5Njfs0kRqD07nB5KwLEQ==
X-Received: by 2002:aa7:d814:0:b0:46f:d952:a0c with SMTP id v20-20020aa7d814000000b0046fd9520a0cmr8877979edq.20.1670952582152;
        Tue, 13 Dec 2022 09:29:42 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:41 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 04/11] xfs: add fs-verity ro-compat flag
Date:   Tue, 13 Dec 2022 18:29:28 +0100
Message-Id: <20221213172935.680971-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To mark inodes sealed with fs-verity the new XFS_DIFLAG2_VERITY flag
will be added in further patch. This requires ro-compat flag to let
older kernels know that fs with fs-verity can not be modified.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 10 ++++++----
 fs/xfs/libxfs/xfs_sb.c     |  2 ++
 fs/xfs/xfs_mount.h         |  2 ++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f413819b2a8aa..2b76e646e6f14 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -353,11 +353,13 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a59bf09495b1d..5c975879f5664 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -161,6 +161,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
+		features |= XFS_FEAT_VERITY;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8aca2cc173ac1..3da28271011d1 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -279,6 +279,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_VERITY		(1ULL << 27)	/* fs-verity */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -342,6 +343,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(verity, VERITY)
 
 /*
  * Mount features
-- 
2.31.1

