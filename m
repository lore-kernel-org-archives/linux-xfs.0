Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470A8C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 16:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiDNQP1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 12:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344340AbiDNQIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 12:08:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDAE1042AC;
        Thu, 14 Apr 2022 08:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A1961F8F;
        Thu, 14 Apr 2022 15:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C1CC385A5;
        Thu, 14 Apr 2022 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649951408;
        bh=xt0li30cJt/1YTVQW1TyP4SVICmALkmKmfMnBpBesFA=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=KBTUMIlTAmwgeKmEWJf8EjSMb8hiIQexZ7eo2la1EblZavS7G72Rxw2oKFiz8wmU7
         qITTBvt8F0A2Zb2RdNQ91ryxFpYWXdb2/FySnOWlY9/JkYAXJjzwa5wcA5vm/Bn0TJ
         6xA6yEIEGOxX9Fw0aWOeDZGDp2Zb34zYMCxbbnPRrOQxGsrmBrmaYG5SNjStFNyUk6
         55Bhk+ZYrgeohawnpx4Cew8UYo9T0Z4cTmuneDh6zHz1f6GrE8ua0ZhqAv3bztrnkU
         19RbjH27CW2xRfAEWTS6KqcyrGznrRmMj5jhTNAChG4LKEqJwRs4LVEPLnNl9PhpND
         tmA5ERiegzcMQ==
Date:   Thu, 14 Apr 2022 08:50:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
Message-ID: <20220414155007.GC17014@magnolia>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia>
 <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
 <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
 <20220413154401.vun2usvgwlfers2r@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413154401.vun2usvgwlfers2r@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 13, 2022 at 11:44:01PM +0800, Zorro Lang wrote:
> On Wed, Apr 13, 2022 at 10:58:41AM +0300, Amir Goldstein wrote:
> > On Wed, Apr 13, 2022 at 1:18 AM Zorro Lang <zlang@redhat.com> wrote:
> > >
> > > On Mon, Apr 11, 2022 at 03:54:42PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > >
> > > > fallocate changes file contents, so make sure that we drop privileges
> > > > and file capabilities after each fallocate operation.
> > > >
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/generic/834     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/834.out |   33 +++++++++++++
> > > >  tests/generic/835     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/835.out |   33 +++++++++++++
> > > >  tests/generic/836     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/836.out |   33 +++++++++++++
> > > >  tests/generic/837     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/837.out |   33 +++++++++++++
> > > >  tests/generic/838     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/838.out |   33 +++++++++++++
> > > >  tests/generic/839     |   77 ++++++++++++++++++++++++++++++
> > > >  tests/generic/839.out |   13 +++++
> > > >  12 files changed, 890 insertions(+)
> > > >  create mode 100755 tests/generic/834
> > > >  create mode 100644 tests/generic/834.out
> > > >  create mode 100755 tests/generic/835
> > > >  create mode 100644 tests/generic/835.out
> > > >  create mode 100755 tests/generic/836
> > > >  create mode 100644 tests/generic/836.out
> > > >  create mode 100755 tests/generic/837
> > > >  create mode 100644 tests/generic/837.out
> > > >  create mode 100755 tests/generic/838
> > > >  create mode 100644 tests/generic/838.out
> > > >  create mode 100755 tests/generic/839
> > > >  create mode 100755 tests/generic/839.out
> > > >
> > > >
> > > > diff --git a/tests/generic/834 b/tests/generic/834
> > > > new file mode 100755
> > > > index 00000000..9302137b
> > > > --- /dev/null
> > > > +++ b/tests/generic/834
> > > > @@ -0,0 +1,127 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 834
> > > > +#
> > > > +# Functional test for dropping suid and sgid bits as part of a fallocate.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto clone quick
> > > > +
> > > > +# Override the default cleanup function.
> > > > +_cleanup()
> > > > +{
> > > > +     cd /
> > > > +     rm -r -f $tmp.* $junk_dir
> > > > +}
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/filter
> > > > +. ./common/reflink
> > > > +
> > > > +# real QA test starts here
> > > > +
> > > > +# Modify as appropriate.
> > > > +_supported_fs xfs btrfs ext4
> > >
> > > So we have more cases will break downstream XFS testing :)
> > 
> > Funny you should mention that.
> > I was going to propose an RFC for something like:
> > 
> > _fixed_by_kernel_commit fbe7e5200365 "xfs: fallocate() should call
> > file_modified()"
> > 
> > The first thing that could be done with this standard annotation is print a
> > hint on failure, like LTP does:
> > 
> > HINT: You _MAY_ be missing kernel fixes:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fbe7e5200365
> 
> I think it's not difficult to implement this behavior in xfstests. Generally if
> a case covers a known bug, we record the patch commit in case description.

