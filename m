Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Feb 2007 18:49:57 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1J2nom7030097
	for <linux-xfs@oss.sgi.com>; Sun, 18 Feb 2007 18:49:52 -0800
Message-ID: <45D91104.10601@sgi.com>
Date: Mon, 19 Feb 2007 13:52:52 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 961263 -[PATCH] dm_create_session() calls create_proc_entry()
 with spinlock held
References: <45D910C6.7060400@sgi.com>
In-Reply-To: <45D910C6.7060400@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

Date:  Mon Feb 19 13:45:32 AEDT 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  vapo
Author:  Kevin Jamieson

The following file(s) were checked into:
 longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  linux-melb:dmapi:28121a
fs/dmapi/dmapi_session.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/dmapi/dmapi_session.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
       - pv 961263, rv vapo - Do not hold dm_session_lock while calling 
create_proc_read_entry() and remove_proc_entry()
