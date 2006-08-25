Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 23:44:59 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7P6iSDW004201
	for <linux-xfs@oss.sgi.com>; Thu, 24 Aug 2006 23:44:40 -0700
Received: from soarer.melbourne.sgi.com (soarer.melbourne.sgi.com [134.14.55.89])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k7P6hknx021419
	for <linux-xfs@oss.sgi.com>; Fri, 25 Aug 2006 01:43:47 -0500
Subject: TAKE 955006 - 
Message-Id: <20060825064405.5DA52627C5@soarer.melbourne.sgi.com>
Date: Fri, 25 Aug 2006 16:44:05 +1000 (EST)
From: vapo@soarer.melbourne.sgi.com (Vlad Apostolov)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.melbourne.sgi.com, linux-xfs@oss.sgi.com

955006: DMAPI set/get/remove attribute returns EINVAL instead of EFAULT:bad &dm_attrname


Date:  Fri Aug 25 16:41:56 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-dmapi
Inspected by:  bnaujok

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26864a
fs/xfs/dmapi/xfs_dm.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- pv 955006, rv bnaujok - check access_ok() for user dm_attrname_t buffer
