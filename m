Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Aug 2006 23:43:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7I6gYDW016627
	for <linux-xfs@oss.sgi.com>; Thu, 17 Aug 2006 23:42:45 -0700
Date: Fri, 18 Aug 2006 16:41:09 +1000 (AEST)
From: Timothy Shimmin <tes@snort.melbourne.sgi.com>
Message-Id: <200608180641.k7I6f9Iq57761523@snort.melbourne.sgi.com>
Subject: TAKE 942533 - xfs_freeze hung on ticket sema in xlog_grant_log_space
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fixes the leak in reservation space because we weren't ungranting space
for the unmount record - which becomes a problem in the freeze/thaw
scenario.

--Tim

Date:  Fri Aug 18 16:39:22 AEST 2006
Inspected by:  dgc@sgi.com

Modid:  xfs-linux-melb:xfs-kern:26815a
xfsidbg.c - 1.306 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.306&r2=text&tr2=1.305&f=h
	- Add some missing transaction types to be printed.

xfs_log.c - 1.327 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.327&r2=text&tr2=1.326&f=h
	- remember to ungrant space for the unmount record.

xfs_log_priv.h - 1.117 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.117&r2=text&tr2=1.116&f=h
	- create a type for XLOG_UNMOUNT_REC_TYPE so that we can see
	  this in kdb transaction printing.
