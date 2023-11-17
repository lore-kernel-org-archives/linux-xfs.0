Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D43CC54FB9
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Nov 2023 22:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjKQWTm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Nov 2023 17:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjKQWTl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2023 17:19:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F9DB8
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2023 14:19:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9106EC433C8;
        Fri, 17 Nov 2023 22:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700259577;
        bh=jAGjw9mb66OQ2d28yda+DnddMWeuZ5oGuiwJ1auDhHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cNvXn8zbtyfG0HIutW9nUvnvd3ucpyKXGbmjQIrREAY8j9dgGALNCFMlU8zWlJUkv
         WHStPAbT4FOI5j6+G5KboFa3flktyOo7n32NqbJVK+VyLwtCIVnpv7acY/gpsVhNkd
         1Dbn5S3spwRVLxU1dbcLm+W3zFXC1hWhkXSJHIyg7myzi1rcSswRQkwSnUnCONP68k
         tUQ7WcF0E/Eim9lX/ohKVlR6CRJBcxwM38Usifc1/CnmPDJOV/Me92yz4IIgclfhRO
         FqcMmFtfjmeNEXap734lfGRMuB/p8cIizJ0ayCtN3kEG8depaof3uC4iiNAoMYwKyH
         Y/GXT2Gp8rODw==
Date:   Fri, 17 Nov 2023 14:19:36 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 1/2] xfs: inode recovery does not validate the recovered
 inode
Message-ID: <20231117221936.GB36190@frogsfrogsfrogs>
References: <20231110044500.718022-1-david@fromorbit.com>
 <20231110044500.718022-2-david@fromorbit.com>
 <20231110192752.GJ1205143@frogsfrogsfrogs>
 <ZU6VSymhrhgJUS8o@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZU6VSymhrhgJUS8o@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 11, 2023 at 07:40:43AM +1100, Dave Chinner wrote:
> On Fri, Nov 10, 2023 at 11:27:52AM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 10, 2023 at 03:33:13PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Discovered when trying to track down a weird recovery corruption
> > > issue that wasn't detected at recovery time.
> > > 
> > > The specific corruption was a zero extent count field when big
> > > extent counts are in use, and it turns out the dinode verifier
> > > doesn't detect that specific corruption case, either. So fix it too.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
> > >  fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
> > >  2 files changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > > index a35781577cad..0f970a0b3382 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > > @@ -508,6 +508,9 @@ xfs_dinode_verify(
> > >  	if (mode && nextents + naextents > nblocks)
> > >  		return __this_address;
> > >  
> > > +	if (nextents + naextents == 0 && nblocks != 0)
> > > +		return __this_address;
> > > +
> > >  	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
> > >  		return __this_address;
> > >  
> > > diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> > > index 6b09e2bf2d74..f4c31c2b60d5 100644
> > > --- a/fs/xfs/xfs_inode_item_recover.c
> > > +++ b/fs/xfs/xfs_inode_item_recover.c
> > > @@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
> > >  	struct xfs_log_dinode		*ldip;
> > >  	uint				isize;
> > >  	int				need_free = 0;
> > > +	xfs_failaddr_t			fa;
> > >  
> > >  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> > >  		in_f = item->ri_buf[0].i_addr;
> > > @@ -529,8 +530,19 @@ xlog_recover_inode_commit_pass2(
> > >  	    (dip->di_mode != 0))
> > >  		error = xfs_recover_inode_owner_change(mp, dip, in_f,
> > >  						       buffer_list);
> > > -	/* re-generate the checksum. */
> > > +	/* re-generate the checksum and validate the recovered inode. */
> > >  	xfs_dinode_calc_crc(log->l_mp, dip);
> > > +	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
> > > +	if (fa) {
> > 
> > Does xlog_recover_dquot_commit_pass2 need to call xfs_dquot_verify as
> > well?
> 
> Maybe - I haven't looked closely at that, and it depends what the
> dquot buffer verifier does. If it's similar to the inode cluster
> buffer verifier (i.e. only checks for dquots, doesn't verify the
> dquots) then it should do the same thing. I don't have time to do
> this right now because I'm OOO for the next week, so maybe you could
> check this and send a patch for it?

I tossed on a patch to do this and after a couple of days of generic/388
and generic/475 spinning I haven't noticed any failures.

--D

> > This patch looks good though,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Thanks!
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
