Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D354FC5AE5B
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbjKPC2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344537AbjKPC2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:51 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F95B127;
        Wed, 15 Nov 2023 18:28:47 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1cc5916d578so3202795ad.2;
        Wed, 15 Nov 2023 18:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101727; x=1700706527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Od7EgD0Elyq2uGCagoXNVTvmQhoLTKZ0iEB5OTeLJdI=;
        b=FFlKDJyB5hl5iXn7u4db+X/yMoT8LH5VkrcOBvYHmKMxTtzNKcIJVBtQ+/bHHyG0ib
         2orLvNNFfmwntf+zb5EobYKXd11SHNwK6/cKsqoPbu1sjhQahWQqY2UCtLj6cCWItcIx
         LJzC1/+gAAuVCHdVNJwfP+QE6leaK9ObUMooM9MZBAZ6bjGuu8W3XrhtKFarudJQg41y
         5YVpL3kjgw/q/ydolZ8FZKsnh77ywQmReo6NEYyf9upqwcXcm9Qj+PPrV6m4kKfTMDvn
         N8eZkfrv91EK8Tc6j9w/iHFC1jReQX3gBdteFBhcxvYU/7RMftsZBXELbMmKv2UkL+E7
         OjDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101727; x=1700706527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Od7EgD0Elyq2uGCagoXNVTvmQhoLTKZ0iEB5OTeLJdI=;
        b=vnJ0KfJK0/KMQpVqSvy2lEZK+q+BtE0Ozpim8NRTZdazjSHoIao4lC306EXLhOkTmB
         2xQX9M5pK3pC2SMKVuTJ6AyYTzs9TARAgYQ7By0kBY1J5aRK/gemsHM0RSPUammmO2iR
         WgOTjRg/nseX/tnYqVcxNIFU0hYyt4aKXxlxb5vYpICLkvrkiiiPIwg3bKPNyXC2KEch
         TCSnlQVRcIra3iwYBVPUvXpIonRRAYY0+3tf1pBm4+H4Ki/y+gtR/RfVuc53spsse9B0
         6h8U/vTbgH9SlM2sLEPybESY4nROKhGrR15/G35EJQFYc0KYvYWU29QiA6z9wuTCmXev
         8txQ==
X-Gm-Message-State: AOJu0Yw9a8Uuecz4sGllXRwC2kuqPMx/dmYA9obPzwIXgaN6FA5dYQPe
        XFQ2LaDW56P7HwgAk8XwnxQDTFlhvI3Niw==
X-Google-Smtp-Source: AGHT+IG4JktJZhGTdKOxMuMs+fNNd6UCupzfXfJCqNSmKyCGQOHVDG3eny6GP89GqJBqDRCCBuyrdA==
X-Received: by 2002:a17:902:c401:b0:1cc:65b7:812b with SMTP id k1-20020a170902c40100b001cc65b7812bmr9702329plk.22.1700101726984;
        Wed, 15 Nov 2023 18:28:46 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:46 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 09/17] xfs: fix NULL pointer dereference in xfs_getbmap()
Date:   Wed, 15 Nov 2023 18:28:25 -0800
Message-ID: <20231116022833.121551-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 001c179c4e26d04db8c9f5e3fef9558b58356be6 ]

Reproducer:
 1. fallocate -l 100M image
 2. mkfs.xfs -f image
 3. mount image /mnt
 4. setxattr("/mnt", "trusted.overlay.upper", NULL, 0, XATTR_CREATE)
 5. char arg[32] = "\x01\xff\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00"
                   "\x00\x00\x00\x00\x00\x08\x00\x00\x00\xc6\x2a\xf7";
    fd = open("/mnt", O_RDONLY|O_DIRECTORY);
    ioctl(fd, _IOC(_IOC_READ|_IOC_WRITE, 0x58, 0x2c, 0x20), arg);

NULL pointer dereference will occur when race happens between xfs_getbmap()
and xfs_bmap_set_attrforkoff():

         ioctl               |       setxattr
 ----------------------------|---------------------------
 xfs_getbmap                 |
   xfs_ifork_ptr             |
     xfs_inode_has_attr_fork |
       ip->i_forkoff == 0    |
     return NULL             |
   ifp == NULL               |
                             | xfs_bmap_set_attrforkoff
                             |   ip->i_forkoff > 0
   xfs_inode_has_attr_fork   |
     ip->i_forkoff > 0       |
   ifp == NULL               |
   ifp->if_format            |

Fix this by locking i_lock before xfs_ifork_ptr().

Fixes: abbf9e8a4507 ("xfs: rewrite getbmap using the xfs_iext_* helpers")
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: added fixes tag]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fd2ad6a3019c..bea6cc26abf9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -439,29 +439,28 @@ xfs_getbmap(
 		whichfork = XFS_COW_FORK;
 	else
 		whichfork = XFS_DATA_FORK;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	switch (whichfork) {
 	case XFS_ATTR_FORK:
+		lock = xfs_ilock_attr_map_shared(ip);
 		if (!XFS_IFORK_Q(ip))
-			goto out_unlock_iolock;
+			goto out_unlock_ilock;
 
 		max_len = 1LL << 32;
-		lock = xfs_ilock_attr_map_shared(ip);
 		break;
 	case XFS_COW_FORK:
+		lock = XFS_ILOCK_SHARED;
+		xfs_ilock(ip, lock);
+
 		/* No CoW fork? Just return */
-		if (!ifp)
-			goto out_unlock_iolock;
+		if (!XFS_IFORK_PTR(ip, whichfork))
+			goto out_unlock_ilock;
 
 		if (xfs_get_cowextsz_hint(ip))
 			max_len = mp->m_super->s_maxbytes;
 		else
 			max_len = XFS_ISIZE(ip);
-
-		lock = XFS_ILOCK_SHARED;
-		xfs_ilock(ip, lock);
 		break;
 	case XFS_DATA_FORK:
 		if (!(iflags & BMV_IF_DELALLOC) &&
@@ -491,6 +490,8 @@ xfs_getbmap(
 		break;
 	}
 
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
 	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
-- 
2.43.0.rc0.421.g78406f8d94-goog

