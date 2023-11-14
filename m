Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1F4C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjKNBx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjKNBx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:58 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1BAD43
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cc5b6d6228so31969925ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926835; x=1700531635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DC4YtQcP1NnB7woduj3X/yOBnvN5bchaEn34vvOvQV0=;
        b=ApbtA1D98MJ3aY6mFqs0WOlup0h+uevxDqtNp201Nz6B34B7i8/SZvvlKHazkdoQYb
         fKu3IszJ9QM3pgfmyYI6NlzdMVXLt25RurDzkVNuMY0XAZxeHaj3swkOBX4vj0PISNUC
         s1ktnLSHVFyp/nq/UKaPX0285rW71asjGPT+ORcD2QEV97tn5M9pHin4f0M/SSrDegv3
         EDEsbWOU0qVD2UVjkjdPfTETgi0kl9iqZKlnjLD+uLYFnjpX3Swow/Fs4oRzPhOeJQwt
         CooUGNN6DSig9DTw6CYgAtICJFT3RrdVJE5cBUHSPHKrE2P7dhXUQFkKCIs0fiD3n194
         dc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926835; x=1700531635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DC4YtQcP1NnB7woduj3X/yOBnvN5bchaEn34vvOvQV0=;
        b=bBIWG58qXwVGhjMTyqCFFS3/JsHaBHRxV7hDiPoi+qiH5Sd/3EivqSKnqwaOAEMWAi
         dtQyL+GAJ5yQZerLRmKcVQpxBjmJYfxJThKAmvVQIwm5e5RVzD9GaOUh9Yi9MohNoN+p
         IsRGf3/VGU4cEmWQycyl47E3C3pFl4aEjuLw9m8CkVY7FQ5mSZBxJIQ4+wbLbzq406D8
         HH2zjr7f0V5aqyYb76dttY4cJMrF4rx3um8RtBbG8XQosxN00fny6YnGZVlayBAVObtK
         iRpBMPcCJvM9Y1NS+l5Pfx32l21x4d8+5cOKLwc4kRjClv3WcB7+IeXEZMe8CNkW4H7D
         /rpw==
X-Gm-Message-State: AOJu0YwIqXc6OM3tU/8b+q8slfUGFqeFf7ZJsYdG9nHX86X7dDQFP0+Y
        AGo5Vv+TfYd/g138AvtF7+PX1rr3ltRuVw==
X-Google-Smtp-Source: AGHT+IFSWo1ZFPGZuWJvyOr0RJIsZomrL2ZcHVxv25iWUTy8mgHMjloF84YUUwfI4a0RD9WyNuqoiQ==
X-Received: by 2002:a17:902:8c86:b0:1cc:32be:b13 with SMTP id t6-20020a1709028c8600b001cc32be0b13mr773330plo.64.1699926835214;
        Mon, 13 Nov 2023 17:53:55 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:54 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        ChenXiaoSong <chenxiaosong2@huawei.com>,
        Guo Xuenan <guoxuenan@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 09/17] xfs: fix NULL pointer dereference in xfs_getbmap()
Date:   Mon, 13 Nov 2023 17:53:30 -0800
Message-ID: <20231114015339.3922119-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
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

