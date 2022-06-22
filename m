Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE96AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 23:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiFVXme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFVXmd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 19:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD37D427E5;
        Wed, 22 Jun 2022 16:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5003061BBA;
        Wed, 22 Jun 2022 23:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8AEC341C5;
        Wed, 22 Jun 2022 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655941351;
        bh=Q27lkrJvEz/mI+pvfPY/VN13BCriVcz3Js9zn2eyutI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCPQaeTL57XAd9GGBEI55l7fuiYVQUkvXShlSvh5xQ79PXZNDkRMDY/Gg7gjG/A0S
         RRNC+WYJT0hdePU03hZwlwmw2H8BGL5YKahxxX06nNMC/yZ10vLHDd6n3gqv1lNdbc
         lsDWZ6DcZHu+14gilFNR+UrsjlljBd2nBqUp9IPP/g1ckpXLiprLsC/7F1mqgtalAo
         g3Ybrphl9OEK8i4q++iom6QdgE9lOG1i0JS90zKGbhCE8JyJ2sockTtvsuE0XYnzVV
         RivmYgPjCG0cIH3yisps73fn/6y0616wHXtK+4Uo7wyd3HZsur4Luq1DIfJjJCQt56
         psrm5veJd6g9w==
Date:   Wed, 22 Jun 2022 16:42:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5.10 CANDIDATE 09/11] xfs: only bother with
 sync_filesystem during readonly remount
Message-ID: <YrOo5wW6CtkK6p8C@magnolia>
References: <20220617100641.1653164-1-amir73il@gmail.com>
 <20220617100641.1653164-10-amir73il@gmail.com>
 <YrNFb9999OY/8JDZ@magnolia>
 <CAOQ4uxi1th2XJ7Ss8avKjrR=k1wMw524+2+ahyafBhSAUsS7dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi1th2XJ7Ss8avKjrR=k1wMw524+2+ahyafBhSAUsS7dQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 07:54:33PM +0300, Amir Goldstein wrote:
> On Wed, Jun 22, 2022 at 7:38 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Fri, Jun 17, 2022 at 01:06:39PM +0300, Amir Goldstein wrote:
> > > From: "Darrick J. Wong" <djwong@kernel.org>
> > >
> > > commit b97cca3ba9098522e5a1c3388764ead42640c1a5 upstream.
> > >
> > > In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
> > > into xfs_fs_remount.  The only time that we ever need to push dirty file
> > > data or metadata to disk for a remount is if we're remounting the
> > > filesystem read only, so this really could be moved to xfs_remount_ro.
> > >
> > > Once we've moved the call site, actually check the return value from
> > > sync_filesystem.
> 
> This part is not really relevant for this backport, do you want me to
> emphasise that?

Not relevant?  Making sync_fs return error codes to callers was the
entire reason for creating this series...

> > >
> > > Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/xfs/xfs_super.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 6323974d6b3e..dd0439ae6732 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -1716,6 +1716,11 @@ xfs_remount_ro(
> > >       };
> > >       int                     error;
> > >
> > > +     /* Flush all the dirty data to disk. */
> > > +     error = sync_filesystem(mp->m_super);
> >
> > Looking at 5.10.124's fsync.c and xfs_super.c:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/sync.c?h=v5.10.124#n31
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/xfs/xfs_super.c?h=v5.10.124#n755
> >
> > I think this kernel needs the patch(es) that make __sync_filesystem return
> > the errors passed back by ->sync_fs, and I think also the patch that
> > makes xfs_fs_sync_fs return errors encountered by xfs_log_force, right?
> 
> It wasn't my intention to fix syncfs() does not return errors in 5.10.
> It has always been that way and IIRC, the relevant patches did not
> apply cleanly.

...because right now userspace can call syncfs() on a filesystem that
dies in the process, and the VFS eats the EIO and returns 0 to
userspace.  Yes, that's the historical behavior fo 5.10, but that's a
serious problem that needs addressing.  Eliding the sync_filesystem call
during a rw remount is not itself all that exciting.

> THIS patch however, fixes something else, not only the return of the error
> to its caller, so I thought it was worth backporting.

Assuming "something else" means "moving the sync_filesystem callsite" --
that was a secondary piece that I did to get the requisite RVB tag under
time pressure after 5.17-rc6 dropped.

> If you think otherwise, I'll drop it.

On the contrary, I think the ->sync_fs fixes *also* need backporting.
It should be as simple as patching __sync_filesystem:

static int __sync_filesystem(struct super_block *sb, int wait)
{
	if (wait)
		sync_inodes_sb(sb);
	else
		writeback_inodes_sb(sb, WB_REASON_SYNC);

	if (sb->s_op->sync_fs) {
		int ret = sb->s_op->sync_fs(sb, wait);
		if (ret)
			return ret;
	}
	return __sync_blockdev(sb->s_bdev, wait);
}

Granted, that can be a part of the next batch.  If you plan to pick up
the vfs sync_fs changes then I guess this one's ok for inclusion now.

--D

> 
> Thanks,
> Amir.
