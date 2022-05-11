Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42908C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 01:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiEKBKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 21:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239955AbiEKBKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 21:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FA8210BB9
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE99C61A46
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 01:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFE9C385D6;
        Wed, 11 May 2022 01:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652231416;
        bh=RXSE/xhE7wMwtcg4RPHEayqvV0fwCCtYighgped2gkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rrFoNtpZvIO6OHgAKpIaHT1Ef6av3gaLEeWze2DvP9KWwsrepry8ssl/vtPElNNYE
         rdZeVhHuMZpGc8MZXSO8UHKHmU9bPc4XB+vjw4aHFGyOuCIXqjpxpPBSX72SLDU0f3
         Bk0gh/ZeuXhSBpwEjIamHCn3POaap/3/DIqe4Eje+WgJoAe+2G+J5n5OTgmf5X0Flb
         9ufQuhWcrVN1U3tBGKyn0PkICY9inUGL0AsxhGnaflqK/4hyY1eVZLnAvUMXwW8VwX
         9LURo/0L0k41CZNJUkr1oK+5NAiwCx6F/x01EQRE9kwmyOV7Kl1yAu/QqxTJ4djj18
         Qsnc/6jufWaHQ==
Date:   Tue, 10 May 2022 18:10:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/18] xfs: can't use kmem_zalloc() for attribute buffers
Message-ID: <20220511011016.GC27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220510222716.GW1098723@dread.disaster.area>
 <20220510235931.GX27195@magnolia>
 <20220511005420.GX1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511005420.GX1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 10:54:20AM +1000, Dave Chinner wrote:
> On Tue, May 10, 2022 at 04:59:31PM -0700, Darrick J. Wong wrote:
> > On Wed, May 11, 2022 at 08:27:16AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Because when running fsmark workloads with 64kB xattrs, heap
> > > allocation of >64kB buffers for the attr item name/value buffer
> > > will fail and deadlock.
> .....
> > > @@ -119,11 +119,11 @@ xfs_attri_item_format(
> > >  			sizeof(struct xfs_attri_log_format));
> > >  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
> > >  			attrip->attri_name,
> > > -			xlog_calc_iovec_len(attrip->attri_name_len));
> > > +			attrip->attri_name_len);
> > 
> > Are we fixing these because the xlog_{copy,finish}_iovec functions do
> > the rounding themselves now?
> 
> Yes, I forgot that I cleaned this up here when I noticed it.
> Probably should mention it in the commit log:
> 
> "We also clean up the attribute name and value lengths as they no
> longer need to be rounded out to sizes compatible with log vectors."

Ok.

> > 
> > >  	if (attrip->attri_value_len > 0)
> > >  		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> > >  				attrip->attri_value,
> > > -				xlog_calc_iovec_len(attrip->attri_value_len));
> > > +				attrip->attri_value_len);
> > >  }
> > >  
> > >  /*
> > > @@ -163,26 +163,21 @@ xfs_attri_init(
> > >  
> > >  {
> > >  	struct xfs_attri_log_item	*attrip;
> > > -	uint32_t			name_vec_len = 0;
> > > -	uint32_t			value_vec_len = 0;
> > > -	uint32_t			buffer_size;
> > > -
> > > -	if (name_len)
> > > -		name_vec_len = xlog_calc_iovec_len(name_len);
> > > -	if (value_len)
> > > -		value_vec_len = xlog_calc_iovec_len(value_len);
> > 
> > ...and we don't need to bloat up the internal structures anymore either,
> > right?
> 
> Yup, because we only copy out the exact length of the name/val now.

<nod>

> > 
> > > -
> > > -	buffer_size = name_vec_len + value_vec_len;
> > > +	uint32_t			buffer_size = name_len + value_len;
> > >  
> > >  	if (buffer_size) {
> > > -		attrip = kmem_zalloc(sizeof(struct xfs_attri_log_item) +
> > > -				    buffer_size, KM_NOFS);
> > > -		if (attrip == NULL)
> > > -			return NULL;
> > > +		/*
> > > +		 * This could be over 64kB in length, so we have to use
> > > +		 * kvmalloc() for this. But kvmalloc() utterly sucks, so we
> > > +		 * use own version.
> > > +		 */
> > > +		attrip = xlog_kvmalloc(sizeof(struct xfs_attri_log_item) +
> > > +					buffer_size);
> > >  	} else {
> > > -		attrip = kmem_cache_zalloc(xfs_attri_cache,
> > > -					  GFP_NOFS | __GFP_NOFAIL);
> > > +		attrip = kmem_cache_alloc(xfs_attri_cache,
> > > +					GFP_NOFS | __GFP_NOFAIL);
> > >  	}
> > > +	memset(attrip, 0, sizeof(struct xfs_attri_log_item));
> > 
> > I wonder if this memset should be right after the xlog_kvmalloc and
> > leave the kmem_cache_zalloc alone?
> 
> Then we memset the header twice in the common small attr case, and
> the xfs_attri_log_item header is not exactly what you'd call small
> (224 bytes).

Eh, ok, NBD.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
