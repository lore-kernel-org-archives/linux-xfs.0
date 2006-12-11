Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Dec 2006 15:30:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBBNUJqw009674
	for <linux-xfs@oss.sgi.com>; Mon, 11 Dec 2006 15:30:22 -0800
Message-ID: <457DEA62.8020008@sgi.com>
Date: Tue, 12 Dec 2006 10:31:46 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 959109: [clone 958105] A mmap call of an offline file does not
 generate a dmapi event.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Fix XFS to include DMAPI specific code in both cases of including DMAPI,
as a module or statically linked with the kernel.

Date:  Tue Dec 12 10:21:45 AEDT 2006
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  dgc
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27696a
fs/xfs/linux-2.6/xfs_linux.h - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
        - pv 959109, rv dgc - define HAVE_DMAPI for modular 
(CONFIG_XFS_DMAPI_MODULE)
          and static link (CONFIG_XFS_DMAPI) of dmapi.

fs/xfs/linux-2.6/xfs_file.c - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
fs/xfs/linux-2.4/xfs_file.c - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_file.c.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
        - pv 959109, rv dgc - CONFIG_XFS_DMAPI is used as both - 
environment var and
          compile time def. Change it to HAVE_DMAPI fro compile time def.
