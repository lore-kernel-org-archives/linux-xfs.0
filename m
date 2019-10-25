Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D651CA9EBD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 20:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B8E221872
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 20:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfJYUyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 16:54:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44840 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726128AbfJYUyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 16:54:09 -0400
Received: from dread.disaster.area (pa49-181-161-154.pa.nsw.optusnet.com.au [49.181.161.154])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C576143E838;
        Sat, 26 Oct 2019 07:54:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iO6at-0006CD-Uv; Sat, 26 Oct 2019 07:53:59 +1100
Date:   Sat, 26 Oct 2019 07:53:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 6/7] xfs: clean up setting m_readio_* / m_writeio_*
Message-ID: <20191025205359.GG4614@dread.disaster.area>
References: <20191025174026.31878-1-hch@lst.de>
 <20191025174026.31878-7-hch@lst.de>
 <258d888c-e359-c264-33c3-910ebbd37bac@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <258d888c-e359-c264-33c3-910ebbd37bac@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=l3vQdJ1SkhDHY1nke8Lmag==:117 a=l3vQdJ1SkhDHY1nke8Lmag==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=eXwvqyvaJv54byhKWIYA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 02:18:02PM -0500, Eric Sandeen wrote:
> On 10/25/19 12:40 PM, Christoph Hellwig wrote:
> > Fill in the default _log values in xfs_parseargs similar to other
> > defaults, and open code the updates based on the on-disk superblock
> > in xfs_mountfs now that they are completely trivial.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_mount.c | 36 +++++-------------------------------
> >  fs/xfs/xfs_super.c |  5 +++++
> >  2 files changed, 10 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 9800401a7d6f..bae53fdd5d51 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -425,35 +425,6 @@ xfs_update_alignment(xfs_mount_t *mp)
> >  	return 0;
> >  }
> >  
> > -/*
> > - * Set the default minimum read and write sizes unless
> > - * already specified in a mount option.
> > - * We use smaller I/O sizes when the file system
> > - * is being used for NFS service (wsync mount option).
> > - */
> > -STATIC void
> > -xfs_set_rw_sizes(xfs_mount_t *mp)
> > -{
> > -	xfs_sb_t	*sbp = &(mp->m_sb);
> > -	int		writeio_log;
> > -
> > -	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
> > -		if (mp->m_flags & XFS_MOUNT_WSYNC)
> > -			writeio_log = XFS_WRITEIO_LOG_WSYNC;
> > -		else
> > -			writeio_log = XFS_WRITEIO_LOG_LARGE;
> > -	} else {
> > -		writeio_log = mp->m_writeio_log;
> > -	}
> > -
> > -	if (sbp->sb_blocklog > writeio_log) {
> > -		mp->m_writeio_log = sbp->sb_blocklog;
> > -	} else {
> > -		mp->m_writeio_log = writeio_log;
> > -	}
> > -	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
> > -}
> > -
> >  /*
> >   * precalculate the low space thresholds for dynamic speculative preallocation.
> >   */
> > @@ -718,9 +689,12 @@ xfs_mountfs(
> >  		goto out_remove_errortag;
> >  
> >  	/*
> > -	 * Set the minimum read and write sizes
> > +	 * Update the preferred write size based on the information from the
> > +	 * on-disk superblock.
> >  	 */
> > -	xfs_set_rw_sizes(mp);
> > +	mp->m_writeio_log =
> > +		max_t(uint32_t, mp->m_sb.sb_blocklog, mp->m_writeio_log);
> > +	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - mp->m_sb.sb_blocklog);
> >  
> >  	/* set the low space thresholds for dynamic preallocation */
> >  	xfs_set_low_space_thresholds(mp);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 1467f4bebc41..83dbfcc5a02d 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -405,6 +405,11 @@ xfs_parseargs(
> >  				XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
> >  			return -EINVAL;
> >  		}
> > +	} else {
> > +		if (mp->m_flags & XFS_MOUNT_WSYNC)
> > +			mp->m_writeio_log = XFS_WRITEIO_LOG_WSYNC;
> > +		else
> > +			mp->m_writeio_log = XFS_WRITEIO_LOG_LARGE;
> >  	}
> 
> Ok let's see, by here, if Opt_allocsize was specified, we set
> mp->m_writeio_log to the specified value, else if Opt_wsync was set, we 
> set m_writeio_log to XFS_WRITEIO_LOG_WSYNC (14), otherwise we default to
> XFS_WRITEIO_LOG_LARGE (16).  So that's it for parseargs.
> 
> AFAICT we can't escape parseargs w/ writeio_log less than PAGE_SHIFT
> (i.e. page size).

We can - 64k page size means XFS_WRITEIO_LOG_WSYNC is less than
PAGE_SHIFT, so it can escape here.

> Then in xfs_mountfs, you have it reset to the max of sb_blocklog and
> m_writeio_log.  i.e. it gets resized iff sb_blocklog is greater than
> the current m_writeio_log, which has a minimum of page size.
> 
> IOWS, it only gets a new value in mountfs if block size is > page size.

Which will never be true on 64k page size machines, but that's not
what this code does, anyway. It will rewrite m_writeio_log if the
block size is larger than the m_writeio_log value, so it preserves
the existing behaviour of setting the m_writeio_log value to a
minimum of one filesystem block....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
