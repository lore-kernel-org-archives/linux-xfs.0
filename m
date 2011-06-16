Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GBP12o028530 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 06:25:01 -0500
Date: Thu, 16 Jun 2011 07:24:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: make log devices with write back caches work
Message-ID: <20110616112457.GA12467@infradead.org>
References: <20110527164137.GA5833@infradead.org>
	<1308163127.2893.58.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1308163127.2893.58.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jun 15, 2011 at 01:38:47PM -0500, Alex Elder wrote:
> I questioned the "else" below.  But as you mentioned on IRC
> it makes sense because a realtime inode will never share the
> same device target as the log (or later in this function, the
> data device).  A short mention of that in the comment above
> might be reassuring.  Similarly, I think it would be worthwhile
> to mention the reason for doing this flush here *before* the
> log gets forced.

I'll update the comments.

> If log_flushed is set on return here, does that also imply
> that the actual blkdev flush of the log device (which is
> possibly the data device) has occurred?  It looks to
> me like xlog_sync() marks each log buffer ordered but I
> don't see the flush (though I didn't look *that* hard...).

Yes.  The XBF_ORDERED flag is a bit misnamed, but it causes the
to set REQ_FLUSH_FUA and thus a full cache flush before the
actual write.

I have some patches in my queue for the next cycle to clean that
naming up.

> Breaking it down, we have either one or two devices to flush,
> the log and either the realtime or (if external log) the data
> device:
> - realtime device (flush it before log device flush)
> - data device (only if not realtime; do first if external log)
> - log device (flush this last, realtime or not)

If we have both an RT and a log device we might even have to flush
all three.  But the flush of the main device is trasparently handled in
xlog_sync().  At this point we might double-flush the data device,
but cleaning that up is more involved and I'll leave it for the next
cycle.

> 
> I may be wrong, but it seems like this may be the
> logic you need:
> 
>     if (RT)
> 	flush RT device
>     else if (external log)
> 	flush data device
>     force the log
>     if (log device wasn't flushed when log forced)
> 	flush log device
> 
> The log device flush of course implies a data device flush
> for an internal log.

No, that's incorrect.  If we have dirty data in the log that needs to be
flushed (that is anything dirty for this inode is in the log), the log
force does it for us.

The flush of the data device after the log force is for the case where
the log did not get flushed.  That case only happens if we did
overwrites of and already allocated file, and we're using fdatasync
and thus don't flush out the timestamps.

> > -	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
> > +	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
> > +		/*
> > +		 * If we have an external log device, flush the data device
> > +		 * before flushing the log.
> > +		 */
> > +		if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
> > +			xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> 
> Shouldn't we flush the realtime device as well here, if present?

No.  The reason we flush the data device here is to make sure metadata
written back from the AIL actually made it to disk before moving the
log tail.  None of that metadata is on the RT device.

I'll add a comment explaning what we do here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
