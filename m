Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71ADC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 20:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A59020CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 20:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="nNIJ0ufs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgBYUJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:09:59 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37689 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbgBYUJ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 15:09:59 -0500
Received: by mail-qt1-f195.google.com with SMTP id j34so571226qtk.4
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 12:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Tim+DLUAfFeDyhqD6kF9gBE+5IE19Obb7iXnkkMIXUE=;
        b=nNIJ0ufsH4VX2yJe5hHsXZRbrjB2QGvyHTUhnDGJ729iI3IWfYfcSrHlI6pogdXUco
         EU/ebHZF8GhhN0ZpwXX3UeoZi4qMkV09ktdBU9ZHOFRHE1gbBKw3pOPgCR9EzR4IStkH
         5+W35rirNzdEz7QouUWCfrvp8VHpopTE+HObvvNYhnzbi7ifbDpIWGveEr0e4rbIXDt0
         UbTYn1NwXf9sYb79HlbjVJSECv4WsdprvQlXsdVmluFeHEyhaSFSTrsBS/UUNgVionRY
         hVtrEDxO7m+jEXvzmCuNnLle63KT3s8eURdlTVs46ZGpvXUU8Uz4nmdzrz3O0nd9IdWL
         Odkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Tim+DLUAfFeDyhqD6kF9gBE+5IE19Obb7iXnkkMIXUE=;
        b=fzCCZSkNhP1vMMRwgh7FOl+EjijvFnDjbEbDUN+cXGlOe1E4b+gvKU8FuWJKGRSNF4
         xS5qOg/URxlQ0M32ik1MIwgNetIS+ul7e0eP1yG5V8Ik+kOyUAQkBaFB6kEm0kc8Y9L5
         BQ52iAxUYQ/PIJT2H+JNa7PW1mHaRkRR4JR3IwaJKE9MNKT9a2x5lSvpzt2c/QawXd5V
         oiWnWG+Tpjm899tf92fOd0eXiyONbfA/uXwxny/d2I+j6uOgs+31p1zPXHBwu/80pFwG
         /iiG/zuSpDPx2Z6fB9UEHP+E2FrAfFDAQo+yybd3MCDSsqQMH3SBBu0NMt9Hb9nccnh0
         AE6w==
X-Gm-Message-State: APjAAAW8dIjaYTJ8O8RTG7QVzfKvRVkN9pvkplzp6Xuob7mKTBXMrHYD
        6NQCVcdv6+X76CVon0TIX7oFsA==
X-Google-Smtp-Source: APXvYqyeuw4PTwffQvUbSdbTrorvpXA+z80Gkiy4Wn3zLV3XMj+sRQJrg6D4RfuzoazhHUX5wHoHRw==
X-Received: by 2002:ac8:7152:: with SMTP id h18mr389503qtp.349.1582661398025;
        Tue, 25 Feb 2020 12:09:58 -0800 (PST)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e130sm7786253qkb.72.2020.02.25.12.09.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 12:09:57 -0800 (PST)
From:   Qian Cai <cai@lca.pw>
To:     darrick.wong@oracle.com
Cc:     elver@google.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] xfs: fix data races in inode->i_*time
Date:   Tue, 25 Feb 2020 15:09:45 -0500
Message-Id: <1582661385-30210-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

