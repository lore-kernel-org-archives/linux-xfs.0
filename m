Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BF4C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 06:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 150CD20722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 06:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgGAG0K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 02:26:10 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:33581 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbgGAG0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 02:26:10 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 80E601A94C2;
        Wed,  1 Jul 2020 16:26:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqWC7-0003Uh-D3; Wed, 01 Jul 2020 16:26:07 +1000
Date:   Wed, 1 Jul 2020 16:26:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: introduce inode unlink log item
Message-ID: <20200701062607.GS2005@dread.disaster.area>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-5-david@fromorbit.com>
 <20200630181942.GP7606@magnolia>
 <20200630223159.GA10152@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630223159.GA10152@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=YgaauvNrWGKJMVYiuxAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 06:31:59AM +0800, Gao Xiang wrote:
> On Tue, Jun 30, 2020 at 11:19:42AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 23, 2020 at 07:50:15PM +1000, Dave Chinner wrote:
> 
> ...
> 
> > > +
> > > +static uint64_t
> > > +xfs_iunlink_item_sort(
> > > +	struct xfs_log_item	*lip)
> > > +{
> > > +	return IUL_ITEM(lip)->iu_ino;
> > > +}
> > 
> > Oh, I see, ->iop_sort is supposed to return a sorting key for each log
> > item so that we can reorder the iunlink items to take locks in the
> > correct order.
> 
> Yes, so I'm not sure the naming of ->iop_sort... When I first saw the name,
> I thought it would be a compare function. (but after I read the code of
> xfs_trans_precommit_sort(), I found I'm wrong...)

Yeah, it's intended to return a sorting key, not do a sort. Naming
is hard, and this is an RFC so it's expected that the naming will
weird and need improvement. :)

As it is, I suspect that a generic filesystem object wide sorting
mechanism needs to be more complex than just returning a single 64
bit key. I think it will work generically if the key reference frame
is the same for all object - I kinda just chose the object's location
on disk for the reference frame and hence the use of the inode
number as the sort key value here.

However, I'm not 100% sure how that would end up working if we have
the object we are trying to sort doesn't have a defined physical
location.  That doesn't seem to be an issue right now - all of the
objects I want to sort have phsyical locations - so I've largely
ignored it this side of the problem. If we need to, we can change
how the sorting works when sorting by physical location is no longer
sufficient as this is purely an in-memory ordering issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
