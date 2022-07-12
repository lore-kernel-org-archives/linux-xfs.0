Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E62C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 00:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiGLABJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 20:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiGLABG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 20:01:06 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E7A62C656
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 17:01:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 856D910E84DC;
        Tue, 12 Jul 2022 10:01:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB3Kq-00HOVG-E1; Tue, 12 Jul 2022 10:01:04 +1000
Date:   Tue, 12 Jul 2022 10:01:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: merge xfs_buf_find() and xfs_buf_get_map()
Message-ID: <20220712000104.GJ3861211@dread.disaster.area>
References: <20220707235259.1097443-1-david@fromorbit.com>
 <20220707235259.1097443-4-david@fromorbit.com>
 <YsuxqAoM0IWD7CaE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsuxqAoM0IWD7CaE@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62ccb9c1
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=wXuDweK0hUcjAH0N0xgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 10, 2022 at 10:14:16PM -0700, Christoph Hellwig wrote:
> On Fri, Jul 08, 2022 at 09:52:56AM +1000, Dave Chinner wrote:
> > index 91dc691f40a8..81ca951b451a 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -531,18 +531,16 @@ xfs_buf_map_verify(
> >  
> >  static int
> >  xfs_buf_find_lock(
> > -	struct xfs_buftarg	*btp,
> >  	struct xfs_buf          *bp,
> >  	xfs_buf_flags_t		flags)
> >  {
> >  	if (!xfs_buf_trylock(bp)) {
> >  		if (flags & XBF_TRYLOCK) {
> > -			xfs_buf_rele(bp);
> > -			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
> > +			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
> >  			return -EAGAIN;
> >  		}
> >  		xfs_buf_lock(bp);
> > -		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
> > +		XFS_STATS_INC(bp->b_mount, xb_get_locked_waited);
> >  	}
> >  
> >  	/*
> 
> Not doing this to start with in the previous patch still feels
> rather odd.

Oops, missed that. Will fix.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
