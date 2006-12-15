Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Dec 2006 18:48:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBF2lsqw023903
	for <linux-xfs@oss.sgi.com>; Thu, 14 Dec 2006 18:47:56 -0800
Message-ID: <45820D0E.3080702@sgi.com>
Date: Fri, 15 Dec 2006 13:48:46 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: PARTIAL TAKE 959264: Workaround log space issue by increasing XFS_TRANS_PUSH_AIL_RESTARTS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Workaround log space issue by increasing XFS_TRANS_PUSH_AIL_RESTARTS

Date:  Fri Dec 15 13:44:12 AEDT 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  chatz
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27750a
fs/xfs/xfs_trans_ail.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
        - pv 959264, rv chatz - Workaround log space issue by increasing 
XFS_TRANS_PUSH_AIL_RESTARTS
