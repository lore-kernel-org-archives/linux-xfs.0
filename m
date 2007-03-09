Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Mar 2007 20:26:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l294QD6p017080
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 20:26:15 -0800
From: donaldd@sgi.com
Subject: TAKE 961964 - Enabling group quota enforcement on a filesystem with group accounting fails.
Message-Id: <20070309042608.EA86225933C5@linuxbuild.melbourne.sgi.com>
Date: Fri,  9 Mar 2007 15:26:08 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix quotaon syscall failures for group enforcement requests.

xfs_qm_scall_quotaon was incorrectly failing requests to enable 
group quota enforcement. Fixes logic error in OQUOTA handling. 

Patch provided by Kouta Ooizumi.

Signed-off-by: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>

Date:  Fri Mar  9 15:22:52 AEDT 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  donaldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28227a
fs/xfs/quota/xfs_qm_syscalls.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Fix handling of OQUOTA in xfs_qm_scall_quotaon.
