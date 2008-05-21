Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 19:33:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L2X2XT004776
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 19:33:04 -0700
Subject: TAKE 981519 - Add name operation vector for directory operations
Message-Id: <20080521023347.A945858C4C29@chook.melbourne.sgi.com>
Date: Wed, 21 May 2008 12:33:47 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Name operation vector for hash and compare

Adds two pieces of functionality for the basis of case-insensitive
support in XFS:

1.  A comparison result enumerated type: xfs_dacmp. It represents an
    exact match, case-insensitive match or no match at all. This patch
    only implements different and exact results.

2.  xfs_nameops vector for specifying how to perform the hash generation
    of filenames and comparision methods. In this patch the hash vector
    points to the existing xfs_da_hashname function and the comparison
    method does a length compare, and if the same, does a memcmp and
    return the xfs_dacmp result.

All filename functions that use the hash (create, lookup remove, rename,
etc) now use the xfs_nameops.hashname function and all directory lookup
functions also use the xfs_nameops.compname function.

The lookup functions also handle case-insensitive results even though
the default comparison function cannot return that. And important
aspect of the lookup functions is that an exact match always has
precedence over a case-insensitive. So while a case-insensitive match
is found, we have to keep looking just in case there is an exact
match. In the meantime, the info for the first case-insensitive match
is retained if no exact match is found.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>


Date:  Wed May 21 12:32:41 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31205a
fs/xfs/xfs_da_btree.c - 1.178 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.178&r2=text&tr2=1.177&f=h
	- Default nameops vector

fs/xfs/xfs_da_btree.h - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.h.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
	- Definitions of compare result and nameops vector

fs/xfs/xfs_dir2_block.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- Handle CI lookup in block form directories

fs/xfs/xfs_dir2_sf.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- Handle CI lookup in shortform directories

fs/xfs/xfs_mount.h - 1.269 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.269&r2=text&tr2=1.268&f=h
	- Add nameops vector to mount structure

fs/xfs/xfs_dir2_data.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_data.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- Use nameops hash routine

fs/xfs/xfs_dir2_leaf.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- Handle CI lookup in leaf form directories

fs/xfs/xfs_dir2_node.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- Handle CI lookup in node form directories

fs/xfs/xfs_dir2.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- Call nameops hash routine
