Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Mar 2007 20:04:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2944B6p004445
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 20:04:12 -0800
From: donaldd@sgi.com
Subject: TAKE 961964 - xfs quota information can become stale when mounted with different quota types.
Message-Id: <20070309040405.35F48250DE15@linuxbuild.melbourne.sgi.com>
Date: Fri,  9 Mar 2007 15:04:05 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Invalidate quotacheck when mounting without a quota type. 

When quotas are mounted or remounted without a particular quota
type the quota accounting for that type becomes invalid. 
Previously we were ignoring this leading to accounting errors. 

Thanks to Utako Kursaka for finding this and helping develop the fix.

Date:  Fri Mar  9 15:02:34 AEDT 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  Utako Kusaka <utako@tnes.nec.co.jp>,vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28225a
fs/xfs/quota/xfs_qm.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- Invalidate quotacheck state when mounting without a paticular quota type.
