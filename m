Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376A3C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA372076D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGQBS3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:18:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60236 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726238AbgGQBS3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:18:29 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6D6627EB4FF;
        Fri, 17 Jul 2020 11:18:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwF12-0001uG-B8; Fri, 17 Jul 2020 11:18:20 +1000
Date:   Fri, 17 Jul 2020 11:18:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK
 uses
Message-ID: <20200717011820.GZ2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488197022.3813063.2727213433560259185.stgit@magnolia>
 <20200717000242.GU2005@dread.disaster.area>
 <20200717010715.GL3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717010715.GL3151642@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=cDZLbgclfRnVaZRc2wgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 06:07:15PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 17, 2020 at 10:02:42AM +1000, Dave Chinner wrote:
> > On Wed, Jul 15, 2020 at 11:46:10PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Fix a few places where we open-coded this mask constant.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_dquot_item_recover.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> > > index d7eb85c7d394..93178341569a 100644
> > > --- a/fs/xfs/xfs_dquot_item_recover.c
> > > +++ b/fs/xfs/xfs_dquot_item_recover.c
> > > @@ -39,7 +39,7 @@ xlog_recover_dquot_ra_pass2(
> > >  	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
> > >  		return;
> > >  
> > > -	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
> > > +	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
> > >  	ASSERT(type);
> > >  	if (log->l_quotaoffs_flag & type)
> > >  		return;
> > > @@ -91,7 +91,7 @@ xlog_recover_dquot_commit_pass2(
> > >  	/*
> > >  	 * This type of quotas was turned off, so ignore this record.
> > >  	 */
> > > -	type = recddq->d_flags & (XFS_DQTYPE_USER | XFS_DQTYPE_PROJ | XFS_DQTYPE_GROUP);
> > > +	type = recddq->d_flags & XFS_DQTYPE_REC_MASK;
> > 
> > Couldn't these both be converted to xfs_dquot_type(recddq)?
> 
> xfs_dquot_type takes a pointer to a incore dquot, not a struct
> xfs_disk_dquot, so no.

Ah, right, I didn't notice the recddq type mismatch there. Ok, code
is fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
