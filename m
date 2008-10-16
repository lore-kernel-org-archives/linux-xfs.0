Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:39:49 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4dk8c013545
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:39:46 -0700
Subject: TAKE 988143 - Finish removing the mount pointer from the AIL API
Message-Id: <20081016044127.E6EE158FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:41:27 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Finish removing the mount pointer from the AIL API

Change all the remaining AIL API functions that are passed
struct xfs_mount pointers to pass pointers directly to the
struct xfs_ail being used. With this conversion, all external
access to the AIL is via the struct xfs_ail. Hence the operation
and referencing of the AIL is almost entirely independent of
the xfs_mount that is using it - it is now much more tightly
tied to the log and the items it is tracking in the log than
it is tied to the xfs_mount.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:41:08 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32353a
fs/xfs/xfs_log.c - 1.373 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.373&r2=text&tr2=1.372&f=h
fs/xfs/xfs_extfree_item.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
fs/xfs/xfs_buf_item.c - 1.172 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.172&r2=text&tr2=1.171&f=h
fs/xfs/xfs_trans_priv.h - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
fs/xfs/xfs_trans_ail.c - 1.92 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.92&r2=text&tr2=1.91&f=h
fs/xfs/xfs_inode_item.c - 1.142 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.142&r2=text&tr2=1.141&f=h
fs/xfs/xfs_log_recover.c - 1.354 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.354&r2=text&tr2=1.353&f=h
fs/xfs/xfs_iget.c - 1.253 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.253&r2=text&tr2=1.252&f=h
fs/xfs/xfs_inode.c - 1.534 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.534&r2=text&tr2=1.533&f=h
fs/xfs/xfs_trans.c - 1.191 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.191&r2=text&tr2=1.190&f=h
fs/xfs/xfs_trans.h - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
fs/xfs/xfs_trans_buf.c - 1.132 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_buf.c.diff?r1=text&tr1=1.132&r2=text&tr2=1.131&f=h
fs/xfs/quota/xfs_dquot_item.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
fs/xfs/quota/xfs_dquot.c - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
	- Finish removing the mount pointer from the AIL API
