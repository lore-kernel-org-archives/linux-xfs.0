Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 01:37:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L8avbE004567
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:36:59 -0700
Subject: TAKE 981498 - kmem_free/realloc should use const void *
Message-Id: <20080521083743.0909158C4C29@chook.melbourne.sgi.com>
Date: Wed, 21 May 2008 18:37:42 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kmem_free and kmem_realloc to use const void *


Date:  Wed May 21 18:37:13 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31212a
fs/xfs/linux-2.6/kmem.h - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.h.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- kmem_free and kmem_realloc to use const void *

fs/xfs/linux-2.6/kmem.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- kmem_free and kmem_realloc to use const void *
