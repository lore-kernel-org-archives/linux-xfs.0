Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8FovLF011151
	for <linux-xfs@oss.sgi.com>; Mon, 8 Dec 2008 09:50:57 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCE34E46
	for <linux-xfs@oss.sgi.com>; Mon,  8 Dec 2008 07:50:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id oJi2Kja5EQY9gPIi for <linux-xfs@oss.sgi.com>;
	Mon, 08 Dec 2008 07:50:56 -0800 (PST)
Message-ID: <493D425F.2010904@sandeen.net>
Date: Mon, 08 Dec 2008 09:50:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS over SSD
References: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>	
	<493D334C.5010006@sandeen.net>
	<5d96567b0812080711x34bb93d6vd8e4f88d9b190e9@mail.gmail.com>
In-Reply-To: <5d96567b0812080711x34bb93d6vd8e4f88d9b190e9@mail.gmail.com>
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
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

Raz wrote:
> On Mon, Dec 8, 2008 at 4:46 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> Raz wrote:
>>> I am thinking of using XFS over a SSD disk.
>>> 1. Can I separate xfs meta data ( not just the logging) from the SSD ?
>>> can I put the meta on a different disk ?
>> Are you talking about just the log (see the mkfs man page for external
>> logs, as Justin suggested) or all metadata?  For the latter, using the
>> realtime subvolume does accomplish this (data on one volume, metadata on
>> the other) but that's not used very often.
>>
>> -Eric
>>
> I am referring to all the meta data. 128K of erase block for some block map
> update is a big penalty. I do not like much rt volumes. I tried that and it is
> cumbersome. UBIFS cannot handle 80GB Flash disks ( well, they say it is up to
> 16GB in MTD web site) . I am about to start benchmarking the SSD with XFS
> ( versus raw access ) and see how performance degrades, in read and writes.
> If there was a way to set XFS meta data ( superblocks, allocation groups...
> on a different device) it would have been nice, since we plan to use the SSD
> as a fast IO device and data persistence is not the main thing here.
> 
> we use XFS on all our SATA based servers, we tweak it ( extents and
> raid awareness).
> XFS proved to be the fastest file system for appliances that use
> Multimedia files
> and big IOs ( 1MB).
> 

I have yet to play with xfs on ssd, but I would imagine that setting up
the fs geometry to match the ssd preferred IO sizes and/or erase block
sizes might at least help.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
