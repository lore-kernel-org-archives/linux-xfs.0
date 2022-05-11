Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1D1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 00:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbiEKAyY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 20:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiEKAyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 20:54:24 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 099FA522D0
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 17:54:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E5425534506;
        Wed, 11 May 2022 10:54:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noacO-00AUuX-4Q; Wed, 11 May 2022 10:54:20 +1000
Date:   Wed, 11 May 2022 10:54:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/18] xfs: can't use kmem_zalloc() for attribute buffers
Message-ID: <20220511005420.GX1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220510222716.GW1098723@dread.disaster.area>
 <20220510235931.GX27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510235931.GX27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=627b093e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=jaZkWtyvtoCeetgN7UkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 04:59:31PM -0700, Darrick J. Wong wrote:
> On Wed, May 11, 2022 at 08:27:16AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because when running fsmark workloads with 64kB xattrs, heap
> > allocation of >64kB buffers for the attr item name/value buffer
> > will fail and deadlock.
.....
> > @@ -119,11 +119,11 @@ xfs_attri_item_format(
> >  			sizeof(struct xfs_attri_log_format));
> >  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> >  			attrip->attri_name,
> > -			xlog_calc_iovec_len(attrip->attri_name_len));
> > +			attrip->attri_name_len);
> 
> Are we fixing these because the xlog_{copy,finish}_iovec functions do
> the rounding themselves now?

Yes, I forgot that I cleaned this up here when I noticed it.
Probably should mention it in the commit log:

"We also clean up the attribute name and value lengths as they no
longer need to be rounded out to sizes compatible with log vectors."

> 
> >  	if (attrip->attri_value_len > 0)
> >  		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> >  				attrip->attri_value,
> > -				xlog_calc_iovec_len(attrip->attri_value_len));
> > +				attrip->attri_value_len);
> >  }
> >  
> >  /*
> > @@ -163,26 +163,21 @@ xfs_attri_init(
> >  
> >  {
> >  	struct xfs_attri_log_item	*attrip;
> > -	uint32_t			name_vec_len = 0;
> > -	uint32_t			value_vec_len = 0;
> > -	uint32_t			buffer_size;
> > -
> > -	if (name_len)
> > -		name_vec_len = xlog_calc_iovec_len(name_len);
> > -	if (value_len)
> > -		value_vec_len = xlog_calc_iovec_len(value_len);
> 
> ...and we don't need to bloat up the internal structures anymore either,
> right?

Yup, because we only copy out the exact length of the name/val now.

> 
> > -
> > -	buffer_size = name_vec_len + value_vec_len;
> > +	uint32_t			buffer_size = name_len + value_len;
> >  
> >  	if (buffer_size) {
> > -		attrip = kmem_zalloc(sizeof(struct xfs_attri_log_item) +
> > -				    buffer_size, KM_NOFS);
> > -		if (attrip == NULL)
> > -			return NULL;
> > +		/*
> > +		 * This could be over 64kB in length, so we have to use
> > +		 * kvmalloc() for this. But kvmalloc() utterly sucks, so we
> > +		 * use own version.
> > +		 */
> > +		attrip = xlog_kvmalloc(sizeof(struct xfs_attri_log_item) +
> > +					buffer_size);
> >  	} else {
> > -		attrip = kmem_cache_zalloc(xfs_attri_cache,
> > -					  GFP_NOFS | __GFP_NOFAIL);
> > +		attrip = kmem_cache_alloc(xfs_attri_cache,
> > +					GFP_NOFS | __GFP_NOFAIL);
> >  	}
> > +	memset(attrip, 0, sizeof(struct xfs_attri_log_item));
> 
> I wonder if this memset should be right after the xlog_kvmalloc and
> leave the kmem_cache_zalloc alone?

Then we memset the header twice in the common small attr case, and
the xfs_attri_log_item header is not exactly what you'd call small
(224 bytes).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
