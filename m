Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p419OSdP167502
	for <linux-xfs@oss.sgi.com>; Sun, 1 May 2011 04:24:28 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1547B15719D8
	for <linux-xfs@oss.sgi.com>; Sun,  1 May 2011 02:28:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OIF1gfe3cM89OP6u for <linux-xfs@oss.sgi.com>;
	Sun, 01 May 2011 02:28:01 -0700 (PDT)
Date: Sun, 1 May 2011 19:27:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: op-journaled fs, journal size and storage speeds
Message-ID: <20110501092758.GG13542@dastard>
References: <19900.8703.214676.218477@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19900.8703.214676.218477@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_xf2@xf2.to.sabi.co.UK>
Cc: Linux fs XFS <linux-xfs@oss.sgi.com>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>

On Sat, Apr 30, 2011 at 03:51:43PM +0100, Peter Grandi wrote:
> Been thinking about journals and RAID6s and SSDs.
> 
> In particular for file system designs like JFS and XFS that do
> operation journaling (while ext[34] do block journaling).

XFS is not an operation journalling filesystem. Most of the metadata
is dirty-region logged via buffers, just like ext3/4. Perhaps you
need to read some documentation like this:

http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Operation_Based_Logging

> The issue is: journal size?
>
> It seems to me that adopting as guideline a percent of the
> filesystem is very wrong, and so I have been using a rule of
> thumb like one second of expected transfer rate, so "in flight"
> updates are never much behind.

How do you know what "one second" of "in flight" operations is going
to be?

I had to deal with this in XFS when implementing the delayed logging
code. It uses a number of operations or a percentage of log space to
determine when to checkpoint the modifications, and that is
typically load dependent as to when it triggers.

And then you've got the problem of concurrency - one second of a
single threaded workload is much different to one second of the same
workload spread across 20 CPU cores. You need to have limits that
work well in both cases, and structures that scale to that level of
concurrency.

In reality, there's not much point in trying to calculate what one
second's worth of metadata is going to be - more often that not
you'll hit some other limitation in the journal subsystem, run out
of memory or have to put limits in place anyway to avoid latency
problems. Easiest and most reliable method seems to be to size your
journal appropriatly in the first place and have you algorithms key
off that....

> But even at a single disk *sequential* transfer rate of say
> 80MB/s average, a journal that contains operation records could
> conceivably hold dozens if not hundreds of thousands of pending
> metadata updates, probably targeted at very widely scattered
> locations on disk, and playing a journal fully could take a long
> time.

17 minutes is my current record by crashing a VM during a chmod -R
operation over a 100 million inode filesystem. That was on a ~2GB
log (maximum supported size).

http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Reducing_Recovery_Time

> So the idea would be that the relevant transfer rate would be
> the *random* one, and since that is around 4MB/s per single
> disk, journal sizes would end up pretty small. But many people
> allocate very large (at least compared to that) journals.
> 
> This seems to me a fairly bad idea, because then the journal
> becomes a massive hot spot on the disk and draws the disk arm
> like black hole. I suspect that operations should not stay on

That's why you can configure an external log....

> the journal for a long time. However if the journal is too small
> processes that do metadata updates start to hang on it.

Well, yes. The journal needs to be large enough to hold all the
transaction reservations for the active transactions. XFS, in the
worse case for a default filesystem config, needs about 100MB of log
space per 300 concurrent transactions. Increasing transaction
concurrency was the main reason we increased the log size...

> So some questions for which I have guesses but not good answers:
> 
>   * What should journal size be proportional to?

Your workload.

>   * What is the downside of a too small journal?

Performance sucks.

>   * What is the downside of a too large journal other than space?

Recovery times too long, lots of outstanding metadata pinned in
memory (hello OOM-killer!), and other resource management related
scalability issues.

> Again I expect answers to be very different for ext[34] but I am
> asking for operation-journaling file system designs like JFS and
> XFS.

> BTW, another consideration is that for filesystems that are
> fairly journal-intensive, putting the journal on a low traffic
> storage device can have large benefits.

Yeah, nobody ever thought of an external log before.... :)

> But if they can be pretty small, I wonder whether putting the
> journals of several filesystems on the same storage device then
> becomes a sensible option as the locality will be quite narrow
> (e.g. a single physical cylinder) or it could be wortwhile like
> the database people do to journal to battery-backed RAM.

Got a supplier for the custom hardware you'd need? Just use a PCIe
SSD....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
