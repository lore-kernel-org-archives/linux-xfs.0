Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4BCC33CB3
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A0CE24683
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nEkEMFLJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgA1Qo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 11:44:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgA1Qo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 11:44:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SGSOX0029100;
        Tue, 28 Jan 2020 16:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EnGABx1ma5IeQDJBF2OCI+TQA4gF+7ZfyfKYnjRd700=;
 b=nEkEMFLJGfHzofqxPRTQNSefesO10N5G0EAcY2MnHlqRIKOEDUHPkSAjmOZvCj1RF+o1
 jgEQIBVhoDPTQjp6wEPNJ4NHdWuhlNZrKADaX4xzBfzpK3TPCr06I8avtnhUdI+tHEZB
 IjFX1RF69ypHtn/xUquxQcXb6Oa4DUGm8CM4WrnS3JvApMDHDqoF/0i0Kja5YYW2FUf6
 Wkc2fSOP8avPbMnKzUqTgRxttNZJA1QS/fzHwFHYPNFeIRMn7+/n/VstufJ5n2gL/Q/d
 iibzr9Uq4QQzII/ohoeMzclIZdfhZwY69hSyEenVS7s2M4aI8ZfNymHYpVNxnWjptUGG tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xrear7f3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 16:44:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00SGSuj5170819;
        Tue, 28 Jan 2020 16:44:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xtg7v8hh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 16:44:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00SGinx0009218;
        Tue, 28 Jan 2020 16:44:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jan 2020 08:44:49 -0800
Date:   Tue, 28 Jan 2020 08:44:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: replace mr*() functions with native rwsem calls
Message-ID: <20200128164448.GQ3447196@magnolia>
References: <20200128145528.2093039-1-preichl@redhat.com>
 <20200128145528.2093039-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128145528.2093039-5-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=648
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=711 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 03:55:28PM +0100, Pavel Reichl wrote:
> Remove mr*() functions as they only wrap the standard kernel functions
> for kernel manimulation.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/mrlock.h    | 61 ----------------------------------------------
>  fs/xfs/xfs_inode.c | 33 +++++++++++++------------
>  fs/xfs/xfs_linux.h |  1 -
>  fs/xfs/xfs_super.c |  6 ++---
>  4 files changed, 19 insertions(+), 82 deletions(-)
>  delete mode 100644 fs/xfs/mrlock.h
> 
> diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
> deleted file mode 100644
> index 245f417a7ffe..000000000000
> --- a/fs/xfs/mrlock.h
> +++ /dev/null
> @@ -1,61 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - */
> -#ifndef __XFS_SUPPORT_MRLOCK_H__
> -#define __XFS_SUPPORT_MRLOCK_H__
> -
> -#include <linux/rwsem.h>
> -
> -typedef struct {
> -	struct rw_semaphore	mr_lock;
> -} mrlock_t;
> -
> -#if defined(DEBUG) || defined(XFS_WARN)
> -#define mrinit(smp, name)	init_rwsem(smp)
> -#else
> -#define mrinit(smp, name)	init_rwsem(smp)
> -#endif
> -
> -#define mrlock_init(smp, t, n, s)	mrinit(smp, n)
> -#define mrfree(smp)		do { } while (0)
> -
> -static inline void mraccess_nested(struct rw_semaphore *s, int subclass)
> -{
> -	down_read_nested(s, subclass);
> -}
> -
> -static inline void mrupdate_nested(struct rw_semaphore *s, int subclass)
> -{
> -	down_write_nested(s, subclass);
> -}
> -
> -static inline int mrtryaccess(struct rw_semaphore *s)
> -{
> -	return down_read_trylock(s);
> -}
> -
> -static inline int mrtryupdate(struct rw_semaphore *s)
> -{
> -	if (!down_write_trylock(s))
> -		return 0;
> -	return 1;
> -}
> -
> -static inline void mrunlock_excl(struct rw_semaphore *s)
> -{
> -	up_write(s);
> -}
> -
> -static inline void mrunlock_shared(struct rw_semaphore *s)
> -{
> -	up_read(s);
> -}
> -
> -static inline void mrdemote(struct rw_semaphore *s)
> -{
> -	downgrade_write(s);
> -}
> -
> -#endif /* __XFS_SUPPORT_MRLOCK_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 567dae69cfac..01bca957e305 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -191,14 +191,15 @@ xfs_ilock(
>  	}
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_mmaplock,
> +				XFS_MMAPLOCK_DEP(lock_flags));

