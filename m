Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 15:20:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lBANK8mU023305
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 15:20:09 -0800
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72BE14679D2
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 15:01:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id Eb6l5DziQ3rbjaYC for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 15:01:09 -0800 (PST)
Message-ID: <475DC056.3000502@sandeen.net>
Date: Mon, 10 Dec 2007 16:40:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Unexpected XFS SB number 0x00000000
References: <002a01c83b74$52060330$f6120990$@de>
In-Reply-To: <002a01c83b74$52060330$f6120990$@de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris <hsvchris@gmx.de>
Cc: linux-xfs@oss.sgi.com

Chris wrote:
> Hello!
> 
> I'm running a home file server with Debian GNU/Linux 4.0 4.0r1 etch
> (2.6.18-5-amd64 Kernel) and an Areca ARC-1220 hardware RAID controller.
> I used to have 4 750GB HDDs connected and set up as RAID 5 array, single
> volume, single XFS partition (set up during the installation of Debian). No
> problems so far.
> 
> Now I added another 750GB HDD to the array, online capacity/volume expansion
> by the controller finished just fine.
> My plan was to add the extra space to the above mentioned XFS partition. So
> I unmounted the partition, started cfdisk, removed the partition table and
> wrote a new one that included the new free space. 
> After rebooting the partition wasn't mounted, so I couldn't use xfs_growth
> to expand the filesystem.  
> 
> xfs_check: unexpected XFS SB magic number 0x00000000

Did your new partition table start in exactly the same place?

Can you find the string "XFSB" anywhere near where your old partition
started?

-Eric
