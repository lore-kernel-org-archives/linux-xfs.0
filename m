Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Aug 2006 21:29:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7A4TCDW024597
	for <linux-xfs@oss.sgi.com>; Wed, 9 Aug 2006 21:29:21 -0700
Subject: TAKE 955303 - fix xfs_free_extent NULL dereference
Message-Id: <20060810042829.15F8F58C6F7C@chook.melbourne.sgi.com>
Date: Thu, 10 Aug 2006 14:28:29 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix xfs_free_extent related NULL pointer dereference.

We recently fixed an out-of-space deadlock in XFS, and part of that 
fix involved the addition of the XFS_ALLOC_FLAG_FREEING flag to some
of the space allocator calls to indicate they're freeing space, not
allocating it.  There was a missed xfs_alloc_fix_freelist condition 
test that did not correctly test "flags".  The same test would also 
test an uninitialised structure field (args->userdata) and depending
on its value either would or would not return early with a critical 
buffer pointer set to NULL.
    
This fixes that up, adds asserts to several places to catch future
botches of this nature, and skips sections of xfs_alloc_fix_freelist
that are irrelevent for the space-freeing case.


Date:  Thu Aug 10 14:27:43 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26743a
xfs_alloc.c - 1.183 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.183&r2=text&tr2=1.182&f=h
