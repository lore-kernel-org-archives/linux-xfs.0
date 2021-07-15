Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973A4C12002
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 01:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A06F61005
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 01:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhGOBPl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 21:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhGOBPk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 21:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940156128C;
        Thu, 15 Jul 2021 01:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626311568;
        bh=0RLm80IHIT15SzsQNZ5vGNlS2lPLoctbjkaKpgd0BRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BTooOtd4B50zuz/Ok1Kq8HmhrhEG3wXla/5u14F5vEjSNZN+p7K3GlhNy0SJpEmp2
         g1Rs2Pg6/GRR9zKM3JffFxpxbozQBpqIC43bzRYPxJWwoLOVjMLnsds4lYmTLKlURM
         nNheiVPcybRxhtUMI8tSZ7+NIsIHd62NEIxxOf21W059D+vLfZ4gx4hZk5IBzuEi3T
         NV10yo25NTIIYjc/zkhbZBiV679kzjVe/sGBXZltkLwhgV4JuePbJ7P4zAYKkBQT2l
         17zDeVd0SMW4piYz87HFI/NFFNBZJufqrgA1ovzBi0hRGJCBo84JX2aVtYo83ftrCr
         3EWWpK1gK/zeQ==
Date:   Wed, 14 Jul 2021 18:12:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: detect misaligned rtinherit directory extent size
 hints
Message-ID: <20210715011248.GT22402@magnolia>
References: <20210714213542.GK22402@magnolia>
 <20210714235049.GF664593@dread.disaster.area>
 <20210715000604.GG664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715000604.GG664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 10:06:04AM +1000, Dave Chinner wrote:
> On Thu, Jul 15, 2021 at 09:50:49AM +1000, Dave Chinner wrote:
> > On Wed, Jul 14, 2021 at 02:35:42PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > If we encounter a directory that has been configured to pass on an
> > > extent size hint to a new realtime file and the hint isn't an integer
> > > multiple of the rt extent size, we should flag the hint for
> > > administrative review because that is a misconfiguration (that other
> > > parts of the kernel will fix automatically).
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/scrub/inode.c |   18 ++++++++++++++++--
> > >  1 file changed, 16 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > > index 61f90b2c9430..76fbc7ca4cec 100644
> > > --- a/fs/xfs/scrub/inode.c
> > > +++ b/fs/xfs/scrub/inode.c
> > > @@ -73,11 +73,25 @@ xchk_inode_extsize(
> > >  	uint16_t		flags)
> > >  {
> > >  	xfs_failaddr_t		fa;
> > > +	uint32_t		value = be32_to_cpu(dip->di_extsize);
> > >  
> > > -	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
> > > -			mode, flags);
> > > +	fa = xfs_inode_validate_extsize(sc->mp, value, mode, flags);
> > >  	if (fa)
> > >  		xchk_ino_set_corrupt(sc, ino);
> > > +
> > > +	/*
> > > +	 * XFS allows a sysadmin to change the rt extent size when adding a rt
> > > +	 * section to a filesystem after formatting.  If there are any
> > > +	 * directories with extszinherit and rtinherit set, the hint could
> > > +	 * become misaligned with the new rextsize.  The verifier doesn't check
> > > +	 * this, because we allow rtinherit directories even without an rt
> > > +	 * device.  Flag this as an administrative warning since we will clean
> > > +	 * this up eventually.
> > > +	 */
> > > +	if ((flags & XFS_DIFLAG_RTINHERIT) &&
> > > +	    (flags & XFS_DIFLAG_EXTSZINHERIT) &&
> > > +	    value % sc->mp->m_sb.sb_rextsize > 0)
> > > +		xchk_ino_set_warning(sc, ino);
> > >  }
> > >  
> > >  /*
> > 
> > Looks good. A warning seems appropriate for scrub in this corner
> > case...
> 
> so...
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cool, thanks for the review!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
