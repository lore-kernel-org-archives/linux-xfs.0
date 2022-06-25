Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0255BC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 19:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiFYTf6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jun 2022 15:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiFYTf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jun 2022 15:35:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FE714092;
        Sat, 25 Jun 2022 12:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3SRIxg5erh0mm3oLtkQYOeeixPaFDs7/M51YjUXTcIw=; b=uvc7jfcKszy0fy14rxh3cDoqEu
        dm5TlDla3tY/OOnSZMQVgCobcA6K1M11KSVWJXc/AM3detM9QrslCdjrK0whQ7tbcTssNUbQiikG7
        og6yt+ciZhJmR53SkjKjWqO9auRaIRQaN3NON/5dsJSnk2AbsluahW9ocQtcxqacd8YG2AY6WrcAy
        g0Foikx9MjKSXXgc8fNcw4b4TBMo0t0J2aJ3Y+8k7FwhD54zl1QeAUMROFONtyBlKQ3lrF7OcFdX7
        VwmTuS+406f6823u39H5nUlQuggiHKN7mBJfYLTlbZWsiEorefM3UqHHbXbbHotkbSEGHu5oBZ63V
        hi1E0U0w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o5BZO-007Tcm-IZ; Sat, 25 Jun 2022 19:35:50 +0000
Date:   Sat, 25 Jun 2022 12:35:50 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Zorro Lang <zlang@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: sharing fstests results (Was: [PATCH 5.15 CANDIDATE v2 0/8] xfs
 stable candidate patches for 5.15.y (part 1))
Message-ID: <YrdjluHoj9xAz3Op@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
 <YrZAtOqQERpYbBXg@bombadil.infradead.org>
 <CAOQ4uxi-KVMWb4nvNCriPdjMcZkPut7x6LA6aHJz_hVMeBxvOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi-KVMWb4nvNCriPdjMcZkPut7x6LA6aHJz_hVMeBxvOA@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 25, 2022 at 10:28:32AM +0300, Amir Goldstein wrote:
> On Sat, Jun 25, 2022 at 1:54 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > Determinism is important for tests though so snapshotting a reflection
> > interpretion of expunges at a specific point in time is also important.
> > So the database would need to be versioned per updates, so a test is
> > checkpointed against a specific version of the expunge db.
> 
> Using the terminology "expunge db" is wrong here because it suggests
> that flakey tests (which are obviously part of that db) should be in
> expunge list as is done in kdevops and that is not how Josef/Ted/Darrick
> treat the flakey tests.

There are flaky tests which can cause a crash, and that is why I started
to expunge these. Not all flaky tests cause a crash though. And so, this
is why in the format I suggested you can specify metadata such as if a
test caused a crash.

At this point I agree that the way kdevops simply skips flaky test which
does not cause a crash should be changed, and if the test is just known
to fail though non deterministically but without a crash it would be
good then at the end to simply not treat that failure as fatal. If
however the failure rate does change it would be useful to update that
information. Without metadata one cannot process that sort of stuff.

> The discussion should be around sharing fstests "results" not expunge
> lists. Sharing expunge lists for tests that should not be run at all
> with certain kernel/disrto/xfsprogs has great value on its own and I
> this the kdevops hierarchical expunge lists are a very good place to
> share think *determinitic* information, but only as long as those lists
> absolutely do not contain non-deterministic test expunges.

The way the expunge list is process could simply be modified in kdevops
so that non-deterministic tests are not expunged but also not treated as
fatal at the end. But think about it, the exception is if the non-deterministic
failure does not lead to a crash, no?

> > > It might perhaps be useful to get a bit more clarity about how we
> > > expect the shared results would be used, because that might drive some
> > > of the design decisions about the best way to store these "results".
> >
> 
> As a requirement, what I am looking for is a way to search for anything
> known to the community about failures in test FS/NNN.

Here's the thing though. Not all developers have incentives to share.
For a while SLE didn't have public expunges, that changed after OpenSUSE
Leap 15.3 as it has binary compatibility with SLE15.3 and so the same
failures on workflows/fstests/expunges/opensuse-leap/15.3/ are applicable/.
It is up to each distro if they wish to share and without a public
vehicle to do so why would they, or how would they?

For upstream and stable I would hope there is more incentives to share.
But again, no shared home ever had existed before. And I don't think
there was ever before dialog about sharing a home for these.

> Because when I get an alert on a possible regression, that's the fastest
> way for me to triage and understand how much effort I should put into
> the investigation of that failure and which directions I should look into.
> 
> Right now, I look at the test header comment and git log, I grep the
> kdepops expunge lists to look for juicy details and I search lore for
> mentions of that test.
> 
> In fact, I already have an auto generated index of lore fstests
> mentions in xfs patch discussions [1] that I just grep for failures found
> when testing xfs. For LTS testing, I found it to be the best way to
> find candidate fix patches that I may have missed.

This effort is valuable and thanks for doing all this.

> Going forward, we can try to standardize the search and results
> format, but for getting better requirements you first need users!

As you are witness to it, running fstests against any fs takes a lot of
time and patience, and as I have noted, not many have incentives to
share. So the best I could do is provide the solution to enable folks to
reproduce testing as fast and as easy as possible and let folks who are
interested to share, to do so. And obvioulsy at least I did get a major
enterprise distro to share some results. Hope others could follow.

So I expect the format for sharing then to be lead by those who have a
clear incentive to do so. Folks working on upstream or stable stakeholders
seem like an obvious candidates. And then it is just volunteer work.

  Luis
