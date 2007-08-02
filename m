Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 00:58:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l727wabm026258
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 00:58:39 -0700
Subject: TAKE 968555 - sparse fixes for 2.6.23
Message-Id: <20070802075835.C646258F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 17:58:35 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix sparse shadowed variable warnings

 - in xfs_probe_cluster rename the inner len to pg_len.  There's no harm
   here because the outer len isn't used after the inner len comes into
   existance but it keeps the code clean.
 - in xfs_da_do_buf remove the inner i because they don't overlap
   and they are both the same type.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug  2 17:58:04 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29311a
fs/xfs/xfs_da_btree.c - 1.175 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.175&r2=text&tr2=1.174&f=h
	- Fix shadowed var in xfs_da_do_buf.

fs/xfs/linux-2.6/xfs_aops.c - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
	- Fix shadowed var in xfs_probe_cluster.
