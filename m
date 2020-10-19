Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA733C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 22:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 743FB22284
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 22:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbgJSWg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 18:36:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52748 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388253AbgJSWgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 18:36:54 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C365058C414;
        Tue, 20 Oct 2020 09:36:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kUdlr-002IK2-0e; Tue, 20 Oct 2020 09:36:51 +1100
Date:   Tue, 20 Oct 2020 09:36:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/27] xfsprogs: convert use-once buffer reads to
 uncached IO
Message-ID: <20201019223651.GN7391@dread.disaster.area>
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-13-david@fromorbit.com>
 <20201015171239.GV9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015171239.GV9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=xLWNyae8_8MFG3-PZ5wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 10:12:39AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 06:21:40PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  db/init.c     |  2 +-
> >  libxfs/init.c | 93 ++++++++++++++++++++++++++++++---------------------
> >  2 files changed, 55 insertions(+), 40 deletions(-)
> > 
> > diff --git a/db/init.c b/db/init.c
> > index 19f0900a862b..f797df8a768b 100644
> > --- a/db/init.c
> > +++ b/db/init.c
> > @@ -153,7 +153,7 @@ init(
> >  	 */
> >  	if (sbp->sb_rootino != NULLFSINO &&
> >  	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > -		int error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
> > +		error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
> 
> Er... this and the xfs_check_sizes hoisting below don't have anything to
> do with uncached io conversion...?
> 
> >  		if (error) {
> >  			fprintf(stderr,
> >  	_("%s: cannot init perag data (%d). Continuing anyway.\n"),
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index fe784940c299..fc30f92d6fb2 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -419,7 +419,7 @@ done:
> >   */
> >  static int
> >  rtmount_init(
> > -	xfs_mount_t	*mp,	/* file system mount structure */
> > +	struct xfs_mount *mp,
> >  	int		flags)
> >  {
> >  	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
> > @@ -473,8 +473,9 @@ rtmount_init(
> >  			(unsigned long long) mp->m_sb.sb_rblocks);
> >  		return -1;
> >  	}
> > -	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1),
> > -			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> > +	error = libxfs_buf_read_uncached(mp->m_rtdev_targp,
> > +					d - XFS_FSB_TO_BB(mp, 1),
> > +					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
> >  	if (error) {
> >  		fprintf(stderr, _("%s: realtime size check failed\n"),
> >  			progname);
> > @@ -657,6 +658,52 @@ libxfs_buftarg_init(
> >  	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev);
> >  }
> >  
> > +/*
> > + * Check that the data (and log if separate) is an ok size.
> > + *
> > + * XXX: copied from kernel, needs to be moved to shared code
> 
> Ah, because you want to share this function with the kernel.
> 
> Hmm... what do you think about putting it in libxfs/xfs_sb.c ?

It's not really superblock functionality - it's buftarg
functionality - but I don't see anywhere else that is even vaguely
appropriate. And the buftarg implementation is not intendeed to be
shared code, so it doesn't fit there, either. :/

So, yeah, maybe that is the only suitable place it can be put. I'll
split it out into it's own patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
