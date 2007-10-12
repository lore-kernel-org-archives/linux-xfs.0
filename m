Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Oct 2007 18:53:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9C1rR49019351
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 18:53:29 -0700
Subject: TAKE 971603 - Turn off XBF_ASYNC flag before re-reading superblock.
Message-Id: <20071012015323.DF38258C38F1@chook.melbourne.sgi.com>
Date: Fri, 12 Oct 2007 11:53:23 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Turn off XBF_ASYNC flag before re-reading superblock.

Date:  Fri Oct 12 11:52:21 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-getsb
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29871a
fs/xfs/xfs_log_recover.c - 1.330 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.330&r2=text&tr2=1.329&f=h
	- Turn off XBF_ASYNC flag before re-reading superblock.
