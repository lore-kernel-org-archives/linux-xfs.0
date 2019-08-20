Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F3CC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 22:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4398D216F4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 22:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfHTWrM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 18:47:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44811 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730638AbfHTWrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 18:47:11 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6466743C621;
        Wed, 21 Aug 2019 08:47:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0Ct6-0001Gb-2M; Wed, 21 Aug 2019 08:46:00 +1000
Date:   Wed, 21 Aug 2019 08:46:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: fix geometry calls on older kernels for 5.2.1
Message-ID: <20190820224600.GI1119@dread.disaster.area>
References: <7d83cd0d-8a15-201e-9ebf-e1f859270b92@sandeen.net>
 <20190820211828.GC1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820211828.GC1037350@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=06siI641TgNblo_UBYoA:9
        a=ORV8YEe1-9RMHKGV:21 a=9D-fd6phwaKbtu2H:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 02:18:28PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 20, 2019 at 03:47:29PM -0500, Eric Sandeen wrote:
> > I didn't think 5.2.0 through; the udpate of the geometry ioctl means
> > that the tools won't work on older kernels that don't support the
> > v5 ioctls, since I failed to merge Darrick's wrappers.
> > 
> > As a very quick one-off I'd like to merge this to just revert every
> > geometry call back to the original ioctl, so it keeps working on
> > older kernels and I'll release 5.2.1.  This hack can go away when
> > Darrick's wrappers get merged.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> For the four line code fix,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> > ---
> > 
> > I'm a little concerned that 3rd party existing code which worked fine
> > before will now get the new XFS_IOC_FSGEOMETRY definition if they get
> > rebuilt, and suddenly stop working on older kernels. Am I overreacting
> > or misunderstanding our compatibility goals?
> 
> As for this question ^^^ ... <URRRK>.
> 
> I thought the overall strategy was to get everything in xfsprogs using
> libfrog wrappers that would degrade gracefully on old kernels.

The wrappers were a necessary part of the conversion. They should
have been merged with the rest of XFS_IOC_FSGEOMETRY changes. How
did this get broken up?

> For xfsdump/restore, I think we should just merge it into xfsprogs and
> then it can use our wrappers.

Don't need to care about dump/restore:

$ git grep FSGEOM
common/fs.c:    if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geo)) {
doc/CHANGES:      XFS_IOC_FSGEOMETRY instead of XFS_IOC_GETFSUUID ioctl, so
$

It only uses teh V1 ioctl.

As it is, the correct thing to do here is to put the fallback into
the xfsctl() function. This is actually an exported and documented
interface to use xfs ioctls by external problems - it's part of
libhandle(), and that should be obvious by the fact the man page
that describes all this is xfsctl(3).

i.e. any app using XFS ioctls should be using the xfsctl()
interface, not calling ioctl directly. The whole reason for that it
because it allows us to handle things like this in application
independent code....
 
So I'd suggest that the fallback code should be in the xfsctl
handler and then userspace will pick this up and won't care about
which kernel it is running on...

I suspect the bigger picture is to convert all the open ioctl()
calls in xfsprogs for XFS specific ioctls to xfsctl(). We've kinda
screwed this pooch since we stopped having to support multiple
platforms.

> For everything else... I thought the story was that you shouldn't really
> be using xfs ioctls unless you're keeping up with upstream.

Or you should be linked against libhandle and using xfsctl() to
be isolated from these sorts of things.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
