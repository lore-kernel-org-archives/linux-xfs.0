Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DA6E7F4E
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 05:50:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 369A2AC001
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 03:50:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FkvtO7m1AQa3ose3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2015 03:50:34 -0700 (PDT)
Date: Mon, 12 Oct 2015 06:50:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: validate metadata LSNs against log on v5 superblocks
Message-ID: <20151012105032.GA25023@bfoster.bfoster>
References: <1443183869-16487-1-git-send-email-bfoster@redhat.com>
	<20151012045817.GE27164@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151012045817.GE27164@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 12, 2015 at 03:58:17PM +1100, Dave Chinner wrote:
> On Fri, Sep 25, 2015 at 08:24:29AM -0400, Brian Foster wrote:
> > Since the onset of v5 superblocks, the LSN of the last modification has
> > been included in a variety of on-disk data structures. This LSN is used
> > to provide log recovery ordering guarantees (e.g., to ensure an older
> > log recovery item is not replayed over a newer target data structure).
> > 
> > While this works correctly from the point a filesystem is formatted and
> > mounted, userspace tools have some problematic behaviors that defeat
> > this mechanism. For example, xfs_repair historically zeroes out the log
> > unconditionally (regardless of whether corruption is detected). If this
> > occurs, the LSN of the filesystem is reset and the log is now in a
> > problematic state with respect to on-disk metadata structures that might
> > have a larger LSN. Until either the log catches up to the highest
> > previously used metadata LSN or each affected data structure is modified
> > and written out without incident (which resets the metadata LSN), log
> > recovery is susceptible to filesystem corruption.
> > 
> > This problem is ultimately addressed and repaired in the associated
> > userspace tools. The kernel is still responsible to detect the problem
> > and notify the user that something is wrong. Check the superblock LSN at
> > mount time and fail the mount if it is invalid. From that point on,
> > trigger verifier failure on any metadata I/O where an invalid LSN is
> > detected. This results in a filesystem shutdown and guarantees that we
> > do not log metadata changes with invalid LSNs on disk. Since this is a
> > known issue with a known recovery path, present a warning to instruct
> > the user how to recover.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
...
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index be43248..e89a0f8 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
...
> > @@ -322,6 +325,7 @@ xfs_da3_node_create(
> >  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> >  		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
> >  
> > +		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
> >  		ichdr.magic = XFS_DA3_NODE_MAGIC;
> >  		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
> >  		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
> 
> Is this a bug fix or just cleanliness? The LSN gets written into the
> header before it goes to disk, so there is nothing uninitialised
> that I am unaware of ending up on disk from this. 
> 

Sorry, I should have pointed this out in the commit log description. I
probably forgot as these were added after the fact from testing and
reproducing write verifier failures.

Both memset() calls are actually bug fixes with respect to the LSN
checks that this patch adds. They don't affect anything on disk. They
just prevent spurious write verifier failures on object creation because
the write verifiers first verify the data structure and then update the
LSN, which means uninitialized data structures in memory can get into
the verifiers with garbage in the LSN field. IIRC, I dug around at the
time and saw that most of such data structures were initialized or
allocated with zeroed memory and so took the same approach here.

Thanks for the other fixups.

Brian

> > @@ -60,6 +61,7 @@ xfs_symlink_hdr_set(
> >  	if (!xfs_sb_version_hascrc(&mp->m_sb))
> >  		return 0;
> >  
> > +	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
> >  	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
> >  	dsl->sl_offset = cpu_to_be32(offset);
> >  	dsl->sl_bytes = cpu_to_be32(size);
> 
> Ditto.
> 
> > index aaadee0..0c8ef76 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -3165,11 +3165,19 @@ xlog_state_switch_iclogs(
> >  	}
> >  
> >  	if (log->l_curr_block >= log->l_logBBsize) {
> > +		/*
> > +		 * Rewind the current block before the cycle is bumped to make
> > +		 * sure that the combined LSN never transiently moves forward
> > +		 * when the log wraps to the next cycle. This is to support the
> > +		 * unlocked sample of these fields from xlog_valid_lsn(). Most
> > +		 * other cases should acquire l_icloglock.
> > +		 */
> > +		log->l_curr_block -= log->l_logBBsize;
> > +		ASSERT(log->l_curr_block >= 0);
> > +		smp_wmb();
> >  		log->l_curr_cycle++;
> 
> OK, so we make sure the write of the l_curr_block cannot be
> reordered to after the write of the l_curr_cycle.
> 
> > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > index 950f3f9..8daba74 100644
> > --- a/fs/xfs/xfs_log_priv.h
> > +++ b/fs/xfs/xfs_log_priv.h
> > @@ -560,4 +560,55 @@ static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
> >  	remove_wait_queue(wq, &wait);
> >  }
> >  
> > +/*
> > + * The LSN is valid so long as it is behind the current LSN. If it isn't, this
> > + * means that the next log record that includes this metadata could have a
> > + * smaller LSN. In turn, this means that the modification in the log would not
> > + * replay.
> > + */
> > +static inline bool
> > +xlog_valid_lsn(
> > +	struct xlog	*log,
> > +	xfs_lsn_t	lsn)
> > +{
> > +	int		cur_cycle;
> > +	int		cur_block;
> > +	bool		valid = true;
> > +
> > +	/*
> > +	 * First, sample the current lsn without locking to avoid added
> > +	 * contention from metadata I/O. The current cycle and block are updated
> > +	 * (in xlog_state_switch_iclogs()) and read here in a particular order
> > +	 * to avoid false negatives (e.g., thinking the metadata LSN is valid
> > +	 * when it is not).
> > +	 *
> > +	 * The current block is always rewound before the cycle is bumped in
> > +	 * xlog_state_switch_iclogs() to ensure the current LSN is never seen in
> > +	 * a transiently forward state. Instead, we can see the LSN in a
> > +	 * transiently behind state if we happen to race with a cycle wrap.
> > +	 */
> > +	cur_cycle = ACCESS_ONCE(log->l_curr_cycle);
> > +	smp_rmb();
> > +	cur_block = ACCESS_ONCE(log->l_curr_block);
> 
> And we make sure the read of the block cannot be reordered to before
> the l_curr_cycle. Looks ok to me.
> 
> I'm going to commit this as is because I don't think the memset()s
> above actuallly change anything on disk. I can always redo the
> commit if this is in error...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
