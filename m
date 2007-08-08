Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 01:14:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l788EFbm011124
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 01:14:19 -0700
Subject: TAKE 968837 - fix nasty quota hashtable allocation bug
Message-Id: <20070808081414.4BF9458C1762@chook.melbourne.sgi.com>
Date: Wed,  8 Aug 2007 18:14:14 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix nasty quota hashtable allocation bug

This git mod: 77e4635ae191774526ed695482a151ac986f3806

converted to a "greedy" allocation interface, but for the quota hashtables
it switched from allocating XFS_QM_HASHSIZE (nr of elements) xfs_dqhash_t's 
to  allocating only XFS_QM_HASHSIZE *bytes* - quite a lot smaller!  Then when 
we  converted hsize "back" to nr of elements (the division line) hsize went 
to 0. This was  leading to oopses when running any quota tests on the Fedora 8
test  kernel, but the problem has been there for almost a year.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Wed Aug  8 18:13:50 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29354a
fs/xfs/quota/xfs_qm.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- correct the quota hash allocation size so we allocate a hash the
	  size we mean and not something a lot smaller.
