Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 03:55:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72Atkbm020226
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 03:55:48 -0700
Subject: PARTIAL TAKE 968563 - fix constness warning in dmapi
Message-Id: <20070802105543.0AFC658F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 20:55:42 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix constness warning in dmapi

File operations are const now so make sure the dmapi code propagates
this properly.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug  2 20:54:51 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29313a
fs/xfs/dmapi/xfs_dm_fsops.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- make file operations const.




Modid:  linux-melb:dmapi:29313b
fs/dmapi/dmapi_kern.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/fs/dmapi/dmapi_kern.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- make file operations const.
