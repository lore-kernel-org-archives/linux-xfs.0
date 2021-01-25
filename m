Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EFDC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EC05227BF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbhAYXa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:30:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732735AbhAYXap (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 18:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83F66206D4;
        Mon, 25 Jan 2021 23:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611617402;
        bh=F6KbvQPNTe4mcL8taJXBGxRGGAIQd/VudrdGwuvBanY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Potcfy5fVKtNQBD+9sd29/eZUfcGQLksdI7cwv3Ts74CltULBmXGkS3zsDjGJXEFL
         D1lZAWFjWrEGYJC5MCVBkP6nXncUiCMYrzFc3NbdAaLJo3obbBKePw9DMpWrFXwLe1
         hGdmVRSsleWV7ZvDKbcJWxKe8szpo3gCCmNdMeKvfA5haKKKfh4sXfxocdKDhiXBpi
         +kzJ3hdlhW3skypGg6JTxl1HqLwTl7o6R31voRxwcr1c3KavaQKv1aNK2Idw4BsM5i
         vwDqwgrLkd+AAU7I/QUmHQ3z/V7mj2Eq3L9PQAAW7Tip3WekUkuzwItwlxHJJc/TVl
         5+EdX0B8lXwPg==
Date:   Mon, 25 Jan 2021 15:30:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: set WQ_SYSFS on all workqueues
Message-ID: <20210125233002.GH7698@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142799960.2173328.12558377173737512680.stgit@magnolia>
 <20210124095454.GG670331@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124095454.GG670331@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 24, 2021 at 09:54:54AM +0000, Christoph Hellwig wrote:
> >  	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
> > -			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
> > -			mp->m_super->s_id);
> > +			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI,
> > +			0, mp->m_super->s_id);
> 
> This is just used for log I/O completions which are effectlively single
> thread.  I don't see any reason to adjust the parameters here.
> 
> >  	if (!log->l_ioend_workqueue)
> >  		goto out_free_iclog;
> >  
> > diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> > index a06661dac5be..b6dab34e361d 100644
> > --- a/fs/xfs/xfs_mru_cache.c
> > +++ b/fs/xfs/xfs_mru_cache.c
> > @@ -294,7 +294,7 @@ int
> >  xfs_mru_cache_init(void)
> >  {
> >  	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache",
> > -				WQ_MEM_RECLAIM|WQ_FREEZABLE, 1);
> > +				WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 1);
> >  	if (!xfs_mru_reap_wq)
> >  		return -ENOMEM;
> 
> This one also hasn't ever been something we tune, so I don't think there
> is a good case for enabling WQ_SYSFS.

Yeah, the only ones I want to push for (and hence document) are
quotacheck, background blockgc, and (in 5.13) background inode
inactivation.

> I've stopped here.  I think we should have a good use case for making
> workqueues show up in sysfs based on that we:
> 
>  a) have resons to adjust them ever
>  b) actually having them easily discoverable and documented for adminds
>     to tune

TBH I think the only workqueues we really ought to expose publicly are
the unbound ones, since they represent kernel threads that can log
transactions, and hence are known to have a performance impact that
sysadmins could tune reasonably.

Dave suggests exposing them all on a debug kernel, of course. :)

--D
