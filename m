Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B1CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiERAUd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiERAUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E9B53A54
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFCC61520
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA45C385B8;
        Wed, 18 May 2022 00:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652833230;
        bh=rgiHRKc+Ny6vvfhXvHhPQZ9IXaLgT+Le59yBPrkXx4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=spcc2MPmxStGO35tMPiVe3TFkYp+pv46JRc6pof/2xsooj2hcFDPemMKEgs5+iT6N
         I7QWGsS5tHrGJf7uyZ5foOGpKCRiKmdKUmz2xBe/GugojtAxvPFhRU9PVw/eGqkspl
         RTmEsmtf7a7foSum8WiddUyjTVwBdVI2N4bNhdCKdWLd++jZLZjsgd2dU9TNGk60gr
         /gtkpPft88TnyDWQF/Z8NmFWd03gwk1f837Mm0sR6oBsM6GeGioWkhPDtmm/7cohxg
         nIzpQPrSfUR9GCJmFidfH00tNrXaOK8L5fZWgfcQkWKVUIAqsOGKR5pLjXt2dgYAT2
         Lgvm+H8LSEqXA==
Date:   Tue, 17 May 2022 17:20:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/6] xfs: use a separate slab cache for deferred xattr
 work state
Message-ID: <YoQ7zS/GYuKRzAdw@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
 <165267195530.626272.4057756502482755002.stgit@magnolia>
 <8dfac8aee25f51f3db994cacd6ab65329848d730.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dfac8aee25f51f3db994cacd6ab65329848d730.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 17, 2022 at 11:20:46AM -0700, Alli wrote:
> On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a separate slab cache for struct xfs_attr_item objects, since
> > we
> > can pack the (96-byte) intent items more tightly than we can with the
> > general slab cache objects.  On x86, this means 42 intents per memory
> > page instead of 32.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c  |   20 +++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_attr.h  |    4 ++++
> >  fs/xfs/libxfs/xfs_defer.c |    4 ++++
> >  fs/xfs/xfs_attr_item.c    |    5 ++++-
> >  4 files changed, 31 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 0f88f6e17101..687e1b0c49f9 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -29,6 +29,7 @@
> >  
> >  struct kmem_cache		*xfs_attri_cache;
> >  struct kmem_cache		*xfs_attrd_cache;
> > +struct kmem_cache		*xfs_attr_intent_cache;
> Functionally this looks ok.  It does make me think that at some point
> we may want to look at improving the log item naming scheme in general.

<nod>

> It was my observation that most items have a xfs_*i_cache and an xfs_*d
> _cache which I think stand for "intent" and "done" caches respectively
> (?).   And now were adding another xfs_attr_intent_cache, but I feel
> like if I were new to the code, it wouldnt be immediately clear why
> there is a xfs_attri_cache and a xfs_attr_intent_cache.

The distinction between the three (XXXi, XXXd, XXX_intent) wasn't
entirely clear to me either, years ago.  TBH, it didn't fully come into
focus for me until 2020 when I wrote the log-assisted extent swapping
code, since it was the first piece of code I touched where deferred work
could happen without log items.

Here's my current understanding of how the three pieces fit together.
You probably already know this, but I'll post it all here for everyone
else following along at home:

The deferred work item (aka that huge state machine coded up in
xfs_attr_set_iter) is a high level filesystem operation that does a
bunch of complex work using a series of smaller transactions.  The big
operation needs to store a bunch of in-memory state as it progresses
through the operation; this is what's stored in xfs_XXX_intent.

(If I had to do it all over again, I'd probably have named this
differently, such as xfs_rmap_deferred instead of xfs_rmap_intent; and
the slab caches xfs_rmap_deferred_cache instead of
xfs_rmap_intent_cache.)

If a deferred work item wants to support restarting an operation after a
crash, it needs to log a "log intent item" to the first transaction
where it commits to doing an operation.  This is what log recovery picks
up in those _commit_pass2 functions, so the log intent item must contain
whatever breadcrumbs are needed to figure out where in the complex
operation was the filesystem when it crashed.

Each time the deferred work item makes some progress, it should log a
"log intent done item" to the same transaction in which it made
progress, which serves as a tombstone for the recovered intent item.  If
there's more work to be done, the deferred work item must also log a new
"log intent item" reflecting the updated internal deferred work state.

