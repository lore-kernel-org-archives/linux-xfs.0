Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 15:03:14 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53M3Baj026254
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 15:03:11 -0700
Received: from rgminet01.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 425901776F3D
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 15:04:04 -0700 (PDT)
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118]) by cuda.sgi.com with ESMTP id aF0HUKrDMgHcRnZx for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 15:04:04 -0700 (PDT)
Subject: Re: Questions for article
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>
Date: Tue, 03 Jun 2008 18:00:42 -0400
In-Reply-To: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org> (Thomas King's message of "Tue\, 3 Jun 2008 15\:48\:49 -0500 \(CDT\)")
Message-ID: <yq1mym2nppx.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas King <kingttx@tomslinux.homelinux.org>
Cc: xfs@oss.sgi.com

>>>>> "Thomas" == Thomas King <kingttx@tomslinux.homelinux.org> writes:

Thomas> -Is XFS fully RAID aware inthat it aligns metadata with RAID
Thomas> stripes? Some of the information I see states XFS can get
Thomas> geometry information from LVM and MD, but what about hardware
Thomas> RAID? 

The stuff that queries MD/LVM for stripe unit/stripe size has been in
XFS for a while[1].

For hardware RAID there is no non-proprietary way to obtain the
information from the device.  So whoever runs mkfs on a hardware RAID
device must manually specify the geometry using the sunit and swidth
parameters.  That capability has been there since the dawn of time.

Note that in the upcoming version of SBC-3 (SCSI Block Commands)
finally features a VPD page that the array firmware can fill out to
let the operating system know about stripe size, etc.  I have been
working on a patch that extracts this information and presents it to
the block layer in a generic fashion.  But so far I have not seen a
single array that implements said VPD page.  IOW, there hasn't been
much motivation to finish that work.

Also, SBC-3 is work in progress.  The standard has not been ratified
yet so things could change before it is released.  I doubt they are
going to change the block limits VPD, but who knows?


Thomas> -Does XFS take advantage of T10 DIF (block protection?)?

As I mentioned earlier today, filesystems do not need to be explicitly
DIF-aware.  I/Os submitted by XFS will be protected if the kernel does
DIF.

The DIF support has not been accepted upstream yet.  Working on that.
But in any case DIF-capable hardware is not generally available.


[1] http://www.linux.sgi.com/archives/xfs/2001-03/msg00435.html

-- 
Martin K. Petersen	Oracle Linux Engineering
