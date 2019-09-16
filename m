Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418B5C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 22:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EFE9214D9
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 22:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfIPWAM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 18:00:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52626 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbfIPWAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 18:00:12 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1A32043D7E3;
        Tue, 17 Sep 2019 08:00:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i9z2X-00014S-2G; Tue, 17 Sep 2019 08:00:09 +1000
Date:   Tue, 17 Sep 2019 08:00:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH] [RFC] xfs: fix inode fork extent count overflow
Message-ID: <20190916220009.GA16973@dread.disaster.area>
References: <20190911012107.26553-1-david@fromorbit.com>
 <20190916162005.GX2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916162005.GX2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=b6BuWpJeRDr661KbwH0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 09:20:05AM -0700, Darrick J. Wong wrote:
> On Wed, Sep 11, 2019 at 11:21:07AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > And that's the behaviour I just saw in a nutshell. The on disk count
> > is correct, but once the tree is loaded into memory, it goes whacky.
> > Clearly there's something wrong with xfs_iext_count():
> > 
> > inline xfs_extnum_t xfs_iext_count(struct xfs_ifork *ifp)
> > {
> >         return ifp->if_bytes / sizeof(struct xfs_iext_rec);
> > }
> > 
> > Simple enough, but 134M extents is 2**27, and that's right about
> 
> On the plus side, 2^27 is way better than the last time anyone tried to
> create an egregious number of extents.

Well, we'd get to 2^26 (~65M extents) before memory allocation
stopped progress...

> > Current testing is at over 500M extents and still going:
> > 
> > fsxattr.nextents = 517310478
> > 
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks reasonable to me; did Zorro retest w/ this patch?

No idea, but I got to 1.3B extents before the VM ran out of RAM and
oom-killed itself to death - the extent list took up >47GB of the
48GB of RAM I gave the VM. At some point we are going to have to
think about demand paging extent lists....

> If so,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
