Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3377CC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 01:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0567761139
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 01:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhDVBwO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 21:52:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhDVBwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 21:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619056300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SexSbDGL45fkYgK7Mpr2lvl8urRWwRc0xdUnLFxIRtk=;
        b=QOtod0pfB98tW3qN/xCUVdjekK/zieNTsYYH0qh92F6uulQK1hFV70c97L9nMaSBpS6ad8
        twXZ3GtskOYR9anyvV21ke8pgzF78E/LBJWfWCzkEF6JOpO+CEM/l5Vsp48cFVgiNg2aCv
        2RbPo2LvhDAlbfNGZ6pn3BL5hT1Xa2s=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-Pb8lnzJ9PCuzYp8XRSuIWg-1; Wed, 21 Apr 2021 21:51:38 -0400
X-MC-Unique: Pb8lnzJ9PCuzYp8XRSuIWg-1
Received: by mail-pg1-f198.google.com with SMTP id g5-20020a63f4050000b02901f6c7b9a6d0so11583291pgi.5
        for <linux-xfs@vger.kernel.org>; Wed, 21 Apr 2021 18:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SexSbDGL45fkYgK7Mpr2lvl8urRWwRc0xdUnLFxIRtk=;
        b=PJs4zQor4ASd0uE+PmD1wC5MeOknmc0XT+N2heRODlVIZX8FMayogV9HtQX1NGIt2R
         zqu92eS7hQbQcJEkgyKWdaJwDRY4TjFtvBgqgdVjtO5w0Cmzpx9hCEDL8aJck5Bzdcho
         q9xdLgxC8ToOKCZBELc0MtUpJ6vB4Oy1bRJcXQyKMcB/yk4PBUkLw/x2MPzjLle5i71b
         A7iWz+CJNO2LC/Ge/8Ml6TLMQ28MHXxINJrn51jfJkBG0IeDdCBaLTP+hG8+L5L6XJ9h
         5k7p/Ey0yCf0fxvsdG42J0+dD1twSPbF8UZjxZIIpmpLQFR1lHehfGuOXi5p1hu2z9+F
         4ZmQ==
X-Gm-Message-State: AOAM532VKsyQ69Jq4K+GOMEVFSScglNRVKDaZf/HsVdsUIytN5bhtgWN
        z599zXfqoOg+2zAPJD3NW/8i7pqxJajwyyFtZUB6iESFSTkJxyYIXB8Tc9HqI0QJ9ZqJbD45hXI
        Iefija860hCKru1B0IBau
X-Received: by 2002:a17:90b:813:: with SMTP id bk19mr14339912pjb.108.1619056297274;
        Wed, 21 Apr 2021 18:51:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlEzAOeyHSsLkmQstCchUeM8GnCCvS7cNn3aOKkTOKYuXU3S2O7GpYq0AZN5Q814UibenNhg==
X-Received: by 2002:a17:90b:813:: with SMTP id bk19mr14339897pjb.108.1619056296932;
        Wed, 21 Apr 2021 18:51:36 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m17sm529135pgh.41.2021.04.21.18.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 18:51:36 -0700 (PDT)
Date:   Thu, 22 Apr 2021 09:51:26 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v2 2/2] xfs: turn on lazysbcount unconditionally
Message-ID: <20210422015126.GA3264012@xiangao.remote.csb>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420110855.2961626-2-hsiangkao@redhat.com>
 <20210420162250.GE3122264@magnolia>
 <20210420200029.GA3028214@xiangao.remote.csb>
 <20210422000140.GU3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210422000140.GU3122264@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 05:01:40PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 21, 2021 at 04:00:29AM +0800, Gao Xiang wrote:

...

