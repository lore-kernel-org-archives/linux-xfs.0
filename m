Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 21:17:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K4H0do006604
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 21:17:02 -0700
Subject: TAKE 966503 - Kill off xfs_count_bits
Message-Id: <20070620041655.A726258C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 14:16:55 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Kill off xfs_count_bits

xfs_count_bits is only called once, and is then compared to 0.
IOW, what it really wants to know is, is the bitmap empty.
This can be done more simply, certainly.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Wed Jun 20 14:16:30 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28944a
fs/xfs/xfs_buf_item.c - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- Use xfs_bitmap_empty instead of xfs_count_bits to determine
	  if the buf item is clean.

fs/xfs/xfs_bit.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- xfs_count_bits is not really used to count bits, just to
	  determine if the bitmap is empty or not. Replace it with
	  a function that does just that.

fs/xfs/xfs_bit.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- xfs_count_bits is not really used to count bits, just to
	  determine if the bitmap is empty or not. Replace it with
	  a function that does just that.
