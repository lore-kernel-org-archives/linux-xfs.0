Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A82CEB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Jun 2023 09:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjFUJ1d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 05:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjFUJ1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 05:27:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F792682
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 02:25:39 -0700 (PDT)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QmJ232RFPzqVG6;
        Wed, 21 Jun 2023 17:22:51 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 21 Jun 2023 17:25:27 +0800
Message-ID: <48402a8a-95db-f7b5-196e-32f3b4b2bf4e@huawei.com>
Date:   Wed, 21 Jun 2023 17:25:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To:     <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        <linux-xfs@vger.kernel.org>
CC:     <louhongxiang@huawei.com>, <liuzhiqiang26@huawei.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] mkfs.xfs: fix segmentation fault caused by accessing a null
 pointer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We encountered a segfault while testing the mkfs.xfs + iscsi.

(gdb) bt
#0 libxfs_log_sb (tp=0xaaaafaea0630) at xfs_sb.c:810
#1 0x0000aaaaca991468 in __xfs_trans_commit (tp=<optimized out>, tp@entry=0xaaaafaea0630, regrant=regrant@entry=true) at trans.c:995
#2 0x0000aaaaca991790 in libxfs_trans_roll (tpp=tpp@entry=0xfffffe1f3018) at trans.c:103
#3 0x0000aaaaca9bcde8 in xfs_dialloc_roll (agibp=0xaaaafaea2fa0, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1561
#4 xfs_dialloc_try_ag (ok_alloc=true, new_ino=<synthetic pointer>, parent=0, pag=0xaaaafaea0210, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1698
#5 xfs_dialloc (tpp=tpp@entry=0xfffffe1f31c8, parent=0, mode=mode@entry=16877, new_ino=new_ino@entry=0xfffffe1f3128) at xfs_ialloc.c:1776
#6 0x0000aaaaca9925b0 in libxfs_dir_ialloc (tpp=tpp@entry=0xfffffe1f31c8, dp=dp@entry=0x0, mode=mode@entry=16877, nlink=nlink@entry=1, rdev=rdev@entry=0, cr=cr@entry=0xfffffe1f31d0,
    fsx=fsx@entry=0xfffffe1f36a4, ipp=ipp@entry=0xfffffe1f31c0) at util.c:525
#7 0x0000aaaaca988fac in parseproto (mp=0xfffffe1f36c8, pip=0x0, fsxp=0xfffffe1f36a4, pp=0xfffffe1f3370, name=0x0) at proto.c:552
#8 0x0000aaaaca9867a4 in main (argc=<optimized out>, argv=<optimized out>) at xfs_mkfs.c:4217

(gdb) p bp
$1 = 0x0

```
void
xfs_log_sb(
        struct xfs_trans        *tp)
{
        // iscsi offline
        ...
        // failed to read sb, bp = NULL
        struct xfs_buf          *bp = xfs_trans_getsb(tp);
        ...
}
```

When writing data to sb, if the device is abnormal at this time,
the bp may be empty. Using it without checking will result in
a segfault.

So before using it, we need to check if the bp is empty and return
the error.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 libxfs/trans.c         |  4 +++-
 libxfs/xfs_attr_leaf.c |  2 +-
 libxfs/xfs_bmap.c      |  7 +++++--
 libxfs/xfs_sb.c        | 23 ++++++++++++++++++++---
 libxfs/xfs_sb.h        |  2 +-
 mkfs/proto.c           | 15 ++++++++++++---
 6 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 553f9471..b37e92d2 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -992,7 +992,9 @@ __xfs_trans_commit(
                        sbp->sb_fdblocks += tp->t_fdblocks_delta;
                if (tp->t_frextents_delta)
                        sbp->sb_frextents += tp->t_frextents_delta;
-               xfs_log_sb(tp);
+               error = xfs_log_sb(tp);
+               if (error)
+                       goto out_unreserve;
        }

        trans_committed(tp);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6cac2531..73079df1 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -668,7 +668,7 @@ xfs_sbversion_add_attr2(
        spin_lock(&mp->m_sb_lock);
        xfs_add_attr2(mp);
        spin_unlock(&mp->m_sb_lock);
-       xfs_log_sb(tp);
+       ASSERT(!xfs_log_sb(tp));
 }

 /*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 76591d07..63c3cf7f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1053,8 +1053,11 @@ xfs_bmap_add_attrfork(
                        log_sb = true;
                }
                spin_unlock(&mp->m_sb_lock);
-               if (log_sb)
-                       xfs_log_sb(tp);
+               if (log_sb) {
+                       error = xfs_log_sb(tp);
+                       if (error)
+                               goto trans_cancel;
+               }
        }

        error = xfs_trans_commit(tp);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 64b4e7be..21611427 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -949,13 +949,15 @@ xfs_sb_mount_common(
  * level of locking that is needed to protect the in-core superblock from
  * concurrent access.
  */
