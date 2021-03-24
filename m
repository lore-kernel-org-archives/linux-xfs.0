Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04741C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 04:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A2E619EC
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 04:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhCXE5i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 00:57:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39445 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232776AbhCXE5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 00:57:12 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DAC77828C3C;
        Wed, 24 Mar 2021 15:57:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOvZq-0065bU-J6; Wed, 24 Mar 2021 15:57:06 +1100
Date:   Wed, 24 Mar 2021 15:57:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210324045706.GL63242@dread.disaster.area>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210323014417.GC63242@dread.disaster.area>
 <20210323040037.GI22100@magnolia>
 <20210323051907.GE63242@dread.disaster.area>
 <20210324020407.GO22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324020407.GO22100@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=EmXinTiM1Eh8SVoqwwoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
        a=fCgQI5UlmZDRPDxm0A3o:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 07:04:07PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 23, 2021 at 04:19:07PM +1100, Dave Chinner wrote:
> > On Mon, Mar 22, 2021 at 09:00:37PM -0700, Darrick J. Wong wrote:
> > > On Tue, Mar 23, 2021 at 12:44:17PM +1100, Dave Chinner wrote:
> > > > On Wed, Mar 10, 2021 at 07:06:13PM -0800, Darrick J. Wong wrote:
> > > > > +	/*
> > > > > +	 * Not a match for our passed in scan filter?  Put it back on the shelf
> > > > > +	 * and move on.
> > > > > +	 */
> > > > > +	spin_lock(&ip->i_flags_lock);
> > > > > +	if (!xfs_inode_matches_eofb(ip, eofb)) {
> > > > > +		ip->i_flags &= ~XFS_INACTIVATING;
> > > > > +		spin_unlock(&ip->i_flags_lock);
> > > > > +		return 0;
> > > > > +	}
> > > > > +	spin_unlock(&ip->i_flags_lock);
> > > > 
> > > > IDGI. What do EOF blocks have to do with running inode inactivation
> > > > on this inode?
> > > 
> > > This enables foreground threads that hit EDQUOT to look for inodes to
> > > inactivate in order to free up quota'd resources.
> > 
> > Not very obvious - better comment, please?
> 
> 	/*
> 	 * Foreground threads that have hit ENOSPC or EDQUOT are allowed
> 	 * to pass in a eofb structure to look for inodes to inactivate
> 	 * immediately to free some resources.  If this inode isn't a
> 	 * match, put it back on the shelf and move on.
> 	 */
> 
> Better?

Yes.

> > > > > +	/*
> > > > > +	 * Perform all on-disk metadata updates required to inactivate inodes.
> > > > > +	 * Since this can involve finobt updates, do it now before we lose the
> > > > > +	 * per-AG space reservations.
> > > > > +	 */
> > > > > +	xfs_inodegc_force(mp);
> > > > 
> > > > Should we stop background inactivation, because we can't make
> > > > modifications anymore and hence background inactication makes little
> > > > sense...
> > > 
> > > We don't actually stop background gc transactions or other internal
> > > updates on readonly filesystems
> > 
> > Yes we do - that's what xfs_blockgc_stop() higher up in this
> > function does. xfs_log_clean() further down in the function also
> > stops the background log work (that covers the log when idle)
> > because xfs_remount_ro() leaves the log clean.
> > 
> > THese all get restarted in xfs_remount_rw()....
> > 
> > > -- the ro part means only that we don't
> > > let /userspace/ change anything directly.  If you open a file readonly,
> > > unlink it, freeze the fs, and close the file, we'll still free it.
> > 
> > How do you unlink the file on a RO mount?
> 
> I got confused here.  If you open a file readonly on a rw mount, unlink
> it, remount the fs readonly, and close the file, we'll still free it.

Not even that way. :)

You can't remount-ro while there are open-but-unlinked files. See
sb->s_remove_count. It's incremented when drop_link() drops the link
count to zero in the unlink() syscall, then decremented when
__destroy_inode() is called during inode eviction when the final
reference goes away. Hence while we have open but unlinked inodes in
active use, that superblock counter is non-zero.

In sb_prepare_remount_readonly() we have:

	if (atomic_long_read(&sb->s_remove_count))
		return -EBUSY;

So a remount-ro will fail with -EBUSY while there are open but
unlinked files.

Except, of course, if you are doing an emergency remount-ro from
sysrq, in which case these open-but-unlinked checks are not done,
but when we are forcing the fs to be read-only this way, it's not
being done for correctness (i.e the system is about to be shot down)
so we don't really care...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
