Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 22:05:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8B55X4p018807
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 22:05:34 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 4570C187B8C1D
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 00:05:36 -0500 (CDT)
Message-ID: <46E6221E.803@sandeen.net>
Date: Tue, 11 Sep 2007 00:05:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH SERIES] untangle spinlock macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

I have a series of patches at
http://sandeen.net/xfs-patches/patches-spinlock-unobfuscate.tar.bz2

to get rid of the macros upon macros hiding xfs' use of spinlocks, via
for example AIL_LOCK->mutex_spinlock->spin_lock.  This also gets rid of
the unused "cookie" variables declared via SPLDECL(s) and other
open-coded unsigned long s; declarations.

patches in the tarball, broken out by lock as requested a while
ago by dgc:

unwrap_AIL_LOCK
unwrap_LOG_LOCK
unwrap_GRANT_LOCK
unwrap_XFS_DQ_PINUNLOCK
unwrap_pagb_lock
unwrap_xfs_dabuf_global_lock
unwrap_mru_lock
unwrap_XFS_SB_LOCK
no_kt_lock
cleanup_lock_goop

Patches have comments/descriptions/signed-off lines in them.

By the end of the series, spin.h is almost empty, only spin_lock_init /
spinlock_destroy are left, and could maybe even be pulled out.... wasn't
sure how far to go.  Since the kernel has a mutex_destroy, I wonder if
spinlocks will ever get similar treatment... anyway....

I can post them to the list individually if preferred... though it's
fairly mechanical and not terribly interesting...

Thanks,
-Eric
