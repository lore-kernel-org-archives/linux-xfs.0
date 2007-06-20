Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 21:08:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K48bdo004862
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 21:08:39 -0700
Subject: TAKE 966502 - transaction leak on error in xfs_inactive
Message-Id: <20070620040834.5D8B858C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 14:08:34 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Cancel transactions on xfs_itruncate_start error.

Signed-Off-By: Jesper Juhl <jesper.juhl@gmail.com>

Date:  Wed Jun 20 14:08:02 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  jesper.juhl@gmail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28943a
fs/xfs/xfs_vnodeops.c - 1.699 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.699&r2=text&tr2=1.698&f=h
	- Prevent transaction leak if we get an error from
	  xfs_itruncate_start() by cancelling it correctly.
