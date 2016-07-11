Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12DB97CA0
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 02:06:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D93B28F8035
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 00:06:06 -0700 (PDT)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
	[209.85.220.49]) by cuda.sgi.com with ESMTP id D8NZ69tyjHsYMRVS
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2016 00:06:05 -0700 (PDT)
Received: by mail-pa0-f49.google.com with SMTP id hu1so19582018pad.3
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 00:06:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160710232217.GB1922@dastard>
References: <CAGeO4WMZtYjaW=L7Hj8CgTd-sO38-xAUMhkZ-x-Z394YjOO7Xg@mail.gmail.com>
	<20160707222829.GG12670@dastard>
	<CAGeO4WN6iYLk7PjjrfU679wgF5NwFgE=1vkowEc_M8nF5W29HQ@mail.gmail.com>
	<20160710232217.GB1922@dastard>
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Mon, 11 Jul 2016 15:06:03 +0800
Message-ID: <CAGeO4WOuQwA7wm_S6352ovDdgiJixn_ztP5=HUVO1d=VmRxfbA@mail.gmail.com>
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
To: xfs@oss.sgi.com

On Mon, Jul 11, 2016 at 7:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> [please don't top post]
>
> On Fri, Jul 08, 2016 at 01:48:43PM +0800, Kaho Ng wrote:
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
>>
>> Hmm, wouldn't xfs_alloc_ag_vextent_size() first remove the free extent
>> record, and insert a new extent record into the freespace by-size
>> btree if the found free extent record is longer than args->maxlen?
>
> Good, you went and looked to verify what I said(*).  Indeed, when
> you read xfs_alloc_fixup_trees() where the two trees are modified
> after an extent has been selected for allocation:
>
> ...
>         * Delete the entry from the by-size btree.
> ...
>         * Add new by-size btree entry(s).
> ...
>         * Fix up the by-block btree entry(s)
>
> It's pretty clear what the answer is. IOWs, yes, you're correct - we
> only ever modify or delete records from the by-bno freespace tree,
> but the by-size tree does do a delete and insert and so can
> split.(**)
>
> So, while it is possible for a split to occur, you still didn't see
> one in your test. That's because a split is rather unlikely in your
> scenario because once we have a large enough freespace btree records
> stored for a split to occur, we almost always have exact matches in
> the by-count tree for freelist fills and so record deletes are the
> usual operationon the by-count tree.
>
> And even if we are doing a by-count insert, the chances the target
> block for the insert is full is quite small, as are the chances the
> target block for the insert is different to the block the original
> record was deleted from (consider ordering, what record index the
> initial lookup returns and that freelist fills usually only require
> a block or two to be allocated).
>
> Cheers,
>
> Dave.
>
> (*) That was what my answer was aimed at getting you to do as I get
> a lot of timewasters asking me via direct email to answer their
> homework questions for them. Anyone who is trying to understand the
> basics of the freespace btrees should have realised the by-count
> tree needs a delete/insert operation pair if we modify the length of
> a freespace record.
>
> (**) The lesson here is this: trust what people say, but always
> verify it when you can. e.g. I now know you'll look at the
> code to try to understand answers you are given, so my time
> answering your questions is not going to be wasted.
>
> --
> Dave Chinner
> david@fromorbit.com

Thanks for the detailed explaination!

Just wonders why we prefer failing the request of refilling freelist
with XFS_WANT_CORRUPTED_RETURN(mp, i == 1) in some rare case, rather
than returning NULLAGBLOCK and allowing the loop in
xfs_alloc_ag_vextent_size() to try xfs_alloc_ag_vextent_small()... In
such corner case there will always be a lot of small extents at the
front of the by-count tree, and any truncation changes to the first
entry in the tree will not result in tree splits and triggering
assertion failure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
