Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78E8C001DE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 02:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjGTC2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 22:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGTC2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 22:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B7119BC;
        Wed, 19 Jul 2023 19:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D6C0618C7;
        Thu, 20 Jul 2023 02:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752C0C433C7;
        Thu, 20 Jul 2023 02:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689820077;
        bh=Et/CGWZgqEOPtZDNlPty5xxGbgN5/uLyX+ztHtxhIlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N0x1lxzy2mUxMhZiF9Wc6UIec1ribQL2QGmy0ptTG4xOdehxFWpoJVnaK+rZSaM02
         kGGJ+3N2UxSoef1phcO4xxBMAcDBOIGaN28NHRC/inD7xxhfPS128VXpF0LBxk5IZN
         0GKIt1/WwCCHfqdb9w2OppA6TUQLhfTQQ8lZNSxjRdS2665ztFymks+rQNBCIYNw3M
         sotxsfebA7rr4OSHaAqAY9TZkbxir4l9+VmzdxnilkpH852x4vxnivH95ISBzUkIbU
         zBkV7383sJebBdpFrGD3yOXZdfeDpEW8ScK8KJwBuA8mh7C+HSnu0y0CXc2OwaVkUA
         F6z8p0EauHV4g==
Date:   Wed, 19 Jul 2023 19:27:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     tytso@mit.edu, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230720022756.GH11352@frogsfrogsfrogs>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
 <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719161115.byva7tvwoafkesga@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2023 at 12:11:15AM +0800, Zorro Lang wrote:
> On Wed, Jul 19, 2023 at 08:29:07AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 19, 2023 at 11:10:24PM +0800, Zorro Lang wrote:
> > > On Tue, Jul 18, 2023 at 06:10:56PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Create a "-smoketest" parameter to check that will run generic
> > > > filesystem smoke testing for five minutes apiece.  Since there are only
> > > > five smoke tests, this is effectively a 16min super-quick test.
> > > > 
> > > > With gcov enabled, running these tests yields about ~75% coverage for
> > > > iomap and ~60% for xfs; or ~50% for ext4 and ~75% for ext4; and ~45% for
> > > > btrfs.  Coverage was about ~65% for the pagecache.
> > > > 
> > > > Cc: tytso@mit.edu
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  check               |    6 +++++-
> > > >  doc/group-names.txt |    1 +
> > > >  tests/generic/475   |    2 +-
> > > >  tests/generic/476   |    2 +-
> > > >  tests/generic/521   |    2 +-
> > > >  tests/generic/522   |    2 +-
> > > >  tests/generic/642   |    2 +-
> > > >  7 files changed, 11 insertions(+), 6 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/check b/check
> > > > index 89e7e7bf20..97c7c4c7d1 100755
> > > > --- a/check
> > > > +++ b/check
> > > > @@ -68,6 +68,7 @@ check options
> > > >      -pvfs2		test PVFS2
> > > >      -tmpfs		test TMPFS
> > > >      -ubifs		test ubifs
> > > > +    -smoketest		run smoke tests for 4min each
> > > 
> > > We have both "smoketest" and "smoke", that's a bit confused :)
> > 
> > We do?  git grep doesn't show anything other than what I added:
> > 
> > $ git grep smoke
> > check:71:    -smoketest         run smoke tests for 4min each
> > check:294:      -smoketest)
> > check:296:              GROUP_LIST="smoketest"
> > doc/group-names.txt:123:smoketest               Simple smoke tests
> > tests/generic/475:15:_begin_fstest shutdown auto log metadata eio recoveryloop smoketest
> > tests/generic/476:11:_begin_fstest auto rw long_rw stress soak smoketest
> > tests/generic/521:10:_begin_fstest soak long_rw smoketest
> > tests/generic/522:10:_begin_fstest soak long_rw smoketest
> > tests/generic/533:9:# Simple attr smoke tests for user EAs, dereived from generic/097.
> > tests/generic/642:11:_begin_fstest auto soak attr long_rw stress smoketest
> 
> Oh, sorry, my memory is a bit of jumbled ...
> 
> > 
> > > >      -l			line mode diff
> > > >      -udiff		show unified diff (default)
> > > >      -n			show me, do not run tests
> > > > @@ -290,7 +291,10 @@ while [ $# -gt 0 ]; do
> > > >  		FSTYP=overlay
> > > >  		export OVERLAY=true
> > > >  		;;
> > > > -
> > > > +	-smoketest)
> > > 
> > > Hmm... I'm wondering if it's worth having a specific running option for
> > > someone test group. If each "meaningful" testing way need a specific check
> > > option, the ./check file will be too complicated.
> > > 
> > > If we need some recommended test ways, how about make some separated wrappers
> > > of ./check? For example:
> > > 
> > > # mkdir fstests/runtest/
> > > # cat > fstests/runtest/smoketest <<EOF
> > > export SOAK_DURATION="4m"
> > > ./check -g smoketest
> > > EOF
> > > 
> > > Of course you can write more codes in it.
> > 
> > The goal here was to give casual developers an easy way to run a quick
> > 15 minute exercise *without* having to write wrapper scripts or type
> > all that in every time.  Compare:
> > 
> > $ ./check -smoketest
> > 
> > vs.
> > 
> > $ SOAK_DURATION=4m ./check -g smoketest
> 
> Oh, I don't mean let users write that wrapper, I mean we provide some wrapper
> scripts (to be recommended). E.g.
> 
> # ./runtest/smoaktest
> 
> If we give "smoaktest" a specific run option, what will we do if more people
> want to add more options like that?
> 
> But a wrapper is not an offical running option, it's just a reference which
> can be used directly or can be copied. Then we can have more wrappers from
> each fs expert as reference, to recommend other users how to use fstests
> specially. And I don't need to add options for each of them. What do you think?

