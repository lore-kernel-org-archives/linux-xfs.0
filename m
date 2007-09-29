Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 19:15:03 -0700 (PDT)
Received: from hogwarts.egr.duke.edu (hogwarts.egr.duke.edu [152.3.195.84])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T2EtMi021245
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 19:14:58 -0700
Date: Fri, 28 Sep 2007 21:49:55 -0400 (EDT)
From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Truncated Filesystem
In-Reply-To: <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
Message-ID: <alpine.LRH.0.9999.0709282145490.22882@hogwarts.egr.duke.edu>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net> <46FD959E.5030009@zytor.com> <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Benjamin Carr <bcarr@whoi.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 at 8:49pm, Benjamin Carr wrote

>> What kind of partition table is it?  MS-DOS partition tables have a 2 TB
>> limit.
>
> Hadn't thought of that, doesn't look good.
> -Ben
>
> sudo fdisk -l /dev/sdc1
> benc's password:

Issue number one -- don't use fdisk, as it doesn't support devices that 
big.  Use parted instead:

parted /dev/sdc
mklabel gpt
mkpart primary ext2 0 11TB
quit

where you may have to sub some other value for the "11TB" in the mkpart 
line -- I forget the exact syntax.

-- 
Joshua Baker-LePain
QB3 Shared Cluster Sysadmin
UCSF
