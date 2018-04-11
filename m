Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:39487 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbeDKIl6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Apr 2018 04:41:58 -0400
Received: by mail-pl0-f66.google.com with SMTP id e7-v6so875420plt.6
        for <linux-xfs@vger.kernel.org>; Wed, 11 Apr 2018 01:41:58 -0700 (PDT)
Date: Wed, 11 Apr 2018 10:41:51 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Force log to disk before reading the AGF during a fstrim
Message-ID: <20180411084151.kfe2zmen6vgh6gxn@odin.usersys.redhat.com>
References: <20180410150814.22610-1-cmaiolino@redhat.com>
 <20180410151834.GT7500@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410151834.GT7500@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 10, 2018 at 08:18:34AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 10, 2018 at 05:08:14PM +0200, Carlos Maiolino wrote:
> > Forcing the log to disk after reading the agf is wrong, we might be
> > calling xfs_log_force with XFS_LOG_SYNC with a metadata lock held.
> > 
> > This can cause a deadlock when racing a fstrim with a filesystem
> > shutdown.
> > 
> > The deadlock has been identified due a miscalculation bug in device-mapper
> > dm-thin, which returns lack of space to its users earlier than the device itself
> > really runs out of space, changing the device-mapper volume into an error state.
> > 
> > The problem happened while filling the filesystem with a single file,
> > triggering the bug in device-mapper, consequently causing an IO error
> > and shutting down the filesystem.
> > 
> > If such file is removed, and fstrim executed before the XFS finishes the
> > shut down process, the fstrim process will end up holding the buffer
> > lock, and going to sleep on the cil wait queue.
> > 
> > At this point, the shut down process will try to wake up all the threads
> > waiting on the cil wait queue, but for this, it will try to hold the
> > same buffer log already held my the fstrim, locking up the filesystem.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > Kudos to Dave who spotted it just after me telling him the process was
> > deadlocked on a buffer lock
> 
> Uh... got an xfstest to reproduce this? :)
> 

Not yet, I'm actually relying on the DM bug to hit this problem :P

I think it can be fabricated without relying using xfstests though.

One thing I forgot to mention, is I could only reproduce it using a very
low-latency device (in my test cases, using a ramdisk), I couldn't trigger it
using my regular spindles or SSD, I believe the higher latency 'helps' the
buffer lock to be released before the fstrim actually tries to lock it.

I don't remember though of any xfstests using ramdisks, so, is it ok if I try to
write a xfstest using a ramdisk device?

Cheers

> Code looks reasonable,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> 
> >  fs/xfs/xfs_discard.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > index b2cde5426182..7b68e6c9a474 100644
> > --- a/fs/xfs/xfs_discard.c
> > +++ b/fs/xfs/xfs_discard.c
> > @@ -50,19 +50,19 @@ xfs_trim_extents(
> >  
> >  	pag = xfs_perag_get(mp, agno);
> >  
> > -	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> > -	if (error || !agbp)
> > -		goto out_put_perag;
> > -
> > -	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
> > -
> >  	/*
> >  	 * Force out the log.  This means any transactions that might have freed
> > -	 * space before we took the AGF buffer lock are now on disk, and the
> > +	 * space before we take the AGF buffer lock are now on disk, and the
> >  	 * volatile disk cache is flushed.
> >  	 */
> >  	xfs_log_force(mp, XFS_LOG_SYNC);
> >  
> > +	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> > +	if (error || !agbp)
> > +		goto out_put_perag;
> > +
> > +	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
> > +
> >  	/*
> >  	 * Look up the longest btree in the AGF and start with it.
> >  	 */
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
