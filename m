Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 18:51:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8C1pD4p000545
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 18:51:15 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA22197; Wed, 12 Sep 2007 11:51:10 +1000
Message-ID: <46E7460D.3000502@sgi.com>
Date: Wed, 12 Sep 2007 11:51:09 +1000
From: Donald Douwsma <donaldd@sgi.com>
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

Eric Sandeen wrote:
> I have a series of patches at
> http://sandeen.net/xfs-patches/patches-spinlock-unobfuscate.tar.bz2
> 
> to get rid of the macros upon macros hiding xfs' use of spinlocks, via
> for example AIL_LOCK->mutex_spinlock->spin_lock.  This also gets rid of
> the unused "cookie" variables declared via SPLDECL(s) and other
> open-coded unsigned long s; declarations.
> 

Hi Eric,

> unwrap_AIL_LOCK
Here you change the comment to use the descriptive name

- * We must not be holding the AIL_LOCK at this point. Calling incore() to
- * search the buffer cache can be a time consuming thing, and AIL_LOCK is a
+ * We must not be holding the AIL lock at this point. Calling incore() to
+ * search the buffer cache can be a time consuming thing, and AIL lock is a
   * spinlock.
   */

> unwrap_LOG_LOCK
> unwrap_GRANT_LOCK
> unwrap_XFS_DQ_PINUNLOCK
> unwrap_pagb_lock
> unwrap_xfs_dabuf_global_lock
> unwrap_mru_lock
> unwrap_XFS_SB_LOCK
But here you use the name of the lock variable.

         /*
-        * We actually don't have to acquire the SB_LOCK at all.
+        * We actually don't have to acquire the m_sb_lock at all.
          * This can only be called from mount, and that's single threaded. XXX
          */

> no_kt_lock
> cleanup_lock_goop
> 
> Patches have comments/descriptions/signed-off lines in them.
> 
> By the end of the series, spin.h is almost empty, only spin_lock_init /
> spinlock_destroy are left, and could maybe even be pulled out.... wasn't
> sure how far to go.  Since the kernel has a mutex_destroy, I wonder if
> spinlocks will ever get similar treatment... anyway....
So the only things left in spin.h are the spinlock headers and

  #define spinlock_init(lock, name)      spin_lock_init(lock)
  #define        spinlock_destroy(lock)

I cant se why we need these abstractions. Should we nuke the whole file and
add the spinlock headers elsewhere?

Don
