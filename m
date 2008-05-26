Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 19:39:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4Q2dfbu030112
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 19:39:42 -0700
Received: from dqmail.dynamicquest.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29EE9BD9980
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 19:40:32 -0700 (PDT)
Received: from dqmail.dynamicquest.com (dqmail.dynamicquest.com [74.202.150.200]) by cuda.sgi.com with ESMTP id n4iOfBngWJDY4tTs for <xfs@oss.sgi.com>; Sun, 25 May 2008 19:40:32 -0700 (PDT)
Received: from [172.20.0.10] (unknown [172.20.0.10])
	by dqmail.dynamicquest.com (Postfix) with ESMTP id 0F3892708022
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 22:40:32 -0400 (EDT)
Message-ID: <483A231F.2030207@dynamicquest.com>
Date: Sun, 25 May 2008 22:40:31 -0400
From: Javier Gomez <gomez@dynamicquest.com>
MIME-Version: 1.0
Subject: Lost Superblock and need help recovering
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com



    We are currently running a few Coraid AoE devices which we have 
formated using Raid-5 and XFS filesystem.  The devices were shutdown 
abruptly causing what looks like a some data issues.  We are running a 
Redhat 5 head unit connected to the disk array.  When the devices came 
back up we were unable to remount them.  Based on the tools to check the 
device we got the log information that the Superblock does not exist nor 
does the secondary.  We have two devices, each with 13 TB of disk space 
each and both with what seems like the same issue.  These devices were 
used as a backup storage device, so they are the backup.  But this 
historical information is very critical to us.  We attempted to run the 
"xfs_repair -nv /dev/etherd/e4.1p1"  command to see if found the 
potential issues ( xfs_repair version 2.9.8 ).  It came back with the 
comments noted below.  Does any one have any suggestions for pulling 
this information off the drive and / or correcting this issue?  What 
other tools should I run to get more information?  Thanks for any 
support or suggestions you can provide.


 > xfs_repair -nv /dev/etherd/e4.1p1
---------------------------------------------------------------
Phase 1 - find and verify superblock...
error reading superblock 4 -- seek to offset 1219003957248 failed
couldn't verify primary superblock - bad magic number !!!

attempting to find secondary superblock...
................................................................................................
......................................................
..................
..................
............Sorry, could not find valid secondary superblock
Exiting now.
---------------------------------------------------------------
