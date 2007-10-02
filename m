Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 21:51:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l924pG8Z021053
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 21:51:19 -0700
Subject: TAKE 971186 - clean up some xfs_log_priv.h macros
Message-Id: <20071002045112.494EE58C38F1@chook.melbourne.sgi.com>
Date: Tue,  2 Oct 2007 14:51:12 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

clean up some xfs_log_priv.h macros

 - the various assign lsn macros are replaced by a single inline,
   xlog_assign_lsn, which is equivalent to ASSIGN_ANY_LSN_HOST except
   for a more sane calling convention.  ASSIGN_LSN_DISK is replaced
   by xlog_assign_lsn and a manual bytespap, and ASSIGN_LSN by the same,
   except we pass the cycle and block arguments explicitly instead of a
   log paramter.  The latter two variants only had 2, respectively one
   user anyway.
 - the GET_CYCLE is replaced by a xlog_get_cycle inline with exactly the
   same calling conventions.
 - GET_CLIENT_ID is replaced by xlog_get_client_id which leaves away
   the unused arch argument.  Instead of conditional defintions
   depending on host endianess we now do an unconditional swap and shift
   then, which generates equal code.
 - the unused XLOG_SET macro is removed.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Oct  2 14:47:44 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-oss
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29820a
fs/xfs/xfs_log.c - 1.341 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.341&r2=text&tr2=1.340&f=h
fs/xfs/xfs_log_priv.h - 1.124 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.124&r2=text&tr2=1.123&f=h
fs/xfs/xfs_log_recover.c - 1.328 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.328&r2=text&tr2=1.327&f=h
	- clean up some xfs_log_priv.h macros
