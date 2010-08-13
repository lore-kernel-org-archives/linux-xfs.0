Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7D6OlLh030361 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 01:24:48 -0500
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B8B44B2026
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 23:24:47 -0700 (PDT)
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) by cuda.sgi.com
	with ESMTP id xFFPmJKoJ3sz2zFp for <xfs@oss.sgi.com>;
	Thu, 12 Aug 2010 23:24:47 -0700 (PDT)
Message-ID: <4C64E52E.2060806@msgid.tls.msk.ru>
Date: Fri, 13 Aug 2010 10:24:46 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: Alignment size?
References: <4C64715F.8060000@msgid.tls.msk.ru>
	<20100812234911.GC10429@dastard>
In-Reply-To: <20100812234911.GC10429@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

13.08.2010 03:49, Dave Chinner wrote:
> On Fri, Aug 13, 2010 at 02:10:39AM +0400, Michael Tokarev wrote:
>> Hello.
>>
>> I used XFS for a long time on many different
>> servers, and it works well.  But now I encountered
>> an.. unexpected problem.
>>
>> The question is: on one of our servers, XFS requires
>> different alignment size for O_DIRECT operations than
>> on others.  Usually it's 512 bytes, but on this server
>> it is 4096 - both min_io and alignment (this is from
>> XFS_IOC_DIOINFO ioctl).
> 
> It'll be a filesystem set up with a 4k sector size, then.  Check the
> output of xfs_info.

yes, xfs_info reports sectsz=4096, I noticed this yesterday.

>> I'm not sure what the reason for this is.
>> On this server, the underlying block device is raid5
>> (linux sw raid), but we had other machines with raid5
>> which didn't have that alignment requiriments.
>>
>> The problem with that is that Oracle db, which we use
>> with XFS alot, refuses to work on this machine, or,
>> rather, XFS refuses to process I/O in 512-byte chunks
>> from oracle (control files and redolog files).
> 
> A clear case of application failure. I guess Oracle have some work
> to do to support 4k sector drives where they won't be able to do 512
> byte direct IOs at all....

Sure thing, that's oracle10, and at least at that time
there was no way to determine the size of I/O in a generic
way.  Now there is, and I hope in oracle12 there will be
support for various different sectors.

But this is not the point..
.
>> Is there a way to remedy this somehow, without
>> reformatting whole 600+ gb?
> 
> Not really. If it is 4k sector size, then there is some extremely
> dangerous voodoo that you could do to realign and resize the AG
> headers, followed by a full xfs_repair run to fix up all the block
> accounting. This is not something I'd recommend anyone ever does,
> and for only 600GB of data it would probably take more time to work
> out how to do it correctly (using disposable filesystem images) than
> it would to dump, mkfs and restore...

Ugh.  I see.  Well, I was afraid of that, but I'm already
sorta-prepared for that, after "sleeping with this idea"... ;)
It'll take ages for sure, but there's no other choice for
now.

So the question that remains is: why?

It's an old machine (PIV era), with old scsi disks (74Gb
non-hotswap), -- the same disks as used on numerous other
machines out there, where there's no such issue.

Plain old linux software raid array, also as used on many
other systems.

At that time, all stuff were in 512 bytes for sure.

The array and filesystem were re-created last year (we
added another drive to it), but I don't think at that
time there were a kernel version that supported >512
sector sizes either (it was 2.6.27 I think).

So why xfs decided the block size is 4K??

And a related question, -- is there a way to create
xfs fs with the right sector size?  The filesystem
were ok in years, not only on this machine, and I'm
quite afraid to replace it with something else (e.g.
ext4) in a hurry without good prior testing.

By the way, how one can check the "sector size" of a
block device nowadays?  I think I saw something about
sysfs, but I see nothing of that sort in 2.6.32 kernel
(which is used on this and other systems).

Thanks!

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
