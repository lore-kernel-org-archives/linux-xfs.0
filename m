Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 22:12:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m415C31w030918
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 22:12:06 -0700
Subject: TAKE 978729 - Fix non-debug build breakage in xfsidbg.c
Message-Id: <20080501051239.7824558C4C15@chook.melbourne.sgi.com>
Date: Thu,  1 May 2008 15:12:39 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix non-debug build breakage in xfsidbg.c


Date:  Thu May  1 15:12:22 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31013a
fs/xfs/xfsidbg.c - 1.348 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.348&r2=text&tr2=1.347&f=h
	- l_iclog_bak only exists in debug kernels now.
