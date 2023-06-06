Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3494C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 03:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjFFDWx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 23:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjFFDWv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 23:22:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39212D
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 20:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94B0C622CF
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 03:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BB9C433D2;
        Tue,  6 Jun 2023 03:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686021769;
        bh=Tare70FegTn60t4s6BFO9cOK28G2EMtoNnjrvgzwKNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=btHdOBcj4phHlUPWWXJ3x1ReRwcEb9hHJo7cNOGDSvEEknSqgwmMbYbZszrZ70sRh
         Nc0w+oZjjCA0NJY1Q4b2LtU88/iPA4TSzJ/maMENg0wq3/P9Ql8RyBZVAs/x+UZvgr
         1UBJmzgy1mOasZPXnBZbgshFIKmHDMaV+FXCA0OJaU8cj+c4TAYFPeLr/xyKnTirM0
         KHCgI34yWoLTcbGJqBQbRiUa352hjSdEeQueI8cH/JmXFvFITeC4ufOh0lyFFJnbql
         zCgF2wZqT52tphlSE/0X480y1tGMKBqNnfLp2Y22o36BiOT/uUof6eH7FXIAkI29uR
         IEDxveumFksVA==
Date:   Mon, 5 Jun 2023 20:22:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        dchinner@redhat.com, linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Message-ID: <20230606032248.GE72267@frogsfrogsfrogs>
References: <87zg88atiw.fsf@doe.com>
 <33c9674c-8493-1b23-0efb-5c511892b68a@leemhuis.info>
 <20230418045615.GC360889@frogsfrogsfrogs>
 <57eeb4d5-01de-b443-be8e-50b08c132e95@leemhuis.info>
 <20230605215745.GC1325469@frogsfrogsfrogs>
 <ZH6d938Hw/msm95A@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH6d938Hw/msm95A@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 12:46:15PM +1000, Dave Chinner wrote:
> On Mon, Jun 05, 2023 at 02:57:45PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 05, 2023 at 03:27:43PM +0200, Thorsten Leemhuis wrote:
> > > /me waves friendly
> > > 
> > > On 18.04.23 06:56, Darrick J. Wong wrote:
> > > > On Mon, Apr 17, 2023 at 01:16:53PM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
> > > >> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
> > > >> for once, to make this easily accessible to everyone.
> > > >>
> > > >> Has any progress been made to fix below regression? It doesn't look like
> > > >> it from here, hence I wondered if it fall through the cracks. Or is
> > > >> there some good reason why this is safe to ignore?
> > > > 
> > > > Still working on thinking up a reasonable strategy to reload the incore
> > > > iunlink list if we trip over this.  Online repair now knows how to do
> > > > this[1], but I haven't had time to figure out if this will work
> > > > generally.  [...]
> > > 
> > > I still have this issue on my list of tracked regressions, hence please
> > > allow me to ask: was there any progress to resolve this? Doesn't look
> > > like it, but from my point it's easy to miss something.
> > 
> > Yeah -- Dave put "xfs: collect errors from inodegc for unlinked inode
> > recovery" in for-next yesterday, and I posted a draft of online repair
> > for the unlinked lists that corrects most of the other problems that we
> > found in the process of digging into this problem:
> > https://lore.kernel.org/linux-xfs/168506068642.3738067.3524976114588613479.stgit@frogsfrogsfrogs/T/#m861e4b1259d9b16b9970e46dfcfdae004a5dd634
> > 
> > But that's looking at things from the ground up, which isn't terribly
> > insightful as to what's going on, as you've noted. :)
> > 
> > > BTW, in case this was not yet addressed: if you have a few seconds,
> > > could you please (just briefly!) explain why it seems to take quite a
> > > while to resolve this? A "not booting" regressions sounds like something
> > > that I'm pretty sure Linus normally wants to see addressed rather sooner
> > > than later. But that apparently is not the case here. I know that XFS
> > > devs normally take regressions seriously, hence I assume there are good
> > > reasons for it. But I'd like to roughly understand them (is this a
> > > extremely corner case issue others are unlike to run into or something
> > > like that?), as I don't want Linus on my back with questions like "why
> > > didn't you put more pressure on the XFS maintainers" or "you should have
> > > told me about this".
> > 
> > First things first -- Ritesh reported problems wherein a freshly mounted
> > filesystem would fail soon after because of some issue or other with the
> > unlinked inode list.  He could reproduce this problem, but (AFAIK) he's
> > the only user who's actually reported this.  It's not like *everyone*
> > with XFS cannot boot anymore, it's just this system.  Given the sparsity
> > of any other reports with similar symptoms, I do not judge this to be
> > a hair-on-fire situation.
> > 
> > (Contrast this to the extent busy deadlock problem that Wengang Wang is
> > trying to solve, which (a) is hitting many customer systems and (b)
> > regularly.  Criteria like (a) make things like that a higher severity
> > problem IMHO.)
> 
> Contrast this to the regression from 6.3-rc1 that caused actual user
> data loss and filesystem corruption after 6.3 was released.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=2208553
> 
> That's so much more important than any problem seen in a test
> environment it's not funny.

