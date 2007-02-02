Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Feb 2007 08:50:22 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l12GoDqw014528
	for <xfs@oss.sgi.com>; Fri, 2 Feb 2007 08:50:15 -0800
Received: from omx2.sgi.com ([198.149.32.25])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l12GdxDW001507
	for <xfs@oss.sgi.com>; Fri, 2 Feb 2007 10:39:59 -0600
Received: from lab41.emea.sgi.com (lab41.emea.sgi.com [144.253.75.41])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l12GfEk6022797
	for <xfs@oss.sgi.com>; Fri, 2 Feb 2007 08:41:14 -0800
Subject: TAKE 960788 - Fix callers of xfs_iozero() to zero the correct range.
Message-Id: <20070202165709.37298576B9@lab41.emea.sgi.com>
Date: Fri,  2 Feb 2007 16:57:09 +0000 (GMT)
From: lachlan@lab41.emea.sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Fix callers of xfs_iozero() to zero the correct range.

The problem is the two callers of xfs_iozero() are rounding out the range
to be zeroed to the end of a fsb and in some cases this extends past the new
eof.  The call to commit_write() in xfs_iozero() will cause the Linux inode's
file size to be set too high.

Date:  Sat Feb  3 03:36:02 AEDT 2007
Workarea:  vpn-emea-sw-emea-160-1.emea.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28013a
fs/xfs/xfs_inode.c - 1.458 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.458&r2=text&tr2=1.457&f=h
fs/xfs/linux-2.6/xfs_lrw.h - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
fs/xfs/linux-2.6/xfs_lrw.c - 1.254 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h
	- Fix callers of xfs_iozero() to zero the correct range.
