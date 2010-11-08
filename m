Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8NtaKU125173 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:55:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8E8F1C259FA
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:57:02 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	swCoEBV0UWalBOwj for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 15:57:02 -0800 (PST)
Date: Tue, 9 Nov 2010 10:56:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: don't truncate prealloc from frequently
	accessed inodes
Message-ID: <20101108235650.GW2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-6-git-send-email-david@fromorbit.com>
	<20101108113645.GA16418@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101108113645.GA16418@infradead.org>
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

On Mon, Nov 08, 2010 at 06:36:45AM -0500, Christoph Hellwig wrote:
> I'd be much more happy about fixing this properly in nfsd. 

So would I, but we've been saying that for years and it still ain't
done....

> But I guess
> the fix is simple enough that we can put it into XFS for now.  Any
> reason you use up a whole int in the inode instead of using a flag in
> i_flags?

I wasn't sure how many dirty releases we wanted before triggering
the change of behaviour. A single dirty release seems to be fine in
my testing so far, and if that continues then I think that , like
you suggest, changing it to a flag in i_flags is the right thing to
do.

> > -
> > -		ASSERT(ip->i_delayed_blks == 0);
> > +		/*
> > +		 * even after flushing the inode, there can still be delalloc
> > +		 * blocks on the inode beyond EOF due to speculative
> > +		 * preallocation. These are not removed until the release
> > +		 * function is called or the inode is inactivated. Hence we
> > +		 * cannot assert here that ip->i_delayed_blks == 0.
> > +		 */
> 
> Shouldn't this be in a separate patch given that we can fail the flush
> due to iolock contention?  I think this and the swapext fix are .37
> material in fact.

Agreed. I should have noted in the series preamble that I thought these
probably need splitting out into separate bug fixing patches rather
than being lumped in here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
