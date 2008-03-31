Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 11:27:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2VIRaas013559
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 11:27:37 -0700
Received: from smtp.getmail.no (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AD4F7194F7
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 11:28:11 -0700 (PDT)
Received: from smtp.getmail.no (smtp.getmail.no [84.208.20.33]) by cuda.sgi.com with ESMTP id Luodrqi28T5JfgoM for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 11:28:11 -0700 (PDT)
Received: from pmxchannel-daemon.no-osl-m323-srv-004-z2.isp.get.no by
 no-osl-m323-srv-004-z2.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 id <0JYL0065BXYXGO00@no-osl-m323-srv-004-z2.isp.get.no> for xfs@oss.sgi.com;
 Mon, 31 Mar 2008 20:28:09 +0200 (CEST)
Received: from smtp.getmail.no ([10.5.16.1])
 by no-osl-m323-srv-004-z2.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 with ESMTP id <0JYL001HTXVD1720@no-osl-m323-srv-004-z2.isp.get.no> for
 xfs@oss.sgi.com; Mon, 31 Mar 2008 20:26:01 +0200 (CEST)
Received: from localhost ([84.215.109.218])
 by no-osl-m323-srv-009-z1.isp.get.no
 (Sun Java System Messaging Server 6.2-7.05 (built Sep  5 2006))
 with ESMTP id <0JYL001WEXVDWPD0@no-osl-m323-srv-009-z1.isp.get.no> for
 xfs@oss.sgi.com; Mon, 31 Mar 2008 20:26:01 +0200 (CEST)
Received: from thor by localhost with local (Exim 4.69 #1 (Debian))
	id 1JgOhk-0005ZI-Vt	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 20:26:01 +0200
Date: Mon, 31 Mar 2008 20:26:00 +0200
From: Thor Kristoffersen <thorkr@gmail.com>
Subject: Does XFS prevent disk spindown?
Message-id: <m2tzimbvif.fsf@getmail.no>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've noticed that when I spin down XFS-mounted disks they spin up again
shortly afterwards.  I used iostat to monitor disk accesses to a mounted
partition (with noatime) in single user mode.  Apparently there is a write
access to the partition approximately every 35 seconds, even if the
partition is idle.  As far as I can understand, since there is no data that
needs to be flushed this must be done by an XFS daemon for some purpose.

Is there any setting or mount option I can use to get rid of this behavior?
I know I can freeze the filesystem, but then I have to remember to unfreeze
it every time I need to write to it, so it's not an ideal solution.


Thor
