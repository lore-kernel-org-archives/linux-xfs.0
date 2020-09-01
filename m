Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29586C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3CD220665
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3k3pk5v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIAJpe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIAJpc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:45:32 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4C4C061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 02:45:31 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so262551plk.10
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Tvk6H0MlVNrnywGGKO+Nwz27CfixoSwIlZe7pivxaA=;
        b=m3k3pk5vjJoqmAAS9fzcpMkgIh5/qEsA/HNligd6jRl62+VobY4wG7yZkJxeWeuOiY
         HLiOZGvAEj0B2OzmNUwtlX4Jd/K5wSxlak0JZZr4q7CwAUMKz1kucUyKcqY84sj+ULLK
         c6CKHpBh/4D4t+OrA893h+JCbTeEcCywcGrZ3LREyrMhakfefykBAC9BFGIe715bo3Sn
         6P2Wv0Fg7uAKtDdT1u0xcRuQFKEbTHysxdDGAifWrjIB/Qq/BSTixG88LnffQByuDFN4
         eZxiZqMISjFkN6cHLPGh4kBJdkrG6CfH4lCAIUmRowiA50Fh4ic5fnv3Osx+wDuOF1/l
         6X3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Tvk6H0MlVNrnywGGKO+Nwz27CfixoSwIlZe7pivxaA=;
        b=Fe0y8pgujXXTrhTdwXqNUhD9ndQ8VjXOsMd+b8K8vGe7XoUZuxiI7Zv4Zn7D7Ukt1b
         CfEDCorW3kMgHc/SXznBm+A0H6ORCR0GIVPmBrWuZXgqB0dlXZHnLE+hAvcMUf3ejLar
         J2R4MQjZbEwIlDtF29wjDDIvpoK4wMQuGuEt5CITUQZXjWWOkBfo4Zxq6Hgk1/+Pt2nU
         lQDiA6fCbc3w0IdEAXXpxU8oek9wXS1JMAWGcG7cDQltPbnWs9IQI8W7oWOR6S6UnGeo
         NrSMhnFuvN0Mko/e/fpgR/cmZdSPm6sq2NCHB0qkIy6utRi/jrnHdmdaIGtpv8pul8xd
         3SOQ==
X-Gm-Message-State: AOAM531d5BkJ5DuyXx+Dj5wVz19YK6T4zljtjOPPRkt52qRifOgyPovV
        kTSj8Ti1rRPWDIHa87VE0uMYDO+tOss=
X-Google-Smtp-Source: ABdhPJxjJZtI18GiThz/00OeYhrpZA5rnPmPgi4f0W9rvoEv1biwT1i3mcEc8Qe1QZDvmXZyt5BDzg==
X-Received: by 2002:a17:90a:b38b:: with SMTP id e11mr779832pjr.94.1598953531356;
        Tue, 01 Sep 2020 02:45:31 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id f17sm1252141pfq.67.2020.09.01.02.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:45:30 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 10/10] xfs: Check for extent overflow when swapping extents
Date:   Tue, 01 Sep 2020 15:15:16 +0530
Message-ID: <799478968.03WXDaQWZF@garuda>
In-Reply-To: <20200831162039.GI6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com> <20200820054349.5525-11-chandanrlinux@gmail.com> <20200831162039.GI6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 31 August 2020 9:50:39 PM IST Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 11:13:49AM +0530, Chandan Babu R wrote:
> > Removing an initial range of source/donor file's extent and adding a new
> > extent (from donor/source file) in its place will cause extent count to
> > increase by 1.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.h |  6 ++++++
> >  fs/xfs/xfs_bmap_util.c         | 11 +++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index d1c675cf803a..4219b01f1034 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -100,6 +100,12 @@ struct xfs_ifork {
> >   */
> >  #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
> >  	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
> > +/*
> > + * Removing an initial range of source/donor file's extent and adding a new
> > + * extent (from donor/source file) in its place will cause extent count to
> > + * increase by 1.
> > + */
> > +#define XFS_IEXT_SWAP_RMAP_CNT		(1)
> >  
> >  /*
> >   * Fork handling.
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index e682eecebb1f..7105525dadd5 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1375,6 +1375,17 @@ xfs_swap_extent_rmap(
> >  		/* Unmap the old blocks in the source file. */
> >  		while (tirec.br_blockcount) {
> >  			ASSERT(tp->t_firstblock == NULLFSBLOCK);
> > +
> > +			error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> > +					XFS_IEXT_SWAP_RMAP_CNT);
> > +			if (error)
> > +				goto out;
> > +
> > +			error = xfs_iext_count_may_overflow(tip, XFS_DATA_FORK,
> > +					XFS_IEXT_SWAP_RMAP_CNT);
> 
> Heh, the old swapext code is very gritty.  Two questions--
> 
> If either of irec and uirec describe a hole, why do we need to check for
> an extent count overflow?

Thanks for pointing this out. I missed this. The check for overflow should be
moved later in the code i.e. after reading up the extent mappings. Also, the
overflow check should be made on source file only if the donor file extent
has a valid on-disk mapping and vice versa.

> 
> Second, is the transaction clean at the point where we could goto out?
> I'm pretty sure it is, but if there's a chance we could end up bailing
> out with a dirty transaction, then we need to do this check elsewhere
> such that we don't shut down the filesystem.
> 
> (I'm pretty sure the answer to #2 is "yes", but I thought I'd better
> ask.)

In xfs_swap_extents(), the code between allocating a new transaction and
invoking xfs_swap_extent_rmap() does not peform any operation that can dirty
the transaction.

Inside xfs_swap_extent_rmap(), we invoke xfs_defer_finish() every time we
register deferred operations to exchange extents between two inodes'
forks. xfs_defer_finish() will always return with a clean transaction. So, we
can safely return an error code on detecting an overflow.
> 
> --D
> 
> > +			if (error)
> > +				goto out;
> > +
> >  			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
> >  
> >  			/* Read extent from the source file */
> 

-- 
chandan



