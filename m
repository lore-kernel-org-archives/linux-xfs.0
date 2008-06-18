Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 21:02:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5I42ejw031403
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 21:02:41 -0700
Subject: TAKE 983395 - simplify xfs_vn_listxattr
Message-Id: <20080618040334.A209958C4C3F@chook.melbourne.sgi.com>
Date: Wed, 18 Jun 2008 14:03:34 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Switches xfs_vn_listxattr to set it's put_listent callback
directly and not go through xfs_attr_list.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Jun 18 14:02:38 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31324a
fs/xfs/xfs_acl.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- Switches xfs_vn_listxattr to set it's put_listent callback
	  directly and not go through xfs_attr_list.

fs/xfs/xfs_attr_leaf.h - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.h.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- Switches xfs_vn_listxattr to set it's put_listent callback
	  directly and not go through xfs_attr_list.

fs/xfs/xfs_attr_leaf.c - 1.113 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.113&r2=text&tr2=1.112&f=h
	- Switches xfs_vn_listxattr to set it's put_listent callback
	  directly and not go through xfs_attr_list.

fs/xfs/xfs_attr.c - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
	- Switches xfs_vn_listxattr to set it's put_listent callback
	  directly and not go through xfs_attr_list.

fs/xfs/xfs_attr.h - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
	- Switches xfs_vn_listxattr to set it's put_listent callback
	  directly and not go through xfs_attr_list.

fs/xfs/linux-2.6/xfs_xattr.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_xattr.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Switches xfs_vn_listxattr to set it's put_listent callback
	  directly and not go through xfs_attr_list.
