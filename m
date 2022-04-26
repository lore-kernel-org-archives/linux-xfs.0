Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683F5C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 02:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242394AbiDZCql (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiDZCql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 22:46:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E7614035
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 19:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A626B81BA9
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 02:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B658C385A7;
        Tue, 26 Apr 2022 02:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650941012;
        bh=mCuuTA78x5bmBLywVRgtbfqpei/K8sn15StqgxFWoM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5KN1yF8swNHffGLbo5uHEl2X8MzQseFYDv3eQJlrLBNYK615aAdJRNSrycFCsHOw
         tSuGnUT8mTaoqvCSxmfIM1MOPI3ialLO8o99VEoAE8gDELGNQP49p7Vyf0A3E2EbK3
         xUMj7NA4Q9/hoEy3ktiUZvCwMN0QRJGP3eDbQ74C0OkkyDFCBTfjlAswmCVSmuzB4t
         OO2KjwQTJHOAf24sY1iiDbqXIc7VrkUi56/fs6FceaRN1wNorM6vA4QBKxwUJqjsFF
         RHmyhB8zL+rVoQmKZvHMK5Th370pEfHNSBfXKdnOrVFsb+sf0HdTpRPX69hRim70XE
         wE20AerSmYGag==
Date:   Mon, 25 Apr 2022 19:43:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <20220426024331.GR17025@magnolia>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
 <20220425222140.GI1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425222140.GI1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 08:21:40AM +1000, Dave Chinner wrote:
> On Mon, Apr 25, 2022 at 01:19:35PM -0500, Eric Sandeen wrote:
> > On 4/21/22 11:58 AM, Catherine Hoang wrote:
> > > Hi all,
> > > 
> > > Based on recent discussion, it seems like there is a consensus that quota
> > > warning limits should be removed from xfs quota.
> > > https://lore.kernel.org/linux-xfs/94893219-b969-c7d4-4b4e-0952ef54d575@sandeen.net/
> > > 
> > > Warning limits in xfs quota is an unused feature that is currently
> > > documented as unimplemented. These patches remove the quota warning limits
> > > and cleans up any related code. 
> > > 
> > > Comments and feedback are appreciated!
> > > 
> > > Catherine
> > > 
> > > Catherine Hoang (2):
> > >   xfs: remove quota warning limit from struct xfs_quota_limits
> > >   xfs: don't set warns on the id==0 dquot
> > > 
> > >  fs/xfs/xfs_qm.c          |  9 ---------
> > >  fs/xfs/xfs_qm.h          |  5 -----
> > >  fs/xfs/xfs_qm_syscalls.c | 19 +++++--------------
> > >  fs/xfs/xfs_quotaops.c    |  3 ---
> > >  fs/xfs/xfs_trans_dquot.c |  3 +--
> > >  5 files changed, 6 insertions(+), 33 deletions(-)
> > 
> > I have a question about the remaining warning counter infrastructure after these
> > patches are applied.
> > 
> > We still have xfs_dqresv_check() incrementing the warning counter, as was added in
> > 4b8628d5 "xfs: actually bump warning counts when we send warnings"
> > 
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -589,6 +589,7 @@
> >                         return QUOTA_NL_ISOFTLONGWARN;
> >                 }
> >  
> > +               res->warnings++;
> >                 return QUOTA_NL_ISOFTWARN;
> >         }
> 
> /me reads another overnight #xfs explosion over this one line of
> code and sighs.
> 
> Well, so much for hoping that there would be an amicable resolution
> to this sorry saga without having to get directly involved.  I'm fed
> up with watching the tantrums, the petty arguments, the refusal to
> compromise, acknowledge mistakes, etc.
> 
> Enough, OK?
> 
> Commit 4b8628d5 is fundamentally broken and causes production
> systems regressions - it just doesn't work in any useful way as it
> stands.  Eric, send me a patch that reverts this commit, and I will
> review and commit it.
> 
> Further:
> 
> - this is legacy functionality that was never implemented in Linux,
> - it cannot be implemented in Linux the (useful) way it was
>   implemented in Irix,
> - it is documented as unimplemented,
> - no use case for the functionality in Linux has been presented
>   ("do something useful" is not a use case),
> - no documentation has been written for it,
> - no fstests coverage of the functionality exists,
> - linux userspace already has quota warning infrastructure via
>   netlink so just accounting warnings in the kernel is of very
>   limited use,
> - it broke existing production systems.
> 
> Given all this, and considering our new policy of not tolerating
> unused or questionable legacy code in the XFS code base any more
> (precendence: ALLOCSP), it is clear that all aspects of this quota
> warning code should simply be removed ASAP.
> 
> Eric and/or Catherine, please send patches to first revert 4b8628d5
> and then remove *all* of this quota warning functionality completely
> (including making the user APIs see zeros on all reads and sliently
> ignore all writes) before I get sufficiently annoyed to simply
> remove the code directly myself.
> 
> So disappointment.

Yeah.  I'm sorry for the role I played in that, though later Eric and I
sorted out quota stuff.  I have burned out and I need to stop working
50+ hour weeks.  *After* I stopped being maintainer and dropped 30% of
my workload, I thought I'd feel better, but instead:

The biggest problem right now is that the pagecache is broken in 5.18
and apparently I'm the only person who can trigger this.  It's the same
problem willy and I have been working on since -rc1 (where the
filemap/iomap debug asserts trip on generic/068 and generic/475) that's
documented on the fsdevel list.  Unfortunately, I don't have much time
to work on this, because as team lead:

Every week I have to go teach a new person how reflink works, and how to
make VM disk image reflinking not stall the VM until it gets evicted by
the cluster manager.  They haven't fixed the problem yet, but every week
I can start over with a new person who isn't familiar with the situation
at all.

No matter how many distro bugs I clear per week, the same number of new
reports are filed.  Almost all of them have me chasing corner cases and
things that you'd think people wouldn't do, but no, tomorrow I have to
teach people that the fs will crash and burn **when they unplug the
storage**.  You'd think I could just close these things, but then people
fight me on that, they argue with me about how this or that works on
XFS, and when I tell them they're wrong, they just say "Are you sure??"

Syzbot.  At least the Hulk Robot people actually send patches.

That attr fork UAF thing -- adding smp_wmb/rmb made the symptoms go
away, but as I was writing up the commit message I realized that the
race window is still there.  Maybe I'll come up with a way to make the
incore attr fork stick around, though both attempts so far have exploded
on impact.

Every week I lose somewhere between 10-70 emails because of some
combination of overzealous spam filters on my kernel.org account, IT
logging me out of random things, and Outlook.  I never have any idea if
anyone is trying to reach me.

Also the furnace is failing and I need to replace that.  $spouse has
handled most of it but it's hard to get contractors to give us
estimates, and between that and weeks of tax return preparation hell
(five different jurisdictions, five separate calculations and five
separate returns!  Thanks, US tax system!) there's nothing left.

This whole quota warning thing has dragged on longer than necessary
because I'm wiped out and do not know or have the mental energy to
figure out how to deprecate this feature.  I'll ack whatever people send
to make it go away.

Sorry everyone.  I probably should not come back.  I will not be
attending LSFMM, not even virtually.  I don't have the mental health to
pull that off.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
