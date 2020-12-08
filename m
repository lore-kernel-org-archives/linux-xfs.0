Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4038CC4361B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 23:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01354238EE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 23:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbgLHXiQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:38:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730438AbgLHXiP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 18:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607470608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aLVu68blltSYkkCFyUvNT7iMFXxbb0UBheR9AltG9Dc=;
        b=QDuR34U6soLVdd2RbqYZ0gc7wWOo0yrdGQ2h7oYXJTOywaql/LU9QoMFo8eNnToURP2CrM
        /85b5Lk0lD9lE/h3yCSD4tUaHK5MRtnuqB+hk8K+AeXoS+pY/JJ3y2wzUYe8iBXaTcr35f
        zcTi3OwgYKjsvpqJV0cyQLxQr8CRqTs=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-Tqa-7KJdOWSUzXyasuK1XA-1; Tue, 08 Dec 2020 18:36:47 -0500
X-MC-Unique: Tqa-7KJdOWSUzXyasuK1XA-1
Received: by mail-pl1-f199.google.com with SMTP id k17so251870pll.18
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 15:36:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aLVu68blltSYkkCFyUvNT7iMFXxbb0UBheR9AltG9Dc=;
        b=GgiSk/YKc/2UZkKMjQuOiGdyQFXAykXqvl1PwlX3+Ebr+gw2fxsd/Gn4b+R28AbRpa
         MocVCw+DhgGFSxJGMHgV0wFnzFS1rFMSIUf7sjkYaMMIaFq27rK0k1VD5mmFIa9s9TA8
         ex0W+2gDEmMF0BrSP0soXB0uPLhLll4h/mxOdcLobUfai/mi6KCB9z2I0399+xHIG1is
         32dUIC+gCdtEnacQyqHvVFkYd1FwWqb2m6dzdTPhKI15AB81YJLyeG/k/5Mz04Iijq69
         1iLFvwMleMoAoowU7+W9dc1DHV6SZcP9j/0BEax72P5ZSprsLjMEFHRxN/nvCseJuQol
         LOug==
X-Gm-Message-State: AOAM530KRar+/N9eso84oAJFJgrmr5YDnSIEh7LN2moh2PyiuOdlmEBu
        cOmk/6YFA/5ArikSxlAcdL0nZvd/wd34WMRoMRWHJtmDIiQPXm7x1apVN+jts6ws43+gOoGuvbd
        4nCl5SkiN2m/SuGgIu6gh
X-Received: by 2002:a63:ce18:: with SMTP id y24mr375096pgf.335.1607470606035;
        Tue, 08 Dec 2020 15:36:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJRdItkTz/Jc1RCxU9qpo6Ug7BoxoeTelWIbMHM3tY38406LCDwKWCN2YJiEuPXoim2+Pp2w==
X-Received: by 2002:a63:ce18:: with SMTP id y24mr375084pgf.335.1607470605761;
        Tue, 08 Dec 2020 15:36:45 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u25sm267730pfn.101.2020.12.08.15.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 15:36:45 -0800 (PST)
Date:   Wed, 9 Dec 2020 07:36:34 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 2/6] xfs: introduce xfs_dialloc_roll()
Message-ID: <20201208233634.GB3257594@xiangao.remote.csb>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
 <20201208122003.3158922-3-hsiangkao@redhat.com>
 <20201208230913.GF1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201208230913.GF1943235@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 03:09:13PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 08, 2020 at 08:19:59PM +0800, Gao Xiang wrote:

...

