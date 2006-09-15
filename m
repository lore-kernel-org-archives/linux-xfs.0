Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Sep 2006 00:11:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8F7AoZd032710
	for <linux-xfs@oss.sgi.com>; Fri, 15 Sep 2006 00:11:01 -0700
Message-ID: <450A51EB.90004@sgi.com>
Date: Fri, 15 Sep 2006 17:10:35 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 956241: make ino validation checks consistent in bulkstat
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com> <44F66CA0.4080008@sgi.com> <450A4E87.4030005@sgi.com>
In-Reply-To: <450A4E87.4030005@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

pv 956241, author: nathans, rv: vapo - make ino validation checks 
consistent in bulkstat

Date:  Fri Sep 15 17:08:03 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-nathan
Inspected by:  vapo
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26984a
fs/xfs/xfs_itable.c - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
fs/xfs/xfs_itable.h - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.h.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
fs/xfs/linux-2.4/xfs_ksyms.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ksyms.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
fs/xfs/dmapi/xfs_dm.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
        - pv 956241, author: nathans, rv: vapo - make ino validation 
checks consistent in bulkstat
