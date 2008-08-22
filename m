Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 16:37:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7MNavTo024644
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 16:36:57 -0700
Received: from chef.nerp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 200A73C4659
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 16:38:18 -0700 (PDT)
Received: from chef.nerp.net (chef.nerp.net [199.199.210.160]) by cuda.sgi.com with ESMTP id zHEKpi9SqmpVaLEs for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 16:38:18 -0700 (PDT)
Received: from chef.nerp.net (localhost [127.0.0.1])
	by chef.nerp.net (Postfix) with ESMTP id 0FF1C140254A
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 18:38:17 -0500 (CDT)
Received: from [75.209.92.19] (19.sub-75-209-92.myvzw.com [75.209.92.19])
	by chef.nerp.net (Postfix) with ESMTPA id 1D5C6140253E
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 18:38:14 -0500 (CDT)
Message-ID: <48AF4DD1.5080603@nerp.net>
Date: Fri, 22 Aug 2008 13:37:53 -1000
From: Dan <dan@nerp.net>
MIME-Version: 1.0
Subject: xfs_quota free
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

Some time ago I needed to determine the free space on a real time 
device.  Nate indicated to use xfs_quota free.  I've read the man pages 
and tried many iterations of this command but I cannot get any results.

One potential problem is I'm uncertain of the folder or device to point 
the command at.  My filesystem is mounted to /mnt, the rtdev is /dev/md0 
and meta data is on /dev/sdb.  Basically it boils down to xfs_quota -c 
'free -r -h'  /mnt I think but I get the following error:

XFS_IOC_FSGEOMETRY_V1: Invalid argument

How do you use this?

Thanks,

Dan
