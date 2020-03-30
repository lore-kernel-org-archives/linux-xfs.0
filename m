Return-Path: <SRS0=hGtO=5P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFC3C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 00:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7EC8206DB
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Mar 2020 00:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgC3AeD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:34:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37880 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727780AbgC3AeD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 20:34:03 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 149903A2893;
        Mon, 30 Mar 2020 11:33:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jIiNK-00067i-19; Mon, 30 Mar 2020 11:33:58 +1100
Date:   Mon, 30 Mar 2020 11:33:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: ratelimit inode flush on buffered write ENOSPC
Message-ID: <20200330003357.GX10776@dread.disaster.area>
References: <20200329172209.GA80283@magnolia>
 <20200329220802.GS10776@dread.disaster.area>
 <20200330001602.GB80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330001602.GB80283@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=lY6nYVmglF29bNcZh0kA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 29, 2020 at 05:16:02PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 30, 2020 at 09:08:02AM +1100, Dave Chinner wrote:
> > On Sun, Mar 29, 2020 at 10:22:09AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > A customer reported rcu stalls and softlockup warnings on a computer
> > > with many CPU cores and many many more IO threads trying to write to a
> > > filesystem that is totally out of space.  Subsequent analysis pointed to
> > > the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
> > > which causes a lot of wb_writeback_work to be queued.  The writeback
> > > worker spends so much time trying to wake the many many threads waiting
> > > for writeback completion that it trips the softlockup detector, and (in
> > > this case) the system automatically reboots.
> > > 
> > > In addition, they complain that the lengthy xfs_flush_inodes scan traps
> > > all of those threads in uninterruptible sleep, which hampers their
> > > ability to kill the program or do anything else to escape the situation.
> > > 
> > > If there's thousands of threads trying to write to files on a full
> > > filesystem, each of those threads will start separate copies of the
> > > inode flush scan.  This is kind of pointless since we only need one
> > > scan, so rate limit the inode flush.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_mount.h |    1 +
> > >  fs/xfs/xfs_super.c |   14 ++++++++++++++
> > >  2 files changed, 15 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index 88ab09ed29e7..50c43422fa17 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -167,6 +167,7 @@ typedef struct xfs_mount {
> > >  	struct xfs_kobj		m_error_meta_kobj;
> > >  	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
> > >  	struct xstats		m_stats;	/* per-fs stats */
> > > +	struct ratelimit_state	m_flush_inodes_ratelimit;
> > >  
> > >  	struct workqueue_struct *m_buf_workqueue;
> > >  	struct workqueue_struct	*m_unwritten_workqueue;
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 68fea439d974..abf06bf9c3f3 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -528,6 +528,9 @@ xfs_flush_inodes(
> > >  {
> > >  	struct super_block	*sb = mp->m_super;
> > >  
> > > +	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
> > > +		return;
> > > +
> > >  	if (down_read_trylock(&sb->s_umount)) {
> > >  		sync_inodes_sb(sb);
> > >  		up_read(&sb->s_umount);
> > > @@ -1366,6 +1369,17 @@ xfs_fc_fill_super(
> > >  	if (error)
> > >  		goto out_free_names;
> > >  
> > > +	/*
> > > +	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
> > > +	 * quarter of a second.  The magic numbers here were determined by
> > > +	 * observation neither to cause stalls in writeback when there are a
> > > +	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
> > > +	 * regressions.  YMMV.
> > > +	 */
> > > +	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
> > > +	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
> > > +			RATELIMIT_MSG_ON_RELEASE);
> > 
> > Urk.
> > 
> > RATELIMIT_MSG_ON_RELEASE prevents "callbacks suppressed"
> > messages when rate limiting was active and resets via __rate_limit().
> > However, in ratelimit_state_exit(), that flag -enables- printing
> > "callbacks suppressed" messages when rate limiting was active and is
> > reset.
> > 
> > Same flag, exact opposite behaviour...
> > 
> > The comment says it's behaviour is supposed to match that of
> > ratelimit_state_exit() (i.e. print message on ratelimit exit), so I
> > really can't tell if this is correct/intended usage or just API
> > abuse....
> 
> This flag (AFAICT) basically means "summarize skipped calls later",
> where later is when _exit is called.  It's very annoying that this
> printk thing is mixed in with what otherwise is a simple ratelimiting
> mechanism, since there isn't much to be gained by spamming dmesg every
> time a buffered write hits ENOSPC, and absolutely nothing to be gained
> by logging that at umount time (with comm being the umount process!)
> 
> Since there's no design documentation for how the ratelimiting system
> works, the best I can do is RTFS and do whatever magic gets the outcome
> I want (which is to set the flag and skip calling _exit.  Only one of
> the ratelimit state users calls ratelimit_state_exit, so it's apparently
> not required.

Yeah, that's pretty much where I got to with it - I wasn't at all
sure if there was something obvious I was missing or it was just
another piece of poorly written code...

> This all is poor engineering practice, but you /did/ suggest
> ratelimiting (on IRC) and I don't want to go reimplementing ratelimit.c
> either, and it /does/ fix the xfs_flush_inodes flooding problems.

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
