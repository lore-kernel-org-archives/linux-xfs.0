Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BADCC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 17:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CDBB60C49
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 17:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhJMRJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhJMRJv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Oct 2021 13:09:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B24A610E6;
        Wed, 13 Oct 2021 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634144868;
        bh=SEcZATXGsFJgbYaxmscGDWEMxkHf3/Ts/M9+4Mcp2iE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f5UxUhQ3M6srOycg/omfwsFnfpYIBfphc0TwQCDVLQWJ4bW+NT3C45cdkAF0hjqLf
         7K9R52e3jd5azySSMKl0cX27eIbVuqsRGLz5JXHgwovAleaKqkUbA5hlS4sREWzq3z
         z82VTQYBQ/wjOSAVHwd5KGxCjNCQopjhIXmGbXwx8nyh4P7qg2t7Qy31qcbgN3YSOT
         w5QAgR7fMlvAvKNMQo82i9JrbL8s1+Nm4IfgGZxwCl1kpyJCl6ngKmS3cDFClrbbfP
         4bmkPRf8TpVkG9glWmM2t3wzBfESucNryq4FJXakt87/4lno3kcjlVRrrFschp7Aaz
         HT7xY3l7YZz6A==
Date:   Wed, 13 Oct 2021 10:07:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 10/15] xfs: compute actual maximum btree height for
 critical reservation calculation
Message-ID: <20211013170747.GX24307@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408160882.4151249.14701173486144926020.stgit@magnolia>
 <20211013054939.GC2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013054939.GC2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 04:49:39PM +1100, Dave Chinner wrote:
> On Tue, Oct 12, 2021 at 04:33:28PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Compute the actual maximum btree height when deciding if per-AG block
> > reservation is critically low.  This only affects the sanity check
> > condition, since we /generally/ will trigger on the 10% threshold.
> > This is a long-winded way of saying that we're removing one more
> > usage of XFS_BTREE_MAXLEVELS.
> 
> And replacing it with a branchy dynamic calculation that has a
> static, unchanging result. :(
> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.c |   18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> > index 2aa2b3484c28..d34d4614f175 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.c
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> > @@ -60,6 +60,20 @@
> >   * to use the reservation system should update ask/used in xfs_ag_resv_init.
> >   */
> >  
> > +/* Compute maximum possible height for per-AG btree types for this fs. */
> > +static unsigned int
> > +xfs_ag_btree_maxlevels(
> > +	struct xfs_mount	*mp)
> > +{
> > +	unsigned int		ret = mp->m_ag_maxlevels;
> > +
> > +	ret = max(ret, mp->m_bm_maxlevels[XFS_DATA_FORK]);
> > +	ret = max(ret, mp->m_bm_maxlevels[XFS_ATTR_FORK]);
> > +	ret = max(ret, M_IGEO(mp)->inobt_maxlevels);
> > +	ret = max(ret, mp->m_rmap_maxlevels);
> > +	return max(ret, mp->m_refc_maxlevels);
> > +}
> 
> Hmmmm. perhaps mp->m_ag_maxlevels should be renamed to
> mp->m_agbno_maxlevels and we pre-calculate mp->m_ag_maxlevels from

I prefer m_alloc_maxlevels for the first one, since "agbno" means "AG
block number" in my head.

As for the second, how about "m_agbtree_maxlevels" since we already use
'agbtree' to refer to per-AG btrees elsewhere?

Other than the naming, I agree with your suggestion.

--D

> the above function and just use the variable in the
> xfs_ag_resv_critical() check?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
