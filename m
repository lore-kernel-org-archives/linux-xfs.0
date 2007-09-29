Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 19:15:26 -0700 (PDT)
Received: from mx1.whoi.edu (zeratul.whoi.edu [128.128.76.62])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T2FLQL021425
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 19:15:22 -0700
Date: Fri, 28 Sep 2007 22:15:18 -0400 (EDT)
From: Benjamin Carr <bcarr@whoi.edu>
Subject: Re: Truncated Filesystem
In-Reply-To: <alpine.LRH.0.9999.0709282145490.22882@hogwarts.egr.duke.edu>
Message-ID: <Pine.LNX.4.58.0709282214540.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
 <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net>
 <46FD959E.5030009@zytor.com> <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
 <alpine.LRH.0.9999.0709282145490.22882@hogwarts.egr.duke.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

> >> What kind of partition table is it?  MS-DOS partition tables have a 2 TB
> >> limit.
> Issue number one -- don't use fdisk, as it doesn't support devices that 
> big.  Use parted instead:

climate:~ benc$ sudo parted /dev/sdc check 1
Warning: Partition 1 is 2005GB, but the file system is 13TB.              

Yeah, that is a problem.