The log intent items are usually named xfs_XXXi_log_item, and the log
intent done items are usually named xfs_XXXd_log_item.  The caches are
named xfs_XXXi_cache and xfs_XXXd_cache.

Note: Deferred work items are /not/ required to use the log to track
progress.  This can happen if the user-visible effects of the operation
are idempotent (defragmenting with fsr) or if the operations are staged
in such an order that inconsistency is not possible (xattr INCOMPLETE
flags).

> Initially I had modeled attrs from the extent free code which called it
> an "xfs_extent_free_item", hence the name "xfs_attr_item".  So i
> suppose in that scheme we're logging items to intent items. But it
> looks like rmap and bmap call them intents (xfs_rmap_intent and
> xfs_bmap_intent).  Which I guess would suggest we log intents to intent
> items?  So now this leaves extent free the weird one. :-)

Yeah.  The naming is weird.  Maybe some day I'll do a treewide change
and fix all this stuff, since "item" is a bit vague to me and confusable
with log items... and an "item/intent" doesn't even necessarily have an
associated log item!  The thing is, renaming like that makes rebasing
developer trees that much harder, which is why I haven't done that.

> In any case, I do think having the extra cache is an improvement so:
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>> 

Thanks!

> But it does make me think that xfs_*i/d_cache could use some clarity
> perhaps as a separate cleanup effort.  Maybe xfs_*i/d_item_cache or
> something like that.

Hmm.  I'll ponder that. :)

--D

> >  
> >  /*
> >   * xfs_attr.c
> > @@ -902,7 +903,7 @@ xfs_attr_item_init(
> >  
> >  	struct xfs_attr_item	*new;
> >  
> > -	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> > +	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS |
> > __GFP_NOFAIL);
> >  	new->xattri_op_flags = op_flags;
> >  	new->xattri_da_args = args;
> >  
> > @@ -1650,3 +1651,20 @@ xfs_attr_namecheck(
> >  	/* There shouldn't be any nulls here */
> >  	return !memchr(name, 0, length);
> >  }
> > +
> > +int __init
> > +xfs_attr_intent_init_cache(void)
> > +{
> > +	xfs_attr_intent_cache = kmem_cache_create("xfs_attr_item",
> > +			sizeof(struct xfs_attr_item),
> > +			0, 0, NULL);
> > +
> > +	return xfs_attr_intent_cache != NULL ? 0 : -ENOMEM;
> > +}
> > +
> > +void
> > +xfs_attr_intent_destroy_cache(void)
> > +{
> > +	kmem_cache_destroy(xfs_attr_intent_cache);
> > +	xfs_attr_intent_cache = NULL;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index c739caa11a4b..cb3b3d270569 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -634,4 +634,8 @@ xfs_attr_init_replace_state(struct xfs_da_args
> > *args)
> >  	return xfs_attr_init_add_state(args);
> >  }
> >  
> > +extern struct kmem_cache *xfs_attr_intent_cache;
> > +int __init xfs_attr_intent_init_cache(void);
> > +void xfs_attr_intent_destroy_cache(void);
> > +
> >  #endif	/* __XFS_ATTR_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index ceb222b4f261..ed65f7e5a9c7 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -877,6 +877,9 @@ xfs_defer_init_item_caches(void)
> >  	if (error)
> >  		goto err;
> >  	error = xfs_attrd_init_cache();
> > +	if (error)
> > +		goto err;
> > +	error = xfs_attr_intent_init_cache();
> >  	if (error)
> >  		goto err;
> >  	return 0;
> > @@ -889,6 +892,7 @@ xfs_defer_init_item_caches(void)
> >  void
> >  xfs_defer_destroy_item_caches(void)
> >  {
> > +	xfs_attr_intent_destroy_cache();
> >  	xfs_attri_destroy_cache();
> >  	xfs_attrd_destroy_cache();
> >  	xfs_extfree_intent_destroy_cache();
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 930366055013..89cabd792b7d 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -404,7 +404,10 @@ xfs_attr_free_item(
> >  {
> >  	if (attr->xattri_da_state)
> >  		xfs_da_state_free(attr->xattri_da_state);
> > -	kmem_free(attr);
> > +	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
> > +		kmem_free(attr);
> > +	else
> > +		kmem_cache_free(xfs_attr_intent_cache, attr);
> >  }
> >  
> >  /* Process an attr. */
> > 
> 
