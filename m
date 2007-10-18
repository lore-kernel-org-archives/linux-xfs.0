Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 00:26:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9I7Q0ED008887
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 00:26:04 -0700
From: donaldd@sgi.com
Subject: TAKE 969769 - Fix dbflush panic in xfs_qm_sync
Message-Id: <20071018072558.4121830A7943@linuxbuild.melbourne.sgi.com>
Date: Thu, 18 Oct 2007 17:25:58 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix dbflush panic in xfs_qm_sync.

The recent behaviour layer removal dropped the check for quotas that have been
requested at mount time but have subsequently been turned off. This results
in a panic when accessing m_quotainfo which has been freed.

This patch adds the check originally made by xfs_qm_syncall() to xfs_qm_sync().

Date:  Thu Oct 18 17:24:16 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  dgc,lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29908a
fs/xfs/quota/xfs_qm.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- Fix dbflush panic in xfs_qm_sync