I disagree -- this is supposed to be a general smoketest that applies to
any filesystem.  It's easy to discover this option via ./check --help.

Adding wrapper scripts means that now we have to find a separate way to
advertise them and people have to find the wrapper on their own if they
miss the advertising.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +		SOAK_DURATION="4m"
> > > > +		GROUP_LIST="smoketest"
> > > > +		;;
> > > >  	-g)	group=$2 ; shift ;
> > > >  		GROUP_LIST="$GROUP_LIST ${group//,/ }"
> > > >  		;;
> > > > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > > > index 1c35a39432..c3dcca3755 100644
> > > > --- a/doc/group-names.txt
> > > > +++ b/doc/group-names.txt
> > > > @@ -118,6 +118,7 @@ selftest		tests with fixed results, used to validate testing setup
> > > >  send			btrfs send/receive
> > > >  shrinkfs		decreasing the size of a filesystem
> > > >  shutdown		FS_IOC_SHUTDOWN ioctl
> > > > +smoketest		Simple smoke tests
> > > >  snapshot		btrfs snapshots
> > > >  soak			long running soak tests whose runtime can be controlled
> > > >                          directly by setting the SOAK_DURATION variable
> > > > diff --git a/tests/generic/475 b/tests/generic/475
> > > > index 0cbf5131c2..ce7fe013b1 100755
> > > > --- a/tests/generic/475
> > > > +++ b/tests/generic/475
> > > > @@ -12,7 +12,7 @@
> > > >  # testing efforts.
> > > >  #
> > > >  . ./common/preamble
> > > > -_begin_fstest shutdown auto log metadata eio recoveryloop
> > > > +_begin_fstest shutdown auto log metadata eio recoveryloop smoketest
> > > >  
> > > >  # Override the default cleanup function.
> > > >  _cleanup()
> > > > diff --git a/tests/generic/476 b/tests/generic/476
> > > > index 8e93b73457..b1ae4df4d4 100755
> > > > --- a/tests/generic/476
> > > > +++ b/tests/generic/476
> > > > @@ -8,7 +8,7 @@
> > > >  # bugs in the write path.
> > > >  #
> > > >  . ./common/preamble
> > > > -_begin_fstest auto rw long_rw stress soak
> > > > +_begin_fstest auto rw long_rw stress soak smoketest
> > > >  
> > > >  # Override the default cleanup function.
> > > >  _cleanup()
> > > > diff --git a/tests/generic/521 b/tests/generic/521
> > > > index 22dd31a8ec..0956e50171 100755
> > > > --- a/tests/generic/521
> > > > +++ b/tests/generic/521
> > > > @@ -7,7 +7,7 @@
> > > >  # Long-soak directio fsx test
> > > >  #
> > > >  . ./common/preamble
> > > > -_begin_fstest soak long_rw
> > > > +_begin_fstest soak long_rw smoketest
> > > >  
> > > >  # Import common functions.
> > > >  . ./common/filter
> > > > diff --git a/tests/generic/522 b/tests/generic/522
> > > > index f0cbcb245c..0e4e6009ed 100755
> > > > --- a/tests/generic/522
> > > > +++ b/tests/generic/522
> > > > @@ -7,7 +7,7 @@
> > > >  # Long-soak buffered fsx test
> > > >  #
> > > >  . ./common/preamble
> > > > -_begin_fstest soak long_rw
> > > > +_begin_fstest soak long_rw smoketest
> > > >  
> > > >  # Import common functions.
> > > >  . ./common/filter
> > > > diff --git a/tests/generic/642 b/tests/generic/642
> > > > index eba90903a3..e6a475a8b5 100755
> > > > --- a/tests/generic/642
> > > > +++ b/tests/generic/642
> > > > @@ -8,7 +8,7 @@
> > > >  # bugs in the xattr code.
> > > >  #
> > > >  . ./common/preamble
> > > > -_begin_fstest auto soak attr long_rw stress
> > > > +_begin_fstest auto soak attr long_rw stress smoketest
> > > >  
> > > >  _cleanup()
> > > >  {
> > > > 
> > > 
> > 
> 
