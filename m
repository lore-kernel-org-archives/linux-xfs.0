Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 01:21:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L8LEkA023422
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 01:21:17 -0700
Subject: PARTIAL TAKE 976035 - Cleanup xfs_attr a bit.
Message-Id: <20080421082152.758E158C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 18:21:52 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Cleanup xfs_attr a bit with xfs_name and remove cred parameter


Date:  Mon Apr 21 18:20:53 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/kern_ci
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30913a
fs/xfs/xfs_acl.c - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- Remove cred parameter from xfs_attr_get

fs/xfs/xfs_attr.c - 1.148 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.148&r2=text&tr2=1.147&f=h
	- Start using xfs_name and remove cred parameter

fs/xfs/xfs_attr.h - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- Remove unused function declarations

fs/xfs/linux-2.6/xfs_ioctl.c - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
	- Remove cred parameter from xfs_attr_get

fs/xfs/dmapi/xfs_dm.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- Remove cred parameter from xfs_attr_get

fs/xfs/xfs_vnodeops.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- Remove cred parameter from xfs_attr_get
