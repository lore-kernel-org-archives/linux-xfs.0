Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A2AC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 20:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE03020679
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 20:51:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tdi/I60E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbgEVUvY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 16:51:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38122 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731014AbgEVUvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 16:51:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MKlmDM073415;
        Fri, 22 May 2020 20:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=drP7/HHoal0yXG4Fpu0/xgdYChPYTHuRmSqtgjprTvQ=;
 b=Tdi/I60EHV+DKN5+Oox6KP0EQZ+C+04CsCribEF/6SS6x5W2ghIyX/B6p0y3SiJLVwqj
 9l4uzYx+6/LmxX+YN9vlmJx+mBjb1Vv4oJ9i8Au8tu5FOjarTt6xeobafltGrsVOBq+x
 CBHACvk8kCoWNCBvk19O5V9eidfAdurCEEUeLCR0qowPSh7/v3xPW2UxlosHhKcSuE3N
 Ys3lRcnpPG6JV1vpAxclSXrO2JSK91N2zUEb49d6cLTE43WHaNOYSCummJmdKrFRl4BV
 pmE/qCTuCeGNw0eIkD6WS35lRY9NJiZWioPm80kkzt/CIadwroUchgZpQqYV+3VFhXdQ Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31501rp8tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 20:51:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MKmkVe113470;
        Fri, 22 May 2020 20:51:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 313gj84wbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 20:51:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MKpI6S012489;
        Fri, 22 May 2020 20:51:18 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 13:51:17 -0700
Date:   Fri, 22 May 2020 13:51:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Airlie <airlied@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: lockdep trace with xfs + mm in it from 5.7.0-rc5
Message-ID: <20200522205116.GD8230@magnolia>
References: <CAPM=9tyy5vubggbcj32bGpA_h6yDaBNM3QeJPySTzci-etfBZw@mail.gmail.com>
 <20200521231312.GJ17635@magnolia>
 <20200522003027.GC2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522003027.GC2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

OTOH, it didn't take that long to whip up a patch.

Dave, does this fix your problem?

--D
---
xfs: more lockdep whackamole with kmem_alloc*

Dave Airlie reported the following lockdep complaint:

>  ======================================================
>  WARNING: possible circular locking dependency detected
>  5.7.0-0.rc5.20200515git1ae7efb38854.1.fc33.x86_64 #1 Not tainted
>  ------------------------------------------------------
>  kswapd0/159 is trying to acquire lock:
>  ffff9b38d01a4470 (&xfs_nondir_ilock_class){++++}-{3:3},
>  at: xfs_ilock+0xde/0x2c0 [xfs]
> 
>  but task is already holding lock:
>  ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
>  __fs_reclaim_acquire+0x5/0x30
> 
>  which lock already depends on the new lock.
> 
> 
>  the existing dependency chain (in reverse order) is:
> 
>  -> #1 (fs_reclaim){+.+.}-{0:0}:
>         fs_reclaim_acquire+0x34/0x40
>         __kmalloc+0x4f/0x270
>         kmem_alloc+0x93/0x1d0 [xfs]
>         kmem_alloc_large+0x4c/0x130 [xfs]
>         xfs_attr_copy_value+0x74/0xa0 [xfs]
>         xfs_attr_get+0x9d/0xc0 [xfs]
>         xfs_get_acl+0xb6/0x200 [xfs]
>         get_acl+0x81/0x160
>         posix_acl_xattr_get+0x3f/0xd0
>         vfs_getxattr+0x148/0x170
>         getxattr+0xa7/0x240
>         path_getxattr+0x52/0x80
>         do_syscall_64+0x5c/0xa0
>         entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
>  -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
>         __lock_acquire+0x1257/0x20d0
>         lock_acquire+0xb0/0x310
>         down_write_nested+0x49/0x120
>         xfs_ilock+0xde/0x2c0 [xfs]
>         xfs_reclaim_inode+0x3f/0x400 [xfs]
>         xfs_reclaim_inodes_ag+0x20b/0x410 [xfs]
>         xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
>         super_cache_scan+0x190/0x1e0
>         do_shrink_slab+0x184/0x420
>         shrink_slab+0x182/0x290
>         shrink_node+0x174/0x680
>         balance_pgdat+0x2d0/0x5f0
>         kswapd+0x21f/0x510
>         kthread+0x131/0x150
>         ret_from_fork+0x3a/0x50
> 
>  other info that might help us debug this:
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(fs_reclaim);
>                                 lock(&xfs_nondir_ilock_class);
>                                 lock(fs_reclaim);
>    lock(&xfs_nondir_ilock_class);
> 
>   *** DEADLOCK ***
> 
>  4 locks held by kswapd0/159:
>   #0: ffffffffbbb8bd00 (fs_reclaim){+.+.}-{0:0}, at:
>  __fs_reclaim_acquire+0x5/0x30
>   #1: ffffffffbbb7cef8 (shrinker_rwsem){++++}-{3:3}, at:
>  shrink_slab+0x115/0x290
>   #2: ffff9b39f07a50e8
>  (&type->s_umount_key#56){++++}-{3:3}, at: super_cache_scan+0x38/0x1e0
>   #3: ffff9b39f077f258
>  (&pag->pag_ici_reclaim_lock){+.+.}-{3:3}, at:
>  xfs_reclaim_inodes_ag+0x82/0x410 [xfs]

This is a known false positive because inodes cannot simultaneously be
getting reclaimed and the target of a getxattr operation, but lockdep
doesn't know that.  We can (selectively) shut up lockdep until either
it gets smarter or we change inode reclaim not to require the ILOCK by
applying a stupid GFP_NOLOCKDEP bandaid.

Reported-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/kmem.h                 |    6 +++++-
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 6143117770e9..11623489b769 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -19,6 +19,7 @@ typedef unsigned __bitwise xfs_km_flags_t;
 #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
 #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
 #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
+#define KM_NOLOCKDEP	((__force xfs_km_flags_t)0x0020u)
 
 /*
  * We use a special process flag to avoid recursive callbacks into
@@ -30,7 +31,7 @@ kmem_flags_convert(xfs_km_flags_t flags)
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_NOFS|KM_MAYFAIL|KM_ZERO));
+	BUG_ON(flags & ~(KM_NOFS | KM_MAYFAIL | KM_ZERO | KM_NOLOCKDEP));
 
 	lflags = GFP_KERNEL | __GFP_NOWARN;
 	if (flags & KM_NOFS)
@@ -49,6 +50,9 @@ kmem_flags_convert(xfs_km_flags_t flags)
 	if (flags & KM_ZERO)
 		lflags |= __GFP_ZERO;
 
+	if (flags & KM_NOLOCKDEP)
+		lflags |= __GFP_NOLOCKDEP;
+
 	return lflags;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 224462b8bf08..55e184722b81 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -489,7 +489,7 @@ xfs_attr_copy_value(
 	}
 
 	if (!args->value) {
-		args->value = kmem_alloc_large(valuelen, 0);
+		args->value = kmem_alloc_large(valuelen, KM_NOLOCKDEP);
 		if (!args->value)
 			return -ENOMEM;
 	}