FWIW I would have started by converting mrlock_t to rw_semaphore in all
callers and then dropped mrlock_t, but this somewhat more circuitous
route works too.

--D

>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mraccess_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  	else if (lock_flags & XFS_ILOCK_SHARED)
> -		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  }
>  
>  /*
> @@ -242,27 +243,27 @@ xfs_ilock_nowait(
>  	}
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL) {
> -		if (!mrtryupdate(&ip->i_mmaplock))
> +		if (!down_write_trylock(&ip->i_mmaplock))
>  			goto out_undo_iolock;
>  	} else if (lock_flags & XFS_MMAPLOCK_SHARED) {
> -		if (!mrtryaccess(&ip->i_mmaplock))
> +		if (!down_read_trylock(&ip->i_mmaplock))
>  			goto out_undo_iolock;
>  	}
>  
>  	if (lock_flags & XFS_ILOCK_EXCL) {
> -		if (!mrtryupdate(&ip->i_lock))
> +		if (!down_write_trylock(&ip->i_lock))
>  			goto out_undo_mmaplock;
>  	} else if (lock_flags & XFS_ILOCK_SHARED) {
> -		if (!mrtryaccess(&ip->i_lock))
> +		if (!down_read_trylock(&ip->i_lock))
>  			goto out_undo_mmaplock;
>  	}
>  	return 1;
>  
>  out_undo_mmaplock:
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrunlock_excl(&ip->i_mmaplock);
> +		up_write(&ip->i_mmaplock);
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mrunlock_shared(&ip->i_mmaplock);
> +		up_read(&ip->i_mmaplock);
>  out_undo_iolock:
>  	if (lock_flags & XFS_IOLOCK_EXCL)
>  		up_write(&VFS_I(ip)->i_rwsem);
> @@ -309,14 +310,14 @@ xfs_iunlock(
>  		up_read(&VFS_I(ip)->i_rwsem);
>  
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrunlock_excl(&ip->i_mmaplock);
> +		up_write(&ip->i_mmaplock);
>  	else if (lock_flags & XFS_MMAPLOCK_SHARED)
> -		mrunlock_shared(&ip->i_mmaplock);
> +		up_read(&ip->i_mmaplock);
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrunlock_excl(&ip->i_lock);
> +		up_write(&ip->i_lock);
>  	else if (lock_flags & XFS_ILOCK_SHARED)
> -		mrunlock_shared(&ip->i_lock);
> +		up_read(&ip->i_lock);
>  
>  	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
>  }
> @@ -335,9 +336,9 @@ xfs_ilock_demote(
>  		~(XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
>  
>  	if (lock_flags & XFS_ILOCK_EXCL)
> -		mrdemote(&ip->i_lock);
> +		downgrade_write(&ip->i_lock);
>  	if (lock_flags & XFS_MMAPLOCK_EXCL)
> -		mrdemote(&ip->i_mmaplock);
> +		downgrade_write(&ip->i_mmaplock);
>  	if (lock_flags & XFS_IOLOCK_EXCL)
>  		downgrade_write(&VFS_I(ip)->i_rwsem);
>  
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 8738bb03f253..921a3eb093ed 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
>  #include "xfs_types.h"
>  
>  #include "kmem.h"
> -#include "mrlock.h"
>  
>  #include <linux/semaphore.h>
>  #include <linux/mm.h>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 760901783944..1289ce1f4e9e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -661,10 +661,8 @@ xfs_fs_inode_init_once(
>  	atomic_set(&ip->i_pincount, 0);
>  	spin_lock_init(&ip->i_flags_lock);
>  
> -	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
> -		     "xfsino", ip->i_ino);
> -	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
> -		     "xfsino", ip->i_ino);
> +	init_rwsem(&ip->i_mmaplock);
> +	init_rwsem(&ip->i_lock);
>  }
>  
>  /*
> -- 
> 2.24.1
> 
