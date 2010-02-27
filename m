Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1R14IJ2223590 for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 19:04:18 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 957311D02071
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 17:05:40 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 1bXHzXvgvbBLEL9D for
	<xfs@oss.sgi.com>; Fri, 26 Feb 2010 17:05:40 -0800 (PST)
Date: Fri, 26 Feb 2010 20:05:40 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
In-Reply-To: <87zl2vsdxs.fsf@openvz.org>
Message-ID: <alpine.DEB.2.00.1002261953350.8247@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan>
	<87zl2vsdxs.fsf@openvz.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Alan Piszcz <ap@solarrain.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com



On Sat, 27 Feb 2010, Dmitry Monakhov wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>
>> Hello,
>>
>> Is it possible to 'optimize' ext4 so it is as fast as XFS for writes?
>> I see about half the performance as XFS for sequential writes.
>>
>> I have checked the doc and tried several options, a few of which are shown
>> below (I have also tried the commit/journal_async/etc options but none of
>> them get the write speeds anywhere near XFS)?
>>
>> Sure 'dd' is not a real benchmark, etc, etc, but with 10Gbps between 2
>> hosts I get 550MiB/s+ on reads from EXT4 but only 100-200MiB/s write.
>>
>> When it was XFS I used to get 400-600MiB/s for writes for the same RAID
>> volume.
>>
>> How do I 'speed' up ext4?  Is it possible?
> I don't know how to speedup, but i do know how to slowdown XFS :)
> Seems that you forget to call fsync at the end of file write
> In this case some data may reside in memory cache.
> Please add  "conv=fsync" or "conv=fdatasync" to the dd cmd.
> And redone your measurements.

Hi,

First with a sync added in the total time (still 2x as fast)

EXT3:
p63:~# mount /dev/md0 -o nobarrier,data=writeback /r1
p63:~# cd /r1
p63:/r1# /usr/bin/time bash -c 'dd if=/dev/zero of=file bs=1M count=10240; sync'
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 35.4163 s, 303 MB/s
0.02user 19.85system 0:36.97elapsed 53%CPU (0avgtext+0avgdata 7296maxresident)k
0inputs+0outputs (5major+1145minor)pagefaults 0swaps

XFS:
p63:/r1# /usr/bin/time bash -c 'dd if=/dev/zero of=file bs=1M count=10240; sync'
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 18.08 s, 594 MB/s
0.03user 16.15system 0:18.67elapsed 86%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (5major+1147minor)pagefaults 0swaps
p63:/r1#

Per your request: conv=fsync & conv=fdatasync


XFS:
p63:/r1# /usr/bin/time bash -c 'dd if=/dev/zero of=file bs=1M conv=fsync count=10240'
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 18.2142 s, 590 MB/s
0.03user 16.05system 0:18.21elapsed 88%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (0major+832minor)pagefaults 0swaps
p63:/r1#

EXT3:
p63:/r1# /usr/bin/time bash -c 'dd if=/dev/zero of=file bs=1M conv=fdatasync count=10240'
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 39.5562 s, 271 MB/s

XFS:
p63:/r1# /usr/bin/time bash -c 'dd if=/dev/zero of=file bs=1M conv=fdatasync count=10240'
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 18.513 s, 580 MB/s
0.03user 16.25system 0:18.51elapsed 87%CPU (0avgtext+0avgdata 7312maxresident)k
0inputs+0outputs (5major+828minor)pagefaults 0swaps
p63:/r1#

p63:/r1# /usr/bin/time bash -c 'dd if=/dev/zero of=file bs=1M conv=fsync count=10240'
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 39.7859 s, 270 MB/s
0.02user 24.20system 0:39.79elapsed 60%CPU (0avgtext+0avgdata 7328maxresident)k
0inputs+0outputs (5major+829minor)pagefaults 0swaps
p63:/r1#

It is still 2x as fast?
Is there some other option I am missing here or is this correct?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
