Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3FFC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F9161A1D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 04:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhCYEVE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhCYEUu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 00:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96D861A14;
        Thu, 25 Mar 2021 04:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616646048;
        bh=cyQjfLDC5CPrAwKYnmDoVAIgkZDsEBsfY7lu3xo97dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXsroXieVU0lNyXPYTTASu0778DRfWURlRZt0eMTlceo0KREWSrCppc9+ajdymrKM
         QMYKGNG7aj1hSs5sk41FBl1dv2tJDwp7ueCv9uCcdbWQm+3AGcgtTJzPgXiyXdIcAs
         bY79v68e7VsQMr4un0PRtkICV3GM5Tiq+biTBpactU5PASZIQTRsgssP3jvdsFg9et
         QAIYdLb0SZ37p9n4lPaJaDf6nrsmsDJ9R0/qqq2T/FSUmZ8Azd+W1/tiVlRo4h4Pto
         vrqS1j7D0sSYecdYQ3jCNVOUHEuNoK1sl8futQc32zJfeu+dIhRJZUKb35DClX02yr
         ngr1QZAQdYYkA==
Date:   Wed, 24 Mar 2021 21:20:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210325042044.GB4090233@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210323014417.GC63242@dread.disaster.area>
 <20210323040037.GI22100@magnolia>
 <20210323051907.GE63242@dread.disaster.area>
 <20210324020407.GO22100@magnolia>
 <20210324045706.GL63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324045706.GL63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:57:06PM +1100, Dave Chinner wrote:
> On Tue, Mar 23, 2021 at 07:04:07PM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 23, 2021 at 04:19:07PM +1100, Dave Chinner wrote:
> > > On Mon, Mar 22, 2021 at 09:00:37PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Mar 23, 2021 at 12:44:17PM +1100, Dave Chinner wrote:
> > > > > On Wed, Mar 10, 2021 at 07:06:13PM -0800, Darrick J. Wong wrote:
> > > > > > +	/*
> > > > > > +	 * Not a match for our passed in scan filter?  Put it back on the shelf
> > > > > > +	 * and move on.
> > > > > > +	 */
> > > > > > +	spin_lock(&ip->i_flags_lock);
> > > > > > +	if (!xfs_inode_matches_eofb(ip, eofb)) {
> > > > > > +		ip->i_flags &= ~XFS_INACTIVATING;
> > > > > > +		spin_unlock(&ip->i_flags_lock);
> > > > > > +		return 0;
> > > > > > +	}
> > > > > > +	spin_unlock(&ip->i_flags_lock);
> > > > > 
> > > > > IDGI. What do EOF blocks have to do with running inode inactivation
> > > > > on this inode?
> > > > 
> > > > This enables foreground threads that hit EDQUOT to look for inodes to
> > > > inactivate in order to free up quota'd resources.
> > > 
> > > Not very obvious - better comment, please?
> > 
> > 	/*
> > 	 * Foreground threads that have hit ENOSPC or EDQUOT are allowed
> > 	 * to pass in a eofb structure to look for inodes to inactivate
> > 	 * immediately to free some resources.  If this inode isn't a
> > 	 * match, put it back on the shelf and move on.
> > 	 */
> > 
> > Better?
> 
> Yes.
> 
> > > > > > +	/*
> > > > > > +	 * Perform all on-disk metadata updates required to inactivate inodes.
> > > > > > +	 * Since this can involve finobt updates, do it now before we lose the
> > > > > > +	 * per-AG space reservations.
> > > > > > +	 */
> > > > > > +	xfs_inodegc_force(mp);
> > > > > 
> > > > > Should we stop background inactivation, because we can't make
> > > > > modifications anymore and hence background inactication makes little
> > > > > sense...

Ahhh, now I remember why the blockgc and inodegc workers call
sb_start_write before running any transactions.  We don't want the
threads to stall on transaction allocation when the fs is at FREEZE_FS,
which means that we have to cancel the work before we get there.  That
means it's too late to cancel the work items in xfs_fs_freeze.

We can't cancel the work items from a ->freeze_super handler before
calling freeze_super(), because we haven't taken any locks yet, and
we're still unfrozen.

For blockgc I solved this problem by making the worker get FREEZE_WRITE
protection so that we can't freeze the fs until the work is done.  Then
we don't have to care that much about ensuring that the worker threads
cannot run while the fs is frozen.  But that's a bit sloppy, since
they're still consuming CPU time.

I could solve this problem by observing that freeze_super calls
sync_filesystem when the fs is in FREEZE_PAGEFAULTS and is about to move
to FREEZE_FS, but that seems ugly and hacky.

> > > > 
> > > > We don't actually stop background gc transactions or other internal
> > > > updates on readonly filesystems
> > > 
> > > Yes we do - that's what xfs_blockgc_stop() higher up in this
> > > function does. xfs_log_clean() further down in the function also
> > > stops the background log work (that covers the log when idle)
> > > because xfs_remount_ro() leaves the log clean.
> > > 
> > > THese all get restarted in xfs_remount_rw()....
> > > 
> > > > -- the ro part means only that we don't
> > > > let /userspace/ change anything directly.  If you open a file readonly,
> > > > unlink it, freeze the fs, and close the file, we'll still free it.
> > > 
> > > How do you unlink the file on a RO mount?
> > 
> > I got confused here.  If you open a file readonly on a rw mount, unlink
> > it, remount the fs readonly, and close the file, we'll still free it.
> 
> Not even that way. :)
> 
> You can't remount-ro while there are open-but-unlinked files. See
> sb->s_remove_count. It's incremented when drop_link() drops the link
> count to zero in the unlink() syscall, then decremented when
> __destroy_inode() is called during inode eviction when the final
> reference goes away. Hence while we have open but unlinked inodes in
> active use, that superblock counter is non-zero.
> 
> In sb_prepare_remount_readonly() we have:
> 
> 	if (atomic_long_read(&sb->s_remove_count))
> 		return -EBUSY;
> 
> So a remount-ro will fail with -EBUSY while there are open but
> unlinked files.

Ah, ok.

> Except, of course, if you are doing an emergency remount-ro from
> sysrq, in which case these open-but-unlinked checks are not done,
> but when we are forcing the fs to be read-only this way, it's not
> being done for correctness (i.e the system is about to be shot down)
> so we don't really care...

Well yes, most bets are off during emergency ro-remounts. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
