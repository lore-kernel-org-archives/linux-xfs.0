Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Sep 2006 19:06:23 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8F25pZd016628
	for <linux-xfs@oss.sgi.com>; Thu, 14 Sep 2006 19:06:01 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k8E1dGnx021464
	for <linux-xfs@oss.sgi.com>; Wed, 13 Sep 2006 20:39:16 -0500
Received: from omx2.sgi.com ([198.149.32.25])
	by internal-mail-relay1.corp.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id k8E1dG8s39912864
	for <linux-xfs@oss.sgi.com>; Wed, 13 Sep 2006 18:39:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with SMTP id k8E4EBti011249
	for <linux-xfs@oss.sgi.com>; Wed, 13 Sep 2006 21:14:12 -0700
Subject: TAKE 952967 - BUG() in generic_delete_inode()
Message-Id: <20060914013903.2896E58CF851@chook.melbourne.sgi.com>
Date: Thu, 14 Sep 2006 11:39:03 +1000 (EST)
From: dgc@SGI.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Really fix use after free in xfs_iunpin.

The previous attempts to fix the linux inode use-after-free in
xfs_iunpin simply made the problem harder to hit. We actually need
complete exclusion between xfs_reclaim and xfs_iunpin, as well as
ensuring that the i_flags are consistent during both of these
functions. Introduce a new spinlock for exclusion and the i_flags,
and fix up xfs_iunpin to use igrab before marking the inode dirty.

Date:  Thu Sep 14 11:37:19 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs-new
Inspected by:  m-saito,masano,nathans

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26964a
fs/xfs/xfs_vnodeops.c - 1.683 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.683&r2=text&tr2=1.682&f=h
	- Use new i_flags_lock to protect i_flags.

fs/xfs/xfs_itable.c - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- Use new i_flags_lock to protect i_flags.

fs/xfs/xfs_iget.c - 1.221 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.221&r2=text&tr2=1.220&f=h
	- Use new i_flags_lock to protect i_flags.

fs/xfs/xfs_inode.c - 1.452 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.452&r2=text&tr2=1.451&f=h
	- Fix xfs_iunpin to prevent use-after-free of the linux inode.

fs/xfs/xfs_inode.h - 1.216 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.216&r2=text&tr2=1.215&f=h
	- Use new i_flags_lock to protect i_flags.

fs/xfs/linux-2.6/xfs_super.c - 1.370 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.370&r2=text&tr2=1.369&f=h
	- Use new i_flags_lock to protect i_flags.
