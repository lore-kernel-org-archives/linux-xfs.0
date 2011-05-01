Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41IAfav187116
	for <linux-xfs@OSS.SGI.com>; Sun, 1 May 2011 13:10:42 -0500
Received: from hermes2.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B17EE424CCF
	for <linux-xfs@OSS.SGI.com>; Sun,  1 May 2011 11:14:14 -0700 (PDT)
Received: from hermes2.dur.ac.uk (hermes2.dur.ac.uk [129.234.248.2]) by
	cuda.sgi.com with ESMTP id 6JIGHFZo6Euim2SE for
	<linux-xfs@OSS.SGI.com>; Sun, 01 May 2011 11:14:14 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <19901.41647.606112.243194@tree.ty.sabi.co.UK>
Date: Sun, 1 May 2011 19:13:03 +0100
Subject: Re: op-journaled fs, journal size and storage speeds
In-Reply-To: <20110501092758.GG13542@dastard>
References: <19900.8703.214676.218477@tree.ty.sabi.co.UK>
	<20110501092758.GG13542@dastard>
From: pg_mh@sabi.co.UK (Peter Grandi)
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
Cc: Linux fs XFS <linux-xfs@oss.sgi.com>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>


>> Been thinking about journals and RAID6s and SSDs. In particular
>> for file system designs like JFS and XFS that do operation
>> journaling (while ext[34] do block journaling).

> XFS is not an operation journalling filesystem. Most of the
> metadata is dirty-region logged via buffers, just like ext3/4.

Looking at the sources, XFS does operations journaling, in the
form of physical ("dirty region") operation logging, instead of
logical operation logging like JFS. Both are very different from
block journaling.

More in details, to me there is a stark contrast between 'jbd.h':

  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=blob;f=include/linux/jbd.h;h=e06965081ba5548f74db935543af84334f58259e;hb=HEAD

where I find only a few journal transaction types (blocks) and
'xfs_trans.h' where I find many journal transaction types (ops):

 http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=blob;f=fs/xfs/xfs_trans.h;h=c2042b736b81131a780703d8a5907c848793eebb;hb=HEAD

Given that in the latter I see transaction types like
'XFS_TRANS_RENAME' or 'XFS_TRANS_MKDIR' it is hard to imagine how
one can argue that the XFS journals something other than ops, even
if in a buffered way of sorts.

Ironically comparing with the 'jfs_logmgr.h':

  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=blob;f=fs/jfs/jfs_logmgr.h;h=9236bc49ae7ff1aed9cad81a2b22c2c54e433ba0;hb=HEAD

I see lower level transaction types there (but they are logged as
ops rather than "dirty-region"s.).

[ ... ]

>> It seems to me that adopting as guideline a percent of the
>> filesystem is very wrong, and so I have been using a rule of
>> thumb like one second of expected transfer rate, so "in flight"
>> updates are never much behind.

> How do you know what "one second" of "in flight" operations is
> going to be?

Well, that's what I discuss later, it is a "rule of thumb" based
on on *some* rationale, but I have been questioning it.

[ ... interesting summary of some of the many issue related to
journal sizing ... ]

> Easiest and most reliable method seems to be to size your
> journal appropriatly in the first place and have you
> algorithms key off that....

Sure, but *I* am asking that question :-).

[ ... ]

> 17 minutes is my current record by crashing a VM during a
> chmod -R operation over a 100 million inode filesystem. That
> was on a ~2GB log (maximum supported size).

Uhhhm I happen to strongly relate to that (on a much smaller
scale :->).

[ ... ]

>> This seems to me a fairly bad idea, because then the journal
>> becomes a massive hot spot on the disk and draws the disk arm
>> like black hole. I suspect that operations should not stay on

> That's why you can configure an external log....

...and lose barriers :-). But indeed.

>> the journal for a long time. However if the journal is too
>> small processes that do metadata updates start to hang on it.

> Well, yes. The journal needs to be large enough to hold all
> the transaction reservations for the active transactions. XFS,
> in the worse case for a default filesystem config, needs about
> 100MB of log space per 300 concurrent transactions. [ ... ]

So something like 300KB per transaction? That seems a pretty
extreme worst case. How is that possible? A metadata transaction
with a "dirty region" of 300KB sound enormously expensive. It may
be about extent maps for a very fragmented file I guess. Also not
clear here what  concurrent  means because the log is sequential.
I'll guess that it means "in flight".

[ ... ]

>> * What should journal size be proportional to?

> Your workload.

Sure, as a very top level goal. But that's not an answer, it is
handwaving. As you argue earlier, it could be proportional in some
cases to IO threads; or it could be number of arms, filesystem
size, size of each volume, sequential transfer rate, random
transfer rate, large IO transfer rate, small IO transfer rate, ...

Some tighter guideline might be better than just guessing.

>> * What is the downside of a too small journal?

> Performance sucks.

But why? Without a journal completely performance is better;
assuming a one-transaction journal this becomes slower because
of writing everything twice, but that happens for any size of
journal, as it is unavoidable.

When the journal fills up the effect is the same as that of a 1
transaction journal. That's the same for every type of buffer.

So the effect of a journal larger than 1 transaction must be
felt only when the journal is not full, that is there are pauses
in the flow of transactions; and then it does not matter a lot
just how large the journal is.

So the journal should be large enough to accomodate the highest
possible rate of metadata updates for the longest time this
happens until there is a pause in the metadata updates.

This of course depends on workload, but some rule of thumb based
on experience might help.

And here my guess is that shorter journals are better than
longer ones, because also:

>> * What is the downside of a too large journal other than space?

> Recovery times too long, lots of outstanding metadata pinned
> in memory (hello OOM-killer!), and other resource management
> related scalability issues.

I would have expected also more seeks, as reading logged but not
yet finalized metadata has to go back to the journal, but I guess
that's a small effect.

>> BTW, another consideration is that for filesystems that are
>> fairly journal-intensive, putting the journal on a low traffic
>> storage device can have large benefits.

> Yeah, nobody ever thought of an external log before.... :)

I was just stating the obvious here, in order to contrast it with:

>> But if they can be pretty small, I wonder whether putting the
>> journals of several filesystems on the same storage device then
>> becomes a sensible option as the locality will be quite narrow
>> (e.g. a single physical cylinder) or it could be wortwhile like
>> the database people do to journal to battery-backed RAM.

For example as described in this old paper:

  http://www.evenenterprises.com/SSDoracl.pdf

> Got a supplier for the custom hardware you'd need?

There are still a few, for example at different ends of the scale:

  http://www.ramsan.com/solutions/oracle/
  http://www.microdirect.co.uk/home/product/39434/ACARD-RAM-Disk-SSD-ANS-9010B-6X-DDR-II-Slots

> Just use a PCIe SSD....

Yes, that's what many people are doing, but mostly for data,
rather than specifically journals.

As mentioned at the start I have indeed been thinking of SSDs.

But they seem to me fundamentally terrible for journals, because
of the large erase blocks sizes and the enormous latency of erase
operations (lots of read-erase-write cycles for small commits).
They seem more oriented to large mostly read-only data sets than
very small mostly write ones.

The saving grace is the capacitor-backed RAM in SSDs (used to work
around erase block size issues as you probably know) which to a
significant extent may act as the  battery-backed RAM  I was
mentioning; and similarly as another post says the  battery-backed
RAM  in RAID host adapters would do much the same function.

But neither as cleanly as a dedicated unit, not a cache.

But as another contributor said a fast/small disk RAID1 might be
quite decent in many situations.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
