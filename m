Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2CDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 02:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0B661207
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 02:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhIPCiN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 22:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233825AbhIPCiN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 22:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B56160E97;
        Thu, 16 Sep 2021 02:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631759813;
        bh=Hgocm3QlSPrkxtGfGQI/VjT81Trc4nJd7a+448XONRE=;
        h=Date:From:To:Cc:Subject:From;
        b=r0egsyAvJAJrGi1miBV5rcTlSuqyqoEi7mKzC5QjmEEh9pMpN+DBV/dRB2fn5/Ecg
         XnxGgL1jlcSCkW6sKN3Qk0oXjHwi/njzZeOsl4frc3AqxrrkhoGLk4Q9P82rBdNM7B
         wTaFwG0TK8P8T2oC2wt5S6ef+izqLHxbLQkrdzJ2Lr8QHC5pkYXtoXz1sK8+XThRdU
         0dfvIU0mgvv84Gx6qjyS68op61FKEbDAnTfKRxjOddG6DFICiUW9a67MU4tYMuqA6V
         L1AufK6l4892nwdDNy0bTwAw3dfZsm84AkWM0bJg9jBvf7bUSm0xLVbFGS7WmyWsvX
         kT8XAGjE+ayOA==
Date:   Wed, 15 Sep 2021 19:36:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Bill O'Donnell <billodo@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: XFS Sprints
Message-ID: <20210916023652.GA34820@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi again,

Now that 5.15-rc1 is past, I would like to say something:

I've been reflecting on my (sharply higher) stress levels in 2021, and
realized that I don't enjoy our development process anymore.  One of the
nice things about being a co-maintainer is that I can take advantage of
the fact that suggesting improvements == leadership, though that comes
with the responsibility that leadership == actually making it happen.

The thing that has been bothering me these past few months is how we
decide what's going into the next merge window.  People send patchsets
at various points between the second week of the merge window and the
week after -rc6, and then ... they wait to see if anyone will actually
read them.  I or one of the maintainers will get to them eventually, but
as a developer it's hard to know if nobody's responding because they
don't like the patchset?  Or they're quietly on leave?  Or they're
drowning trying to get their own patchsets out to the list?  Or they
have too many bugs to triage and distro kernel backports?  Or they're
afraid of me?

Regardless, I've had the experience that it's stressful as the
maintainer looking at all the stuff needing review; it's stressful as a
developer trying to figure out if I'm /really/ going to make any
progress this cycle; and as a reviewer it's stressful keeping up with
both of these dynamics.  I've also heard similar sentiments from
everyone else.

The other problem I sense we're having is implied sole ownership of
patchesets being developed.  Reviewers make comments, but then it seems
like it's totally on the developer (as the applicant) to make all those
changes.  It's ... frustrating to watch new code stall because reviewers
ask for cleanups and code restructuring that are outside of the original
scope of the series as a condition for adding a Reviewed-by tag... but
then they don't work on those cleanups.

At that point, what's a developer to do?  Try to get someone else's
attention and start the review process all over again?  Try to get
another maintainer's attention and have them do it?  This last thing is
hard if you're already a maintainer, because doing that slows /everyone/
down.

(And yes, I've been growing our XFS team at Oracle this year so that
this doesn't seem so one-sided with RedHat.)

I've also heard from a few of you who find it offputting when patches
show up with verbiage that could be interpreted as "I know best and
won't take any further suggestions".  I agree with your feelings when
I hear complaints coming in, because my own thoughts had usually already
been "hmm, this sounds preemptively defensive, why?"

Ok, so, things I /do/ like:

During the 5.15 development cycle I really enjoyed going back and forth
with Dave over my deferred inode inactivation series and the log
speedups that we were both proposing.  I learned about percpu lists, and
I hope he found it useful to remember how that part of the inode cache
works again.  This dialectic was what drew me to XFS back in 2014 when I
started working on reflink, and I've been missing it, especially since
the pandemic started.

So the question I have is: Can we do community sprints?  Let's get
together (on the lists, or irc, wherever) the week after -rc2 drops to
figure out who thinks they're close to submitting patchsets, decide
which one or two big patchsets we as a group want to try to land this
cycle, and then let's /all/ collaborate on making it happen.  If you
think a cleanup would be a big help for someone else's patchset, write
those changes and make that part happen.

There's never been a prohibition on us working like that, but I'd like
it if we were more intentional about working like a coordinated team to
get things done.  What do you all think?

(Small changes and bug fixes can be sent any time and I'll take a look
at them; I'm not proposing any changes to that part of the process.)

--D
