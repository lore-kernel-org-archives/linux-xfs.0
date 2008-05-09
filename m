Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:33:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m491WtVt009256
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:32:58 -0700
Subject: TAKE 981502 - Ensure that 2 GiB xfs logs work properly.
Message-Id: <20080509013338.4264358C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:33:38 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Ensure that 2 GiB xfs logs work properly.

We found this while experimenting with 2GiB xfs logs.
The previous code never assumed that xfs logs would
ever get so large.

 
Signed-off-by: Michael Nishimoto <miken@agami.com>


Date:  Fri May  9 11:33:19 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  miken@agami.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31058a
fs/xfs/xfs_log.c - 1.358 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.358&r2=text&tr2=1.357&f=h
	- Fix log space wrapping issue when using 2GB logs.
