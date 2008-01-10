Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jan 2008 20:56:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0A4tpjw001576
	for <xfs@oss.sgi.com>; Wed, 9 Jan 2008 20:55:55 -0800
Subject: TAKE 974151 - prevent panic during log recovery due to bogus operation header length
Message-Id: <20080110045603.A61C458C4C0F@chook.melbourne.sgi.com>
Date: Thu, 10 Jan 2008 15:56:03 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

prevent panic during log recovery due to bogus operation header length

A problem was reported where a system panicked in log recovery due
to a corrupt log record.  The cause of the corruption is not known
but this change will at least prevent a crash for this specific
scenario.  Log recovery definitely needs some more work in this area.

Date:  Thu Jan 10 15:54:49 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-free
Inspected by:  
dgc
hch@infradead.org
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30318a
fs/xfs/xfs_log_recover.c - 1.333 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.333&r2=text&tr2=1.332&f=h
	- prevent panic during log recovery due to bogus operation header length
