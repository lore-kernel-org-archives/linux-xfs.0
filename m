Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D533DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 20:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A44364F6C
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 20:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBCUjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 15:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhBCUjX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 15:39:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E7A564F58;
        Wed,  3 Feb 2021 20:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612384722;
        bh=vo1/95+sR6LudrZMJ++ZNxoOJrmz4ZZ7s4ZKgTZQ/Q8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=vBOd7o7hyRikz7k2PnN0+vW4cYg/oSbuLrJ5C6sOOW9a4X2604C0yYJSsK/54caeN
         j3nuu8H8IBhLQEoXA4y6swRePgYfRQbcnJQFZ3fnZVKmnfZkumP6xLKrUTPA/hqANk
         S1W858S1xgVtESdHNDR2J7dXsPWF2VK6U9qu/eZG8Vr5q2MtW9DxOLQj8d2U0/z6AS
         /wVKYEMCkmth6myU/SYCR3z3uT8qDTABhSxLwxHuD6x1Fm/tvViHtJLaji7bIYn7M4
         U8w3QGHftyXL0MoaAtxom0cpB+6Eek/50J1sgxwcWzfU3UBTaa6BXnZJW9FNpjnHNe
         7KZwKvO1DSj8g==
Date:   Wed, 3 Feb 2021 12:38:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: test delalloc quota leak when chprojid fails
Message-ID: <20210203203841.GE7193@magnolia>
References: <20210202194101.GQ7193@magnolia>
 <20210203160115.GE14354@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203160115.GE14354@localhost.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 04, 2021 at 12:01:16AM +0800, Zorro Lang wrote:
> On Tue, Feb 02, 2021 at 11:41:01AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test for a bug in the XFS implementation of
> > FSSETXATTR.  When we try to change a file's project id, the quota
> > reservation code will update the incore quota reservations for delayed
> > allocation blocks.  Unfortunately, it does this before we finish
> > validating all the FSSETXATTR parameters, which means that if we decide
> > to bail out, we also fail to undo the incore changes.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Looks like this patch comes from djwong-devel :) It can't be merged into
> xfstests-dev mainline directly.

Yeah, applying patches to fstests is annoying like that. :(

>   Applying: xfs: test delalloc quota leak when chprojid fails
>   error: patch failed: src/Makefile:29
>   error: src/Makefile: patch does not apply
>   error: patch failed: tests/xfs/group:544
>   error: tests/xfs/group: patch does not apply
> 
> Anyway, I think Eryu can solve it. I just have another question below.
> 
> >  .gitignore          |    1 +
> >  src/Makefile        |    3 +-
> >  src/chprojid_fail.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/765       |   63 +++++++++++++++++++++++++++++++++++++
> >  tests/xfs/765.out   |    3 ++
> >  tests/xfs/group     |    1 +
> >  6 files changed, 156 insertions(+), 1 deletion(-)
> >  create mode 100644 src/chprojid_fail.c
> >  create mode 100755 tests/xfs/765
> >  create mode 100644 tests/xfs/765.out
> > 
> 
> [snip]
> 
> > +# FS QA Test No. 765
> > +#
> > +# Regression test for failing to undo delalloc quota reservations when changing
> > +# project id but we fail some other part of FSSETXATTR validation.  If we fail
> > +# the test, we trip debugging assertions in dmesg.
> > +#
> > +# The appropriate XFS patch is:
> > +# xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_debug
> 
> Why CONFIG_XFS_DEBUG=y is necessary for this case? Maybe I miss something, but
> I didn't see any debug injection in this case. If a kernel is only built with
> CONFIG_XFS_WARN=y, I still can reproduce this bug [1].

Heh, I forgot that asserts can trigger even if debug is disabled.

> Even if the XFS_WARN and XFS_DEUBG are all unset, I think this case can be run
> without any failures. So why not just let it run? We could recommand using
> debug xfs kernel, but general kernel don't need to skip this test.

Ok.  I'll get rid of it then.

--D

> Thanks,
> Zorro
> 
> [1]
> # ./check xfs/765
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 4.18.0 #1 SMP Sat Jan 23 14:15:14 EST 2021
> MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 /dev/mapper/xfscratch
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/xfscratch /mnt/scratch
> 
> xfs/765 _check_dmesg: something found in dmesg (see /home/xfstests-dev/results//xfs/765.dmesg)
> 
> Ran: xfs/765
> Failures: xfs/765
> Failed 1 of 1 tests
> 
> [root@hp-dl380pg8-01 xfstests-dev]# less /home/xfstests-dev/results//xfs/765.dmesg
> [30020.559403] run fstests xfs/765 at 2021-02-03 10:36:02
> ...
> [30028.411797] XFS: Assertion failed: dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount), file: fs/xfs/xfs_trans_dquot.c, line: 471
> 
> > +_require_command "$FILEFRAG_PROG" filefrag
> > +_require_test_program "chprojid_fail"
> > +_require_quota
> > +_require_scratch
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format filesystem" | tee -a $seqres.full
> > +_scratch_mkfs > $seqres.full
> > +_qmount_option 'prjquota'
> > +_qmount
> > +_require_prjquota $SCRATCH_DEV
> > +
> > +echo "Run test program"
> > +$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
> > +$here/src/chprojid_fail $SCRATCH_MNT/blah >> $seqres.full
> > +res=$?
> > +if [ $res -ne 0 ]; then
> > +	echo "chprojid_fail returned $res, expected 0"
> > +fi
> > +$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
> > +$FILEFRAG_PROG -v $SCRATCH_MNT/blah >> $seqres.full
> > +$FILEFRAG_PROG -v $SCRATCH_MNT/blah 2>&1 | grep -q delalloc || \
> > +	echo "file didn't get delalloc extents?"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/765.out b/tests/xfs/765.out
> > new file mode 100644
> > index 00000000..f44ba43e
> > --- /dev/null
> > +++ b/tests/xfs/765.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 765
> > +Format filesystem
> > +Run test program
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index f406a9b9..fb78b0d7 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -544,6 +544,7 @@
> >  762 auto quick rw scrub realtime
> >  763 auto quick rw realtime
> >  764 auto quick repair
> > +765 auto quick quota
> >  908 auto quick bigtime
> >  909 auto quick bigtime quota
> >  910 auto quick inobtcount
> > 
> 
