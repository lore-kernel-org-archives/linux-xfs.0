Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8FxGcr011628
	for <linux-xfs@oss.sgi.com>; Mon, 8 Dec 2008 09:59:17 -0600
Received: from yx-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9452216E12E4
	for <linux-xfs@oss.sgi.com>; Mon,  8 Dec 2008 07:59:15 -0800 (PST)
Received: from yx-out-1718.google.com (yx-out-1718.google.com [74.125.44.158])
	by cuda.sgi.com with ESMTP id SxatzLRdqvtIm2qw for
	<linux-xfs@oss.sgi.com>; Mon, 08 Dec 2008 07:59:15 -0800 (PST)
Received: by yx-out-1718.google.com with SMTP id 36so445482yxh.32
	for <linux-xfs@oss.sgi.com>; Mon, 08 Dec 2008 07:59:15 -0800 (PST)
Message-ID: <5d96567b0812080711x34bb93d6vd8e4f88d9b190e9@mail.gmail.com>
Date: Mon, 8 Dec 2008 17:11:58 +0200
From: Raz <raziebe@gmail.com>
Subject: Re: XFS over SSD
In-Reply-To: <493D334C.5010006@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
	<493D334C.5010006@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

On Mon, Dec 8, 2008 at 4:46 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Raz wrote:
>> I am thinking of using XFS over a SSD disk.
>> 1. Can I separate xfs meta data ( not just the logging) from the SSD ?
>> can I put the meta on a different disk ?
>
> Are you talking about just the log (see the mkfs man page for external
> logs, as Justin suggested) or all metadata?  For the latter, using the
> realtime subvolume does accomplish this (data on one volume, metadata on
> the other) but that's not used very often.
>
> -Eric
>
I am referring to all the meta data. 128K of erase block for some block map
update is a big penalty. I do not like much rt volumes. I tried that and it is
cumbersome. UBIFS cannot handle 80GB Flash disks ( well, they say it is up to
16GB in MTD web site) . I am about to start benchmarking the SSD with XFS
( versus raw access ) and see how performance degrades, in read and writes.
If there was a way to set XFS meta data ( superblocks, allocation groups...
on a different device) it would have been nice, since we plan to use the SSD
as a fast IO device and data persistence is not the main thing here.

we use XFS on all our SATA based servers, we tweak it ( extents and
raid awareness).
XFS proved to be the fastest file system for appliances that use
Multimedia files
and big IOs ( 1MB).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
