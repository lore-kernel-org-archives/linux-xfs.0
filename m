Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396C6C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9F4233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfH2KpV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 06:45:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45602 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbfH2KpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 06:45:21 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A9D2943D207;
        Thu, 29 Aug 2019 20:45:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HvY-00032E-1v; Thu, 29 Aug 2019 20:45:16 +1000
Date:   Thu, 29 Aug 2019 20:45:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: allocate xattr buffer on demand
Message-ID: <20190829104516.GU1119@dread.disaster.area>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-4-david@fromorbit.com>
 <20190829075559.GC18966@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829075559.GC18966@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=afKqoqfF4qHBqeDAvzYA:9 a=slx7vdCkXqdxHpr7:21
        a=pq4Bp7Y_Q7bjjSxN:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 12:55:59AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 28, 2019 at 02:23:50PM +1000, Dave Chinner wrote:
> > + * If ATTR_ALLOC is set in @flags, allocate the buffer for the value after
> > + * existence of the attribute has been determined. On success, return that
> > + * buffer to the caller and leave them to free it. On failure, free any
> > + * allocated buffer and ensure the buffer pointer returned to the caller is
> > + * null.
> 
> Given that all three callers pass ATTR_ALLOC, do we even need a flag

Only one caller passes ATTR_ALLOC - the ACL code. The other two
have their own buffers that are supplied....

> and keep the old behavior around, at least at the xfs_attr_get level?
> For the lower level we still have scrub, but that fills out the args
> structure directly.
> 
> > +static int
> > +xfs_attr_copy_value(
> > +	struct xfs_da_args	*args,
> > +	unsigned char		*value,
> > +	int			valuelen)
> > +{
> > +	/*
> > +	 * No copy if all we have to do is get the length
> > +	 */
> > +	if (args->flags & ATTR_KERNOVAL) {
> > +		args->valuelen = valuelen;
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * No copy if the length of the existing buffer is too small
> > +	 */
> > +	if (args->valuelen < valuelen) {
> > +		args->valuelen = valuelen;
> > +		return -ERANGE;
> > +	}
> > +
> > +	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
> > +		args->value = kmem_alloc_large(valuelen, KM_SLEEP);
> > +		if (!args->value)
> > +			return -ENOMEM;
> > +	}
> > +	args->valuelen = valuelen;
> 
> Can't we just move the setting of ->valuelen up to common code shared
> between all the branches?  That means it would also be set on an
> allocation error, but that should be harmless.

Can't overwrite args->valuelen until we've done the ERANGE check.
Sure, I could put it in a local variable, but that doesn't reduce
the amount of code, or make it obvious that we intentionally return
the attribute size when the supplied buffer it too small...

> > +	/* remote block xattr requires IO for copy-in */
> > +	if (args->rmtblkno)
> > +		return xfs_attr_rmtval_get(args);
> > +
> > +	/*
> > +	 * This is to prevent a GCC warning because the remote xattr case
> > +	 * doesn't have a value to pass in. In that case, we never reach here,
> > +	 * but GCC can't work that out and so throws a "passing NULL to
> > +	 * memcpy" warning.
> > +	 */
> > +	if (!value)
> > +		return -EINVAL;
> > +	memcpy(args->value, value, valuelen);
> > +	return 0;
> > +}
> 
> Can you split creating this helper into a separate prep patch?  While
> not strictly required it would make reviewing what is consolidation
> vs what is new code for the on-demand buffer allocation a little easier.

ok.

> > +	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
> > +				ATTR_ALLOC|ATTR_ROOT);
> 
> Please keep space between the symbols and | on each side.

Fixed.

-- 
Dave Chinner
david@fromorbit.com