> >  
> > +int
> > +xfs_dialloc_roll(
> > +	struct xfs_trans	**tpp,
> > +	struct xfs_buf		*agibp)
> > +{
> > +	struct xfs_trans	*tp = *tpp;
> > +	struct xfs_dquot_acct	*dqinfo = NULL;
> > +	unsigned int		tflags = 0;
> > +	int			error;
> > +
> > +	/*
> > +	 * Hold to on to the agibp across the commit so no other allocation can
> > +	 * come in and take the free inodes we just allocated for our caller.
> > +	 */
> > +	xfs_trans_bhold(tp, agibp);
> > +
> > +	/*
> > +	 * We want the quota changes to be associated with the next transaction,
> > +	 * NOT this one. So, detach the dqinfo from this and attach it to the
> > +	 * next transaction.
> > +	 */
> > +	if (tp->t_dqinfo) {
> > +		dqinfo = tp->t_dqinfo;
> > +		tp->t_dqinfo = NULL;
> > +		tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> > +		tp->t_flags &= ~XFS_TRANS_DQ_DIRTY;
> 
> FWIW, one of xiakaixu's cleanup patches removes XFS_TRANS_DQ_DIRTY on
> the grounds that there seemed to be a 1:1 correlation between the dqinfo
> being set and the flag being set.  That creates a minor merge conflict
> that I can fix at commit time.  The rest looks fine, so

Yeah, it sounds good to me, thanks for reminder & help!

Thanks,
Gao Xiang

> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> 
> > +	}
> > +
> > +	error = xfs_trans_roll(&tp);
> > +
> > +	/* Re-attach the quota info that we detached from prev trx. */
> > +	if (dqinfo) {
> > +		tp->t_dqinfo = dqinfo;
> > +		tp->t_flags |= tflags;
> > +	}
> > +
> > +	*tpp = tp;
> > +	if (error)
> > +		return error;
> > +	xfs_trans_bjoin(tp, agibp);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Allocate an inode on disk.
> >   *
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> > index 72b3468b97b1..bd6e0db9e23c 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.h
> > +++ b/fs/xfs/libxfs/xfs_ialloc.h
> > @@ -32,6 +32,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
> >  	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
> >  }
> >  
> > +int
> > +xfs_dialloc_roll(
> > +	struct xfs_trans	**tpp,
> > +	struct xfs_buf		*agibp);
> > +
> >  /*
> >   * Allocate an inode on disk.
> >   * Mode is used to tell whether the new inode will need space, and whether
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2bfbcf28b1bd..76282da7a05c 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -958,8 +958,6 @@ xfs_dir_ialloc(
> >  	xfs_inode_t	*ip;
> >  	xfs_buf_t	*ialloc_context = NULL;
> >  	int		code;
> > -	void		*dqinfo;
> > -	uint		tflags;
> >  
> >  	tp = *tpp;
> >  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > @@ -1003,46 +1001,13 @@ xfs_dir_ialloc(
> >  	 * to succeed the second time.
> >  	 */
> >  	if (ialloc_context) {
> > -		/*
> > -		 * Normally, xfs_trans_commit releases all the locks.
> > -		 * We call bhold to hang on to the ialloc_context across
> > -		 * the commit.  Holding this buffer prevents any other
> > -		 * processes from doing any allocations in this
> > -		 * allocation group.
> > -		 */
> > -		xfs_trans_bhold(tp, ialloc_context);
> > -
> > -		/*
> > -		 * We want the quota changes to be associated with the next
> > -		 * transaction, NOT this one. So, detach the dqinfo from this
> > -		 * and attach it to the next transaction.
> > -		 */
> > -		dqinfo = NULL;
> > -		tflags = 0;
> > -		if (tp->t_dqinfo) {
> > -			dqinfo = (void *)tp->t_dqinfo;
> > -			tp->t_dqinfo = NULL;
> > -			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> > -			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
> > -		}
> > -
> > -		code = xfs_trans_roll(&tp);
> > -
> > -		/*
> > -		 * Re-attach the quota info that we detached from prev trx.
> > -		 */
> > -		if (dqinfo) {
> > -			tp->t_dqinfo = dqinfo;
> > -			tp->t_flags |= tflags;
> > -		}
> > -
> > +		code = xfs_dialloc_roll(&tp, ialloc_context);
> >  		if (code) {
> >  			xfs_buf_relse(ialloc_context);
> >  			*tpp = tp;
> >  			*ipp = NULL;
> >  			return code;
> >  		}
> > -		xfs_trans_bjoin(tp, ialloc_context);
> >  
> >  		/*
> >  		 * Call ialloc again. Since we've locked out all
> > -- 
> > 2.18.4
> > 
> 

