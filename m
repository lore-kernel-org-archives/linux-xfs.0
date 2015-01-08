Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66A8F7F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 02:09:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46CA88F8039
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 00:09:21 -0800 (PST)
Received: from mail-yk0-f175.google.com (mail-yk0-f175.google.com
	[209.85.160.175]) by cuda.sgi.com with ESMTP id
	4ZmD4n6iA36YWCMu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 00:09:19 -0800 (PST)
Received: by mail-yk0-f175.google.com with SMTP id 200so641796ykr.6
	for <xfs@oss.sgi.com>; Thu, 08 Jan 2015 00:09:18 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Jan 2015 01:09:18 -0700
Message-ID: <CAJCQCtQJhg_Tn0zL0tcJLvwuJ2qafYM05g0DmsRWgZm-_es8vQ@mail.gmail.com>
Subject: Re: XFS corrupt after RAID failure and resync
From: Chris Murphy <lists@colorremedies.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Raffelt <david.raffelt@florey.edu.au>
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jan 7, 2015 at 12:05 AM, David Raffelt
<david.raffelt@florey.edu.au> wrote:

> Yes, after the 2 disks were dropped I definitely had a working degraded
> drive with 5/7 . I only see XFS errors in the kernel log soon AFTER the hot
> spare finished syncing.

I suggest moving this to the linux-raid@ list and include the following:

brief description: e.g. 7 drive raid6 array, 2 drives got booted at
some point due to errors, a hotspare starts rebuilding and finishes,
then XFS errors appear in the log, and xfs_repair -n results suggest a
bad RAID assembly

kernel version
mdadm version
drive model numbers as well as their SCT ERC values
mdadm -E for all drives

The list can take all of this. I'm not sure if it'll also take a large
journal but I'd try it first before using a URL.

For the journal, two things: first it's not going back far enough, the
problems had already begun and it'd be good to have a lot more context
so I'd dig back and find the first indication of a problem, you can
use journalctl --since for this. It can take the form:

journalctl --since "24 hours ago" or "2015-01-04 12:15:00"


Also use the option -o short-monotonic which will use monotonic time,
could come in handy, and is more like dmesg output.

>> smarctl -l scterc /dev/sdX
>
>
> I'm ashamed to say that this command only works on 1 of the 8 drives since
> this is the only enterprise class drive (we are funded by small science
> grants). We have been gradually replacing the desktop class drives as they
> fail.

The errors in your logs are a lot more extensive than what I'm used to
seeing in cases of misconfiguration with desktop drives that lack
configurable SCT ERC. But the failure is consistent with that common
misconfiguration. The problem with desktop drives is the combination
of long error recoveries for bad sectors along with a short kernel
SCSI command timer. So what happens is the kernel thinks the drive has
hung up, and does a link reset. In reality the drive is probably in a
so called "deep recovery" but doesn't get a chance to report an
explicit read error. An explicit read error includes the affected
sector LBA which the md kernel code can then use to rebuild the data
from parity and overwrite the bad sector which fixes the problem.

However...


>> This has to be issued per drive, no shortcut available by specifying
>> all letters at once in brackets. And then lastly this one:
>>
>> cat /sys/block/sd[abcdefg]/device/timeout
>>
>> Again plug in the correct letters.
>
>
> All devices are set to 30 seconds.

This effectively prevents consumer drives from reporting marginally
bad blocks. If they're clearly bad, drive ECC reports read errors
fairly quickly. If they're fuzzy, then the ECC does a bunch of retries
potentially well beyond 30 seconds. I've heard times of 2-3 minutes,
which seems crazy but, that's apparently how long it can be before the
drive will give up and report a read error. And that read error is
necessary for RAID to work correctly.

So what you need to do for all drives that do not have configurable SCT ERC, is:

echo 180 > /sys/block/sdX/device/timeout

That way the kernel will wait up to 3 minutes. The drive will almost
certainly report an explicit read error in less than that, and then md
can fix the problem by writing over that bad sector. To force this
correction actively rather than passively you should schedule a scrub
of all arrays:

echo check > /sys/block/mdX/md/sync_action

You can do this on complete arrays in normal operation. I wouldn't do
this on the degraded array though. Consult linux-raid@ and do what's
suggested there.




>> Right well it's not fore sure toast yet. Also, one of the things
>> gluster is intended to mitigate is the loss of an entire brick, which
>> is what happened, but you need another 15TB of space to do
>> distributed-replicated on your scratch space. If you can tolerate
>> upwards of 48 hour single disk rebuild times, there are now 8TB HGST
>> Helium drives :-P
>
>
> Just to confirm, we have 3x15TB bricks in a 45TB volume. Don't we need
> complete duplication in a distributed-replicated Gluster volume, or can we
> get away with only 1 more brick?

If you want all the data to be replicated you need double the storage.
But you can have more than one volume, such that one has replication
and the other doesn't. The bricks used for replication volumes don't
both have to be raid6. It could be one raid6 and one raid5, or one
raid6 and one raid0. It's a risk assessment.


-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
