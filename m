Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jun 2008 00:36:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K7aIjX005845
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2008 00:36:19 -0700
Subject: TAKE 983336 - Always reset btree cursor after an insert
Message-Id: <20080620073711.6730358C4C3F@chook.melbourne.sgi.com>
Date: Fri, 20 Jun 2008 17:37:11 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Always reset btree cursor after an insert

After a btree insert operation a cursor can be invalid due to block
splits and a maybe a new root block.  We reset the cursor in
xfs_bmbt_insert() in the cases where we think we need to but it
isn't enough as we still see assertions.  Just do what we do elsewhere
and reset the cursor unconditionally.  Also remove the fix to
revalidate the original cursor in xfs_bmbt_insert().

Date:  Fri Jun 20 17:36:09 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-agno2
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31342a
fs/xfs/xfs_bmap_btree.c - 1.170 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.170&r2=text&tr2=1.169&f=h
fs/xfs/xfs_bmap.c - 1.394 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.394&r2=text&tr2=1.393&f=h
	- Always reset btree cursor after an insert
