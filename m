Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEBCC43381
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A5B22EBD
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731833AbhAZFT1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731923AbhAZCeK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 21:34:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F1A22D58;
        Tue, 26 Jan 2021 02:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611628409;
        bh=ePdhuxKJxmU0fxnzWnm49AvD7zbY2ULe/2nZQccEEBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eul8+ATyZbo+LXK3E4n7BsBioPsan8kfLt7vRlIsC2g+p9LJ4jJlFyQRbBOAXGZYl
         rEgR3USaP0JFmCvP4oyxb3jFzM+9OAPSKT17psNnJF4Hs5xslag5PtCN+Jo5hrhqY8
         NMgD+svrpg67EkhmwDao00tY3okqHjCuAJi29F3gF1/Q2z7vGQk+lWI53Za3EGjmOm
         GEj9wmq2tcorvXilrOGFjGuEewPCQyFGpP+5Mf4Bu0sGQRRADttpVLEPYzOYHcCZHh
         YTV1a065AbKM1qpsZ3dmB83LVTsWpcYE9jbG663nGomFbiseDbnlecrT+Mw+IoYRAD
         CyzX0wpynp4PQ==
Date:   Mon, 25 Jan 2021 18:33:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 10/11] xfs: refactor xfs_icache_free_{eof,cow}blocks call
 sites
Message-ID: <20210126023327.GK7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142797509.2171939.4924852652653930954.stgit@magnolia>
 <20210125184601.GN2047559@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125184601.GN2047559@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 01:46:01PM -0500, Brian Foster wrote:
> On Sat, Jan 23, 2021 at 10:52:55AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In anticipation of more restructuring of the eof/cowblocks gc code,
> > refactor calling of those two functions into a single internal helper
> > function, then present a new standard interface to purge speculative
> > block preallocations and start shifting higher level code to use that.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_file.c   |    3 +--
> >  fs/xfs/xfs_icache.c |   39 +++++++++++++++++++++++++++++++++------
> >  fs/xfs/xfs_icache.h |    1 +
> >  fs/xfs/xfs_trace.h  |    1 +
> >  4 files changed, 36 insertions(+), 8 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 7f999f9dd80a..0d228a5e879f 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1645,6 +1645,38 @@ xfs_start_block_reaping(
> >  	xfs_queue_cowblocks(mp);
> >  }
> >  
> > +/* Scan all incore inodes for block preallocations that we can remove. */
> > +static inline int
> > +xfs_blockgc_scan(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_eofblocks	*eofb)
> > +{
> > +	int			error;
> > +
> > +	error = xfs_icache_free_eofblocks(mp, eofb);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_icache_free_cowblocks(mp, eofb);
> > +	if (error)
> > +		return error;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Try to free space in the filesystem by purging eofblocks and cowblocks.
> > + */
> > +int
> > +xfs_blockgc_free_space(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_eofblocks	*eofb)
> > +{
> > +	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
> > +
> > +	return xfs_blockgc_scan(mp, eofb);
> > +}
> > +
> 
> What's the need for two helpers instead of just
> xfs_blockgc_free_space()? Otherwise seems fine.

The whole mess of helpers are combined in interesting ways in the "xfs:
consolidate posteof and cowblocks cleanup" patchset that follows this
one.  The xfs_iwalk_ag loops under xfs_icache_free_{eof,cow}blocks get
hoisted to xfs_blockgc_free_space so we only do the iteration once.

Hm, I guess an additional optimization would be to combine them in the
final product as a patch 10/9.

--D

> Brian
> 
> >  /*
> >   * Run cow/eofblocks scans on the supplied dquots.  We don't know exactly which
> >   * quota caused an allocation failure, so we make a best effort by including
> > @@ -1661,7 +1693,6 @@ xfs_blockgc_free_dquots(
> >  	struct xfs_eofblocks	eofb = {0};
> >  	struct xfs_mount	*mp = NULL;
> >  	bool			do_work = false;
> > -	int			error;
> >  
> >  	if (!udqp && !gdqp && !pdqp)
> >  		return 0;
> > @@ -1699,11 +1730,7 @@ xfs_blockgc_free_dquots(
> >  	if (!do_work)
> >  		return 0;
> >  
> > -	error = xfs_icache_free_eofblocks(mp, &eofb);
> > -	if (error)
> > -		return error;
> > -
> > -	return xfs_icache_free_cowblocks(mp, &eofb);
> > +	return xfs_blockgc_free_space(mp, &eofb);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 5f520de637f6..583c132ae0fb 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -57,6 +57,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
> >  int xfs_blockgc_free_dquots(struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> >  		struct xfs_dquot *pdqp, unsigned int eof_flags);
> >  int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
> > +int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
> >  
> >  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
> >  void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 4cbf446bae9a..c3fd344aaf5b 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3926,6 +3926,7 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
> >  		 unsigned long caller_ip), \
> >  	TP_ARGS(mp, eofb, caller_ip))
> >  DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
> > +DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
> >  
> >  #endif /* _TRACE_XFS_H */
> >  
> > 
> 
