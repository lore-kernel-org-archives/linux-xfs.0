Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 21:59:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7V4xIDW024860
	for <linux-xfs@oss.sgi.com>; Wed, 30 Aug 2006 21:59:32 -0700
Message-ID: <44F66CA0.4080008@sgi.com>
Date: Thu, 31 Aug 2006 14:59:12 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 955006: DMAPI set/get/remove attribute returns EINVAL instead
 of EFAULT:bad &dm_attrname
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com>
In-Reply-To: <44EE9DF7.1080904@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Date:  Thu Aug 31 14:55:04 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-dmapi
Inspected by:  bnaujok
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26892a
fs/xfs/dmapi/xfs_dm.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
        - pv 955006, rv bnaujok - Better (and proper) way to fix the 
problem.
          strnlen_user returns strlen+1 not strlen as documented in the 
ia64 code.
