Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 00:57:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M7vAbQ009604
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 00:57:11 -0700
Subject: TAKE 984429 - Do not access buffers after dropping reference count
Message-Id: <20080722075814.0D78358C4C3F@chook.melbourne.sgi.com>
Date: Tue, 22 Jul 2008 17:58:13 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Do not access buffers after dropping reference count

We should not access a buffer after dropping it's reference count otherwise
we could race with another thread that releases the final reference count
and frees the buffer causing us to access potentially unmapped memory.
The bug this change fixes only occured on DEBUG XFS since the offending
code was in an ASSERT.

Date:  Tue Jul 22 17:57:07 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-tot
Inspected by:  david@fromorbit.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31715a
fs/xfs/linux-2.6/xfs_buf.c - 1.258 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.258&r2=text&tr2=1.257&f=h
	- Do not access buffers after dropping reference count
