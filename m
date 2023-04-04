Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3600DC6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbjDDO44 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjDDO42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131123C16
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VcQmWR+9Y5ByK+ATZGapbO5pnH99zCU6qprkC/Vu/Vo=;
        b=eU6N0VXJNRAr7DZ0RE//JSnLYXqVLX8cRcM0jYMwecmRey+qUYGtPe+7hJ9JWdTDTtkYPq
        VyEgxYIuPAvJmWs2xNZK6uEDoeBMn7Dj/H3zjTEQXZeK2DPh1ojMl2X+UHnFsFeIpacdMv
        SUVwiTSvgKZTCMYEB4LfXGX6Ygptm+w=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-UEUxcGOLOUeRUkSSnP0rig-1; Tue, 04 Apr 2023 10:55:31 -0400
X-MC-Unique: UEUxcGOLOUeRUkSSnP0rig-1
Received: by mail-qk1-f197.google.com with SMTP id c186-20020a379ac3000000b007484744a472so14540033qke.22
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VcQmWR+9Y5ByK+ATZGapbO5pnH99zCU6qprkC/Vu/Vo=;
        b=I13ZAgayofVmfRltTvd+SLqx7LlFpBwvqaIeVgjKQISOaztppbw69HYk83t+KVglqO
         oFFWHcwG1QKHbCOFuiAaO2ajShuDqYKOzz1swqWuOE+2yK+denKkLuoV7/Zsi0P8l6Yf
         CbIv/kp9pPgpRH4Dads0AjIIb/Udn+GQfKABO0tE+dXGGWP0kZhlwg/h09EEoWoqkFQe
         GunmAb3xhje+f/ViK/dwqUP8h2N5AiyNz2TZMaNQmH4deoBpkVH//QHt2JncC9lmZKVV
         l6vxlC2FjyEnZNmy48MKy264th/URbw9hOcpMsrCYchwXouAD+KUXmdiqNo1ipEQK4Jk
         N/gg==
X-Gm-Message-State: AAQBX9fuXgaV+hkSIewdkR6BqU0uhJS9xPImUNdK6Zvg1XJd+OHjJqXS
        P22B3Av7H/HSb3+sk6cHDjJmHLCwHd8yI0fSOlJX32iG8qhlhpWSK/ZwDMmPHPNHYbG0M6fhnye
        31sDD2wZaLUocuMKduyE=
X-Received: by 2002:ac8:7e96:0:b0:3e6:3c76:84c4 with SMTP id w22-20020ac87e96000000b003e63c7684c4mr4113068qtj.42.1680620130436;
        Tue, 04 Apr 2023 07:55:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zr2rxw/Z5UAEkY/x+zomx2LR8SpENS3uogBfhkrXJlt+UiOQV8XzWD8t3/6Y5inpxjlQNwhw==
X-Received: by 2002:ac8:7e96:0:b0:3e6:3c76:84c4 with SMTP id w22-20020ac87e96000000b003e63c7684c4mr4113018qtj.42.1680620130035;
        Tue, 04 Apr 2023 07:55:30 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:29 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 15/23] xfs: add fs-verity ro-compat flag
Date:   Tue,  4 Apr 2023 16:53:11 +0200
Message-Id: <20230404145319.2057051-16-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
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
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 2 ++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..ef617be2839c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -353,6 +353,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 99cc03a298e2..b1f1b21e8953 100644
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
index 53a4a9304937..9254c3cd9077 100644
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
2.38.4

