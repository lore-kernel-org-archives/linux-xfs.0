Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 17:59:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2K0xM6p023091
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 17:59:25 -0700
From: donaldd@sgi.com
Subject: TAKE 962291 - Quota enforcement active for all quota types when enforcement is active for any
Message-Id: <20070320005916.2197B26AB4C4@linuxbuild.melbourne.sgi.com>
Date: Tue, 20 Mar 2007 11:59:15 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix uquota and oquota enforcement problems.

When uquota and oquota (gquota/pquota) are enabled for accounting both
are enforced if ether has enforcement active. 

Conditions:
 - Both XFS_UQUOTA_ACCT and XFS_GQUOTA_ACCT are enabled.
 - Either XFS_UQUOTA_ENFD or XFS_OQUOTA_ENFD is enabled.
 - The usage without enforce is reached at the soft limit.

Problems:
 1. "repquota" shows all grace time even if no enforcement. 
 2. we cannot make a file over a hard limits even if no enforcement.

Signed-off-by: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>



Date:  Tue Mar 20 11:54:43 AEDT 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  doanldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28272a
fs/xfs/xfs_quota.h - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_quota.h.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- Split out XFS_IS_QUOTA_ENFORCED into XFS_IS_UQUOTA_ENFORCED and XFS_IS_OQUOTA_ENFORCED.

fs/xfs/quota/xfs_trans_dquot.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_trans_dquot.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Fix uquota and oquota enforcement problems.

fs/xfs/quota/xfs_qm_syscalls.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
	- Fix uquota and oquota enforcement problems.
