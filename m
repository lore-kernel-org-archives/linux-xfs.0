Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F348ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 22:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiJ0WYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 18:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiJ0WYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 18:24:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161E1B03D4
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 15:24:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c24so3113707pls.9
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 15:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XTrfFiifXpUqqhcLbwvZBXyM9avMxPoO0gQC1h6rTpc=;
        b=RcPa1RyRqFtbqpOwQLzCt+lVCol8+DDKOGji4sb0NJMsEf5ldb9a2+OD0L5OKfbDU9
         SqJjojhp4m2uBQuQ7WeJW793k9+PqHIJb7GeuiclrOsVOFvQ6O1CBfqnPYey8sdgLfPE
         RX0FMyc63gVMJemlxWWUlxBNUc2JsaMzSTghyaC7jVAyCslH4f98Lv7pGqbTLcBFC75a
         ntT7y3o+Lb0XorKFWm4w3rehwXKOASYNBUFGRIPca1spTjthQvPK3Q8JUOan05o9Hc0R
         /yR+HNlgd2ZieTNyl329zBcSxVAHrbCVt/4cp9T9SvSlpPw6dktRlngUy2PMaxfPdjwC
         Tkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTrfFiifXpUqqhcLbwvZBXyM9avMxPoO0gQC1h6rTpc=;
        b=yuLY8bKwiheDgFR6on2RZe7ET3zCXo4wyF2zsU/j8aie1HOskFX2m2YHe4T4W1oSG8
         l2yVeWEf4KDnUAKjHbCTqaMZEmEt7siATYac5kQXAfYpPBs/8yZEI/VE1nYciKxFbAHt
         H52rv5RieYTQ2/kgrQe+C/ABW0XShGQb2a+ICbDdu9p1lNSsOkurWpGlFgYic0Hkp9aJ
         LXnjk0vtCnqhOapOENX0Ga6xdfh8BcLJH28z0os+fe0Ffhkdl5KXNsINaE7UpH5a5ZN8
         oSl7t4jbWJVf3WjZzb9Mwz5TQHjTsJD4n8afS8xvN55PgwCIKFMsCsk/G6pTxBiBQBYE
         DJvg==
X-Gm-Message-State: ACrzQf12lH+T19MkU55SG+uFMGsV04GgepYdgjsVfvkBWiUXC5WWE1Gt
        ZnWSrksVWk7diPYOrBC0vgd4eA==
X-Google-Smtp-Source: AMsMyM5YG4fk++2XEfLObaYDoyVq/oq6M40r1hAys96oMPW6b0J7rSpx2ALnnMYdaO8cJt+kzkn8Fg==
X-Received: by 2002:a17:903:110f:b0:178:ae31:ab2 with SMTP id n15-20020a170903110f00b00178ae310ab2mr51839488plh.89.1666909446532;
        Thu, 27 Oct 2022 15:24:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id a22-20020aa795b6000000b0056bb06ce1cfsm1684331pfk.97.2022.10.27.15.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:24:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooBIB-007Aq5-BO; Fri, 28 Oct 2022 09:24:03 +1100
Date:   Fri, 28 Oct 2022 09:24:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: check deferred refcount op continuation
 parameters
Message-ID: <20221027222403.GB3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689085464.3788582.2756559047908250104.stgit@magnolia>
 <20221027204957.GR3600936@dread.disaster.area>
 <Y1r4+k5uKQBySEta@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1r4+k5uKQBySEta@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 02:32:42PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 28, 2022 at 07:49:57AM +1100, Dave Chinner wrote:
