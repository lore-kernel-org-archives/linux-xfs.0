Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 21:39:55 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB65dmUU017556
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 21:39:51 -0800
Subject: TAKE 974224 - xfsbufd doesn't freeze
Message-Id: <20071206053950.CDF2258FA249@chook.melbourne.sgi.com>
Date: Thu,  6 Dec 2007 16:39:50 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make xfsbufd threads freezable

Fix breakage caused by commit 831441862956fffa17b9801db37e6ea1650b0f69
that did not introduce the necessary call to set_freezable() in
xfs/linux-2.6/xfs_buf.c .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>


Date:  Thu Dec  6 16:38:20 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  rjw@sisk.pl

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30203a
fs/xfs/linux-2.6/xfs_buf.c - 1.252 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.252&r2=text&tr2=1.251&f=h
	- Make xfsbufd freezable again.
