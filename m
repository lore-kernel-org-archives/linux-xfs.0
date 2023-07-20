Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE06DEB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 14:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjGTOf2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjGTOf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 10:35:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4690E269A
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 07:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689863680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mgonm6g+GiZ/o+7Nx9UzJ5M0cozPBijs75UQtV1HNLo=;
        b=NJkMjfD0H46jhi3v86EqgSkVAMo3tcXh+g2dVfPN0iP7HxRxmnnJFF0TnwOirHokXDcXGD
        WmpWx105Y287fYTNv8jLlVYw5EcfhbfF/aTxY7/u1+uzyet1ELUnH6emMGnaPW4oaFyMsI
        fRIqs9i/e72EZBEm+5mhF95koY0fb9Q=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-GRCfW-kWMbqF0Xk-pQlFsA-1; Thu, 20 Jul 2023 10:34:38 -0400
X-MC-Unique: GRCfW-kWMbqF0Xk-pQlFsA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b8a4e947a1so12674545ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 07:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689863678; x=1690468478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mgonm6g+GiZ/o+7Nx9UzJ5M0cozPBijs75UQtV1HNLo=;
        b=Sn86QqNtc8jn2CJK+wEVgoO+0GhCQWscTrGonF7pS9G7lLGzRQiTBA1ji1kkobxANL
         uBfAkB7ueeGJiuauvrbzyQr1fj7bYkUE8XCu7oTEOA8k3oSG3wIgVLFBq5156oFicarM
         efGT4NDlPwz5vBgpd6FUcGlIeObEq2tvThww5kZnvumUEEQ8GNE+pdElpyNtmme5TkV+
         sJqWgRVkgtUXo0if1SA4ohFb2ynk9EfaBr3ixOaRqQI5cLCzb+RQg/yFFCFREYUG83Pj
         L+AOT1YoDAL5zVnLyO+kagzjFQ7gwS8heA/MfIUz4JFQceTO180ZNq9zf4p/oMnjFEKy
         sfqg==
X-Gm-Message-State: ABy/qLbAizGkD2U7xs4QC5rxVWLgh2AKQ6OYakfY4C2Dnwd1BtayuPrh
        bb20uNrlZ0VploDKkHjacg38MGwZLfvRA6TeE7lvG6WHAfn6NB5QTtjxNpmznuuOwKyEWbA4k4z
        2FefnWWfVVY4MoLAu4q1r
X-Received: by 2002:a17:903:338e:b0:1b0:3d03:4179 with SMTP id kb14-20020a170903338e00b001b03d034179mr5905924plb.6.1689863677929;
        Thu, 20 Jul 2023 07:34:37 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH7y5WNgXMjNoASTPswBqbrEq0z6IXaVF1iFd8MOifnbM9ryUw7pvm2Svqi378ZzjmSsLnqTQ==
X-Received: by 2002:a17:903:338e:b0:1b0:3d03:4179 with SMTP id kb14-20020a170903338e00b001b03d034179mr5905904plb.6.1689863677611;
        Thu, 20 Jul 2023 07:34:37 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id bc2-20020a170902930200b001a95f632340sm1452781plb.46.2023.07.20.07.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 07:34:37 -0700 (PDT)
Date:   Thu, 20 Jul 2023 22:34:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     tytso@mit.edu, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
 <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720022756.GH11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 19, 2023 at 07:27:56PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 20, 2023 at 12:11:15AM +0800, Zorro Lang wrote:
