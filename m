Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:40:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0ed9h028620
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:40:41 -0700
Subject: PARTIAL TAKE 980084 - xfs_bdwrite() does not return errors.
Message-Id: <20080410004117.6D96658C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:41:17 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

xfs_bdwrite() does not return errors.

xfs_bdwrite() cannot return an error; it only queues buffers
to the delayed write list and as such never encounters anything
that can fail. Mark it void.


Date:  Thu Apr 10 10:41:01 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30825a
fs/xfs/linux-2.6/xfs_buf.h - 1.124 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.124&r2=text&tr2=1.123&f=h
	- xfs_bdwrite() does not return errors.

fs/xfs/linux-2.6/xfs_buf.c - 1.254 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h
	- xfs_bdwrite() does not return errors.
