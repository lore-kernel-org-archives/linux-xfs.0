Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 18:31:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7S1VRDW009028
	for <linux-xfs@oss.sgi.com>; Sun, 27 Aug 2006 18:31:38 -0700
Message-ID: <44F2476C.1010101@sgi.com>
Date: Mon, 28 Aug 2006 11:31:24 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 955157: Deadlock in xfs_bulkstat() when an invalid user buffer
 pointer is passed
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com> <44EEA07E.9070207@sgi.com> <44EEA313.80101@sgi.com>
In-Reply-To: <44EEA313.80101@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Date:  Mon Aug 28 11:29:07 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-dmapi
Inspected by:  bnaujok
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26869a
fs/xfs/xfs_itable.c - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
        - pv 955157, rv bnaujok - break the loop on EFAULT formatter() 
error
