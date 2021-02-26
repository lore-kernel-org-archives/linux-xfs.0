Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32935C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFBCA64EE2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 05:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhBZFCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 00:02:44 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:32985 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhBZFCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 00:02:43 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 16D1E48D46;
        Fri, 26 Feb 2021 16:02:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFVGI-004lr1-R7; Fri, 26 Feb 2021 16:01:58 +1100
Date:   Fri, 26 Feb 2021 16:01:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: initialise attr fork on inode create
Message-ID: <20210226050158.GW4662@dread.disaster.area>
References: <20210222230556.GR4662@dread.disaster.area>
 <20210225232153.GM7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225232153.GM7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=PbMJZtR6J4hZ3KS4GwUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 03:21:53PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 10:05:56AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >  STATIC int
> >  xfs_generic_create(
> >  	struct inode	*dir,
> > @@ -161,7 +192,9 @@ xfs_generic_create(
> >  		goto out_free_acl;
> >  
> >  	if (!tmpfile) {
> > -		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
> > +		error = xfs_create(XFS_I(dir), &name, mode, rdev,
> > +				xfs_create_need_xattr(dir, default_acl, acl),
> > +				&ip);
> >  	} else {
> >  		error = xfs_create_tmpfile(XFS_I(dir), mode, &ip);
> 
> Same question as last time: Do selinux or smack want to set xattr-based
> security labels on tempfiles too?

I think they do, but nobody has ever indicated that O_TMPFILE
creation to to be performance critical. Until someone comes to me
and says "concurrent O_TMPFILE creation at scale is really important
to our workload", I'm largely ignoring scalability issues for
tmpfile creation. Especially because AGI locks and the unlinked list
manipulations are the bottleneck here, not xattr creation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
