Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Sep 2006 16:47:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8HNkuZd004677
	for <linux-xfs@oss.sgi.com>; Sun, 17 Sep 2006 16:47:08 -0700
Message-ID: <450DDE60.50300@sgi.com>
Date: Mon, 18 Sep 2006 09:46:40 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 955947: Infinite loop in xfs_bulkstat() on formatter() error
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com> <44F66CA0.4080008@sgi.com> <450A4E87.4030005@sgi.com> <450A531E.2070205@sgi.com>
In-Reply-To: <450A531E.2070205@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

955947: Infinite loop in xfs_bulkstat() on formatter() error

Date:  Mon Sep 18 09:43:49 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  nathans
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26986a
fs/xfs/xfs_itable.c - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
        - pv 955947, rv: nathans - update lastino on non critical errors 
returned by formatter()
