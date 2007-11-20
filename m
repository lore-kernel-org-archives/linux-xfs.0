Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 21:21:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAK5LGDa004392
	for <xfs@oss.sgi.com>; Mon, 19 Nov 2007 21:21:19 -0800
Subject: PARTIAL TAKE 971186 - Use kernel-supplied "roundup_pow_of_two" for simplicity
Message-Id: <20071120052116.92D0858C4C0A@chook.melbourne.sgi.com>
Date: Tue, 20 Nov 2007 16:21:16 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use kernel-supplied "roundup_pow_of_two" for simplicity

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Date:  Tue Nov 20 16:20:46 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  rpjday@crashcourse.ca

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30098a
fs/xfs/xfs_inode.c - 1.487 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.487&r2=text&tr2=1.486&f=h
	- Use roundup_pow_of_two() instead of hand rolling it.

fs/xfs/xfs_inode.h - 1.238 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.238&r2=text&tr2=1.237&f=h
	- Use roundup_pow_of_two() instead of hand rolling it.
