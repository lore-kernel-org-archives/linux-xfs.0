Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70715C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 21:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57C016120D
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 21:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhJUVND (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 17:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhJUVND (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Oct 2021 17:13:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D58FB6109F;
        Thu, 21 Oct 2021 21:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634850646;
        bh=Dxo42s5w0i+l/lvEkxhXcovPe1/EmpIrXCsCfFXcAHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUZEbgvxGsQs3o0s7zO23dLheIa6W8zJHEjzqfoG+YaL3f1kzqox8/voWLMkNLi+Q
         UYhs7JrWOWdKf0HPQUiUcMxBiwEp0/f6GQXCokzFzeLbcdo98WgYlZBJbEEqDjl5YD
         xbKQ2FEHFmav2Lx8ctZIQ7XnFi72x+qSL1TvuKw49WP8Lac5FiAjQPFKRmBP3sdGFa
         S6EnPiMU1VGfdF0d4IkdciIZGx+brnyWVDDkZxNTA0hcuvH7OYYSmZoDyRwq2gvx0Y
         m4VhR8QCfm5vw3rBDOoFEhJ/TUcXSHxkKbP/zJrALD+Hfys1aGUsfQyn5pHrCrFQ5C
         65GX+vtnd5P/g==
Date:   Thu, 21 Oct 2021 14:10:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: test COW writeback failure when overlapping
 non-shared blocks
Message-ID: <20211021211046.GX24307@magnolia>
References: <20211021163959.1887011-1-bfoster@redhat.com>
 <20211021184005.GV24307@magnolia>
 <YXG6/f7tAV4+zYfy@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXG6/f7tAV4+zYfy@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 21, 2021 at 03:09:49PM -0400, Brian Foster wrote:
> On Thu, Oct 21, 2021 at 11:40:05AM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 21, 2021 at 12:39:59PM -0400, Brian Foster wrote:
> > > Test that COW writeback that overlaps non-shared delalloc blocks
> > > does not leave around stale delalloc blocks on I/O failure. This
> > > triggers assert failures and free space accounting corruption on
> > > XFS.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > This test targets the problem addressed by the following patch in XFS:
> > > 
> > > https://lore.kernel.org/linux-xfs/20211021163330.1886516-1-bfoster@redhat.com/
> > > 
> > > Brian
> > > 
> > >  tests/generic/651     | 53 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/651.out |  2 ++
> > >  2 files changed, 55 insertions(+)
> > >  create mode 100755 tests/generic/651
> > >  create mode 100644 tests/generic/651.out
> > > 
> > > diff --git a/tests/generic/651 b/tests/generic/651
> > > new file mode 100755
> > > index 00000000..8d4e6728
> > > --- /dev/null
> > > +++ b/tests/generic/651
> > > @@ -0,0 +1,53 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 651
> > > +#
> > > +# Test that COW writeback that overlaps non-shared delalloc blocks does not
> > > +# leave around stale delalloc blocks on I/O failure. This triggers assert
> > > +# failures and free space accounting corruption on XFS.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick clone
> > > +
> > > +_cleanup()
> > > +{
> > > +	_cleanup_flakey
> > > +	cd /
> > > +	rm -r -f $tmp.*
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/reflink
> > > +. ./common/dmflakey
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_require_scratch_reflink
> > > +_require_flakey_with_error_writes
> > 
> > _require_cp_reflink
> > 
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_init_flakey
> > > +_mount_flakey
> > > +
> > > +# create two files that share a single block
> > > +$XFS_IO_PROG -fc "pwrite 4k 4k" $SCRATCH_MNT/file1 >> $seqres.full
> > 
> > Please use:
> > 
> > blksz=$(_get_file_block_size $SCRATCH_MNT)
> > $XFS_IO_PROG -fc "pwrite $blksz $blksz" $SCRATCH_MNT/file1 >> $seqres.full
> > 
> > So that this test will work properly on filesystems with bs > 4k.
> > 
> 
> Yeah, I'll fix the various hardcoded sizes. Thanks.
> 
> > > +cp --reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
> > 
> > Nit: This could be shortened to use the _cp_reflink helper, though it
> > doesn't really matter to me if you do.
> > 
> 
> Didn't know we had it. I'll look into it.
> 
> > > +# Perform a buffered write across the shared and non-shared blocks. On XFS, this
> > > +# creates a COW fork extent that covers the shared block as well as the just
> > 
> > Ah, the reason why there's a cow fork extent covering the delalloc
> > reservation is due to the default cow extent size hint, right?  In that
> > case, you need:
> > 
> 
> Yeah..
> 
> > _require_xfs_io_command "cowextsize"
> > $XFS_IO_PROG -c "cowextsize 0" $SCRATCH_MNT >> $seqres.full
> > 
> > to ensure that the speculative cow preallocation actually gets set up.
> > Otherwise, I think test won't reproduce the bug if the test config has
> > -d cowextsize=1 in the mkfs options.
> > 
> 
> .. but then we aren't susceptible to the problem, right?
> 
> I sometimes waffle on whether it's better for a test to create a
> problematic situation and test it, or run on the configuration specified
> by the user and test a particular scenario against that. Maybe the
> former makes more sense in this very specific test case, but then I
> suppose "cowextsize blksz*2" (or whatever large enough value) is

Yes, blksz*2.

> probably more robust than "cowextsize 0" (which I assume means "default"
> and thus can change, right)?

Seeing as this is a reproducer, explicitly setting cowextsize seems
appropriate.

Alternately, I suppose you could detect the one case where it won't
work (cowextsize == 1fsb) and only then change it.

--D

> 
> Brian
> 
> > > +# created non-shared delalloc block. Fail the writeback to verify that all
> > > +# delayed allocation is cleaned up properly.
> > > +_load_flakey_table $FLAKEY_ERROR_WRITES
> > > +$XFS_IO_PROG -c "pwrite 0 8k" -c fsync $SCRATCH_MNT/file2 >> $seqres.full
> > 
> > $((2 * blksz)), not 8k
> > 
> > Other than that, this looks reasonable to me.  I'll go look at the fix
> > patch now. :)
> > 
> > --D
> > 
> > > +_load_flakey_table $FLAKEY_ALLOW_WRITES
> > > +
> > > +# Try a post-fail reflink and then unmount. Both of these are known to produce
> > > +# errors and/or assert failures on XFS if we trip over a stale delalloc block.
> > > +cp --reflink $SCRATCH_MNT/file2 $SCRATCH_MNT/file3
> > > +_unmount_flakey
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/651.out b/tests/generic/651.out
> > > new file mode 100644
> > > index 00000000..bd44c80c
> > > --- /dev/null
> > > +++ b/tests/generic/651.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 651
> > > +fsync: Input/output error
> > > -- 
> > > 2.31.1
> > > 
> > 
> 