> > On Wed, Jul 19, 2023 at 08:29:07AM -0700, Darrick J. Wong wrote:
> > > On Wed, Jul 19, 2023 at 11:10:24PM +0800, Zorro Lang wrote:
> > > > On Tue, Jul 18, 2023 at 06:10:56PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Create a "-smoketest" parameter to check that will run generic
> > > > > filesystem smoke testing for five minutes apiece.  Since there are only
> > > > > five smoke tests, this is effectively a 16min super-quick test.
> > > > > 
> > > > > With gcov enabled, running these tests yields about ~75% coverage for
> > > > > iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45% for
> > > > > btrfs.  Coverage was about ~65% for the pagecache.
> > > > > 
> > > > > Cc: tytso@mit.edu
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  check               |    6 +++++-
> > > > >  doc/group-names.txt |    1 +
> > > > >  tests/generic/475   |    2 +-
> > > > >  tests/generic/476   |    2 +-
> > > > >  tests/generic/521   |    2 +-
> > > > >  tests/generic/522   |    2 +-
> > > > >  tests/generic/642   |    2 +-
> > > > >  7 files changed, 11 insertions(+), 6 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/check b/check
> > > > > index 89e7e7bf20..97c7c4c7d1 100755
> > > > > --- a/check
> > > > > +++ b/check
> > > > > @@ -68,6 +68,7 @@ check options
> > > > >      -pvfs2		test PVFS2
> > > > >      -tmpfs		test TMPFS
> > > > >      -ubifs		test ubifs
> > > > > +    -smoketest		run smoke tests for 4min each
> > > > 
> > > > We have both "smoketest" and "smoke", that's a bit confused :)
> > > 
> > > We do?  git grep doesn't show anything other than what I added:
> > > 
> > > $ git grep smoke
> > > check:71:    -smoketest         run smoke tests for 4min each
> > > check:294:      -smoketest)
> > > check:296:              GROUP_LIST="smoketest"
> > > doc/group-names.txt:123:smoketest               Simple smoke tests
> > > tests/generic/475:15:_begin_fstest shutdown auto log metadata eio recoveryloop smoketest
> > > tests/generic/476:11:_begin_fstest auto rw long_rw stress soak smoketest
> > > tests/generic/521:10:_begin_fstest soak long_rw smoketest
> > > tests/generic/522:10:_begin_fstest soak long_rw smoketest
> > > tests/generic/533:9:# Simple attr smoke tests for user EAs, dereived from generic/097.
> > > tests/generic/642:11:_begin_fstest auto soak attr long_rw stress smoketest
> > 
> > Oh, sorry, my memory is a bit of jumbled ...
> > 
> > > 
> > > > >      -l			line mode diff
> > > > >      -udiff		show unified diff (default)
> > > > >      -n			show me, do not run tests
> > > > > @@ -290,7 +291,10 @@ while [ $# -gt 0 ]; do
> > > > >  		FSTYP=overlay
> > > > >  		export OVERLAY=true
> > > > >  		;;
> > > > > -
> > > > > +	-smoketest)
> > > > 
> > > > Hmm... I'm wondering if it's worth having a specific running option for
> > > > someone test group. If each "meaningful" testing way need a specific check
> > > > option, the ./check file will be too complicated.
> > > > 
> > > > If we need some recommended test ways, how about make some separated wrappers
> > > > of ./check? For example:
> > > > 
> > > > # mkdir fstests/runtest/
> > > > # cat > fstests/runtest/smoketest <<EOF
> > > > export SOAK_DURATION="4m"
> > > > ./check -g smoketest
> > > > EOF
> > > > 
> > > > Of course you can write more codes in it.
> > > 
> > > The goal here was to give casual developers an easy way to run a quick
> > > 15 minute exercise *without* having to write wrapper scripts or type
> > > all that in every time.  Compare:
> > > 
> > > $ ./check -smoketest
> > > 
> > > vs.
> > > 
> > > $ SOAK_DURATION=4m ./check -g smoketest
> > 
> > Oh, I don't mean let users write that wrapper, I mean we provide some wrapper
> > scripts (to be recommended). E.g.
> > 
> > # ./runtest/smoaktest
> > 
> > If we give "smoaktest" a specific run option, what will we do if more people
> > want to add more options like that?
> > 
> > But a wrapper is not an offical running option, it's just a reference which
> > can be used directly or can be copied. Then we can have more wrappers from
> > each fs expert as reference, to recommend other users how to use fstests
> > specially. And I don't need to add options for each of them. What do you think?
> 
> I disagree -- this is supposed to be a general smoketest that applies to
> any filesystem.  It's easy to discover this option via ./check --help.
> 
> Adding wrapper scripts means that now we have to find a separate way to
> advertise them and people have to find the wrapper on their own if they
> miss the advertising.

