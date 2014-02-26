Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A71247F37
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 23:51:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32C63AC004
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:51:14 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BioalTP0ZLg6XECD for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 21:51:12 -0800 (PST)
Date: Wed, 26 Feb 2014 16:51:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/10] repair: prefetch runs too far ahead
Message-ID: <20140226055109.GQ13647@dastard>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-8-git-send-email-david@fromorbit.com>
	<20140226015250.GB3616@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140226015250.GB3616@infradead.org>
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

On Tue, Feb 25, 2014 at 05:52:50PM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2014 at 05:29:26PM +1100, Dave Chinner wrote:
> > @@ -842,7 +842,7 @@ start_inode_prefetch(
> >  	 * and not any other associated metadata like directories
> >  	 */
> >  
> > -	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
> > +	max_queue = libxfs_bcache->c_maxcount / thread_count / 32;
> 
> I can't correlate this to anything mentioned in the changelog.
> Also if you're touching it anyway it might be a good idea to document
> the magic number here.

I was fiddling with the magic number to see if it affected the
readahead behaviour (it didn't) and forgot to set it back to the
original value. Will fix.

> 
> > +void
> > +prefetch_ag_range(
> > +	struct work_queue	*work,
> > +	xfs_agnumber_t		start_ag,
> > +	xfs_agnumber_t		end_ag,
> > +	bool			dirs_only,
> > +	void			(*func)(struct work_queue *,
> > +					xfs_agnumber_t, void *))
> > +{
> > +	int			i;
> > +	struct prefetch_args	*pf_args[2];
> > +
> > +	pf_args[start_ag & 1] = start_inode_prefetch(start_ag, dirs_only, NULL);
> > +	for (i = start_ag; i < end_ag; i++) {
> > +		/* Don't prefetch end_ag */
> > +		if (i + 1 < end_ag)
> > +			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
> > +						dirs_only, pf_args[i & 1]);
> > +		func(work, i, pf_args[i & 1]);
> > +	}
> > +}
> 
> This seems to largely duplicate the common code added in patch 5.
> Having _range variants of those that the non-range ones wrap with 0 and
> mp->m_sb.sb_agcount as default parameters would avoid that duplication.

Actually, that's pretty much what this patch does in this hunk:

@@ -905,12 +945,8 @@ do_inode_prefetch(
         */
        if (!stride) {
                queue.mp = mp;
-               pf_args[0] = start_inode_prefetch(0, dirs_only, NULL);
-               for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-                       pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
-                                       dirs_only, pf_args[i & 1]);
-                       func(&queue, i, pf_args[i & 1]);
-               }
+               prefetch_ag_range(&queue, 0, mp->m_sb.sb_agcount,
+                                 dirs_only, func);
                return;
        }


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
