Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8571F7F5E
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 09:21:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75F7D304032
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 07:21:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id u7l1vYDpeuhtmU7U (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 07:21:04 -0700 (PDT)
Date: Tue, 22 Sep 2015 10:21:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC v2 2/2] xfs: validate metadata LSNs against log on v5
	superblocks
Message-ID: <20150922142100.GB46026@bfoster.bfoster>
References: <1441997635-36644-1-git-send-email-bfoster@redhat.com>
	<1441997635-36644-3-git-send-email-bfoster@redhat.com>
	<20150922080725.GC3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150922080725.GC3902@dastard>
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

On Tue, Sep 22, 2015 at 06:07:25PM +1000, Dave Chinner wrote:
> On Fri, Sep 11, 2015 at 02:53:55PM -0400, Brian Foster wrote:
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
> > mount time and notify the user and fail the mount if it is invalid.
> > From that point on, simply warn the user if an invalid metadata LSN is
> > detected from the various metadata I/O verifiers. A new xfs_mount flag
> > is added to guarantee that a warning fires at least once for each
> > affected filesystem mount. From that point forward, further instances of
> > the problem are rate limited to a once per 24 hour period.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c          |  9 +++++--
> >  fs/xfs/libxfs/xfs_attr_leaf.c      |  2 ++
> >  fs/xfs/libxfs/xfs_btree.c          | 14 +++++++++--
> >  fs/xfs/libxfs/xfs_da_btree.c       |  3 +++
> >  fs/xfs/libxfs/xfs_dir2_block.c     |  1 +
> >  fs/xfs/libxfs/xfs_dir2_data.c      |  1 +
> >  fs/xfs/libxfs/xfs_dir2_leaf.c      |  1 +
> >  fs/xfs/libxfs/xfs_dir2_node.c      |  1 +
> >  fs/xfs/libxfs/xfs_ialloc.c         |  8 +++++--
> >  fs/xfs/libxfs/xfs_sb.c             |  8 +++++++
> >  fs/xfs/libxfs/xfs_symlink_remote.c |  3 +++
> >  fs/xfs/xfs_log.c                   |  1 -
> >  fs/xfs/xfs_log_priv.h              | 24 +++++++++++++++++++
> >  fs/xfs/xfs_log_recover.c           | 15 +++++++++++-
> >  fs/xfs/xfs_mount.c                 | 49 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_mount.h                 |  3 +++
> >  16 files changed, 135 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index ffad7f2..cb26016 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -482,6 +482,8 @@ xfs_agfl_verify(
> >  		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
> >  			return false;
> >  	}
> > +
> > +	xfs_detect_invalid_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn));
> >  	return true;
> 
> 	xfs_log_check_lsn(mp, <lsn>);
> 

Ok.

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
> > +	int		cycle = CYCLE_LSN(lsn);
> > +	int		block = BLOCK_LSN(lsn);
> > +	bool		valid = true;
> > +
> > +	spin_lock(&log->l_icloglock);
> > +	if ((cycle > log->l_curr_cycle) ||
> > +	    (cycle == log->l_curr_cycle && block > log->l_curr_block))
> > +		valid = false;
> > +	spin_unlock(&log->l_icloglock);
> > +
> > +	return valid;
> > +}
> 
> We do not want to take the l_icloglock in metadata IO
> context. It's a global fs lock, and it's a hot lock, too, so we
> do not want to be taking this during every metadata IO completion.
> 
> I think, at minimum, we need to sample the current values and do an
> unlocked check, then if the result is suspect we need to do an
> accurate locked check. This means that we will almost never take the
> l_icloglock here. e.g:
> 
> {
> 	int cycle = ACCESS_ONCE(log->l_curr_cycle);
> 	int block = ACCESS_ONCE(log->l_curr_block);
> 
> 	if (CYCLE_LSN(lsn) > cycle ||
> 	    (CYCLE_LSN(lsn) == cycle && BLOCK_LSN(lsn) > block)) {
> 		/* suspect, take icloglock to check again */
> 		bool valid = true;
> 
> 		....
> 		return valid;
> 	}
> 	return true;
> }
> 

Good point. In this case, I may just lift the lock out of the helper and
allow this to be the responsibility of the caller, but I'll see how it
looks.

