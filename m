Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Jul 2007 17:02:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6602itL012755
	for <linux-xfs@oss.sgi.com>; Thu, 5 Jul 2007 17:02:46 -0700
Message-ID: <468D82BA.3020901@sgi.com>
Date: Fri, 06 Jul 2007 09:46:02 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 960527 - DMAPI dm_punch_hole and dm_probe hole have several
 problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Fri Jul  6 09:39:04 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29084a
fs/xfs/dmapi/xfs_dm.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
    - pv 960527, rv dgc - Implement variable size DMAPI probe/punch 
hole. We don't
      strictly follow the DMAPI spec, see the comments in the code for 
more details.
