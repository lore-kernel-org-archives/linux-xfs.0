Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AD637F54
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 03:50:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02328AC007
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 01:50:53 -0800 (PST)
Received: from mail-vb0-f48.google.com (mail-vb0-f48.google.com
	[209.85.212.48]) by cuda.sgi.com with ESMTP id xtI5S7DOH9SezeFx
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Nov 2013 01:50:52 -0800 (PST)
Received: by mail-vb0-f48.google.com with SMTP id x16so3389050vbf.7
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 01:50:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131121092606.GU11434@dastard>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
Date: Thu, 21 Nov 2013 04:50:51 -0500
Message-ID: <CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
Subject: Re: Filesystem writes on RAID5 too slow
From: Martin Boutin <martboutin@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 21, 2013 at 4:26 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Nov 21, 2013 at 04:11:41AM -0500, Martin Boutin wrote:
>> On Mon, Nov 18, 2013 at 7:57 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Nov 18, 2013 at 12:28:21PM -0600, Eric Sandeen wrote:
>> >> On 11/18/13, 10:02 AM, Martin Boutin wrote:
>> >> > Dear list,
>> >> >
>> >> > I am writing about an apparent issue (or maybe it is normal, that's my
>> >> > question) regarding filesystem write speed in in a linux raid device.
>> >> > More specifically, I have linux-3.10.10 running in an Intel Haswell
>> >> > embedded system with 3 HDDs in a RAID-5 configuration.
>> >> > The hard disks have 4k physical sectors which are reported as 512
>> >> > logical size. I made sure the partitions underlying the raid device
>> >> > start at sector 2048.
>> >>
>> >> (fixed cc: to xfs list)
>> >>
>> >> > The RAID device has version 1.2 metadata and 4k (bytes) of data
>> >> > offset, therefore the data should also be 4k aligned. The raid chunk
>> >> > size is 512K.
>> >> >
>> >> > I have the md0 raid device formatted as ext3 with a 4k block size, and
>> >> > stride and stripes correctly chosen to match the raid chunk size, that
>> >> > is, stride=128,stripe-width=256.
>> >> >
>> >> > While I was working in a small university project, I just noticed that
>> >> > the write speeds when using a filesystem over raid are *much* slower
>> >> > than when writing directly to the raid device (or even compared to
>> >> > filesystem read speeds).
>> >> >
>> >> > The command line for measuring filesystem read and write speeds was:
>> >> >
>> >> > $ dd if=/tmp/diskmnt/filerd.zero of=/dev/null bs=1M count=1000 iflag=direct
>> >> > $ dd if=/dev/zero of=/tmp/diskmnt/filewr.zero bs=1M count=1000 oflag=direct
>> >> >
>> >> > The command line for measuring raw read and write speeds was:
>> >> >
>> >> > $ dd if=/dev/md0 of=/dev/null bs=1M count=1000 iflag=direct
>> >> > $ dd if=/dev/zero of=/dev/md0 bs=1M count=1000 oflag=direct
>> >> >
>> >> > Here are some speed measures using dd (an average of 20 runs).:
>> >> >
>> >> > device       raw/fs  mode   speed (MB/s)    slowdown (%)
>> >> > /dev/md0    raw    read    207
>> >> > /dev/md0    raw    write    209
>> >> > /dev/md1    raw    read    214
>> >> > /dev/md1    raw    write    212
>> >
>> > So, that's writing to the first 1GB of /dev/md0, and all the writes
>> > are going to be aligned to the MD stripe.
>> >
>> >> > /dev/md0    xfs    read    188    9
>> >> > /dev/md0    xfs    write    35    83o
>> >
>> > And these will not be written to the first 1GB of the block device
>> > but somewhere else. Most likely a region that hasn't otherwise been
>> > used, and so isn't going to be overwriting the same blocks like the
>> > /dev/md0 case is going to be. Perhaps there's some kind of stripe
>> > caching effect going on here? Was the md device fully initialised
>> > before you ran these tests?
>> >
>> >> >
>> >> > /dev/md1    ext3    read    199    7
>> >> > /dev/md1    ext3    write    36    83
>> >> >
>> >> > /dev/md0    ufs    read    212    0
>> >> > /dev/md0    ufs    write    53    75
>> >> >
>> >> > /dev/md0    ext2    read    202    2
>> >> > /dev/md0    ext2    write    34    84
>> >
>> > I suspect what you are seeing here is either the latency introduced
>> > by having to allocate blocks before issuing the IO, or the file
>> > layout due to allocation is not idea. Single threaded direct IO is
>> > latency bound, not bandwidth bound and, as such, is IO size
>> > sensitive. Allocation for direct IO is also IO size sensitive -
>> > there's typically an allocation per IO, so the more IO you have to
>> > do, the more allocation that occurs.
>>
>> I just did a few more tests, this time with ext4:
>>
>> device       raw/fs  mode   speed (MB/s)    slowdown (%)
>> /dev/md0    ext4    read    199    4%
>> /dev/md0    ext4    write    210    0%
>>
>> This time, no slowdown at all on ext4. I believe this is due to the
>> multiblock allocation feature of ext4 (I'm using O_DIRECT, so it
>> should be it). So I guess for the other filesystems, it was indeed
>> the latency introduced by block allocation.
>
> Except that XFS does extent based allocation as well, so that's not
> likely the reason. The fact that ext4 doesn't see a slowdown like
> every other filesystem really doesn't make a lot of sense to
> me, either from an IO dispatch point of view or an IO alignment
> point of view.
>
> Why? Because all the filesystems align identically to the underlying
> device and all should be doing 4k block aligned IO, and XFS has
> roughly the same allocation overhead for this workload as ext4.
> Did you retest XFS or any of the other filesystems directly after
> running the ext4 tests (i.e. confirm you are testing apples to
> apples)?

Yes I did, the performance figures did not change for either XFS or ext3.
>
> What we need to determine why other filesystems are slow (and why
> ext4 is fast) is more information about your configuration and block
> traces showing what is happening at the IO level, like was requested
> in a previous email....

Ok, I'm going to try coming up with meaningful data. Thanks.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Martin Boutin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
