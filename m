Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 19:04:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6T242UD007249
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 19:04:03 -0700
Received: from smtp.sina.com.cn (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC35D33AF84
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 19:05:14 -0700 (PDT)
Received: from smtp.sina.com.cn (smtp.sina.com.cn [202.108.3.233]) by cuda.sgi.com with ESMTP id j0MiatNL55nY8ea2 for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 19:05:14 -0700 (PDT)
Received: from xgw (unknown [211.162.201.124])
	by smtp.sina.com.cn (SINAMAIL) with ESMTP id 0BECB5F9914
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 10:05:11 +0800 (CST)
Message-ID: <010901c8f11f$9a9a68f0$3400a8c0@xgw>
From: "Robert" <xiaguowu2004@sina.com>
Subject: linux xfs filesystem corruption
Date: Tue, 29 Jul 2008 10:05:30 +0800
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dear all,
      I have encoutered linux xfs filesystem corruption, I search this topic 
on the
web, but I can't find any useful information to fix my problem.
      I build a raid5 with 'mdadm' on my own embeded system which is based 
on
arm, and format it with 'mkfs.xfs',  mount it to a directory to be set for 
nfs
share. On the host side, I mount the raid, and start writing data to this 
raid,  for
about 20hours later, I start to delete the data , but the following message 
shows:

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1610 of file
fs/xfs/xfs_alloc.c, xfs_force_shutdown(md0,0x8) called from line 4073 of 
file fs/xfs/xfs_bmap.c
Filesystem "md0" corruption of in-memory data detected. Shutting down
filesystem.Please umount the filesystem and rectify the problem.

     Although the filesystem crashed, the system did not hang. So I cd to 
this directory,
and ls, and find that all the data seems to be lost,  but 'df' reports that 
the most of
raid has been used, I try to repair it with xfs_repair, and everything is 
OK.
     But now I don't want to fix this problem by xfs_repair, if the problem 
happens again,
I have to reparit it again, it's too trouble, so if there is any way to 
solve this prolbem?
I want to find out what causes this error happend,
   Anybody has experience in this problem?
   The following is my system parameter:
  linux version: 2.6.12.6
  CPU: arm926ej
  memory: 128M
  If you answer this question ,Could you please cc to me? I didn't subscribe 
this mailing list.
 Thanks in advance!

 Robert 
