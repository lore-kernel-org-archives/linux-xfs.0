Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 20:44:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L3i4tU017611
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 20:44:06 -0700
Subject: TAKE 981521 - Return actual name for CI match for dentry cache
Message-Id: <20080521034449.67F4758C4C29@chook.melbourne.sgi.com>
Date: Wed, 21 May 2008 13:44:49 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Return case-insensitive match for dentry cache

This implements the code to store the actual filename found
during a lookup in the dentry cache and to avoid multiple entries
in the dcache pointing to the same inode.

To avoid polluting the dcache, we implement a new directory inode
operations for lookup. xfs_vn_ci_lookup() stores the correct case
name in the dcache.

The "actual name" is only allocated and returned for a case-
insensitive match and not an actual match.

Another unusual interaction with the dcache is not storing
negative dentries like other filesystems doing a d_add(dentry, NULL)
when an ENOENT is returned. During the VFS lookup, if a dentry
returned has no inode, dput is called and ENOENT is returned.
By not doing a d_add, this actually removes it completely from
the dcache to be reused. create/rename have to be modified to
support unhashed dentries being passed in.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>


Date:  Wed May 21 13:44:00 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31208a
fs/xfs/xfs_da_btree.h - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.h.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- Add a CI_LOOKUP args flag

fs/xfs/xfs_vnodeops.c - 1.760 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.760&r2=text&tr2=1.759&f=h
	- Add lookup support for returning actual case-preserved name

fs/xfs/xfs_dir2_block.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- Add lookup support for returning actual case-preserved name

fs/xfs/xfs_dir2_sf.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
	- Add lookup support for returning actual case-preserved name

fs/xfs/xfs_dir2_leaf.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- Add lookup support for returning actual case-preserved name

fs/xfs/xfs_dir2_node.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- Add lookup support for returning actual case-preserved name

fs/xfs/xfs_dir2.h - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.h.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
	- Add lookup support for returning actual case-preserved name

fs/xfs/xfs_dir2.c - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
	- Add lookup support for returning actual case-preserved name

fs/xfs/linux-2.6/xfs_iops.c - 1.286 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.286&r2=text&tr2=1.285&f=h
	- Add xfs_vn_ci_lookup function for CI mode

fs/xfs/linux-2.6/xfs_iops.h - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.h.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
	- Export CI inode ops vector

fs/xfs/linux-2.6/xfs_export.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- Add aextra xfs_lookup paramater (NULL)

fs/xfs/xfs_vnodeops.h - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Add lookup support for returning actual case-preserved name
