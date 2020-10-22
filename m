Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3ADEC4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 08:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98472223BF
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 08:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443784AbgJVIPK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 04:15:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46614 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2443612AbgJVIPJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 04:15:09 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A729F58C0CB;
        Thu, 22 Oct 2020 19:15:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVVkX-0036yQ-Rr; Thu, 22 Oct 2020 19:15:05 +1100
Date:   Thu, 22 Oct 2020 19:15:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] repair: protect inode chunk tree records with a mutex
Message-ID: <20201022081505.GT7391@dread.disaster.area>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-4-david@fromorbit.com>
 <20201022060256.GO9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022060256.GO9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=frA0HDwQyOGo51hoZwoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 21, 2020 at 11:02:56PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 04:15:33PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Phase 6 accesses inode chunk records mostly in an isolated manner.
> > However, when it finds a corruption in a directory or there are
> > multiple hardlinks to an inode, there can be concurrent access
> > to the inode chunk record to update state.
> > 
> > Hence the inode record itself needs a mutex. This protects all state
> > changes within the inode chunk record, as well as inode link counts
> > and chunk references. That allows us to process multiple chunks at
> > once, providing concurrency within an AG as well as across AGs.
> > 
> > The inode chunk tree itself is not modified in phase 6 - it's built
> 
> Well, that's not 100% true -- mk_orphanage can do that, but AFAICT
> that's outside the scope of the parallel processing (and I don't see
> much point in parallelizing that part) so I guess that's fine?

AFAICT, yes.

> > in phases 3 and 4  - and so we do not need to worry about locking
> > for AVL tree lookups to find the inode chunk records themselves.
> > hence internal locking is all we need here.
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> TBH I wonder if all the phase6.c code to recreate the root dir, the
> orphanage, and the realtime inodes ought to get moved to another file,
> particularly since the metadata directory patches add quite a bit more
> stuff here?  But that's a topic for another patch...

Probably should and yes, spearate patch :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