> 
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -41,6 +41,7 @@
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> >  #include "xfs_sysfs.h"
> > +#include "xfs_log_priv.h"
> >  
> >  
> >  static DEFINE_MUTEX(xfs_uuid_table_mutex);
> > @@ -1301,3 +1302,51 @@ xfs_dev_is_read_only(
> >  	}
> >  	return 0;
> >  }
> > +
> > +/*
> > + * Verify that an LSN stamped into a piece of metadata is valid. This is
> > + * intended for use in read verifiers on v5 superblocks.
> > + */
> > +void
> > +xfs_detect_invalid_lsn(
> > +	struct xfs_mount	*mp,
> > +	xfs_lsn_t		lsn)
> > +{
> 
> This shoul dbe called xfs_log_check_lsn() and be located in
> xfs_log.c.
> 

Ok.

> > +	struct xlog		*log = mp->m_log;
> > +	int			cycle = CYCLE_LSN(lsn);
> > +	int			block = BLOCK_LSN(lsn);
> > +	const char 		*fmt;
> > +
> > +	/*
> > +	 * 'norecovery' mode skips mount-time log processing and unconditionally
> > +	 * resets the LSN.
> > +	 */
> > +	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
> > +		return;
> > +
> > +	if (xlog_valid_lsn(mp->m_log, lsn))
> > +		return;
> > +
> > +	/*
> > +	 * Warn at least once for each filesystem susceptible to this problem
> > +	 * and once per day thereafter.
> > +	 *
> > +	 * XXX: Specify the minimum xfs_repair version required to resolve?
> > +	 * Older versions will silently reintroduce the problem.
> > +	 *
> > +	 * We should eventually convert this condition into a hard error (via
> > +	 * verifier failure). Defer that behavior for a few release cycles or so
> > +	 * until the userspace fixes have had the opportunity to propogate
> > +	 * throughout the various distributions.
> > +	 */
> > +	fmt = "WARNING: Metadata has LSN (%d:%d) ahead of current LSN (%d:%d). "
> > +"This may result in filesystem failure. Please unmount and run xfs_repair to resolve.";
> > +	if (!mp->m_warned_bad_lsn) {
> > +		mp->m_warned_bad_lsn = true;
> > +		xfs_warn(mp, fmt, cycle, block, log->l_curr_cycle,
> > +			 log->l_curr_block);
> > +	} else {
> > +		xfs_warn_daily(mp, fmt, cycle, block, log->l_curr_cycle,
> > +			       log->l_curr_block);
> > +	}
> 
> That's really ugly. Rate limited prints should always occur at least
> once for each ratelimit key, and now i've seen this I can say the
> first patch needs rework.
> 

This is definitely more ugly than the shutdown approach. As mentioned,
I've been waffling back and forth on how to handle this condition. I had
already sent the shutdown version, so I figured I would put together
what I thought would be necessary to handle this with a warning for
comparison.

> that is, each xfs_warn_daily() caller needs it's own ratelimit key,
> rather than sharing the global ratelimit key that all other XFS
> messages share.
> 

What do you mean by a key? What is the purpose?

On further thought... I think I see what you mean. Each mount should
report in the ratelimited timeframe independently. Or in other words,
the rate limit of one mount should not affect message delivery on
another.

> e.g.:
> 	xfs_warn_daily(mp, mp->m_log->l_lsn_rlstate,
> "Corruption warning: Metadata has LSN (%d:%d) ahead of current LSN (%d:%d). "
> "Please unmount and run xfs_repair (>= v4.3) to resolve.".
> 			cycle, block, log->l_curr_cycle, log->l_curr_block);
> 
> But really, thinking on this further (the "corruption warning" bit)
> I'm starting to think we should just shut the filesystem down when
> we hit this and force the user to fix it immediately. if we don't,
> then who knows whether we are making things worse or not...
> 

I was originally thinking the shutdown might not be ideal because we
induce the very situation we're warning about (forcing a log recovery).
Since this verifies on metadata reads, however, we should in theory
avoid the problem before it could ever be introduced. My follow on
question to that was whether a shutdown is appropriate for something
that is somewhat minor and self-corrective..?

Given the ugliness of the multiple warnings, new mount flag, additional
complication of the ratelimit mechanism, etc., I might just go back to
the shutdown and call it a day. ;) I think the subtle point raised above
about calling this a corruption is a sufficient argument. While this
might be minor and self-correcting, it is still technically a corruption
of sorts and should be identified and repaired appropriately. Thanks for
the feedback.

Brian

> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -127,6 +127,7 @@ typedef struct xfs_mount {
> >  	int64_t			m_low_space[XFS_LOWSP_MAX];
> >  						/* low free space thresholds */
> >  	struct xfs_kobj		m_kobj;
> > +	bool			m_warned_bad_lsn;/* bad metadata lsn detected */
> 
> That's where I'd put the ratelimit key (or in the struct xlog).
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
