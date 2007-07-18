Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 20:33:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6I3Xibm016369
	for <linux-xfs@oss.sgi.com>; Tue, 17 Jul 2007 20:33:46 -0700
Message-ID: <469D8A99.8030705@sgi.com>
Date: Wed, 18 Jul 2007 13:35:53 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 967622 - DMAPI ioctl() returning positive errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

pv 967622, rv dgc - return negative DMAPI ioctl() errors.


Date:  Wed Jul 18 13:30:25 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29169a
fs/xfs/dmapi/xfs_dm.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
        - pv 967622, rv dgc - Return negative DMAPI errors.
