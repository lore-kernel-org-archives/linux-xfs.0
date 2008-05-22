Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 00:19:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M7JI20001231
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 00:19:19 -0700
Subject: TAKE 981521 - Remove d_add call for an ENOENT CI lookup return code
Message-Id: <20080522072004.EA21458C4C29@chook.melbourne.sgi.com>
Date: Thu, 22 May 2008 17:20:04 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove d_add call for an ENOENT CI lookup return code


Date:  Thu May 22 17:18:57 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31214a
fs/xfs/linux-2.6/xfs_iops.c - 1.287 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.287&r2=text&tr2=1.286&f=h
	- Remove d_add call for an ENOENT lookup return code