> > > >  /*
> > > >   * xfs_initialize_perag_data
> > > >   *
> > > > @@ -864,27 +914,51 @@ xfs_initialize_perag_data(
> > > >  	uint64_t	btree = 0;
> > > >  	uint64_t	fdblocks;
> > > >  	int		error = 0;
> > > > +	bool		conv = !(mp->m_flags & XFS_MOUNT_RDONLY) &&
> > > > +				!xfs_sb_version_haslazysbcount(sbp);
> > > > +
> > > > +	if (conv)
> > > > +		xfs_warn(mp, "enabling lazy-counters...");
> > > >  
> > > >  	for (index = 0; index < agcount; index++) {
> > > > +		struct xfs_trans	*tp = NULL;
> > > > +		struct xfs_buf		*agfbp;
> > > > +
> > > > +		if (conv) {
> > > > +			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb,
> > > > +					0, 0, 0, &tp);
> > > > +			if (error)
> > > > +				return error;
> > > > +		}
> > > > +
> > > >  		/*
> > > > -		 * read the agf, then the agi. This gets us
> > > > +		 * read the agi, then the agf. This gets us
> > > >  		 * all the information we need and populates the
> > > >  		 * per-ag structures for us.
> > > >  		 */
> > > > -		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
> > > > -		if (error)
> > > > +		error = xfs_ialloc_pagi_init(mp, tp, index);
> > > > +		if (error) {
> > > > +err_out:
> > > > +			if (tp)
> > > > +				xfs_trans_cancel(tp);
> > > >  			return error;
> > > > +		}
> > > >  
> > > > -		error = xfs_ialloc_pagi_init(mp, NULL, index);
> > > > +		error = xfs_alloc_read_agf(mp, tp, index, 0, &agfbp);
> > > >  		if (error)
> > > > -			return error;
> > > > -		pag = xfs_perag_get(mp, index);
> > > > +			goto err_out;
> > > > +		pag = agfbp->b_pag;
> > > >  		ifree += pag->pagi_freecount;
> > > >  		ialloc += pag->pagi_count;
> > > >  		bfree += pag->pagf_freeblks;
> > > >  		bfreelst += pag->pagf_flcount;
> > > > +		if (tp) {
> > > > +			error = xfs_fixup_agf_btreeblks(mp, tp, agfbp, index);
> > > 
> > > Lazysbcount upgrades should be done from a separate function, not mixed
> > > in with perag initialization. 
> > 
> > I've seen some previous discussion about multiple AG total scan time cost.
> > Yeah, if another extra scan really accepts here, I could update instead.
> > 
> > > Also, why is it necessary to walk all the space btrees to set agf_btreeblks?
> > 
> > If my understanding is correct, I think because without lazysbcount,
> > even pagf_btreeblks is updated unconditionally now, but that counter
> > is unreliable for quite ancient kernels which don't have such update
> > logic.
> > 
> > Kindly correct me if I'm wrong here.
> 
> Ah, you're right.  The agf_btreeblks field in the AGF only exists if
> lazysbcount is enabled, which means that adding the feature means that
> we have to scan every AG to compute the correct value.
> 
> Still, we only need to do this walk once per filesystem, so I'd prefer
> not to clutter up the xfs_initialize_perag_data code for the sake of a
> onetime upgrade for a deprecated ondisk format.
> 
> In my mind it's a feature to be able to do:
> 
> #if IS_ENABLED(CONFIG_XFS_V4)
> int
> xfs_fs_set_lazycount(...)
> {
> 	/* walk AGs, fix AGF... */
> 	/* lock super */
> 	/* set lazysbcount */
> 	/* bwrite super */
> 	/* log super changes */
> 	/* commit the whole mess */
> }
> #else
> # define xfs_fs_set_lazycount(..)	(-ENOSYS)
> #endif
> 
> Because then we know that this is all XFSv4 code and can easily make it
> go away.

Yeah, sounds better. I could refine this in the next version. :)

> 
> The other question I have is: Do we /really/ want to QA and support
> this in the kernel?  Considering that we already have xfs_admin -c1?

I think we might ask Zorro for this whole thing, since no end users
actually report this. :) (Cc Zorro here.) Although the reality is
we still support !lazysbcount fses even it isn't looked after at all.

My another suggestion completely forbids !lazysbcount from mounting
in months (or right now.)

Just warn users to use xfs_admin -c1 to convert this. And after months,
warn users to convert this and also forbid it from mounting.

