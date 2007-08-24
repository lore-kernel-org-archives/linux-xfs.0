Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:12:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OBCr4p031748
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:12:55 -0700
Subject: PARTIAL TAKE 969608 - kill the v_number member in struct bhv_vnode
Message-Id: <20070824111249.D08FF58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:12:49 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill the v_number member in struct bhv_vnode

It's entirely unused except for ignored arguments in the mrlock
initialization, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:12:25 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29499a
fs/xfs/xfsidbg.c - 1.328 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.328&r2=text&tr2=1.327&f=h
	- kill the v_number member in struct bhv_vnode

fs/xfs/xfs_iget.c - 1.230 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.230&r2=text&tr2=1.229&f=h
	- kill the v_number member in struct bhv_vnode

fs/xfs/linux-2.6/xfs_vnode.c - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- kill the v_number member in struct bhv_vnode

fs/xfs/linux-2.6/xfs_vnode.h - 1.136 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.136&r2=text&tr2=1.135&f=h
	- kill the v_number member in struct bhv_vnode
