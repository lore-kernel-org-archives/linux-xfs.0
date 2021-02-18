Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5017BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 04:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15DA964E76
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 04:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBREsN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 23:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhBREsK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Feb 2021 23:48:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FCBB64E6F;
        Thu, 18 Feb 2021 04:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613623650;
        bh=FfSAxAwlrcsQGD7XAPOH98yCo42EMSVoZ3qvQKtJxxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gbFuVu+7LvPPQqpl40Bzw9CeS7u2RM17jqZiHTZkq2KPH7OKrzNr3B18v3pSyZYzd
         fazQnT6DVJNIyV4Kq4JFtepsaU45qNujNB/oveAJH0n2gQekuCPP5JcE509e0uqLic
         0fWoAgllxvE+0Ejtey5AbUQMuzw04stowDuRotU2nuA5v83I1mWgWv4NeRAhJUX6gf
         L5U9cIn3Zfe0lV5oERXoIVwxnLlyjzxtKYZpzY0Jvs/DpPZF2JXoQ1yytd2ykJWiYX
         nxPlMp4yCUBM2m79X8BtNjnHu9zN+alNd6yGx6ZOfZoBLkV2/icQI8ILGAhqrYF0S0
         rtwpDkvGq0o9w==
Date:   Wed, 17 Feb 2021 20:47:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: add post-phase error injection points
Message-ID: <20210218044729.GS7193@magnolia>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319522176.422860.4620061453225202229.stgit@magnolia>
 <20210216115839.GD534175@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216115839.GD534175@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 16, 2021 at 06:58:39AM -0500, Brian Foster wrote:
> On Fri, Feb 12, 2021 at 09:47:01PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create an error injection point so that we can simulate repair failing
> > after a certain phase.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  repair/globals.c    |    3 +++
> >  repair/globals.h    |    3 +++
> >  repair/progress.c   |    3 +++
> >  repair/xfs_repair.c |    4 ++++
> >  4 files changed, 13 insertions(+)
> > 
> > 
> ...
> > diff --git a/repair/progress.c b/repair/progress.c
> > index e5a9c1ef..5bbe58ec 100644
> > --- a/repair/progress.c
> > +++ b/repair/progress.c
> > @@ -410,6 +410,9 @@ timestamp(int end, int phase, char *buf)
> >  		current_phase = phase;
> >  	}
> >  
> > +	if (fail_after_phase && phase == fail_after_phase)
> > +		kill(getpid(), SIGKILL);
> > +
> 
> It seems a little hacky to bury this in timestamp(). Perhaps we should
> at least check for end == PHASE_END (even though PHASE_START is
> currently only used in one place). Otherwise seems reasonable..

Yeah, I don't know of a better place to put it -- adding another call
after every timestamp() just seems like clutter.

Will fix it to check for PHASE_END, though.

Thanks for reading. :)

--D

> Brian
> 
> >  	if (buf) {
> >  		tmp = localtime((const time_t *)&now);
> >  		sprintf(buf, _("%02d:%02d:%02d"), tmp->tm_hour, tmp->tm_min, tmp->tm_sec);
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 12e319ae..6b60b8f4 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -362,6 +362,10 @@ process_args(int argc, char **argv)
> >  
> >  	if (report_corrected && no_modify)
> >  		usage();
> > +
> > +	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
> > +	if (p)
> > +		fail_after_phase = (int)strtol(p, NULL, 0);
> >  }
> >  
> >  void __attribute__((noreturn))
> > 
> 
