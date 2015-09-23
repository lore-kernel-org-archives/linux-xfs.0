Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 676D27F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 08:18:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F130BAC005
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 06:18:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kcXs9STEyFMJHaqB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2015 06:18:33 -0700 (PDT)
Date: Wed, 23 Sep 2015 09:18:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 02/12] libxfs: track largest metadata LSN in use via
	verifiers
Message-ID: <20150923131831.GB37210@bfoster.bfoster>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-3-git-send-email-bfoster@redhat.com>
	<20150923034406.GR3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150923034406.GR3902@dastard>
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

On Wed, Sep 23, 2015 at 01:44:06PM +1000, Dave Chinner wrote:
> On Fri, Sep 11, 2015 at 02:55:32PM -0400, Brian Foster wrote:
> > The LSN validation helper is called in the I/O verifier codepath for
> > metadata that embed a last-modification LSN. While the codepath exists,
> > this is not used in userspace as in the kernel because the former
> > doesn't have an active log.
> > 
> > xfs_repair does need to check the validity of the LSN metadata with
> > respect to the on-disk log, however. Use the LSN validation mechanism to
> > track the largest LSN that has been seen. Export the value so repair can
> > use it once it has processed the entire filesystem. Note that the helper
> > continues to always return true to preserve existing behavior.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> ....
> > +xfs_lsn_t		libxfs_max_lsn = 0;
> > +pthread_mutex_t		libxfs_max_lsn_lock = PTHREAD_MUTEX_INITIALIZER;
> > +
> >  void
> >  xfs_detect_invalid_lsn(
> >  	struct xfs_mount	*mp,
> >  	xfs_lsn_t		lsn)
> >  {
> > +	int			cycle = CYCLE_LSN(lsn);
> > +	int			block = BLOCK_LSN(lsn);
> > +	int			max_cycle;
> > +	int			max_block;
> > +
> > +	if (lsn == NULLCOMMITLSN)
> > +		return;
> > +
> > +	pthread_mutex_lock(&libxfs_max_lsn_lock);
> > +
> > +	max_cycle = CYCLE_LSN(libxfs_max_lsn);
> > +	max_block = BLOCK_LSN(libxfs_max_lsn);
> > +
> > +	if ((cycle > max_cycle) ||
> > +	    (cycle == max_cycle && block > max_block))
> > +		libxfs_max_lsn = lsn;
> > +
> > +	pthread_mutex_unlock(&libxfs_max_lsn_lock);
> 
> This will have the same lock contention problems that the kernel
> code would have had - my repair scalablity tests regularly reach
> over 1GB/s of metadata being prefetched through tens of threads, so
> this is going have a significant impact on performance in those
> tests....
> 

Hmm, Ok. I initially didn't have locking here (by accident) but
reproduced some breakage for which the exact details escape me. I
suspect it was a test and set race.

I suppose we could try doing something like what we plan to do on the
kernel side in terms of a racy check followed by the locked check so the
lock contention goes away once we find the max lsn. The context here is
different, however, in that we're using a 64-bit LSN rather than
independently updated cycle and block fields. It could also take a while
to stabilize the max lsn depending on the fs. (There are some details on
the kernel side I'd like to get worked out first as well).

Perhaps we could try to make this smarter... in the case where either
the log has been zeroed or we've identified an LSN beyond the current
log state, we only really need to track the max cycle value since a log
format is imminent at that point. In the case where the fs is
consistent, we could seed the starting value with the current log lsn,
or track per-ag max LSNs without locking and compare them at at the end,
etc.

I'll have to think about this some more and see what's effective. I'd
also like to quantify the effect the current locking has on performance
if possible. Can you provide a brief description of your typical repair
test that you would expect this to hurt? E.g., a large fs, many AGs,
populated with fs_mark and repaired with many threads..? Any special
storage configuration? Thanks.

Brian

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
