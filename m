Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 18:16:51 -0700 (PDT)
Received: from terminus.zytor.com ([198.137.202.10])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T1Gjdd008610
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 18:16:47 -0700
Message-ID: <46FDA778.1070500@zytor.com>
Date: Fri, 28 Sep 2007 18:16:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: Truncated Filesystem
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net> <46FD959E.5030009@zytor.com> <Pine.LNX.4.58.0709282048440.14057@puck.litech.org> <46FDA35A.8040504@zytor.com> <Pine.LNX.4.58.0709282105590.14057@puck.litech.org>
In-Reply-To: <Pine.LNX.4.58.0709282105590.14057@puck.litech.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Benjamin Carr <bcarr@whoi.edu>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Benjamin Carr wrote:
>>> sudo fdisk -l /dev/sdc1
>>                 ^^^^^^^^^ Uh...
> 
> yeah, long day:
> 
> Disk /dev/sdc: 12999.9 GB, 12999988871168 bytes
> 255 heads, 63 sectors/track, 1580491 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1      243744  1957867653+  83  Linux
> 

Looks like an MS-DOS partition table, indeed.

	-hpa
