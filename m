Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 511DD8000
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 13:33:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CE84304062
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:33:51 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JM5VhEjBmhppehHH for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 11:33:49 -0800 (PST)
Date: Tue, 3 Feb 2015 06:33:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: use generic percpu counters for inode counter
Message-ID: <20150202193344.GK6282@dastard>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-3-git-send-email-david@fromorbit.com>
	<20150202164409.GA695@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202164409.GA695@infradead.org>
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

On Mon, Feb 02, 2015 at 08:44:09AM -0800, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 4cf335b..7bfa527 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -357,7 +357,8 @@ __xfs_sb_from_disk(
> >  	to->sb_rextslog = from->sb_rextslog;
> >  	to->sb_inprogress = from->sb_inprogress;
> >  	to->sb_imax_pct = from->sb_imax_pct;
> > -	to->sb_icount = be64_to_cpu(from->sb_icount);
> > +	if (percpu_counter_initialized(&to->sb_icount))
> > +		percpu_counter_set(&to->sb_icount, be64_to_cpu(from->sb_icount));
> 
> Why would the percpu counter not be initialized here?  Oh, I guess
> this is for xfs_sb_verify().  But why can't xfs_mount_validate_sb simply
> operate on the disk endian SB to avoid that whole issue?

Possibly. I'll look into it.

> > @@ -1288,8 +1288,11 @@ xfs_mod_incore_sb(
> >  	int			status;
> >  
> >  #ifdef HAVE_PERCPU_SB
> > -	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
> > +	ASSERT(field < XFS_SBS_IFREE || field > XFS_SBS_FDBLOCKS);
> >  #endif
> > +	if (field == XFS_SBS_ICOUNT)
> > +		return xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
> > +
> 
> Why is this multiplexd through xfs_mod_incore_sb_unlocked while needing
> a different locking context?  Shouldn't we simply use a different helper
> for this case?

Again, expedient. To fix, I need to export
xfs_mod_incore_sb_unlocked().

> >  	xfs_icsb_cnts_t *cntp;
> >  	int		i;
> >  
> > +	i = percpu_counter_init(&mp->m_sb.sb_icount, 0, GFP_KERNEL);
> > +	if (i)
> > +		return ENOMEM;
> > +
> >  	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
> > -	if (mp->m_sb_cnts == NULL)
> > +	if (!mp->m_sb_cnts) {
> > +		percpu_counter_destroy(&mp->m_sb.sb_icount);
> >  		return -ENOMEM;
> > +	}
> >  
> >  	for_each_online_cpu(i) {
> 
> Reusing a variable for both an errno value and a loop iterator is
> not very readable, just add an additional "error" variabe.

In the end it gets renamed to error. I'll fix it up.

> Also percpu_counter_init returns a proper egative errno value, no need
> to turn that into the incorrect postive ENOMEM.

Oversight. Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
