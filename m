Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C442D7FC2
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 05:25:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5619BAC002
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:25:28 -0700 (PDT)
Received: from belhaven.mcs.st-and.ac.uk (belhaven.mcs.st-and.ac.uk
	[138.251.201.57]) by cuda.sgi.com with ESMTP id
	Vb7XOEEAnzF11fCE for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 03:25:26 -0700 (PDT)
Received: from mcs.st-and.ac.uk (becks [138.251.201.65])
	by belhaven.mcs.st-and.ac.uk (8.13.8+Sun/8.13.8) with ESMTP id
	s46ANDvS011915
	for <xfs@oss.sgi.com>; Tue, 6 May 2014 11:23:14 +0100 (BST)
Received: from becks.mcs.st-and.ac.uk (localhost.localdomain [127.0.0.1])
	by mcs.st-and.ac.uk (8.13.8/8.13.8) with ESMTP id s46APPGH001347
	for <xfs@oss.sgi.com>; Tue, 6 May 2014 11:25:25 +0100
Received: from localhost (steveb@localhost)
	by becks.mcs.st-and.ac.uk (8.13.8/8.13.8/Submit) with ESMTP id
	s46APOpZ001344 for <xfs@oss.sgi.com>; Tue, 6 May 2014 11:25:25 +0100
Date: Tue, 6 May 2014 11:25:24 +0100 (BST)
From: Steve Brooks <steveb@mcs.st-and.ac.uk>
Subject: XFS tune to adaptec ASR71605 
Message-ID: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi All,

New to the list so first hello to you all from St Andrews, Scotland. 
We have three new raid hosts each with an Adaptec ASR71605 
controller. Given upstream (Red Hat) are going to be using XFS as their 
default file system we are going to use XFS on the three raid hosts. After 
much reading around this is what I came up with.

All hosts have 16x4TB WD RE WD4000FYYZ drives and will run "RAID 6"

The underlying RAID details are

    RAID level                               : 6 Reed-Solomon
    Status of logical device                 : Optimal
    Size                                     : 53401590 MB
    Stripe-unit size                         : 512 KB
    Read-cache setting                       : Enabled
    Read-cache status                        : On
    Write-cache setting                      : Disabled
    Write-cache status                       : Off
    Partitioned                              : No


I built the filesystem with

mkfs.xfs -f -d su=512k,sw=14 /dev/sda

and mounted with fstab options

xfs    defaults,inode64,nobarrier


My question is are the "mkfs.xfs" and the mount options I used sensible? 
The RAID is to be used to store data from "numerical simulations" that 
were run on a high performance cluster and is not mission critical in the 
sense that it can be regenerated if lost. Of course that would take the 
user/cluster some time.

Thanks for any advice.

Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
