Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E11C41513
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 06:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjGZGBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 02:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjGZGBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 02:01:20 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A41519AF
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 23:01:19 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-116-181.bstnma.fios.verizon.net [173.48.116.181])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36Q612Jc023588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jul 2023 02:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1690351264; bh=AEbuTru0wWCwmAKvSL2oeR89+nk2+em32b8HpYTaoK4=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=f7lnSAv1ouXc2TysVHzS9BaNZVfIP1bQxW++YID3+ZAPZ0ecO/Qo2fdRbu2nsFaeN
         /xAWXLCYHU4yJEEEk9HEWr/NR4i5BFryiYCXL5wzgJloTY/S7kCLq/K4K1CwOQCsPq
         0LE1jrzuRnhQ2dIOd89BprvQK6uz2cuZ96sZx1z/S99sxyowzpNcA+UxjwMUmVDIO8
         yUNlmLXBUwnnes7OUCV21aLibws0CQYNw6ERA9+YHAIsUKw19fm/9lJXiO6UhQ7OZn
         zmq5LoUFQjs7i9Tbn1DYfLOM6IJOnmpQmKctUmg2jSyGi9pYpxUMdiw4yw5aSGVuTb
         GBPlkv9C+TQPA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4EF7315C04DF; Wed, 26 Jul 2023 02:01:02 -0400 (EDT)
Date:   Wed, 26 Jul 2023 02:01:02 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230726060102.GB30264@mit.edu>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
 <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726000524.GG11340@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 25, 2023 at 05:05:24PM -0700, Darrick J. Wong wrote:
> 
> If someone wants that, then ok.  The taret audience for this are the
> drive-by filesystem patch authors.  IOWs, people who have some small bug
> they want to try to fix and want to run a quick test to see if their
> change works.

Zorro,

FYI, the context behind this was a comment I had made to Darrick that
the time necessary to run "-g quick" had been getting longer and
longer, and it might be nice to create a manually curated "-g smoke"
that was good enough for drive-by patch authors.  I was originally
thinking about a cut-down set of tests by selecting a subset of "-g
quick", but Darrick suggested that instead, we just run a very small
set of tests (mostly based on fsstress / fsx) and just run them in a
loop for 4 minutes or so.

We also talked about having a time budget (say, 15 minutes) and then
just dividing 15 time by the number of tests, and just run them in for
a specified soak time, so that the total time is known ahead of time.

To be honest, I was a bit dubious it could be that simple, but that's
where using kcov to show that you get a pretty good code coverage
using something that simple comes from.

> I don't think it's reasonable to expect drive-by'ers to know all that
> much about the fstests groups or spend the hours it takes to run -g all.
> As a maintainer, I prefer that these folks have done at least a small
> taste of QA before they start talking to the lists.

A big problem for the drive-by'ers is that that the top-level xfstests
README file is just plain scary, and has far too many steps for a
drive-by patch author to follow.

What I plan to add to a maintainer-entry-file.rst file for ext4 in the
kernel docs is to tell that drive-by posters that should run
"kvm-xfstests smoke" before submitting a patch, and setting up
kvm-xfstess is dead simple easy:


1)  Install kvm-xfstests --- you only have to run this once

% git clone https://github.com/tytso/xfstests-bld fstests
% cd fstests
% make ; make install

# Optional, if your file system you are developing isn't ext4;
# change f2fs to the file system of your choice
% echo PRIMARY_FSTYPE=f2fs >> ~/.config/kvm-xfstests


2) Build the kernel suitable for use with kvm-xfstests

% cd /path/to/your/kernel
% install-kconfig
% kbuild

3) Run the smoke test --- assuming the cwd is /path/to/your/kernel

(Note: today this runs -g quick, but it would be good if this could be
faster)

% kvm-xfstests smoke 


It's simple, and since the kvm-xfstests script will download a
pre-compiled test appliance image automatically, there's no need to
require the drive-by tester to figure out how compile xfstests with
any of its prerequisites.

And once things are set up, then it's just a matter of running
"kbuild" to build your kernel after you make changes, and running
"kvm-xfstests smoke" to do a quick smoke testing run.

No muss, no fuss, no dirty dishes...   :-)

Cheers,

					- Ted
