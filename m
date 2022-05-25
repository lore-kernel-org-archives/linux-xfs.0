Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB8EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 21:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238571AbiEYVXP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 17:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiEYVXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 17:23:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FBFBF64
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 14:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3573861A85
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 21:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D07FC385B8;
        Wed, 25 May 2022 21:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653513791;
        bh=NRkpEF99tG4OLRdNOvYkcp1bBsfC+oEd6mIEPZb/8qc=;
        h=Date:From:To:Cc:Subject:From;
        b=dvD/96DDyRUyHCDjhtfjvV5MdS9tjCdDtUXTL6Ettt3ebGXPn8uUNP13JoddT3n9R
         xVY3ph3K6qrJ88NGmMmnW17kfkT1DNnprTGrNHsoO0+22lfE0/I8oXq5Q5JKKmW9BH
         nZb1iQssyVNlUHMG63rt3hTRAzpOWScN3q8bhzPMuH6X1I8HeldAYJFEF7re3+KcZY
         JQlGTbNeds4pqqbGs3QbHfIEAFtzDnJmFdzldSK3vfrYAeyVmfDMIyF6TyMmSz2eDO
         cRPMfXnFQJ28Vs90Q38gBijCxEUDmplFPKsVKCsbFxCnJ+zSA6FtHCq48xITw0IXr7
         tdSCn/1Al1NpQ==
Date:   Wed, 25 May 2022 14:23:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Leah Rumancik <lrumancik@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Shirley Ma <shirley.ma@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: XFS LTS backport cabal
Message-ID: <Yo6ePjvpC7nhgek+@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

As most of the people cc'd on this message are aware, there's been a
recent groundswell of interest in increasing the amount of staff time
assigned to backporting bug fixes to LTS kernels.  As part of preparing
to resume maintainership on June 5th, I thought it would be a good idea
to introduce all the participants (that I know of!) and to capture a
summary of everyone's thoughts w.r.t. how to make stable backports
happen.

First, some introductions: Leah and Ted work at Google, and they've
expressed interest in 5.15 LTS backports.  Dave and Eric are the other
upstream XFS maintainers, so I've included them.  Amir seems to be
working on 5.10 LTS backports for his employer(?).  Chandan and I work
at Oracle (obviously) and he's also been working on a few 5.15 LTS
backports.

I won't speak for other organizations, but we (Oracle) are also
interested in stable backports for the 5.4 and 4.14 LTS kernels, since
we have customers running <cough> derivatives of those kernels.  Given
what I've heard from others, many kernel distributors lean on the LTS
kernels.

The goal of this thread, then, is to shed some light on who's currently
doing what to reduce duplication of LTS work, and to make sure that
we're all more or less on the same page with regards to what we will and
won't try to push to stable.  (A side goal of mine is to help everyone
working on the stable branches to avoid the wrath and unhelpful form
letters of the stable maintainers.)

Briefly, I think the patches that flow into XFS could be put into three
rough categories:

(a) Straightforward fixes.  These are usually pretty simple fixes (e.g.
omitted errno checking, insufficient validation, etc.) sometimes get
proper Fixes tags, which means that AUTOSEL can be of some benefit.

(b) Probable fixes.  Often these aren't all that obvious -- for example,
the author may be convinced that they correct a mis-interaction between
subsystems, but we would like the changes to soak in upstream for a few
months to build confidence that they solve the problem and without
causing more problems.

(c) Everything else.  New features, giant refactorings, etc.  These
generally should not be backported, unless someone has a /really/ good
reason.

Here are a few principles I'd like to see guiding stable backport
efforts:

1. AUTOSEL is a good tool to _start_ the process of identifying low
hanging fruit to backport.  Automation is our friend, but XFS is complex
so we still need people who have kept up with linux-xfs to know what's
appropriate (and what compile tests can't find) to finish the process.

2. Some other tag for patches that could be a fix, but need a few months
to soak.  This is targetted at (b), since I'm terrible at remembering
that there are patches that are reaching ripeness.

3. fstesting -- new patches proposed for stable branches shouldn't
introduce new regressions, and ideally there would also be a regression
test that would now pass.  As Dave and I have stated in the past,
fstests is a big umbrella of a test suite, which implies that A/B
testing is the way to go.  I think at least Zorro and I would like to
improve the tagging in fstests to make it more obvious which tests
contain enough randomness that they cannot be expected to behave 100%
reliably.

Here's a couple of antipatterns from the past:

i. Robots shovelling patches into stable kernels with no testing.

ii. Massively large backports.  New features don't go to stable kernels,
and I doubt the stable kernel maintainers will accept that anyway.  I
grok the temptation to backport more so that it's easier to land future
fixes via AUTOSEL, but I personally wouldn't endorse frontloading a
bunch of work to chase a promise of less future work.

And a question or two:

a> I've been following the recent fstests threads, and it seems to me
that there are really two classes of users -- sustaining people who want
fstests to run reliably so they can tell if their backports have broken
anything; and developers, who want the randomness to try to poke into
dusty corners of the filesystem.  Can we make it easier to associate
random bits of data (reliability rates, etc.) with a given fstests
configuration?  And create a test group^Wtag for the tests that rely on
RNGs to shake things up?

b> Testing relies very heavily on being able to spin up a lot of testing
resources.  Can/should we make it easier for people with a kernel.org
account to get free(ish) cloud accounts with the LF members who are also
cloud vendors?

Thoughts? Flames?

--D
