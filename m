Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:33:41 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4XcJZ011765
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:33:39 -0700
Subject: TAKE 988143 - move the AIl traversal over to a consistent interface
Message-Id: <20081016043514.2B08658FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:35:14 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

move the AIl traversal over to a consistent interface

With the new cursor interface, it makes sense to make all the
traversing code use the cursor interface and make the old one go
away. This means more of the AIL interfacing is done by passing
struct xfs_ail pointers around the place instead of struct
xfs_mount pointers.

We can replace the use of xfs_trans_first_ail() in
xfs_log_need_covered() as it is only checking if the AIL is empty.
We can do that with a call to xfs_trans_ail_tail() instead, where a
zero LSN returned indicates and empty AIL...

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:34:55 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32348a
fs/xfs/xfs_log.c - 1.370 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.370&r2=text&tr2=1.369&f=h
fs/xfs/xfs_trans_priv.h - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
fs/xfs/xfs_trans_ail.c - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
fs/xfs/xfs_log_recover.c - 1.351 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.351&r2=text&tr2=1.350&f=h
fs/xfs/xfs_trans.h - 1.153 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.153&r2=text&tr2=1.152&f=h
	- move the AIl traversal over to a consistent interface