It's not hard, but it's a treewide change to identify all the fstests
that are regression fixes (or at least mention a commit hash) and well
beyond the scope of adding tests for a new fallocate security behavior.

In fact, it's an *entirely new project*.  One that I don't have time to
take on myself as a condition for getting *this* patch merged.

> As my habit, if a test case fails, I'd like to read the case source code
> directly, to get more details about the failure, and check if there's a known
> issue(commit id) covered by that. If there is, check if the kernel I'm testing
> contains this commit.
> 
> From my experience, if a case fails as it's expect, that's easy to find out,
> if the comments is good. Print a hint will help, but won't help much I think,
> due to the hint is just a guess, we still need to read source code or do more
> testing to make sure that, when we hit a failure first time. But most of time
> we always hit unexpected failures, that takes longer time to check.
> 
> > 
> > The second thing to be done is that downstream testers could use a script
> > to auto-generate an expunge list for their test kernel, if they don't care about
> > testing known issues, only regressions.
> 
> In my testing on RHEL (downstream), I record and update known issues, include known
> failures and panic/hang issues (need to skip) for each RHEL release. Before running
> xfstests, I try to get a skip list for a specified RHEL/kernel version. Then compare
> with its known failures after testing done, to decide if a failure is known/unknown.
> Also I created version tags for my redhat internal xfstests repo, for some downstream
> of downstream kernel testing (likes Z-stream testing) can use fixed xfstests version.
> 
> Some known issue format I record as below[1], a bash script will help to parse it and
> compare with testing results. It's only for our internal use, due to I think it's too
> crude to be shared :-P
> 
> [1]
> $ cat known_results/$distro/xfs/145.json 
> [
>     {
>         "DESCRIPTION": "bz19483*** XFS: Assertion failed: dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount)",
>         "FS": ["xfs"],
>         "DMESG": "Assertion failed: dqp->q_res_bcount >= be64_to_cpu\\(dqp->q_core.d_bcount\\)",
>         "FIXED": true
>     }
> ]
> $ cat known_results/$distro/generic/417.json 
> [
>     {
>         "DESCRIPTION": "bz16255*** (<1%): XFS corruption attribute entry #0 in attr block 0, inode 674 is INCOMPLETE",
>         "FS": ["xfs"],
>         "ARCH": ["ppc64le"],
>         "OUTBAD": "_check_xfs_filesystem.*inconsistent",
>         "FULL": "attribute entry.*in attr block.*, inode.*is INCOMPLETE"
>     }
> ]
> 
> > 
> > I hope that with the new maintainship you will also take the opportunity
> > to make fstests more friendly to downstream kernel testers.
> > 
> > > All cases looks good, but according to the custom, all generic cases use
> > > "_supported_fs generic", if you have 1+ specified filesystems, maybe
> > > "tests/shared/*" is better?
> > >
> > 
> > I think we should stay away from tests/shared for as much as possible and
> > use it only for very specific fs behaviors.
> 
> I prefer generic testing too :)
> 
> > 
> > What in the behavior of fallocate() and setgid makes it so special that it needs
> > to be restricted to "xfs btrfs ext4" and not treated as a bug for other fs?
> > I suspect that it might be difficult or impossible to change that behavior in
> > network filesystems?
> 
> I'm not sure what other filesystems think about this behavior. If this's a standard
> or most common behavior, I hope it can be a generic test (then let other fs maintainers
> worry about their new testing failure:-P). Likes generic/673 was written for XFS,
> then btrfs found failure, then btrfs said XFS should follow VFS as btrfs does :)

It will *become* a new behavior, but I haven't spread it to any other
filesystems other than the three listed above.  Overlayfs, for example,
doesn't clear set.id bits or drop file capabilities, nor do things like
f2fs and fat.  I'll get to them eventually, but I think I'll have an
easier time persuading the other maintainers of this new behavior if I
can tell them "Here is a change, and this is an existing fstest that
checks the behavior for correctness."

--D

> 
> > 
> > When facing a similar dilemma in the past we ended up with a whitelist
> > _fstyp_has_non_default_seek_data_hole(), but not sure we need to resort to that.
> > 
> > Thanks,
> > Amir.
> > 
> 