inode->i_*time could be accessed concurrently. The plain reads in
xfs_vn_getattr() is lockless which result in data races. To avoid bad
compiler optimizations like load tearing, adding pairs of
READ|WRITE_ONCE(). While at it, also take care of xfs_setattr_time()
which presumably could run concurrently with xfs_vn_getattr() as well.
The data races were reported by KCSAN,

 write to 0xffff9275a1920ad8 of 16 bytes by task 47311 on cpu 46:
  xfs_vn_update_time+0x1b0/0x400 [xfs]
  xfs_vn_update_time at fs/xfs/xfs_iops.c:1122
  update_time+0x57/0x80
  file_update_time+0x143/0x1f0
  __xfs_filemap_fault+0x1be/0x3d0 [xfs]
  xfs_filemap_page_mkwrite+0x25/0x40 [xfs]
  do_page_mkwrite+0xf7/0x250
  do_fault+0x679/0x920
  __handle_mm_fault+0xc9f/0xd40
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x6f9
  page_fault+0x34/0x40

 4 locks held by doio/47311:
  #0: ffff9275e7d70808 (&mm->mmap_sem#2){++++}, at: do_page_fault+0x143/0x6f9
  #1: ffff9274864394d8 (sb_pagefaults){.+.+}, at: __xfs_filemap_fault+0x19b/0x3d0 [xfs]
  #2: ffff9274864395b8 (sb_internal){.+.+}, at: xfs_trans_alloc+0x2af/0x3c0 [xfs]
  #3: ffff9275a1920920 (&xfs_nondir_ilock_class){++++}, at: xfs_ilock+0x116/0x2c0 [xfs]
 irq event stamp: 42649
 hardirqs last  enabled at (42649): [<ffffffffb22dcdb3>] _raw_spin_unlock_irqrestore+0x53/0x60
 hardirqs last disabled at (42648): [<ffffffffb22dcad1>] _raw_spin_lock_irqsave+0x21/0x60
 softirqs last  enabled at (42306): [<ffffffffb260034c>] __do_softirq+0x34c/0x57c
 softirqs last disabled at (42299): [<ffffffffb18c6762>] irq_exit+0xa2/0xc0

 read to 0xffff9275a1920ad8 of 16 bytes by task 47312 on cpu 40:
  xfs_vn_getattr+0x20c/0x6a0 [xfs]
  xfs_vn_getattr at fs/xfs/xfs_iops.c:551
  vfs_getattr_nosec+0x11a/0x170
  vfs_statx_fd+0x54/0x90
  __do_sys_newfstat+0x40/0x90
  __x64_sys_newfstat+0x3a/0x50
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 no locks held by doio/47312.
 irq event stamp: 43883
 hardirqs last  enabled at (43883): [<ffffffffb1805119>] do_syscall_64+0x39/0xb05
 hardirqs last disabled at (43882): [<ffffffffb1803ede>] trace_hardirqs_off_thunk+0x1a/0x1c
 softirqs last  enabled at (43844): [<ffffffffb260034c>] __do_softirq+0x34c/0x57c
 softirqs last disabled at (43141): [<ffffffffb18c6762>] irq_exit+0xa2/0xc0

Signed-off-by: Qian Cai <cai@lca.pw>
---
 fs/xfs/xfs_iops.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 81f2f93caec0..2d5ca13ee9da 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -547,9 +547,9 @@
 	stat->uid = inode->i_uid;
 	stat->gid = inode->i_gid;
 	stat->ino = ip->i_ino;
-	stat->atime = inode->i_atime;
-	stat->mtime = inode->i_mtime;
-	stat->ctime = inode->i_ctime;
+	stat->atime = READ_ONCE(inode->i_atime);
+	stat->mtime = READ_ONCE(inode->i_mtime);
+	stat->ctime = READ_ONCE(inode->i_ctime);
 	stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
 
@@ -614,11 +614,11 @@
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
+		WRITE_ONCE(inode->i_atime, iattr->ia_atime);
 	if (iattr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = iattr->ia_ctime;
+		WRITE_ONCE(inode->i_ctime, iattr->ia_ctime);
 	if (iattr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = iattr->ia_mtime;
+		WRITE_ONCE(inode->i_mtime, iattr->ia_mtime);
 }
 
 static int
@@ -1117,11 +1117,11 @@
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (flags & S_CTIME)
-		inode->i_ctime = *now;
+		WRITE_ONCE(inode->i_ctime, *now);
 	if (flags & S_MTIME)
-		inode->i_mtime = *now;
+		WRITE_ONCE(inode->i_mtime, *now);
 	if (flags & S_ATIME)
-		inode->i_atime = *now;
+		WRITE_ONCE(inode->i_atime, *now);
 
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, log_flags);
-- 
1.8.3.1

