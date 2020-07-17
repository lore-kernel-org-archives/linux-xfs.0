Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD34C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3AC2207BC
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGQBLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:11:43 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:47277 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbgGQBLn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:11:43 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D98B45ECBFC;
        Fri, 17 Jul 2020 11:11:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwEuZ-0001tf-FU; Fri, 17 Jul 2020 11:11:39 +1000
Date:   Fri, 17 Jul 2020 11:11:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: improve ondisk dquot flags checking
Message-ID: <20200717011139.GY2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488198306.3813063.16348101518917273554.stgit@magnolia>
 <20200717001359.GW2005@dread.disaster.area>
 <20200717010528.GK3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717010528.GK3151642@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=dK6iRUtyjZiKHoUV-ngA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 06:05:28PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 17, 2020 at 10:13:59AM +1000, Dave Chinner wrote:
> > On Wed, Jul 15, 2020 at 11:46:23PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create an XFS_DQTYPE_ANY mask for ondisk dquots flags, and use that to
> > > ensure that we never accept any garbage flags when we're loading dquots.
> > > While we're at it, restructure the quota type flag checking to use the
> > > proper masking.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_dquot_buf.c |   11 ++++++++---
> > >  fs/xfs/libxfs/xfs_format.h    |    2 ++
> > >  2 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > Ok, I looked at this and questioned why it existed and why the
> > code didn't just use XFS_DQTYPE_REC_MASK directly. I think this
> > change exists because you plan on adding a new on-disk flag for
> > bigtime support and hence XFS_DQTYPE_ANY will grow to include the
> > new flag, right?
> 
> Correct.
> 
> > If so, can you add that to the commit message?
> 
> Ok, will do.

Thanks. With that:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