> > On Thu, Oct 27, 2022 at 10:14:14AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > If we're in the middle of a deferred refcount operation and decide to
> > > roll the transaction to avoid overflowing the transaction space, we need
> > > to check the new agbno/aglen parameters that we're about to record in
> > > the new intent.  Specifically, we need to check that the new extent is
> > > completely within the filesystem, and that continuation does not put us
> > > into a different AG.
> > > 
> > > If the keys of a node block are wrong, the lookup to resume an
> > > xfs_refcount_adjust_extents operation can put us into the wrong record
> > > block.  If this happens, we might not find that we run out of aglen at
> > > an exact record boundary, which will cause the loop control to do the
> > > wrong thing.
> > > 
> > > The previous patch should take care of that problem, but let's add this
> > > extra sanity check to stop corruption problems sooner than later.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_refcount.c |   48 ++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 46 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > > index 831353ba96dc..c6aa832a8713 100644
> > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > @@ -1138,6 +1138,44 @@ xfs_refcount_finish_one_cleanup(
> > >  		xfs_trans_brelse(tp, agbp);
> > >  }
> > >  
> > > +/*
> > > + * Set up a continuation a deferred refcount operation by updating the intent.
> > > + * Checks to make sure we're not going to run off the end of the AG.
> > > + */
> > > +static inline int
> > > +xfs_refcount_continue_op(
> > > +	struct xfs_btree_cur		*cur,
> > > +	xfs_fsblock_t			startblock,
> > > +	xfs_agblock_t			new_agbno,
> > > +	xfs_extlen_t			new_len,
> > > +	xfs_fsblock_t			*fsbp)
> > > +{
> > > +	struct xfs_mount		*mp = cur->bc_mp;
> > > +	struct xfs_perag		*pag = cur->bc_ag.pag;
> > > +	xfs_fsblock_t			new_fsbno;
> > > +	xfs_agnumber_t			old_agno;
> > > +
> > > +	old_agno = XFS_FSB_TO_AGNO(mp, startblock);
> > > +	new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
> > > +
> > > +	/*
> > > +	 * If we don't have any work left to do, then there's no need
> > > +	 * to perform the validation of the new parameters.
> > > +	 */
> > > +	if (!new_len)
> > > +		goto done;
> > 
> > Shouldn't we be validating new_fsbno rather than just returning
> > whatever we calculated here?
> 
> No.  Imagine that the deferred work is performed against the last 30
> blocks of the last AG in the filesystem.  Let's say that the last AG is
> AG 3 and the AG has 100 blocks.  fsblock 3:99 is the last fsblock in the
> filesystem.
> 
> Before we start the deferred work, startblock == 3:70 and
> blockcount == 30.  We adjust the refcount of those 30 blocks, so we're
> done now.  The adjust function passes out new_agbno == 70 + 30 and
> new_len == 30 - 30.
> 
> The agbno to fsbno conversion sets new_fsbno to 3:100 and new_len is 0.
> However, fsblock 3/100 is one block past the end of both AG 3 and the
> filesystem, so the check below will fail:

Sure, but my point here is that the function returns this invalid
fsbno in *fsbp and assumes that the caller will handle it correctly.

If the caller knows that we aren't going to continue past the
"new_len == 0" condition, then why is it even calling this function?
i.e. this isn't a "decide if we are going to continue" function,
it's a "calculate and validate next fsbno" function...

i.e. the intent doesn't match the name of the function.

> > > +	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, new_fsbno, new_len)))
> > > +		return -EFSCORRUPTED;
> > > +
> > > +	if (XFS_IS_CORRUPT(mp, old_agno != XFS_FSB_TO_AGNO(mp, new_fsbno)))
> > > +		return -EFSCORRUPTED;
> > 
> > We already know what agno new_fsbno sits in - we calculated it
> > directly from pag->pag_agno above, so this can jsut check against
> > pag->pag_agno directly, right?
> 
> We don't actually know what agno new_fsbno sits in because of the way
> that the agblock -> fsblock conversion works:
> 
> #define XFS_AGB_TO_FSB(mp,agno,agbno)	\
> 	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))

Sure, but FSBs are *sparse* and there is unused, unchecked address
space between the AGs that agbno overruns can fall into. And when we
look at XFS_FSB_TO_AGNO():

#define XFS_FSB_TO_AGNO(mp,fsbno)       \
        ((xfs_agnumber_t)((fsbno) >> (mp)->m_sb.sb_agblklog))

we can see that it simply truncates away the agbno portion to get
back to the agno.

IOWs:

	0			sb_agblocks
	+--------------------------+------------+
					(1 << sb_agblklog)
				   +------------+
				   invalid agbnos!

Hence the agbno needs to be checked agains sb_agblocks to capture AG
overruns, not converted to a FSB and back to an AGNO as this will
claim agbnos in the inaccessible address space region between AGs
are valid....

> Notice how we don't mask off the bits of agbno above sb_agblklog?  If
> sb_agblklog is (say) 20 but agbno has bit 31 set, that bit 31 will bump
> the AG number by 2^11 AGs.

Yes, but that's only a side effect of the agbno having the high bit
set - it could have many other bits set and still be out of range.
i.e. coverting to fsb and back to agno doesn't actually capture all
cases of the next calculated agbno/fsbno could be invalid.

xfs_verify_fsbext() may capture this by chance because it checks
the entire agbno portion of the fsb (via XFS_FSB_TO_AGBNO) against
xfs_ag_block_count(agno), but it won't capture the overruns that
only bump the AGNO portion of the FSB.

Hence I really think we should be checking new_agbno for validity
here, not relying on side effects of coverting to/from FSBs and
verifying fsb extents to capture ag block count overruns in the
supplied agbno....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
