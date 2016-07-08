Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 931287CAF
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 23:06:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0220EAC002
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 21:05:57 -0700 (PDT)
Received: from mail-pa0-f68.google.com (mail-pa0-f68.google.com
	[209.85.220.68]) by cuda.sgi.com with ESMTP id n0wBdMK8fzWwvKrH
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2016 21:05:52 -0700 (PDT)
Received: by mail-pa0-f68.google.com with SMTP id ib6so3488410pad.3
	for <xfs@oss.sgi.com>; Thu, 07 Jul 2016 21:05:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160708034710.GL12670@dastard>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
	<20160707222829.GG12670@dastard>
	<CAGeO4WNAdmeXgL4+CAQ1Yqo18XFgv3NZxWVbDTS0xDZLyb3e2w@mail.gmail.com>
	<20160708034710.GL12670@dastard>
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Fri, 8 Jul 2016 12:05:51 +0800
Message-ID: <CAGeO4WOVhk=XY4v-Nu4=6yB=kJ16Pgf7WX_O-SsqZtvJ+UOXUw@mail.gmail.com>
Subject: Re: [QUESTION] about the freelist allocator in XFS
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

Hmm, wouldn't xfs_alloc_ag_vextent_size() first remove the free extent
record, and insert a new extent record into the freespace by-size
btree if the found free extent record is longer than args->maxlen?

On Fri, Jul 8, 2016 at 11:47 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jul 08, 2016 at 10:26:33AM +0800, Kaho Ng wrote:
>> Hmm, wouldn't xfs_alloc_ag_vextent_size() first remove the free extent
>> record, and insert a new extent record into the freespace by-size
>> btree if the found free extent record is longer than args->maxlen?
>
> Please reply to the list, not privately.
>
> -Dave.
>
>>
>> On Fri, Jul 8, 2016 at 6:28 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Thu, Jul 07, 2016 at 07:01:35PM +0800, Kaho Ng wrote:
>> >> I am trying to investigate how freelist allocator in xfs interacts
>> >> with freespace B+Tree allocator.
>> >> First I prepared a patch
>> >> <https://gist.github.com/22ffca35929e67c08759b057779b7566> on
>> >> linux-source/fs/xfs/libxfs/xfs_alloc.c to print debugging messages
>> >> (The kernel version used is linux-3.10.0-327.22.2.el7).
>> > ......
>> >> When reading the log output
>> >> <https://gist.github.com/890076405e1c13c0a952a579e25e6afe> , I
>> >> realised that there is no B+Tree split
>> >> triggered by xfs_alloc_fix_freelist() when calling xfs_free_extent().
>> >> Isn't B+Tree split possible in by-size B+Tree even when truncating a
>> >> longer freespace record to shorter one? But what I found in the log is
>> >> only a few tree shrinks... And when reading the source code of
>> >> freespace allocator I found that a B+Tree growth in this case is
>> >> impossible at least...
>> >
>> > args->isfl doesn't mean what you think it means.
>> >
>> > args->isfl is only set when moving blocks from the freespace btree
>> > to the AGFL, which only occurs when a previous operation allocated a
>> > new freespace btree block and depleted the current freelist. i.e.
>> > "AG Free List" != "AG freespace btree" - they are different
>> > structures on disk...
>> >
>> > And when you consider that a freelist refill can only remove records
>> > from the the freespace btree, it's should be clear that a btree
>> > split won't occur during a freelist refill...
>> >
>> > Cheers,
>> >
>> > Dave.
>> > --
>> > Dave Chinner
>> > david@fromorbit.com
>>
>
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
