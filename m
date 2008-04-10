Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 20:27:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A3QrNc022981
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 20:26:55 -0700
Subject: PARTIAL TAKE 976035 - cleanup: refactor xfs_dir2_leafn_lookup_int()
Message-Id: <20080410032727.0087E58C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 13:27:26 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Split xfs_dir2_leafn_lookup_int into its two pieces of functionality


Date:  Thu Apr 10 13:26:21 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30834a
fs/xfs/xfs_dir2_node.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Split xfs_dir2_leafn_lookup_int into its two pieces of functionality
