Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 18:14:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K1Eg4H009411
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:14:43 -0700
Subject: TAKE 983284 - Assertion failure in node form directory lookup in CI mode
Message-Id: <20080620011537.2E01958C4C3F@chook.melbourne.sgi.com>
Date: Fri, 20 Jun 2008 11:15:37 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix returning case-preserved name with CI node form directories

xfs_dir2_node_lookup() calls xfs_da_node_lookup_int() which iterates
through leaf blocks containing the matching hash value for the name
being looked up. Inside xfs_da_node_lookup_int(), it calls the
xfs_dir2_leafn_lookup_for_entry() for each leaf block.
xfs_dir2_leafn_lookup_for_entry() iterates through each matching
hash/offset pair doing a name comparison to find the matching
dirent.

For CI mode, the state->extrablk retains the details of the block
that has the CI match so xfs_dir2_node_lookup() can return the
case-preserved name.

The original implementation didn't retain the xfs_da_buf_t properly,
so the lookup was returning a bogus name to be stored in the dentry.

In the case of unlink, the bad name was passed and in debug mode,
ASSERTed when it can't find the entry.


Date:  Fri Jun 20 11:14:53 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31337a
fs/xfs/xfs_dir2_node.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- Fix returning case-preserved name with CI node form directories
