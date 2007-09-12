Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 18:04:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8C1414p025169
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 18:04:04 -0700
Message-ID: <46E73BAD.4000906@sgi.com>
Date: Wed, 12 Sep 2007 11:06:53 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH SERIES] untangle spinlock macros
References: <46E6221E.803@sandeen.net>
In-Reply-To: <46E6221E.803@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

They look good to me.  There's still a few unused variables left over
but nothing we can't fix up.

Eric Sandeen wrote:
> I have a series of patches at
> http://sandeen.net/xfs-patches/patches-spinlock-unobfuscate.tar.bz2
> 
> to get rid of the macros upon macros hiding xfs' use of spinlocks, via
> for example AIL_LOCK->mutex_spinlock->spin_lock.  This also gets rid of
> the unused "cookie" variables declared via SPLDECL(s) and other
> open-coded unsigned long s; declarations.
> 
> patches in the tarball, broken out by lock as requested a while
> ago by dgc:
> 
> unwrap_AIL_LOCK
> unwrap_LOG_LOCK
> unwrap_GRANT_LOCK
> unwrap_XFS_DQ_PINUNLOCK
> unwrap_pagb_lock
> unwrap_xfs_dabuf_global_lock
> unwrap_mru_lock
> unwrap_XFS_SB_LOCK
> no_kt_lock
> cleanup_lock_goop
> 
> Patches have comments/descriptions/signed-off lines in them.
> 
> By the end of the series, spin.h is almost empty, only spin_lock_init /
> spinlock_destroy are left, and could maybe even be pulled out.... wasn't
> sure how far to go.  Since the kernel has a mutex_destroy, I wonder if
> spinlocks will ever get similar treatment... anyway....
> 
> I can post them to the list individually if preferred... though it's
> fairly mechanical and not terribly interesting...
> 
> Thanks,
> -Eric
> 
> 
> 
