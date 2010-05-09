Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49LvbwT236157 for <xfs@oss.sgi.com>; Sun, 9 May 2010 16:57:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06E0697ED36
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 15:00:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	E7uPCgbbx6EMBlny for <xfs@oss.sgi.com>;
	Sun, 09 May 2010 15:00:03 -0700 (PDT)
Date: Mon, 10 May 2010 07:59:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add discard support (at transaction commit)
Message-ID: <20100509215944.GF25419@dastard>
References: <20100509175048.GA1435@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100509175048.GA1435@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, May 09, 2010 at 01:50:48PM -0400, Christoph Hellwig wrote:
> Now that we have reliably tracking of deleted extents in a transaction
> we can easily implement "online" discard support which calls
> blkdev_issue_discard once a transaction commits.  We simply have to
> walk the list of busy extents after transaction commit, but before deleting
> it from the rbtree tracking these busy extents.
> 
> This does not replace by background discard support patch which is probably
> better for thin provisioned arrays - I will updated it to apply ontop of
> this patch when I'm ready to re-submit it.

I think this can  be made to work, but I don't really like it that
much, especially the barrier flush part. Is there any particular
reason we need to issue discards at this level apart from "other
filesystems are doing it" rather than doing it lazily in a
non-performance critical piece of code?

Regardless of this, some questions about the patch come to mind:

	1. is it safe to block the xfslogd in the block layer in,
	say, get_request()? i.e. should we be issuing IO from an IO
	completion handler? That raises red flags in my head...

	2. issuing discards will block xfslogd and potentially stall
	the log if there are lots of discards to issue.

	3. DISCARD_FL_BARRIER appears to be used to allow async
	issuing of the discard to ensure any followup write has the
	discard processed first. What happens if the device does not
	support barriers or barriers are turned off?

	To me it appears that a lack of barriers could result in a
	write being reordered in front of the discard.  e.g.
	delalloc results in btree block freed, marked busy. New
	delalloc occurs, allocates block, marked sync, forces log,
	issues async discard, completes transaction and then writes
	data async.  Which operation does the drive see and complete
	first - the discard or the data write?

	4. A barrier IO on every discard? In a word: Ouch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
