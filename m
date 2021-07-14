Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628A5C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B7CF613C9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 09:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbhGNJs0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:48:26 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:45588 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238271AbhGNJs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 05:48:26 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 947D86933C;
        Wed, 14 Jul 2021 19:45:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3bSP-006Ogi-4N; Wed, 14 Jul 2021 19:45:33 +1000
Date:   Wed, 14 Jul 2021 19:45:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <20210714094533.GY664593@dread.disaster.area>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-4-david@fromorbit.com>
 <YO6LCbZWRz3q4JRg@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO6LCbZWRz3q4JRg@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=5HK6nBeeUcFlUIFmgfwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 07:58:17AM +0100, Christoph Hellwig wrote:
> > +	/*
> > +	 * Now that we've recovered any pending superblock feature bit
> > +	 * additions, we can finish setting up the attr2 behaviour for the
> > +	 * mount. If no attr2 mount options were specified, the we use the
> > +	 * behaviour specified by the superblock feature bit.
> > +	 */
> > +	if (!(mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) &&
> 
> Missing spaces around the |.
> 
> > +	if ((mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) ==
> > +			  (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) {
> > +		xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
> > +		return -EINVAL;
> > +	}
> 
> Same here.
> 
> > +
> > +
> >  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> 
> Double empty line.

Will fix.

> More importantly I wonder if we can simplify this further:
> 
>  - completely ignore the attr2 option (we already warn about it being
>    deprecated) and remove XFS_MOUNT_ATTR2
>  - just check for XFS_MOUNT_NOATTR2 do disable automatically switching
>    to v2 attrs

That's what happens later in the patchset. The XFS_FEAT_ATTR2 is
set when either the mount option or the on-disk sb flag is set, and
it is overridden after log recovery (which can set the SB flag) if
the XFS_FEAT_NOATTR2 feature has been specified.

> And maybe as a service to the user warn when the noattr2 option is
> specified on a file system that already has v2 attrs.

That can be added, but I don't see the point - it will jsut add a
new warning that can be ignored to every mount for such users.

<shrug>

See what others think, and I'll do whatever falls out...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
