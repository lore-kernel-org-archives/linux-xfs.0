Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q9Qbsv111019 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 04:26:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4AE01461ED8
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 02:29:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kR2B5Hms74gr3lgU for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 02:29:41 -0700 (PDT)
Date: Mon, 26 Jul 2010 05:29:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: add discard support (at transaction commit)
Message-ID: <20100726092938.GA13150@infradead.org>
References: <20100509175048.GA1435@infradead.org>
	<20100509215944.GF25419@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100509215944.GF25419@dastard>
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
Cc: lczerner@redhat.com, jmoyer@redhat.com, snitzer@redhat.com, xfs@oss.sgi.com

On Mon, May 10, 2010 at 07:59:44AM +1000, Dave Chinner wrote:
> I think this can  be made to work, but I don't really like it that
> much, especially the barrier flush part. Is there any particular
> reason we need to issue discards at this level apart from "other
> filesystems are doing it" rather than doing it lazily in a
> non-performance critical piece of code?

To be able to benchmark it.  I finally had the opportunity to test
discard against a real life highend storage device - an iscsi attached
RAID array from a big name vendor (not quite sure about the NDA status,
so I can't name which one exactly yet).

Running postmark with our without discards enabled with a setup Lukas
created the online discard support is much faster than the offline
one.  With online discard on XFS we are getting close to the speed
without discards.

Unfortunately the discard performance isn't always 100% determinstic so
we have some error margin, but with the online discard support discards
are in the range of 1.5% faster than no
discard mode to 3% slower, while the offline discard is in the range
of 4 to 8% slower.  That still compares favourable to the online discard
in ext4 which is 10% to 15% slower than not using discard.  The btrfs
is online discard is in the same range as XFS, with a tendency to be
even slightly faster.

> Regardless of this, some questions about the patch come to mind:
> 
> 	1. is it safe to block the xfslogd in the block layer in,
> 	say, get_request()? i.e. should we be issuing IO from an IO
> 	completion handler? That raises red flags in my head...


Good question - probably not a that smart idea.  
> 
> 	2. issuing discards will block xfslogd and potentially stall
> 	the log if there are lots of discards to issue.

> 	3. DISCARD_FL_BARRIER appears to be used to allow async
> 	issuing of the discard to ensure any followup write has the
> 	discard processed first. What happens if the device does not
> 	support barriers or barriers are turned off?

These days all useful devices do support barriers, and certainly
any device that supports discards does.  But if not we'll get back
an EOPNOTUPP error which simply gets ignored.

Note that for a device that does not support write barriers (which
includes basically any highend storage device that supports scsi thin
provisioning) the DISCARD flag currently evaluates to a queue drain,
but even that isn't actually nessecary in this case.  It will be gone
soon as part changes I plan to the barrier code.

> 	4. A barrier IO on every discard? In a word: Ouch.

Whne running with the delaylog option the discard don't happen very
often anymore.  Basically we'll do one discard everytime we write a log
record.  Which in fact already did a barrier anyway, so the the effect
isn't that bad.  We'd could in fact get away with just removing the
barrier and doing a cache flush just after the discard, but before
removing the extents from the busy list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
