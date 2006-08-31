Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 22:32:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7V5WJDW031883
	for <linux-xfs@oss.sgi.com>; Wed, 30 Aug 2006 22:32:30 -0700
Message-ID: <44F6745C.20501@sgi.com>
Date: Thu, 31 Aug 2006 15:32:12 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: PARTIAL TAKE 955854: [SUSE#196895] Undefined behavior calling dm_path_to_hdl
 if path longer than 2000
References: <44CE9F23.7000605@sgi.com> <44EE9DF7.1080904@sgi.com> <44F66CA0.4080008@sgi.com>
In-Reply-To: <44F66CA0.4080008@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Date:  Thu Aug 31 15:23:16 AEST 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-dmapi
Inspected by:  vapo
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  linux-melb:dmapi:26893a
fs/dmapi/dmapi_register.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_register.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
        - pv 955854, author: Paul Hinchman, rv: vapo - use PATH_MAX 
instead hardcoded
          value of 2000 for limitting the user string length calculation.
