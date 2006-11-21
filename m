Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Nov 2006 22:19:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAL6JTaG030564
	for <linux-xfs@oss.sgi.com>; Mon, 20 Nov 2006 22:19:31 -0800
Message-ID: <45629AD8.8000800@sgi.com>
Date: Tue, 21 Nov 2006 17:21:12 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 956783 - xfs_dm_getall_dmattr() doesn't check if the user buffer
 is at valid address
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

No EFAULT error when dm_getall_dmattr() called with an invalid user 
buffer address.

Date:  Tue Nov 21 17:14:34 AEDT 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-dmapi
Inspected by:  donaldd
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27510a
fs/xfs/dmapi/xfs_dm.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
        - pv 956783, rv donaldd - Check user buffer address in 
dm_getall_dmattr() for EFAULT error