> 
> > > 
> > > > +			xfs_trans_commit(tp);
> > > > +		} else {
> > > > +			xfs_buf_relse(agfbp);
> > > > +		}
> > > >  		btree += pag->pagf_btreeblks;
> > > > -		xfs_perag_put(pag);
> > > >  	}
> > > >  	fdblocks = bfree + bfreelst + btree;
> > > >  
> > > > @@ -900,6 +974,11 @@ xfs_initialize_perag_data(
> > > >  		goto out;
> > > >  	}
> > > >  
> > > > +	if (conv) {
> > > > +		xfs_sb_version_addlazysbcount(sbp);
> > > > +		mp->m_update_sb = true;
> > > > +		xfs_warn(mp, "lazy-counters has been enabled.");
> > > 
> > > But we don't log the sb update?
> > > 
> > > As far as the feature upgrade goes, is it necessary to bwrite the
> > > primary super to disk (and then log the change)[1] to prevent a truly
> > > ancient kernel that doesn't support lazysbcount from trying to recover
> > > the log and ending up with an unsupported feature set?
> > 
> > Not quite sure if it does harm to ancient kernels with such
> > unsupported feature. may I ask for more details? :)
> 
> 1. Walk AG to update btreeblks.
> 2. Commit feature flag update in superblock.
> 3. Log flushes to disk before the superblock update gets written to
>    sector 0.
> <crash>
> 4. Boot ancient kernel that doesn't understand lazysbcount
>    (from USB recovery stick).
> 5. Mount begins, because sector 0 doesn't have the lazysbcount bit set.
> 6. Log recovery replays the primary super update over sector 0, and the
>    new contents of sector 0 say lazysbcount is enabled.
> 7. Superblock now says it has lazysbcount, what does the kernel do?

Yeah, but I'm not sure if it has some bad effect if ancient kernels
do it in this way. I mean (I think) it's somewhat different from
log_incompat thing.

If ancient kernels just replay the log, and then sb read verified
and refuse to proceed (but fs is not corrupted...) I think that
would be fine?

I'm not sure about the whole thing on ancient kernels. So very
curious about this. I will look into the whole thing as well.

> 
> > 
> > but yeah, if any issues here, I should follow
> >  1) bwrite sb block first;
> >  2) log sb
> > 
> > > 
> > > [1] https://lore.kernel.org/linux-xfs/161723934343.3149451.16679733325094950568.stgit@magnolia/
> > > 
> > > > +	}
> > > >  	/* Overwrite incore superblock counters with just-read data */
> > > >  	spin_lock(&mp->m_sb_lock);
> > > >  	sbp->sb_ifree = ifree;
> > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > index cb1e2c4702c3..b3b13acd45d6 100644
> > > > --- a/fs/xfs/xfs_mount.c
> > > > +++ b/fs/xfs/xfs_mount.c
> > > > @@ -626,7 +626,7 @@ xfs_check_summary_counts(
> > > >  	 * superblock to be correct and we don't need to do anything here.
> > > >  	 * Otherwise, recalculate the summary counters.
> > > >  	 */
> > > > -	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> > > > +	if ((xfs_sb_version_haslazysbcount(&mp->m_sb) &&
> > > 
> > > Not clear why the logic here inverts?
> > 
> > .. thus xfs_initialize_perag_data() below can be called then.
> 
> That seems like all the more reason to make it a separate function, TBH.

Yeah, will refine this later.

Thanks,
Gao Xiang

> 
> --D
> 
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > --D
> > > 
> > > >  	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
> > > >  	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
> > > >  		return 0;
> > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > index a2dab05332ac..16197a890c15 100644
> > > > --- a/fs/xfs/xfs_super.c
> > > > +++ b/fs/xfs/xfs_super.c
> > > > @@ -1678,6 +1678,11 @@ xfs_remount_rw(
> > > >  	}
> > > >  
> > > >  	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > > > +	if (!xfs_sb_version_haslazysbcount(sbp)) {
> > > > +		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
> > > > +		if (error)
> > > > +			return error;
> > > > +	}
> > > >  
> > > >  	/*
> > > >  	 * If this is the first remount to writeable state we might have some
> > > > -- 
> > > > 2.27.0
> > > > 
> > > 
> > 
> 