-void
+int
 xfs_log_sb(
        struct xfs_trans        *tp)
 {
        struct xfs_mount        *mp = tp->t_mountp;
        struct xfs_buf          *bp = xfs_trans_getsb(tp);

+       if (!bp)
+               return -EIO;
        /*
         * Lazy sb counters don't update the in-core superblock so do that now.
         * If this is at unmount, the counters will be exactly correct, but at
@@ -980,6 +982,8 @@ xfs_log_sb(
        xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
        xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
        xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
+
+       return 0;
 }

 /*
@@ -1006,7 +1010,12 @@ xfs_sync_sb(
        if (error)
                return error;

-       xfs_log_sb(tp);
+       error = xfs_log_sb(tp);
+       if (error) {
+               xfs_trans_cancel(tp);
+               return error;
+       }
+
        if (wait)
                xfs_trans_set_sync(tp);
        return xfs_trans_commit(tp);
@@ -1103,7 +1112,15 @@ xfs_sync_sb_buf(
                return error;

        bp = xfs_trans_getsb(tp);
-       xfs_log_sb(tp);
+       if (!bp) {
+               xfs_trans_cancel(tp);
+               return -EIO;
+       }
+       error = xfs_log_sb(tp);
+       if (error) {
+               xfs_trans_cancel(tp);
+               return error;
+       }
        xfs_trans_bhold(tp, bp);
        xfs_trans_set_sync(tp);
        error = xfs_trans_commit(tp);
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index a5e14740..fa7d4496 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -13,7 +13,7 @@ struct xfs_trans;
 struct xfs_fsop_geom;
 struct xfs_perag;

-extern void    xfs_log_sb(struct xfs_trans *tp);
+extern int     xfs_log_sb(struct xfs_trans *tp);
 extern int     xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern int     xfs_sync_sb_buf(struct xfs_mount *mp);
 extern void    xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index ea31cfe5..1e7ad915 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -589,7 +589,10 @@ parseproto(
                if (!pip) {
                        pip = ip;
                        mp->m_sb.sb_rootino = ip->i_ino;
-                       libxfs_log_sb(tp);
+                       error = -libxfs_log_sb(tp);
+                       if (error) {
+                               fail(_("Log sb failed"), error);
+                       }
                        isroot = 1;
                } else {
                        libxfs_trans_ijoin(tp, pip, 0);
@@ -690,7 +693,10 @@ rtinit(
        rbmip->i_diflags = XFS_DIFLAG_NEWRTBM;
        *(uint64_t *)&VFS_I(rbmip)->i_atime = 0;
        libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
-       libxfs_log_sb(tp);
+       error = -libxfs_log_sb(tp);
+       if (error) {
+               fail(_("Log sb failed"), error);
+       }
        mp->m_rbmip = rbmip;
        error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
                                        &creds, &fsxattrs, &rsumip);
@@ -700,7 +706,10 @@ rtinit(
        mp->m_sb.sb_rsumino = rsumip->i_ino;
        rsumip->i_disk_size = mp->m_rsumsize;
        libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
-       libxfs_log_sb(tp);
+       error = -libxfs_log_sb(tp);
+       if (error) {
+               fail(_("Log sb failed"), error);
+       }
        error = -libxfs_trans_commit(tp);
        if (error)
                fail(_("Completion of the realtime summary inode failed"),
--
2.27.0
