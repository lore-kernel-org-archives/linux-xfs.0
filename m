Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Nov 2006 15:00:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAQN01aG016847
	for <linux-xfs@oss.sgi.com>; Sun, 26 Nov 2006 15:00:03 -0800
Message-ID: <456A1CD4.8000301@sgi.com>
Date: Mon, 27 Nov 2006 10:01:40 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 958534 - [clone 958472] dmf does not work with mangrove 1.0
 enhanced dmapi module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

DMF doesn't work with mangrove 1.0 because of uninitialized dt_dev in 
xfs_ip_to_stat()

Date:  Mon Nov 27 09:56:20 AEDT 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  chatz
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27551a
fs/xfs/dmapi/xfs_dm.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
        - pv 958534, rv chatz - add forgotten initialization of dt_dev 
in xfs_ip_to_stat()
