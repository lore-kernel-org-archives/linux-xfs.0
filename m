Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93E2C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 12:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B210E20739
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 12:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2xsmnpB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgGPMSU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 08:18:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29536 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbgGPMST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 08:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594901896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wzw7LgiEvM1jHEvHWTjdZUjP3XY5A/IfQxaFD9SxArA=;
        b=P2xsmnpBavzWVjvj/1vVY1D8SXcFmkSYriS2vrW9om/aZPZ51U6AN2Aa4c1qQ0gm+cqjEp
        2RX9Ju/+WQYJutgJCvyoHpFrQuOpIhwVj4UZsVQ1xnwmBr5SbZXYunQrBYaoJFTOME1ttg
        2kXd4ue4qNfw2dxdBZb5JkO+lgbm+I8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-1Yy0WVtUMomu-o1ZQzNoLA-1; Thu, 16 Jul 2020 08:18:14 -0400
X-MC-Unique: 1Yy0WVtUMomu-o1ZQzNoLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 840341009600;
        Thu, 16 Jul 2020 12:18:13 +0000 (UTC)
Received: from bfoster (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EC447848E;
        Thu, 16 Jul 2020 12:18:12 +0000 (UTC)
Date:   Thu, 16 Jul 2020 08:18:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix inode allocation block res calculation
 precedence
Message-ID: <20200716121811.GB31705@bfoster>
References: <20200715193310.22002-1-bfoster@redhat.com>
 <20200715222935.GI2005@dread.disaster.area>
 <20200716014759.GH3151642@magnolia>
 <20200716020209.GK2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716020209.GK2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 12:02:09PM +1000, Dave Chinner wrote:
> On Wed, Jul 15, 2020 at 06:47:59PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 16, 2020 at 08:29:35AM +1000, Dave Chinner wrote:
> > > On Wed, Jul 15, 2020 at 03:33:10PM -0400, Brian Foster wrote:
> > > > The block reservation calculation for inode allocation is supposed
> > > > to consist of the blocks required for the inode chunk plus
> > > > (maxlevels-1) of the inode btree multiplied by the number of inode
> > > > btrees in the fs (2 when finobt is enabled, 1 otherwise).
> > > > 
> > > > Instead, the macro returns (ialloc_blocks + 2) due to a precedence
> > > > error in the calculation logic. This leads to block reservation
> > > > overruns via generic/531 on small block filesystems with finobt
> > > > enabled. Add braces to fix the calculation and reserve the
> > > > appropriate number of blocks.
> > > > 
> > > > Fixes: 9d43b180af67 ("xfs: update inode allocation/free transaction reservations for finobt")
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_trans_space.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > > > index 88221c7a04cc..c6df01a2a158 100644
> > > > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > > > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > > > @@ -57,7 +57,7 @@
> > > >  	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
> > > >  #define	XFS_IALLOC_SPACE_RES(mp)	\
> > > >  	(M_IGEO(mp)->ialloc_blks + \
> > > > -	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
> > > > +	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> > > >  	  (M_IGEO(mp)->inobt_maxlevels - 1)))
> > > 
> > > Ugh. THese macros really need rewriting as static inline functions.
> > > This would not have happened if it were written as:
> > > 
> > > static inline int
> > > xfs_ialloc_space_res(struct xfs_mount *mp)
> > > {
> > > 	int	res = M_IGEO(mp)->ialloc_blks;
> > > 
> > > 	res += M_IGEO(mp)->inobt_maxlevels - 1;
> > > 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > > 		res += M_IGEO(mp)->inobt_maxlevels - 1;
> > > 	return res;
> > > }
> > > 
> > > Next question: why is this even a macro that is calculated on demand
> > > instead of a read-only constant held in inode geometry calculated
> > > at mount time? Then it doesn't even need to be an inline function
> > > and can just be rolled into xfs_ialloc_setup_geometry()....
> > 
> > Yeah, I hate those macros too.  Fixing all that sounds like a <cough>
> > cleanup series for someone, but in the meantime this is easy enough to
> > backport to stable kernels.
> 
> Well, I'm not suggesting that we have to fix all of them at once.
> Just converting this specific one to a IGEO variable is probably
> only 20 lines of code, which is still an "easy to backport" fix.
> 
> i.e. XFS_IALLOC_SPACE_RES() is used in just 7 places in the code,
> 4 of them are in that same header file, so it's a simple, standalone
> patch that fixes the bug by addressing the underlying cause of
> the problem (i.e. nasty macro!).
> 

I agree that the inline is nicer than the macro, but a transaction
reservation value seems misplaced to me in the IGEO. Perhaps having
something analogous to struct xfs_trans_resv might be more appropriate.

Regardless, I agree with Darrick on the backporting situation. The
original patch needs to be backportable to however many upstream stable
releases back to v3.16 and similarly for distro kernels. Either patch
might not be complex overall, but for somebody who might be processing
hundreds of backports across various subsystems refactoring things as
such in the same patch is clearly not equivalent to a one line change to
an otherwise unchanged line since the original commit. I'll post a patch
on top of this one to rework into an inline if people view that as
preferable to the macro.

Brian

> Historically speaking , we have cleaned up stuff like this to fix
> the bug, not done a one liner and then left fixing the root cause to
> some larger chunk of future work. The "one-liner" approach is
> largely a recent invention. I look at this sort of thing as being
> similar to cleaning up typedefs: we remove typedefs as we change
> surrounding code, thereby slowly remove them over time. We could
> just remove them all as one big patchset, but we don't do that
> because of all the outstanding work it would cause conflicts in.
> 
> Perhaps we've lost sight of the fact that doing things in little
> chunks on demand actually results in a lot of good cleanup change
> over time. We really don't have to do cleanups as one huge chunk of
> work all at once....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

