Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2CC07F37
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 19:17:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 218D0AC001
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 17:17:18 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	Z7wBU69hXNxULxop (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Apr 2015 17:17:16 -0700 (PDT)
Received: by wiun10 with SMTP id n10so47749239wiu.1
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 17:17:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150424061554.GN15810@dastard>
References: <CABppvi55C+vE7Ei8u=_ntC_heDQb4HwUcKom-_9hGkunk84Sfw@mail.gmail.com>
	<20150423224324.GM15810@dastard>
	<CABppvi7+Mu78FAM75YvJvekX2CHtKk4yeMrU7j35fvvWRb923Q@mail.gmail.com>
	<20150424061554.GN15810@dastard>
Date: Tue, 28 Apr 2015 17:17:14 -0700
Message-ID: <CABppvi6N6McmfLgAPcP9cxXxPrBMaD81UyeiVHWOaxrJisSN=g@mail.gmail.com>
Subject: Re: Inode and dentry cache behavior
From: Shrinand Javadekar <shrinand@maginatics.com>
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
Cc: xfs@oss.sgi.com

I will look at the hardware. But, I think, there's also a possible
software problem here.

If you look at the sequence of events, first a tmp file is created in
<mount-point>/tmp/tmp_blah. After a few writes, this file is renamed
to a different path in the filesystem.

rename(<mount-point>/tmp/tmp_blah,
<mount-point>/objects/1004/eef/deadbeef/foo.data).

The "tmp" directory above is created only once. Temp files get created
inside it and then get renamed. We wondered if this causes disk layout
issues resulting in slower performance. And then, we stumbled upon
this[1]. Someone complaining about the exact same problem.

One quick way to validate this was to delete the "tmp" directory
periodically and see what numbers we get. And they do. With 15 runs of
writing 80K objects in each run, our performance was dropping from
~100MB/s to 30MB/s. With deleting the tmp directory after each run, we
saw the performance only drop from ~100MB/s to 80MB/s.

 The explanation in the link below says that when xfs does not find
free extents in an existing allocation group, it frees up the extents
by copying data from existing extents to their target allocation group
(which happens because of renames). Is that explanation still valid?

Thanks in advance.
-Shri

[1] http://xfs.9218.n7.nabble.com/Performance-degradation-over-time-td28514.html

On Thu, Apr 23, 2015 at 11:15 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Apr 23, 2015 at 04:48:51PM -0700, Shrinand Javadekar wrote:
>> > from the iostat log:
>> >
>> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> > .....
>> > dm-6              0.00     0.00    0.20   22.40     0.00     0.09    8.00    22.28  839.01 1224.00  835.57  44.25 100.00
>> > dm-7              0.00     0.00    0.00    1.20     0.00     0.00    8.00     2.82 1517.33    0.00 1517.33 833.33 100.00
>> > dm-8              0.00     0.00    0.00  195.20     0.00     0.76    8.00  1727.51 4178.89    0.00 4178.89   5.12 100.00
>> > ...
>> > dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00    0.00    0.00   0.00 100.00
>> > dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00  1178.85    0.00    0.00    0.00   0.00 100.00
>> >
>> > dm-7 is showing almost a second for single IO wait times, when it is
>> > actually completing IO. dm-8 has a massive queue depth - I can only
>> > assume you've tuned  sys/block/*/queue/nr_requests to something
>> > really large? But like dm-7, it's showing very long IO times, and
>> > that's likely the source of your latency problems.
>>
>> I see that /sys/block/*/queue/nr_requests is set to 128 which is way
>> less than the queue depth shown in the iostat numbers. What gives?
>
> No idea, but it's indicative of a problem below XFS. Work out what
> is happening with your storage hardware first, then work your way up
> the stack...
>
>> One other observation we had was that xfs shows a large amount of
>> directory fragmentation. Directory fragmentation was shown at ~40%
>> whereas file fragmentation was very low at 0.1%.
>
> Pretty common. Directories are only accessed a single block at a
> time, and sequential offset reads are pretty rare, so fragmentation
> makes little difference to performance. You're seeing almost zero
> read IO load, so the directory layout is not a concern for this
> workload.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
