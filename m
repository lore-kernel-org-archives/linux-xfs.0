Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 02:26:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6J9QDDW002077
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 02:26:26 -0700
Date: Wed, 19 Jul 2006 19:25:14 +1000 (AEST)
From: Timothy Shimmin <tes@snort.melbourne.sgi.com>
Message-Id: <200607190925.k6J9PErG32441978@snort.melbourne.sgi.com>
Subject: TAKE 954372 - xfs EA list callback functionality + namespace abstractions
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Add EA list callbacks for xfs kernel use.
Cleanup some namespace code.

Date:  Wed Jul 19 19:19:40 AEST 2006
Workarea:  snort.melbourne.sgi.com:/home/tes/isms/xfs-linux
Inspected by:  nathans@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26583a
xfs_attr_leaf.h - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.h.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- Some namespace macros and additional fields
	  for the EA list context.

xfs_attr_leaf.c - 1.103 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.103&r2=text&tr2=1.102&f=h
	- Add calls to EA list callback.
	  Allow callback to be given a value as well as a name.
	  Allow callback to indicate that the list iteration should
	  finish early allowing to be used for searching.
	  Abstract some namespace operations to simplify code for additions
	  of more namespaces if needed.

xfs_attr.c - 1.139 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.139&r2=text&tr2=1.138&f=h
	- Add EA list callbacks.

xfs_attr.h - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
	- Some prototype additions.
