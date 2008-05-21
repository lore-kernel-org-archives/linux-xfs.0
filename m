Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 19:39:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L2d2Vd005642
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 19:39:03 -0700
Subject: TAKE 981520 - Add op_flags field to xfs_da_args
Message-Id: <20080521023948.7FF1D58C4C29@chook.melbourne.sgi.com>
Date: Wed, 21 May 2008 12:39:48 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Add op_flags field to xfs_da_args

The end of the xfs_da_args structure has 4 unsigned char fields for
true/false information on directory and attr operations using the
xfs_da_args structure.

The following converts these 4 into a op_flags field that uses the
first 4 bits for these fields and allows expansion for future
operation information (eg. case-insensitive lookup request).

Signed-off-by: Barry Naujok <bnaujok@sgi.com>


Date:  Wed May 21 12:39:19 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31206a
fs/xfs/xfsidbg.c - 1.350 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.350&r2=text&tr2=1.349&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_da_btree.c - 1.179 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.179&r2=text&tr2=1.178&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_da_btree.h - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.h.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_dir2_block.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_dir2_sf.c - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_dir2_trace.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_trace.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_dir2_leaf.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_attr_leaf.c - 1.112 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.112&r2=text&tr2=1.111&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_dir2_node.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_attr.c - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
	- Convert discrete xfs_da_args flags into flag bits

fs/xfs/xfs_dir2.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- Convert discrete xfs_da_args flags into flag bits
