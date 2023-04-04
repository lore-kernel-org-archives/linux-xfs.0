Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CF4C6FD1D
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjDDO47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbjDDO4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F074C2B
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5CBlu3rB6FB4/gHV+J994sqM8eAaiIHabLpvipzBAI=;
        b=gOUgCrfeQUjKxwtOafUhZRjKFm8ryWBwbpIMc8Gqnk1cufqOeLFVE7Ftd1ILfxTlPWDYSa
        tz9/Oth60C9wZWt7pRnUnd2qVt8CDTjfvAVUpgxsYn7T9swqxCeF0tzhGTVriNm2VtOU6n
        orrXhvOYfXoI//EeuVup1Jy3DpjKM4s=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-FDDPNjv4PPKwUmSJKMke-A-1; Tue, 04 Apr 2023 10:55:34 -0400
X-MC-Unique: FDDPNjv4PPKwUmSJKMke-A-1
Received: by mail-qt1-f198.google.com with SMTP id a11-20020ac85b8b000000b003e3979be6abso22123668qta.12
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s5CBlu3rB6FB4/gHV+J994sqM8eAaiIHabLpvipzBAI=;
        b=wilit9O3aKQtthzlZUMLhr3jNYWooRT456NIchyuiMlAd4foO/hkTpXjdsS4YtkYBi
         vmrgC7HZNQxyUvjzISQyTDcL8/djmnvRX3ogvH14/gsEtTh+IsaaDmoyd50k3mFHUMVq
         u26IMi129OTumzPKrttjwdbsmarIY0o6dN9EIBGEFGIYtcNeQEldT/GgTXNnFlh7cDX/
         YgT7LfiiAFxSrr44HDBs2RbYzguewgeBY4kuMhoR0U1hG46I1IutYvuwEai7Hqbfyx5g
         gVVnuWIF5PIrc+9DyWvvoI+/Cf2d7fcrka/N6nnTEY9lkEqFLXuAcEcOHd8nFXmRY2Sb
         YSjQ==
X-Gm-Message-State: AAQBX9cAFaKmswvDmBWwDtNkYAh14mvDb41UpJGm93ESR8HzwiBMjXxr
        z6Fp23tHIZXtacWZ1eB3NJQbpOlGu1LrYFncovwbqn6NPNQ3bZYhO2xdGN0Xxpyg2R/Hzjc+i3g
        69+uOJY0s3TPKtNETCrc=
X-Received: by 2002:a05:622a:1116:b0:3d7:7d98:d202 with SMTP id e22-20020a05622a111600b003d77d98d202mr4199914qty.32.1680620133271;
        Tue, 04 Apr 2023 07:55:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350agz24OCLzc85AGxUuPb8W7opye3ABchefrsnh9VPCEo+l0sKKLvduzLpg+Bm8Xk2N7Z0je6A==
X-Received: by 2002:a05:622a:1116:b0:3d7:7d98:d202 with SMTP id e22-20020a05622a111600b003d77d98d202mr4199873qty.32.1680620132920;
        Tue, 04 Apr 2023 07:55:32 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:32 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 16/23] xfs: add inode on-disk VERITY flag
Date:   Tue,  4 Apr 2023 16:53:12 +0200
Message-Id: <20230404145319.2057051-17-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add flag to mark inodes which have fs-verity enabled on them (i.e.
descriptor exist and tree is built).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/ioctl.c                 | 4 ++++
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/xfs_inode.c         | 2 ++
 fs/xfs/xfs_iops.c          | 2 ++
 include/uapi/linux/fs.h    | 1 +
 5 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 5b2481cd4750..a274b33b2fd0 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -480,6 +480,8 @@ void fileattr_fill_xflags(struct fileattr *fa, u32 xflags)
 		fa->flags |= FS_DAX_FL;
 	if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
 		fa->flags |= FS_PROJINHERIT_FL;
+	if (fa->fsx_xflags & FS_XFLAG_VERITY)
+		fa->flags |= FS_VERITY_FL;
 }
 EXPORT_SYMBOL(fileattr_fill_xflags);
 
@@ -510,6 +512,8 @@ void fileattr_fill_flags(struct fileattr *fa, u32 flags)
 		fa->fsx_xflags |= FS_XFLAG_DAX;
 	if (fa->flags & FS_PROJINHERIT_FL)
 		fa->fsx_xflags |= FS_XFLAG_PROJINHERIT;
+	if (fa->flags & FS_VERITY_FL)
+		fa->fsx_xflags |= FS_XFLAG_VERITY;
 }
 EXPORT_SYMBOL(fileattr_fill_flags);
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ef617be2839c..ccb2ae5c2c93 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1070,16 +1070,18 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
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
index 5808abab786c..3b2bf9e7580b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -634,6 +634,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_XFLAG_VERITY;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 24718adb3c16..5398be75a76a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1232,6 +1232,8 @@ xfs_diflags_to_iflags(
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_XFLAG_VERITY)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index b7b56871029c..5172a2eb902c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -140,6 +140,7 @@ struct fsxattr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity sealed inode */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.38.4