Hmmm.. OK, but we also have other general test types, e.g. soak test, stress
test, rw test. Should we give each of them a specific option if anyone need
that?

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > +		SOAK_DURATION="4m"
> > > > > +		GROUP_LIST="smoketest"
> > > > > +		;;
> > > > >  	-g)	group=$2 ; shift ;
> > > > >  		GROUP_LIST="$GROUP_LIST ${group//,/ }"
> > > > >  		;;
> > > > > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > > > > index 1c35a39432..c3dcca3755 100644
> > > > > --- a/doc/group-names.txt
> > > > > +++ b/doc/group-names.txt
> > > > > @@ -118,6 +118,7 @@ selftest		tests with fixed results, used to validate testing setup
> > > > >  send			btrfs send/receive
> > > > >  shrinkfs		decreasing the size of a filesystem
> > > > >  shutdown		FS_IOC_SHUTDOWN ioctl
> > > > > +smoketest		Simple smoke tests
> > > > >  snapshot		btrfs snapshots
> > > > >  soak			long running soak tests whose runtime can be controlled
> > > > >                          directly by setting the SOAK_DURATION variable
> > > > > diff --git a/tests/generic/475 b/tests/generic/475
> > > > > index 0cbf5131c2..ce7fe013b1 100755
> > > > > --- a/tests/generic/475
> > > > > +++ b/tests/generic/475
> > > > > @@ -12,7 +12,7 @@
> > > > >  # testing efforts.
> > > > >  #
> > > > >  . ./common/preamble
> > > > > -_begin_fstest shutdown auto log metadata eio recoveryloop
> > > > > +_begin_fstest shutdown auto log metadata eio recoveryloop smoketest
> > > > >  
> > > > >  # Override the default cleanup function.
> > > > >  _cleanup()
> > > > > diff --git a/tests/generic/476 b/tests/generic/476
> > > > > index 8e93b73457..b1ae4df4d4 100755
> > > > > --- a/tests/generic/476
> > > > > +++ b/tests/generic/476
> > > > > @@ -8,7 +8,7 @@
> > > > >  # bugs in the write path.
> > > > >  #
> > > > >  . ./common/preamble
> > > > > -_begin_fstest auto rw long_rw stress soak
> > > > > +_begin_fstest auto rw long_rw stress soak smoketest
> > > > >  
> > > > >  # Override the default cleanup function.
> > > > >  _cleanup()
> > > > > diff --git a/tests/generic/521 b/tests/generic/521
> > > > > index 22dd31a8ec..0956e50171 100755
> > > > > --- a/tests/generic/521
> > > > > +++ b/tests/generic/521
> > > > > @@ -7,7 +7,7 @@
> > > > >  # Long-soak directio fsx test
> > > > >  #
> > > > >  . ./common/preamble
> > > > > -_begin_fstest soak long_rw
> > > > > +_begin_fstest soak long_rw smoketest
> > > > >  
> > > > >  # Import common functions.
> > > > >  . ./common/filter
> > > > > diff --git a/tests/generic/522 b/tests/generic/522
> > > > > index f0cbcb245c..0e4e6009ed 100755
> > > > > --- a/tests/generic/522
> > > > > +++ b/tests/generic/522
> > > > > @@ -7,7 +7,7 @@
> > > > >  # Long-soak buffered fsx test
> > > > >  #
> > > > >  . ./common/preamble
> > > > > -_begin_fstest soak long_rw
> > > > > +_begin_fstest soak long_rw smoketest
> > > > >  
> > > > >  # Import common functions.
> > > > >  . ./common/filter
> > > > > diff --git a/tests/generic/642 b/tests/generic/642
> > > > > index eba90903a3..e6a475a8b5 100755
> > > > > --- a/tests/generic/642
> > > > > +++ b/tests/generic/642
> > > > > @@ -8,7 +8,7 @@
> > > > >  # bugs in the xattr code.
> > > > >  #
> > > > >  . ./common/preamble
> > > > > -_begin_fstest auto soak attr long_rw stress
> > > > > +_begin_fstest auto soak attr long_rw stress smoketest
> > > > >  
> > > > >  _cleanup()
> > > > >  {
> > > > > 
> > > > 
> > > 
> > 
> 

