Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 18:23:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F1N51l022786
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 18:23:07 -0700
Date: Thu, 15 May 2008 11:23:47 +1000 (AEST)
From: Mohamed Barwani <mohamedb@snort.melbourne.sgi.com>
Message-Id: <200805150123.m4F1NlCN167238325@snort.melbourne.sgi.com>
Subject: TAKE 981801 - Fix Test 180 for long /dev paths
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.mangrove@engr.sgi.com
Cc: xfs@oss.sgi.com

Test 180 breaks if you have long device paths
Use -P for df to fix it

       -P, --portability
              use the POSIX output format


Date:  Thu May 15 11:23:04 AEST 2008
Workarea:  snort.melbourne.sgi.com:/home/mohamedb/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31162a
xfstests/180 - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/180.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- fix df for long /dev paths
