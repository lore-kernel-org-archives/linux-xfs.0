Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42AatUj227603
	for <linux-xfs@oss.sgi.com>; Mon, 2 May 2011 05:36:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75ECE1EC75C4
	for <linux-xfs@oss.sgi.com>; Mon,  2 May 2011 03:40:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1fGBRy06LQmMQHhG for
	<linux-xfs@oss.sgi.com>; Mon, 02 May 2011 03:40:32 -0700 (PDT)
Date: Mon, 2 May 2011 06:40:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: op-journaled fs, journal size and storage speeds
Message-ID: <20110502104031.GA22953@infradead.org>
References: <19900.8703.214676.218477@tree.ty.sabi.co.UK>
	<20110501092758.GG13542@dastard>
	<19901.41647.606112.243194@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19901.41647.606112.243194@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_mh@sabi.co.UK>
Cc: Linux fs XFS <linux-xfs@oss.sgi.com>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>

On Sun, May 01, 2011 at 07:13:03PM +0100, Peter Grandi wrote:
> > That's why you can configure an external log....
> 
> ...and lose barriers :-). But indeed.

Using a writeback cache on the log device is rather pointless as
every writes needs write through semantics using FUA or a post-flush
anyway.  But I actually have patch to allow for devices with
a writeback cache in external log configurations, it's just a bit
complicated as we basically need to copy the pre-flush statemachine
into XFS to deal with the preflush beeing for a different device
than the actual write.

> >> But if they can be pretty small, I wonder whether putting the
> >> journals of several filesystems on the same storage device then
> >> becomes a sensible option as the locality will be quite narrow
> >> (e.g. a single physical cylinder) or it could be wortwhile like
> >> the database people do to journal to battery-backed RAM.
> 
> For example as described in this old paper:

It only makes sense if the log activity bursts for the different
filesystems happen at different times, or none of the filesystems
maxes out the log IOP rate.  

> But they seem to me fundamentally terrible for journals, because
> of the large erase blocks sizes and the enormous latency of erase
> operations (lots of read-erase-write cycles for small commits).
> They seem more oriented to large mostly read-only data sets than
> very small mostly write ones.

As mentioned earlier in this thread XFS allows to align and pad
log writes.  Just make sure to get a device with an erase block
size <= 256 kilobytes, which usually means SLC.  But even drives
with a larger erase block size and sane firmware tend to be faster
than plain old disks.  But as Dave mentioned there's nothing that's
going to beat a battery backed cache/memory for log IOP performance.

> The saving grace is the capacitor-backed RAM in SSDs (used to work
> around erase block size issues as you probably know) which to a
> significant extent may act as the  battery-backed RAM  I was
> mentioning; and similarly as another post says the  battery-backed
> RAM  in RAID host adapters would do much the same function.

Just make sure your device actually has it.  Both the Intel X25 SSDs
and many other consumer / prosumer SSDs actually don't have them
and will lose data in case of a powerloss.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
