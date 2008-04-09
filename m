Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:23:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m397NiiJ018753
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:23:46 -0700
Subject: PARTIAL TAKE 980084 - Warn if errors come from block_truncate_page().
Message-Id: <20080409072418.C006A58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:24:18 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Warn if errors come from block_truncate_page().

block_truncate_page() can return errors that we currently
ignore and silently discard. We should not ever get errors
reported here - an error indicates a bug somewhere else.
Hence catch the error and issue a stack dump to the syslog
because we cannot propagate the error any further up the
call chain.


Date:  Wed Apr  9 17:24:00 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30800a
fs/xfs/linux-2.6/xfs_iops.c - 1.282 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.282&r2=text&tr2=1.281&f=h
	- Warn if errors come from block_truncate_page().
