Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM3l8JN158833 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 21:47:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE7DF1CE9967
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 19:49:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	RXYMSwLpw2Rnm1h7 for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 19:49:04 -0800 (PST)
Date: Wed, 22 Dec 2010 14:49:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/34] xfs: remove all the inodes on a buffer from the
	AIL in bulk
Message-ID: <20101222034902.GF4907@dastard>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-21-git-send-email-david@fromorbit.com>
	<1292984446.2408.358.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292984446.2408.358.camel@doink>
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
Cc: xfs@oss.sgi.com

On Tue, Dec 21, 2010 at 08:20:46PM -0600, Alex Elder wrote:
> On Tue, 2010-12-21 at 18:29 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When inode buffer IO completes, usually all of the inodes are removed from the
> > AIL. This involves processing them one at a time and taking the AIL lock once
> > for every inode. When all CPUs are processing inode IO completions, this causes
> > excessive amount sof contention on the AIL lock.
> > 
> > Instead, change the way we process inode IO completion in the buffer
> > IO done callback. Allow the inode IO done callback to walk the list
> > of IO done callbacks and pull all the inodes off the buffer in one
> > go and then process them as a batch.
> > 
> > Once all the inodes for removal are collected, take the AIL lock
> > once and do a bulk removal operation to minimise traffic on the AIL
> > lock.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> One question, below.		-Alex
> 
> . . .
> 
> > @@ -861,28 +910,37 @@ xfs_iflush_done(
> >  	 * the lock since it's cheaper, and then we recheck while
> >  	 * holding the lock before removing the inode from the AIL.
> >  	 */
> > -	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) {
> > +	if (need_ail) {
> > +		struct xfs_log_item *log_items[need_ail];
> 
> What's the worst-case value of need_ail we might see here?

The number of inodes in a cluster. That's 32 for 256 byte inodes
with the current 8k cluster size.

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
