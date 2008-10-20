Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 18:16:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K1GRMV019291
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 18:16:27 -0700
Received: from mail.ramunia.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DC63AC8E00
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 18:18:10 -0700 (PDT)
Received: from mail.ramunia.com ([58.26.86.165]) by cuda.sgi.com with ESMTP id eHbBgNqhaFVn6eSo for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 18:18:10 -0700 (PDT)
Message-ID: <48FBDC47.5080700@ramunia.com>
Date: Mon, 20 Oct 2008 09:17:59 +0800
From: Muhammad Fakhrul Rozi Bin Mohd Seth <rozi@ramunia.com>
MIME-Version: 1.0
Subject: XFS slow performance
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi All,

I'm using the UBUNTU server with LVM group of SCSI harddisk.

I'm using this setting for XFS:

               1. mkfs.xfs --l logdev=/dev/sda1,size=64m --d agcount=32
                  /dev/test/department

               1. mount -o noatime,nodiratime,nobarrier,logbufs=8
                  /dev/test/department /data/

My current situation is :

1) I'm using XFS file system as my files server
2) i'm using snapshot to make a hot backup like shadow copies in windows

The problem is it takes a long time and some time it make time out for:

1) New file creation
2) Copy files from xfs shared to another local pc's

** what have i check is; if no snapshot was taken; the files sharing was 
go on without problem and really fast.
This problem occurred only when we have a snapshot drives. even a single 
drive.


please help me and advise me on this?

Regards
Rozi



[[HTML alternate version deleted]]
