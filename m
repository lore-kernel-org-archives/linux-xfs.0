Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Aug 2006 00:53:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7P7qjDY002499
	for <linux-xfs@oss.sgi.com>; Fri, 25 Aug 2006 00:53:00 -0700
Message-ID: <44EEA07E.9070207@sgi.com>
Date: Fri, 25 Aug 2006 17:02:22 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 955271: [SUSE#197643] dm_set_fileattr does not update atime
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com>
In-Reply-To: <44EE9DF7.1080904@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Date:  Fri Aug 25 16:59:14 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-dmapi
Inspected by:  bnaujok
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26865a
fs/xfs/dmapi/xfs_dm.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
        - pv 955271, rv bnaujok - update inode->i_atime.tv_sec