Oh yeah, I'd forgotten about that one, probably because I was out on
vacation for nearly all of that.

Thank you Dave & Eric for fixing this quickly.

> We'd already fixed this regression that caused it in 6.4-rc1 - the
> original bug report (a livelock in data writeback) happened 2 days
> before 6.3 released. It took me 3 days from report to having a fix
> out for review (remember that timeframe).
> 
> At the time we didn't recognise the wider corruption risk the
> failure we found exposed us to, so we didn't push it to stable
> immediately. Hence when users started tripping over corruption and I
> triaged it down to misdirected data write from -somewhere-. Eric
> then found a reproducer and bisected to a range of XFS changes, and
> I then realised what the problem was....
> 
> Stuff like this takes days of effort and multiple people to get to
> the bottom of, and -everything else- gets ignored while we work
> through the corruption problem.
> 
> Thorsten, I'm betting that you didn't even know about this
> regression - it's been reported, tracked, triaged and fixed
> completely outside the scope and visibility of the "kernel
> regression tracker". Which clearly shows that we don't actually need
> some special kernel regression tracker infrastructure to do our jobs
> properly, nor do we need a nanny to make sure we actually are
> prioritising things correctly....

I mostly disagree -- nag emails are a bit annoying when I'm under
stress, yes, but OTOH I would not (and am not) saying no to another set
of eyes who some day might see something we don't see, and nudge us.
Like you did here.  Or someday you might be the first to spot (say) some
cross-fs problem that isn't so obvious to the rest of us who are
concentrating on a single subsys/fs/whatever.

You can choose not to nag Dave, but please keep sending me stuff. :)
I'd rather have you write something and say no than have you not write
something and then we never hear about it.

> ....
> 
> > Dave's patch addresses #5 by plumbing error returns up the stack so that
> > frontend processes that push the background gc threads can receive
> > errors and throw them out to userspace.
> 
> Right, the inodegc regression fix simply restored the previous
> status quo.  Nothing more, nothing less, exactly what we want
> regression fixes to do. But it took some time for me to get to
> because there were much higher priority events occurring....
> 
> ....
> 
> > The problem with putting this in online repair is that Dave (AFAIK)
> > feels very strongly that every bug report needs to be triaged
> > immediately, and that takes priority over reviewing new code such as
> > online repair.
> 
> My rationale is that we can ignore it once we know the scope of the
> issue, but until we know that information the risk of being
> unprepared for sudden escalation is rather high and that's even
> worse for stress and burnout levels.

Yeah, too bad a lot of xfs bugs are mismatches in thinking between
subcomponent authors & require deep analysis.  Occasionally we get
"lucky" and it's closer to the surface like the 6.3 corruption thing.
Other times it's broken stuff hiding deep.

> The fedora corruption bug I mention above is a canonical example of
> why triaging bug reports immediately is important - the original bug
> report was clearly somethign that needed to be fixed straight away,
> regardless of the fact we didn't know it could cause misdirected
> writes at the time.
> 
> Once we got far enough into the fedora bug report triage, I simply
> pointed the distro at the commit for them to test, and they did
> everything else. Once confirmation that it fixed the problem came
> in, I sent it immediately to the stable kernel maintainers.
> 
> IOWs, if I had not paid attention to the original bug report, it
> would have taken me several more days to find the problem and fix it
> (remember it took me ~3 days from report to fix originally).  Users
> would have been exposed to the corruption bug for much longer than
> they were, and that doesn't make a bad situation any better.
> 
> And don't get me started on syzkaller and "security researchers"
> raising inappropriate CVEs....

I won't.  We're severely understaffed, and that problem just got
worse.

> So, yeah, immediate triage is pretty much required at this point for
> all bug reports because the downstream impacts of ignoring them is
> only causing more stress and burnout risk for lots more people. The
> number of downstream people pulled into (and still dealing with the
> fallout of) that recent, completely unnecessary CVE fire drill was
> just ... crazy.

I saw the 39 rhbz sub-bugs from that one.  Wow.  What an abuse of
process to make you all endure that.

> We can choose to ignore triaged bug reports if they aren't important
> enough to deal with immediately (like this unlinked inode list
> issue), but we can make the decision (and justify it) based on the
> knowledge we have rather instead of claiming ignorance. We're
> supposed to be professional engineers, yes?

I was only here to collect dogecoin. :P

> > That's the right thing to do, but every time someone
> > sends in some automated fuzzer report, it slows down online repair
> > review.  This is why I'm burned out and cranky as hell about script
> > kiddies dumping zerodays on the list and doing no work to help us fix
> > the problems.
> 
> Reality sucks, and I hate it too. We get handed all the shit
> sandwiches and everyone seems to expect that we will simply to eat
> them up without complaining. But it's not like we didn't expect it -
> upstream Linux development has always been a great big shit sandwich
> and it's not going to be changing any time soon....

<sob>

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
