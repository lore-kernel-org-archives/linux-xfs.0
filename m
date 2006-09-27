Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 21:31:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8R4V8aG021494
	for <linux-xfs@oss.sgi.com>; Tue, 26 Sep 2006 21:31:10 -0700
Message-ID: <4519FE80.4000609@sgi.com>
Date: Wed, 27 Sep 2006 14:30:56 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: PARTIAL TAKE 955274: DMAPI qa test fixes
References: <44CE9F23.7000605@sgi.com>
In-Reply-To: <44CE9F23.7000605@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

pv 955274 - Limit the random generated file size attribute to 1 TB (if 
size is too big the kernel panics)

Date:  Wed Sep 27 14:28:03 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/xfs-cmds
Inspected by:  none
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27060a
xfstests/dmapi/src/suite2/src/test_fileattr.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite2/src/test_fileattr.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
        - pv 955274 - Limit the random generated file size attribute to 
1 TB (if size is too big the kernel panics)
