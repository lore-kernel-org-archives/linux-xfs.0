Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42690C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CBEC64ECE
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhBRSsb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234951AbhBRSCB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 13:02:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1011264EAD;
        Thu, 18 Feb 2021 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613671280;
        bh=jl6jw0Yz6cCIeXPJaWnAp4aHd1FDhf1t+33BefN0vLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bbd38mh+HoiFSQN1HVSp5MGPMHTOrB1X/WbDJk2HT4S6tmMip5hUDMiKLcqMPtkOL
         pDGGyvAlKk/T9nMOd8sxaByeiRa25bgWPgJESH0UACzMfp54mPwu8Pr4vW0trkBD1x
         siDnEQ58/eC67dlMmofurP/D7Dsnlx/cN+m59ssFMgLfpipeYMIFL0Oq9QWEzzxf8h
         4C3z6JdFdJjnuHlvUNBKaxMH2EfE8b6fI4987SfneZJH6xs6RDHSVFqgMbfxdHwrcT
         c2sd4xgQO76aZ16AgXLuDm2+jPueJ0BNokEe8bLVJKO1TqmVBASDpgrAEGwrR1H6WK
         zYL6VDcY4zGOw==
Date:   Thu, 18 Feb 2021 10:01:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: add post-phase error injection points
Message-ID: <20210218180119.GW7193@magnolia>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319522176.422860.4620061453225202229.stgit@magnolia>
 <20210216115839.GD534175@bfoster>
 <20210218044729.GS7193@magnolia>
 <20210218130228.GC685651@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218130228.GC685651@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 08:02:28AM -0500, Brian Foster wrote:
> On Wed, Feb 17, 2021 at 08:47:29PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 16, 2021 at 06:58:39AM -0500, Brian Foster wrote:
> > > On Fri, Feb 12, 2021 at 09:47:01PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Create an error injection point so that we can simulate repair failing
> > > > after a certain phase.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  repair/globals.c    |    3 +++
> > > >  repair/globals.h    |    3 +++
> > > >  repair/progress.c   |    3 +++
> > > >  repair/xfs_repair.c |    4 ++++
> > > >  4 files changed, 13 insertions(+)
> > > > 
> > > > 
> > > ...
> > > > diff --git a/repair/progress.c b/repair/progress.c
> > > > index e5a9c1ef..5bbe58ec 100644
> > > > --- a/repair/progress.c
> > > > +++ b/repair/progress.c
> > > > @@ -410,6 +410,9 @@ timestamp(int end, int phase, char *buf)
> > > >  		current_phase = phase;
> > > >  	}
> > > >  
> > > > +	if (fail_after_phase && phase == fail_after_phase)
> > > > +		kill(getpid(), SIGKILL);
> > > > +
> > > 
> > > It seems a little hacky to bury this in timestamp(). Perhaps we should
> > > at least check for end == PHASE_END (even though PHASE_START is
> > > currently only used in one place). Otherwise seems reasonable..
> > 
> > Yeah, I don't know of a better place to put it -- adding another call
> > after every timestamp() just seems like clutter.
> > 
> 
> I was thinking that factoring timestamp() into a new post-phase helper
> seemed a relatively simple cleanup.

Ok, will do.

--D

> Brian
> 
> > Will fix it to check for PHASE_END, though.
> > 
> > Thanks for reading. :)
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  	if (buf) {
> > > >  		tmp = localtime((const time_t *)&now);
> > > >  		sprintf(buf, _("%02d:%02d:%02d"), tmp->tm_hour, tmp->tm_min, tmp->tm_sec);
> > > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > > index 12e319ae..6b60b8f4 100644
> > > > --- a/repair/xfs_repair.c
> > > > +++ b/repair/xfs_repair.c
> > > > @@ -362,6 +362,10 @@ process_args(int argc, char **argv)
> > > >  
> > > >  	if (report_corrected && no_modify)
> > > >  		usage();
> > > > +
> > > > +	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
> > > > +	if (p)
> > > > +		fail_after_phase = (int)strtol(p, NULL, 0);
> > > >  }
> > > >  
> > > >  void __attribute__((noreturn))
> > > > 
> > > 
> > 
> 
