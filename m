Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98DD97F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 16:11:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88B02304062
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 14:11:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZPVb7iRRL1A7K17E for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 14:11:14 -0800 (PST)
Date: Sat, 14 Dec 2013 09:11:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: xlog_recover_process_data leaks like a sieve
Message-ID: <20131213221102.GX10988@dastard>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-6-git-send-email-david@fromorbit.com>
	<20131213123205.GA17935@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213123205.GA17935@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 04:32:05AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2013 at 04:34:37PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Fix the double free of the transaction structure introduced by
> > commit 2a84108 ("xfs: free the list of recovery items on error").
> > In the process, make the freeing of the trans structure on error or
> > completion of processing consistent - i.e. the responsibility of the
> > the function that detected the error or completes processing. Add
> > comments to document this behaviour so it can be maintained more
> > easily in future.
> 
> I don't really understand why we'd want to push the freeing into
> more low-level functions.
> 
> e.g. keeping it in xlog_recover_process_data vs the low-level
> functions called by it not only reduces the amount of code, but also
> is way more logical as we lookup trans there, so freeing it seems
> more logical as well.
> 
> > +			if (trans)
> > +				xlog_recover_free_trans(trans);
> 
> goto out_free_trans;
> 
> >  			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
> > -				xfs_warn(log->l_mp, "%s: bad length 0x%x",
> > +				xfs_warn(log->l_mp,
> > +				"%s: bad transaction opheader length 0x%x",
> >  					__func__, be32_to_cpu(ohead->oh_len));
> >  				WARN_ON(1);
> > -				return (XFS_ERROR(EIO));
> > +				xlog_recover_free_trans(trans);
> 
> goto out_free_trans;
> 
> > +			/*
> > +			 * If there's been an error, the trans structure has
> > +			 * already been freed. So there's nothing for us to do
> > +			 * but abort the recovery process.
> > +			 */
> > +			if (error)
> > +				return error;
> 
> To me it seems we'd be better off doing a goto out_free_trans here
> aswell, then remove the existing call to xlog_recover_free_trans in
> xlog_recover_commit_trans for the error case, and keep it out of
> xlog_recover_add_to_trans.

I'll rework it, but hte main issue is that it has to be freed
regardless of the error value in commit record processing, so it's
not as simple as just freeing it on error....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
