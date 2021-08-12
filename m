Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F619C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1706109F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhHLX5n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:57:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:41300 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhHLX5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 19:57:42 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 589601B4A8D;
        Fri, 13 Aug 2021 09:57:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mEKZW-0002JZ-Fl; Fri, 13 Aug 2021 09:57:14 +1000
Date:   Fri, 13 Aug 2021 09:57:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
Message-ID: <20210812235714.GF3657114@dread.disaster.area>
References: <20210812064222.GA20009@kili>
 <20210812214048.GE3657114@dread.disaster.area>
 <20210812224133.GY3601466@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812224133.GY3601466@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=iovoapXEdvDWmHL4:21 a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=2RqmLUb-O6GAleDFyNMA:9 a=CjuIK1q_8ugA:10 a=5XSRGvUTWXORsQhOJJ0S:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 03:41:33PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 13, 2021 at 07:40:48AM +1000, Dave Chinner wrote:
> > On Thu, Aug 12, 2021 at 09:42:22AM +0300, Dan Carpenter wrote:
> > > Hello Darrick J. Wong,
> > > 
> > > The patch c809d7e948a1: "xfs: pass the goal of the incore inode walk
> > > to xfs_inode_walk()" from Jun 1, 2021, leads to the following
> > > Smatch static checker warning:
> > > 
> > > 	fs/xfs/xfs_icache.c:52 xfs_icwalk_tag()
> > > 	warn: unsigned 'goal' is never less than zero.
> > > 
> > > fs/xfs/xfs_icache.c
> > >     49 static inline unsigned int
> > >     50 xfs_icwalk_tag(enum xfs_icwalk_goal goal)
> > >     51 {
> > > --> 52 	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;
> > > 
> > > This enum will be unsigned in GCC, so "goal" can't be negative.
> > 
> > I think this is incorrect. The original C standard defines enums as
> > signed integers, not unsigned. And according to the GCC manual
> > (section 4.9 Structures, Unions, Enumerations, and Bit-Fields)
> > indicates that C90 first defines the enum type to be compatible with
> > the declared values. IOWs, for a build using C89 like the kernel
> > does, enums should always be signed.
> > 
> > This enum is defined as:
> > 
> > enum xfs_icwalk_goal {
> >         /* Goals that are not related to tags; these must be < 0. */
> >         XFS_ICWALK_DQRELE       = -1,
> > 
> >         /* Goals directly associated with tagged inodes. */
> >         XFS_ICWALK_BLOCKGC      = XFS_ICI_BLOCKGC_TAG,
> >         XFS_ICWALK_RECLAIM      = XFS_ICI_RECLAIM_TAG,
> > };
> > 
> > i.e. the enum is defined to clearly contain negative values and so
> > GCC should be defining it as a signed integer regardless of the
> > version of C being used...
> > 
> > > Plus
> > > we only pass 0-1 for goal (as far as Smatch can tell).
> > 
> > Yup, smatch has definitely got that one wrong:
> > 
> > xfs_dqrele_all_inodes()
> >   xfs_icwalk(mp, XFS_ICWALK_DQRELE, &icw);
> >     xfs_icwalk_get_perag(.... XFS_ICWALK_DQRELE)
> >       xfs_icwalk_tag(... XFS_ICWALK_DQRELE, ...)
> > 
> > So this warning looks like an issue with smatch, not a bug in the
> > code...
> 
> ...unless Dan is running smatch against for-next, which removes
> XFS_ICWALK_DQRELE and thus allows for an unsigned type to back the enum?

Ah, I didn't realise that had gone away in the quotaoff removal -
I've kinda had my head stuck in fixing the journal/log recovery
problems recently.  Thanks for pointing out something I missed.

FWIW, I just assumed it was a current TOT being checked because
c809d7e948a1 was introduced in 5.14-rc1 and that's the commit smatch
is, IMO, incorrectly blaming.  Commit 777eb1fa857e ("xfs: remove
xfs_dqrele_all_inodes") which is the one in for-next that removed
the XFS_ICWALK_DQRELE definition from the enum and so, under C90,
gcc will turn the enum from from signed to unsigned. But we still
build the kernel under C89, so it's not clear to me that the smatch
assertion is correct...

Perhaps there might be some improvements that can be made to smatch
to handle this better. Knowing what tree was being checked would
also help us here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
