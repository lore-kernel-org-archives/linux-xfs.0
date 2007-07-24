Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 21:57:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6O4vYbm018630
	for <linux-xfs@oss.sgi.com>; Mon, 23 Jul 2007 21:57:38 -0700
Message-ID: <46A58732.4020703@sgi.com>
Date: Tue, 24 Jul 2007 14:59:30 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 967674 - hole not show when file is created with resvsp
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

xfs_bmap doesn't show hole at EOF if the file is preallocated or with 
extent hint


Date:  Tue Jul 24 14:54:44 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs1
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29211a
fs/xfs/xfs_bmap.c - 1.373 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.373&r2=text&tr2=1.372&f=h
        - pv 967674, rv dgc - xfs_bmap doesn't show hole at EOF if the 
file is preallocated or with extent hint
