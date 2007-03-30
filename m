Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 23:49:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2U6nb6p004921
	for <linux-xfs@oss.sgi.com>; Thu, 29 Mar 2007 23:49:39 -0700
Message-ID: <460CB049.5070105@sgi.com>
Date: Fri, 30 Mar 2007 16:38:01 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 962866 - sleeping in atomic in dmapi
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Fri Mar 30 16:33:02 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  dgc
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  linux-melb:dmapi:28328a
fs/dmapi/dmapi_register.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_register.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
        - pv 962866, rv dgc - do not hold dm_reg_lock while calling 
create_proc_read_entry()
