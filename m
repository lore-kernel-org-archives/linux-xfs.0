Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 00:16:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8D7Gm4p023355
	for <linux-xfs@oss.sgi.com>; Thu, 13 Sep 2007 00:16:52 -0700
Message-ID: <46E8E44C.8080802@sgi.com>
Date: Thu, 13 Sep 2007 17:18:36 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 970451: "dmapi" mount option not overwriting the default "noikeep"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Fix for a regression caused by a recent patch that moved
the DMAPI mount option processing inside xfs_parseargs().
The DMAPI mount option used to be processed in the DMAPI module loaded 
before
xfs_parseargs() was invoked.

Date:  Thu Sep 13 17:13:23 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  dgc
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29683a
fs/xfs/xfs_vfsops.c - 1.539 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.539&r2=text&tr2=1.538&f=h
        - pv 970451, rv dgc - Fix for a regression caused by a recent 
patch that moved
          the DMAPI mount option processing inside xfs_parseargs().
          The DMAPI mount option used to be processed in the DMAPI 
module loaded before
          xfs_parseargs() was invoked.
