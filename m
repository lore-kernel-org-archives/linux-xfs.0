Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Feb 2007 21:52:20 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1D5qAm7031781
	for <linux-xfs@oss.sgi.com>; Mon, 12 Feb 2007 21:52:13 -0800
Message-ID: <45D152C1.4080801@sgi.com>
Date: Tue, 13 Feb 2007 16:55:13 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: PARTIAL TAKE - 960928: dmapi destroy events not generated for removing
 files without attributes set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Tue Feb 13 16:48:40 AEDT 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  vapo, tes
Author:  Christopher Pascoe

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  linux-melb:dmapi:28087a
fs/dmapi/dmapi_event.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_event.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
        - patch author: Christopher Pascoe.
          dmapi destroy events not generated for removing files without 
attributes set
