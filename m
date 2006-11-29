Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 19:56:20 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAT3u9aG012229
	for <xfs@oss.sgi.com>; Tue, 28 Nov 2006 19:56:11 -0800
Subject: TAKE 958639 - xfs buftarg flags are almost broken
Message-Id: <20061129033348.1FBE458F5C06@chook.melbourne.sgi.com>
Date: Wed, 29 Nov 2006 14:33:48 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Current usage of buftarg flags is incorrect.

The {test,set,clear}_bit() operations take a bit index for
the bit to operate on. The XBT_* flags are defined as bit
fields which is incorrect, not to mention the way the bit
fields are enumerated is broken too. This was only working
by chance.

Fix the definitions of the flags and make the code using
them use the {test,set,clear}_bit() operations correctly.

Date:  Wed Nov 29 14:32:56 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27565a
fs/xfs/linux-2.6/xfs_buf.h - 1.118 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.118&r2=text&tr2=1.117&f=h
	- Fix enumeration of xfs_buftarg_flags_t to declare bit indexes
	  rather than bit fields as required by test_bit() and friends.

fs/xfs/linux-2.6/xfs_buf.c - 1.231 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.231&r2=text&tr2=1.230&f=h
	- Set bt_flags appropriately for delwri list flushing rather than
	  abusing flag indexes.
