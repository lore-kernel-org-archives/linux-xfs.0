Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5AGP9fr084106 for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 11:25:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A9573BB139
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 09:27:42 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id S5EIkekfwaJKQAua for
	<xfs@oss.sgi.com>; Thu, 10 Jun 2010 09:27:42 -0700 (PDT)
Message-ID: <4C11127C.3030907@sandeen.net>
Date: Thu, 10 Jun 2010 11:27:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair 3.1.2 crashing
References: <201006101306.07587@zmi.at>
In-Reply-To: <201006101306.07587@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs-oss <xfs@oss.sgi.com>

Michael Monnerie wrote:
> Dear devs, I have a massive problem with a filesystem in our internal 
> server. We've had an overheating problem with the RAID controller CPU, 
> as it's very hot here and aircondition was turn off... the system "just" 
> stopped working. This is a XenServer with some Linuxen on it, and one of 
> them (of course our main server :-) reports this on xfs_repair:
> 
...

> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 2
>         - agno = 1
> data fork in regular inode 2267035928 claims used block 537158068
> xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' 
> failed.
> 
> Any ideas?

It'd be great to at least capture the issue by creating an xfs_metadump
image for analysis...

-Eric
 
> Before that, I had 3.0.3 installed, it found tons of errors before also 
> crashing. I'll send that log later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
