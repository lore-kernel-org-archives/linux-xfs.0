Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 18:49:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7S1nCDW015010
	for <linux-xfs@oss.sgi.com>; Sun, 27 Aug 2006 18:49:23 -0700
Message-ID: <44F24B95.3040504@sgi.com>
Date: Mon, 28 Aug 2006 11:49:09 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: PARTIAL TAKE 955274: DMAPI qa test fixes
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com> <44EEA07E.9070207@sgi.com> <44EEA313.80101@sgi.com>
In-Reply-To: <44EEA313.80101@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Date:  Mon Aug 28 11:44:36 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/xfs-cmds
Inspected by:  bnaujok
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26870a
xfstests/dmapi/src/suite2/src/test_dmattr.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite2/src/test_dmattr.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
        - pv 955274, rv bnaujok - add 1sec delay between file creation 
and changing its
          attribute via dm_set_dmattr(). If the machine is too fast the 
ctime doesn't
          change between create and dm_set_dmattr() and the test fails.
