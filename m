Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 05:29:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2BCT4vC012032
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 05:29:07 -0700
Subject: PARTIAL TAKE 978682 - Replace custom AIL linked-list code with struct list_head
Message-Id: <20080311122929.2390C58C4C0F@chook.melbourne.sgi.com>
Date: Tue, 11 Mar 2008 23:29:29 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Replace custom AIL linked-list code with struct list_head

Replace the xfs_ail_entry_t with a struct list_head and clean
the surrounding code up. Also fixes a livelock in
xfs_trans_first_push_ail() by terminating the loop at the
head of the list correctly.

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>


Date:  Tue Mar 11 23:29:03 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30636a
fs/xfs/xfs_trans_ail.c - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
	- Replace custom AIL linked-list code with struct list_head.
	  Fix livelock in xfs_trans_first_push_ail() by terminating search loop
	  correctly.

fs/xfs/xfs_mount.h - 1.260 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.260&r2=text&tr2=1.259&f=h
	- Replace custom AIL linked-list code with struct list_head

fs/xfs/xfs_trans.h - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- Replace custom AIL linked-list code with struct list_head
