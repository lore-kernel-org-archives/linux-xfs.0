Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A584C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 16:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E4D60249
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 16:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhG1Qpz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 12:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhG1Qpz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 12:45:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFFCB60F01;
        Wed, 28 Jul 2021 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627490753;
        bh=xNJ6yIi2LKXpRYErf+n/zT5V05RgR15B0Kzd8PUSZcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLFoTn5dStBi15YZN3pXM8rJTjjoEU45wHN4YV2HcFiCVHuI7NNRkIUTUDEa7eyeA
         89ZMMID8SCpE6m8T8bh2yOb36yZbNYdiotWbr/5Pi/kPWXbgzMT7rErRjRV+R3qjhO
         e4CEikEdtsxbhpzvY21jnCbutycDXShUq4VE3EWV4UvqN/nGWRlmGJVtAtSfiN2Ter
         GDbIdQjrUMLTEMRqB4iyQ1ze4Idlh/9TyAhWzZYIm9lN5BNaaNltBfP27oRW0NOLsC
         wa5wb2rYKn4FyiCQYjzbZ/lWsfyUyaLfHsRJQj8Qsj77W8Hgf1EgeQMDKgpPAAmikO
         cO9BWoFre0f1A==
Date:   Wed, 28 Jul 2021 09:45:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 1/1] misc: tag all tests that examine crash recovery in a
 loop
Message-ID: <20210728164553.GA3601443@magnolia>
References: <162743103739.3429001.16912087881683869606.stgit@magnolia>
 <162743104288.3429001.18145781236429703996.stgit@magnolia>
 <CAL3q7H511wY0nHvTuqfnp0ttvvGuFt9Eke2B6cXy_4+JDyJVRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H511wY0nHvTuqfnp0ttvvGuFt9Eke2B6cXy_4+JDyJVRw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 10:40:29AM +0100, Filipe Manana wrote:
> On Wed, Jul 28, 2021 at 1:10 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Given all the recent problems that we've been finding with log recovery,
> > I think it would be useful to create a 'recoveryloop' group so that
> > developers have a convenient way to run every single test that rolls
> > around in a fs shutdown loop looking for subtle errors in recovery.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/btrfs/190   |    2 +-
> >  tests/generic/019 |    2 +-
> >  tests/generic/388 |    2 +-
> >  tests/generic/455 |    2 +-
> >  tests/generic/457 |    2 +-
> >  tests/generic/475 |    2 +-
> >  tests/generic/482 |    2 +-
> >  tests/generic/725 |    2 +-
> >  tests/xfs/057     |    2 +-
> >  9 files changed, 9 insertions(+), 9 deletions(-)
> >
> >
> > diff --git a/tests/btrfs/190 b/tests/btrfs/190
> > index 3aa718e2..974438c1 100755
> > --- a/tests/btrfs/190
> > +++ b/tests/btrfs/190
> > @@ -8,7 +8,7 @@
> >  # balance needs to be resumed on mount.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto quick replay balance qgroup
> > +_begin_fstest auto quick replay balance qgroup recoveryloop
> 
> For btrfs, there are more tests like this: btrfs/172, btrfs/192 and btrfs/206.

I saw those when I was collecting tests for the new group.  I couldn't
tell if they were looping recovery tests, though if you'd like me to add
them to the group I certain will?

--D

> >
> >  # Import common functions.
> >  . ./common/filter
> > diff --git a/tests/generic/019 b/tests/generic/019
> > index b8d025d6..db56dac1 100755
> > --- a/tests/generic/019
> > +++ b/tests/generic/019
> > @@ -8,7 +8,7 @@
> >  # check filesystem consistency at the end.
> >  #
> >  . ./common/preamble
> > -_begin_fstest aio dangerous enospc rw stress
> > +_begin_fstest aio dangerous enospc rw stress recoveryloop
> >
> >  fio_config=$tmp.fio
> >
> > diff --git a/tests/generic/388 b/tests/generic/388
> > index e41712af..9cd737e8 100755
> > --- a/tests/generic/388
> > +++ b/tests/generic/388
> > @@ -15,7 +15,7 @@
> >  # spurious corruption reports and/or mount failures.
> >  #
> >  . ./common/preamble
> > -_begin_fstest shutdown auto log metadata
> > +_begin_fstest shutdown auto log metadata recoveryloop
> >
> >  # Override the default cleanup function.
> >  _cleanup()
> > diff --git a/tests/generic/455 b/tests/generic/455
> > index 62788798..13d326e7 100755
> > --- a/tests/generic/455
> > +++ b/tests/generic/455
> > @@ -7,7 +7,7 @@
> >  # Run fsx with log writes to verify power fail safeness.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto log replay
> > +_begin_fstest auto log replay recoveryloop
> >
> >  # Override the default cleanup function.
> >  _cleanup()
> > diff --git a/tests/generic/457 b/tests/generic/457
> > index d9e38268..f4fdd81d 100755
> > --- a/tests/generic/457
> > +++ b/tests/generic/457
> > @@ -7,7 +7,7 @@
> >  # Run fsx with log writes on cloned files to verify power fail safeness.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto log replay clone
> > +_begin_fstest auto log replay clone recoveryloop
> >
> >  # Override the default cleanup function.
> >  _cleanup()
> > diff --git a/tests/generic/475 b/tests/generic/475
> > index 62894491..c426402e 100755
> > --- a/tests/generic/475
> > +++ b/tests/generic/475
> > @@ -12,7 +12,7 @@
> >  # testing efforts.
> >  #
> >  . ./common/preamble
> > -_begin_fstest shutdown auto log metadata eio
> > +_begin_fstest shutdown auto log metadata eio recoveryloop
> >
> >  # Override the default cleanup function.
> >  _cleanup()
> > diff --git a/tests/generic/482 b/tests/generic/482
> > index f26e6fc4..0fadf795 100755
> > --- a/tests/generic/482
> > +++ b/tests/generic/482
> > @@ -9,7 +9,7 @@
> >  # Will do log replay and check the filesystem.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto metadata replay thin
> > +_begin_fstest auto metadata replay thin recoveryloop
> >
> >  # Override the default cleanup function.
> >  _cleanup()
> > diff --git a/tests/generic/725 b/tests/generic/725
> > index f43bcb37..8bd724e3 100755
> > --- a/tests/generic/725
> > +++ b/tests/generic/725
> > @@ -12,7 +12,7 @@
> >  # in writeback on the host that cause VM guests to fail to recover.
> >  #
> >  . ./common/preamble
> > -_begin_fstest shutdown auto log metadata eio
> > +_begin_fstest shutdown auto log metadata eio recoveryloop
> >
> >  _cleanup()
> >  {
> > diff --git a/tests/xfs/057 b/tests/xfs/057
> > index d4cfa8dc..9fb3f406 100755
> > --- a/tests/xfs/057
> > +++ b/tests/xfs/057
> > @@ -21,7 +21,7 @@
> >  # Note that this test requires a DEBUG mode kernel.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto log
> > +_begin_fstest auto log recoveryloop
> >
> >  # Override the default cleanup function.
> >  _cleanup()
> >
> 
> 
> -- 
> Filipe David Manana,
> 
> “Whether you think you can, or you think you can't — you're right.”
