Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 17:49:21 -0700 (PDT)
Received: from mx1.whoi.edu (zeratul.whoi.edu [128.128.76.62])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T0nEob028543
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 17:49:18 -0700
Date: Fri, 28 Sep 2007 20:49:12 -0400 (EDT)
From: Benjamin Carr <bcarr@whoi.edu>
Subject: Re: Truncated Filesystem
In-Reply-To: <46FD959E.5030009@zytor.com>
Message-ID: <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
 <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net>
 <46FD959E.5030009@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

> What kind of partition table is it?  MS-DOS partition tables have a 2 TB
> limit.

Hadn't thought of that, doesn't look good.
-Ben

sudo fdisk -l /dev/sdc1
benc's password:

Disk /dev/sdc1: 2004.8 GB, 2004856477184 bytes
255 heads, 63 sectors/track, 243743 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdc1 doesn't contain a valid partition table
