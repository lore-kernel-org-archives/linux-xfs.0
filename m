Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Feb 2007 15:06:57 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l18N6lm7009160
	for <xfs@oss.sgi.com>; Thu, 8 Feb 2007 15:06:51 -0800
Message-ID: <45CB9EA6.9090301@sgi.com>
Date: Fri, 09 Feb 2007 09:05:26 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: PARTIAL TAKE 960369: XFS-QA-144-ERROR: get_bulkattr found 0 matching
 files (expected 50) in NUM loops
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs mailing list <xfs@oss.sgi.com>

A dmapi enabled xfs filesytem can be mounted with any of the alias mount
options "dmapi", "xdsm" or "dmi". Libdm is missing a check for "dmi"
hence the failure in xfs qa test 144.

Date:  Fri Feb  9 09:57:59 AEDT 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/xfs-cmds-pv960369
Inspected by:  dgc
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28053a
dmapi/VERSION - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/VERSION.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
dmapi/doc/CHANGES - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/doc/CHANGES.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
dmapi/libdm/dm_handle2path.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/libdm/dm_handle2path.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
        - pv 960369, rv dgc - libdm is missing a check for "dmi" mount 
option in get_mnt()
