Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CB6EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 06:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240998AbjFPGfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 02:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241307AbjFPGfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 02:35:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0785B270E
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 23:35:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6668c030ec9so399951b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 23:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686897301; x=1689489301;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zDWqm1QOdjd+ZoFFTXX7UZrrVZguqutKQcuJZkVx+B8=;
        b=lxUzIS/lt3AjKp4gpYIZpd/bn8ePu2ziF3jw7Yo2zAxuJQ/gyurLa7ZtSsEFy/nVLT
         lXHIZK5b1H6oHQ6iTh1v2dQAAOkhv7gcfAQQ/ekMFQuP/PmH6D2UozLLTQlqorW24XfM
         qKnN5KPDKlqtPUqnKppBTfmf4uPqOs4E1sfPhCC8HH1Uuarkrv12O24CgEwrrj7Y3EVm
         95vXwyztnfeyTT3NpIo1TGSUc4WpJxumeOP7vb/evgUHKNLK4YKTCq+cdVuBZhpDmsRW
         FFtxtjnYdrSJI5jnR/5V6WfLKjnT38p0DWS7VDkHJylkucFam+7Ibc9Jr8RiS+u0J3ZU
         M0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686897301; x=1689489301;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zDWqm1QOdjd+ZoFFTXX7UZrrVZguqutKQcuJZkVx+B8=;
        b=OJm/XCvgRd2gMgMnb2u1B2GQxiPLxSIUPirqG0WMFiYbMV3H0Zb8mgoKORrm0cGnGW
         oUQkPSP3MlLuHtDVvhiEZzWkvVNUdawvdKC+YpZyxaaLRamqX0oCIsNsuEeHWlMEFlTK
         0oVjBRlv5j75Injpz8BuSVJtfAZJkg+SAeTWC88y+XqC2omM3dS2FmB77tuV99T4V1R0
         TC9U/5+JdUEJt1T41FnVaTogD3/Wj8GD3ux2KxvrN6jNkF6Q4SG90qJ5XJnL23TK3TIA
         ICL38AFu7gTixSoZwRDrSvye+UFIR9umgVta6s1p2H4bc0HQ7pTAyxZj+N4nc9Nx5tOB
         32Ew==
X-Gm-Message-State: AC+VfDxEd9t0b17kn6KaZIgcBGX95YApvtO+V8YVUQ347QPjyZiSpV5W
        lSQdzREQxqsxCgSUfIyxRibqQ6KO/qPAfdmPDbA=
X-Google-Smtp-Source: ACHHUZ7ZYF8X7nQAi0KBrw7BXRfVlMItx8ufepQ+vjiOX/mpiqqJkc3rwav2NVN3hddIgF2qy0McPA==
X-Received: by 2002:a05:6a00:c8b:b0:654:492b:d55e with SMTP id a11-20020a056a000c8b00b00654492bd55emr1424278pfv.18.1686897301327;
        Thu, 15 Jun 2023 23:35:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id i21-20020aa78d95000000b0064d34ace753sm13018552pfr.114.2023.06.15.23.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 23:35:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qA32w-00CN85-0i;
        Fri, 16 Jun 2023 16:34:58 +1000
Date:   Fri, 16 Jun 2023 16:34:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: AGF length has never been bounds checked
Message-ID: <ZIwCknB7YDRqvXe1@dread.disaster.area>
References: <20230616015906.3813726-1-david@fromorbit.com>
 <20230616041901.GR11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616041901.GR11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 09:19:01PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 16, 2023 at 11:59:06AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The AGF verifier does not check that the AGF length field is within
