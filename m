Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7ABDC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 03:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241667AbiETDWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 23:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiETDWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 23:22:12 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A1445932F
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 20:22:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1465C53462A;
        Fri, 20 May 2022 13:22:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrtDL-00E62x-0k; Fri, 20 May 2022 13:22:07 +1000
Date:   Fri, 20 May 2022 13:22:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/3] xfs: share xattr name and value buffers when logging
 xattr updates
Message-ID: <20220520032207.GA1098723@dread.disaster.area>
References: <165290010248.1646163.12346986876716116665.stgit@magnolia>
 <165290011382.1646163.15379392968983343462.stgit@magnolia>
 <20220519002727.GR1098723@dread.disaster.area>
 <YoaHkOVuBDbF8+XD@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoaHkOVuBDbF8+XD@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62870961
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=G2iu8kol_LjX9X6A0gAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 11:08:16AM -0700, Darrick J. Wong wrote:
> On Thu, May 19, 2022 at 10:27:27AM +1000, Dave Chinner wrote:
> > On Wed, May 18, 2022 at 11:55:13AM -0700, Darrick J. Wong wrote:
> > > @@ -158,41 +239,17 @@ xfs_attri_item_release(
> > >  STATIC struct xfs_attri_log_item *
> > >  xfs_attri_init(
> > >  	struct xfs_mount		*mp,
> > > -	uint32_t			name_len,
> > > -	uint32_t			value_len)
> > > -
> > > +	struct xfs_attri_log_nameval	*anvl)
> > >  {
> > >  	struct xfs_attri_log_item	*attrip;
> > > -	uint32_t			buffer_size = name_len + value_len;
> > >  
> > > -	if (buffer_size) {
> > > -		/*
> > > -		 * This could be over 64kB in length, so we have to use
> > > -		 * kvmalloc() for this. But kvmalloc() utterly sucks, so we
> > > -		 * use own version.
> > > -		 */
> > > -		attrip = xlog_kvmalloc(sizeof(struct xfs_attri_log_item) +
> > > -					buffer_size);
> > > -	} else {
> > > -		attrip = kmem_cache_alloc(xfs_attri_cache,
> > > -					GFP_NOFS | __GFP_NOFAIL);
> > > -	}
> > > -	memset(attrip, 0, sizeof(struct xfs_attri_log_item));
> > > +	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_NOFS | __GFP_NOFAIL);
> > >  
> > > -	attrip->attri_name_len = name_len;
> > > -	if (name_len)
> > > -		attrip->attri_name = ((char *)attrip) +
> > > -				sizeof(struct xfs_attri_log_item);
> > > -	else
> > > -		attrip->attri_name = NULL;
> > > -
> > > -	attrip->attri_value_len = value_len;
> > > -	if (value_len)
> > > -		attrip->attri_value = ((char *)attrip) +
> > > -				sizeof(struct xfs_attri_log_item) +
> > > -				name_len;
> > > -	else
> > > -		attrip->attri_value = NULL;
> > > +	/*
> > > +	 * Grab an extra reference to the name/value buffer for this log item.
> > > +	 * The caller retains its own reference!
> > > +	 */
> > > +	attrip->attri_nameval = xfs_attri_log_nameval_get(anvl);
> > 
> > Handle _get failure here, or better, pass in an already referenced
> > nv because the caller should always have a reference to begin
> > with. Caller can probably handle allocation failure, too, because
> > this should be called before we've dirtied the transaction, right?
> 
> _nameval_get merely bumps the refcount, so the caller should already
> have a valid reference to begin with.  So I think the _get function can
> become:
> 
> 	if (!refcount_inc_not_zero(anvl..))
> 		return NULL;
> 	return val;
> 
> and then this callsite can add a simple ASSERT to ensure that we never
> pass around a zero-refcount object (in theory the refcount code will
> also fail loudly):
> 
> 	attrip->attri_nameval = xfs_attri_log_nameval_get(anvl);
> 	ASSERT(attrip->attri_nameval);

I'm fine with that - it documents that the get should not fail at
this point.

> 
> > .....
> > 
> > > @@ -385,16 +435,33 @@ xfs_attr_create_intent(
> > >  	 * Each attr item only performs one attribute operation at a time, so
> > >  	 * this is a list of one
> > >  	 */
> > > -	list_for_each_entry(attr, items, xattri_list) {
> > > -		attrip = xfs_attri_init(mp, attr->xattri_da_args->namelen,
> > > -					attr->xattri_da_args->valuelen);
> > > -		if (attrip == NULL)
> > > -			return NULL;
> > > +	attr = list_first_entry_or_null(items, struct xfs_attr_item,
> > > +			xattri_list);
> > >  
> > > -		xfs_trans_add_item(tp, &attrip->attri_item);
> > > -		xfs_attr_log_item(tp, attrip, attr);
> > > +	/*
> > > +	 * Create a buffer to store the attribute name and value.  This buffer
> > > +	 * will be shared between the higher level deferred xattr work state
> > > +	 * and the lower level xattr log items.
> > > +	 */
> > > +	if (!attr->xattri_nameval) {
> > > +		struct xfs_da_args	*args = attr->xattri_da_args;
> > > +
> > > +		/*
> > > +		 * Transfer our reference to the name/value buffer to the
> > > +		 * deferred work state structure.
> > > +		 */
> > > +		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
> > > +				args->namelen, args->value, args->valuelen);
> > > +	}
> > > +	if (!attr->xattri_nameval) {
> > > +		xlog_force_shutdown(mp->m_log, SHUTDOWN_LOG_IO_ERROR);
> > > +		return NULL;
> > >  	}
> > 
> > Why shutdown on ENOMEM? I would have expects that we return to the
> > caller so it can cancel the transaction. That way we only shut down
> > if the transaction is dirty or the caller context can't handle
> > errors....
> 
> ->create_intent can return NULL if they don't need to log any intent
> items to restart a piece of deferred work.  xfs_defer_create_intent*()
> currently have no means to convey an errno up to their callers, but that
> could be a preparatory cleanup.

Ok, if you add a brief comment then I'm fine with it. The cleanup so
we have error paths here can be done later.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
