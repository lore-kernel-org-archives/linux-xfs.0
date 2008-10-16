Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:31:17 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4VDYE011095
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:31:14 -0700
Subject: TAKE 988143 - Allocate the struct xfs_ail
Message-Id: <20081016043248.7B76758FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:32:48 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Allocate the struct xfs_ail

Rather than embedding the struct xfs_ail in the struct xfs_mount,
allocate it during AIL initialisation. Add a back pointer to
the struct xfs_ail so that we can pass around the xfs_ail
and still be able to access the xfs_mount if need be. This
is th first step involved in isolating the AIL implementation
from the surrounding filesystem code.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:32:15 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32346a
fs/xfs/xfs_trans_priv.h - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
fs/xfs/xfs_trans_ail.c - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
fs/xfs/xfs_mount.h - 1.282 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.282&r2=text&tr2=1.281&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.463 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.463&r2=text&tr2=1.462&f=h
	- Allocate the struct xfs_ail