> > known good bounds. This has never been checked by runtime kernel
> > code (i.e. the lack of verification goes back to 1993) yet we assume
> 
> Woo hoo!
> 
> > in many places that it is correct and verify other metdata against
> > it.
> > 
> > Add length verification to the AGF verifier. The length of the AGF
> > must be equal to the size of the AG specified in the superblock,
> > unless it is the last AG in the filesystem. In that case, it must be
> > less than or equal to sb->sb_agblocks and greater than
> > XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs operation will
> > allow to exist.
> > 
> > This requires a bit of rework of the verifier function. We want to
> > verify metadata before we use it to verify other metadata. Hence
> > we need to verify the AGF sequence numbers before using them to
> > verify the length of the AGF. Then we can verify the AGF length
> > before we verify AGFL fields. Then we can verifier other fields that
> > are bounds limited by the AGF length.
> > 
> > And, finally, by calculating agf_length only once into a local
> > variable, we can collapse repeated "if (xfs_has_foo() &&"
> > conditionaly checks into single checks. This makes the code much
> > easier to follow as all the checks for a given feature are obviously
> > in the same place.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 81 ++++++++++++++++++++++-----------------
> >  1 file changed, 46 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 7c675aae0a0f..78556cad57e5 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2970,6 +2970,7 @@ xfs_agf_verify(
> >  {
> >  	struct xfs_mount	*mp = bp->b_mount;
> >  	struct xfs_agf		*agf = bp->b_addr;
> > +	uint32_t		agf_length = be32_to_cpu(agf->agf_length);
> >  
> >  	if (xfs_has_crc(mp)) {
> >  		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
> > @@ -2981,18 +2982,38 @@ xfs_agf_verify(
> >  	if (!xfs_verify_magic(bp, agf->agf_magicnum))
> >  		return __this_address;
> >  
> > -	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
> > -	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
> > -	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
> > -	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
> > -	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
> > +	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum))))
> >  		return __this_address;
> >  
> > -	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
> > +	/*
> > +	 * during growfs operations, the perag is not fully initialised,
> > +	 * so we can't use it for any useful checking. growfs ensures we can't
> > +	 * use it by using uncached buffers that don't have the perag attached
> > +	 * so we can detect and avoid this problem.
> 
> Would you mind adding an extra sentence here:
> 
> "Both agf_seqno and agf_length need to be validated before anything else
> fsblock related in the AGF."

Yup.

> > +	 */
> > +	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
> > +		return __this_address;
> > +
> > +	/*
> > +	 * Only the last AGF in the filesytsem is allowed to be shorter
> > +	 * than the AG size recorded in the superblock.
> > +	 */
> > +	if (agf_length != mp->m_sb.sb_agblocks) {
> > +		if (be32_to_cpu(agf->agf_seqno) != mp->m_sb.sb_agcount - 1)
> > +			return __this_address;
> > +		if (agf_length < XFS_MIN_AG_BLOCKS)
> 
> The superblock verifier checks that sb_agblocks >= XFS_MIN_AG_BYTES,
> which means that it can't be less than 16MB.  That's the lower bound on
> the general AG size, not the lower bound of a runt AG at the end of the
> fs.

*nod*

> OTOH, the lower bound of a runt AG is XFS_MIN_AG_BLOCKS, or 64FSB.  I
> would sorta like this to be outside this sub-block since that's
> independent of whatever sb_agblocks is.
>
> That said, there is no filesystem where setting sb_agblocks to 16MB
> would result in an sb_agblocks with a value less than 256, so I suppose
> this is a moot worry of mine.
> 
> Does that make sense?

*nod*.

The sb verifier is checking valid sb_agblocks bounds, and this is
just checking the invariant that all AGs must be the same size as
sb_agblocks, except for the runt AG. The runt AG has bounds of
XFS_MIN_AG_BLOCKS <= agf_length <= sb_agblocks, so we check those
here...

> > +			return __this_address;
> > +		if (agf_length > mp->m_sb.sb_agblocks)
> > +			return __this_address;
> > +	}
> > +
> > +	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp) ||
> > +	    be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp) ||
> > +	    be32_to_cpu(agf->agf_flcount) > xfs_agfl_size(mp))
> >  		return __this_address;
> 
> I wish each check would get its own return __this_address.  Today I was
> debugging some dumb bug but addr2line dropped me off in the middle of
> this mound of code. :(

I've got to revise it for the comment above, so I can do that
easily enough here too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
