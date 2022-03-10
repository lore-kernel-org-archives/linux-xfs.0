Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78573C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 01:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiCJBvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 20:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiCJBvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 20:51:51 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93F83127D62
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 17:50:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D967110E2D05;
        Thu, 10 Mar 2022 12:50:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nS7x3-003bnF-9J; Thu, 10 Mar 2022 12:50:49 +1100
Date:   Thu, 10 Mar 2022 12:50:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: reserve quota for dir expansion when
 linking/unlinking files
Message-ID: <20220310015049.GA3927073@dread.disaster.area>
References: <164685374120.495923.2523387358442198692.stgit@magnolia>
 <164685374682.495923.2923492909223420951.stgit@magnolia>
 <20220309214821.GH661808@dread.disaster.area>
 <20220309233302.GE8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309233302.GE8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62295979
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=x7-iSg9MmjYYeIP6ZiUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 03:33:02PM -0800, Darrick J. Wong wrote:
> On Thu, Mar 10, 2022 at 08:48:21AM +1100, Dave Chinner wrote:
> > On Wed, Mar 09, 2022 at 11:22:26AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >  		if (error)
> > >  			goto error_return;
> > >  	}
> > > @@ -2755,6 +2749,7 @@ xfs_remove(
> > >  	xfs_mount_t		*mp = dp->i_mount;
> > >  	xfs_trans_t             *tp = NULL;
> > >  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
> > > +	int			dontcare;
> > >  	int                     error = 0;
> > >  	uint			resblks;
> > >  
> > > @@ -2781,22 +2776,13 @@ xfs_remove(
> > >  	 * block from the directory.
> > >  	 */
> > >  	resblks = XFS_REMOVE_SPACE_RES(mp);
> > > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
> > > -	if (error == -ENOSPC) {
> > > -		resblks = 0;
> > > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
> > > -				&tp);
> > > -	}
> > > +	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
> > > +			&tp, &dontcare);
> > >  	if (error) {
> > >  		ASSERT(error != -ENOSPC);
> > >  		goto std_return;
> > >  	}
> > 
> > So we just ignore -EDQUOT when it is returned in @dontcare? I'd like
> > a comment to explain why we don't care about EDQUOT here, because
> > the next time I look at this I will have forgotten all about this...
> 
> Ok.  How about:
> 
> 	/*
> 	 * We try to get the real space reservation first, allowing for
> 	 * directory btree deletion(s) implying possible bmap insert(s).
> 	 * If we can't get the space reservation then we use 0 instead,
> 	 * and avoid the bmap btree insert(s) in the directory code by,
> 	 * if the bmap insert tries to happen, instead trimming the LAST
> 	 * block from the directory.
> 	 *
> 	 * Ignore EDQUOT and ENOSPC being returned via nospace_error
> 	 * because the directory code can handle a reservationless
> 	 * update and we don't want to prevent a user from trying to
> 	 * free space by deleting things.
> 	 */
> 	error = xfs_trans_alloc_dir(...);

Yeah, that looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
