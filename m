Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26514C2D0E2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 21:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18B7221E8
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 21:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgIVV0u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 17:26:50 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40629 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbgIVV0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 17:26:50 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AE8D23A8366;
        Wed, 23 Sep 2020 07:26:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kKpoE-0003ni-L0; Wed, 23 Sep 2020 07:26:46 +1000
Date:   Wed, 23 Sep 2020 07:26:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200922212646.GP12131@dread.disaster.area>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
 <20200922044428.GA4284@xiangao.remote.csb>
 <20200922160328.GG7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922160328.GG7955@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=9H7fhBpbkTgvMFdmzcgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 09:03:28AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 22, 2020 at 12:44:28PM +0800, Gao Xiang wrote:
> > On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> > > From: Gao Xiang <hsiangkao@redhat.com>
> > > 
> > > Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> > > tree"), there is no m_peraglock anymore, so it's hard to understand
> > > the described situation since per-ag is no longer an array and no
> > > need to reallocate, call xfs_filestream_flush() in growfs.
> > > 
> > > In addition, the race condition for shrink feature is quite confusing
> > > to me currently as well. Get rid of it instead.
> > > 
> > 
> > (Add some words) I think I understand what the race condition could mean
> > after shrink fs is landed then, but the main point for now is inconsistent
> > between code and comment, and there is no infrastructure on shrinkfs so
> > when shrink fs is landed, the locking rule on filestream should be refined
> > or redesigned and xfs_filestream_flush() for shrinkfs which was once
> > deleted by 1c1c6ebcf52 might be restored to drain out in-flight
> > xfs_fstrm_item for these shrink AGs then.
> > 
> > From the current code logic, the comment has no use and has been outdated
> > for years. Keep up with the code would be better IMO to save time.
> 
> Not being familiar with the filestream code at all, I wonder, what
> replaced all that stuff?  Does that need a comment?  I can't really tell
> at a quick glance what coordinates growfs with filestreams.

The filestream perag state would get trashed by the realloc of the
perag array that growfs used to do. Hence the filestreams had to be
flushed before growfs could realloc the array so there was no state
that could be lost by a grow. The m_peraglock was needed to
serialise that. Moving to the current perag tree setup meant grow no
longer reallocated perag structures, so they didn't go away
transiently and lose state any more, hence none of the flushing or
perag locking was needed anymore.

Shrink is a different matter altogether. The shrink context is going
to have to flush the filestreams itself after it makes sure that new
filestreams can't be created in that AG.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
