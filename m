Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA16C83F11
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Aug 2023 15:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjH0P5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Aug 2023 11:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjH0P4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Aug 2023 11:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0935C129;
        Sun, 27 Aug 2023 08:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 839CC610D5;
        Sun, 27 Aug 2023 15:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD62CC433C8;
        Sun, 27 Aug 2023 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693151806;
        bh=jIXUP4UaYNSpzrAMSlnWn/9sFqLYlDzwWHdFP+JMODw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mnxTWXWUgMaeLJczFtaFR2sGj2NMDwPKLomMkVJPckCJb7d6DFyZ3r1LG0ikDuR27
         Ggv77zs+e9JxL0OKjW0QyUTK4ZpaeiEzvKxQrduHr1+tAzCPCUVrVqysc+iwLqQPs1
         AcAo6yXHFmioVfuRPpnP0tB6RrSKuvsiVSeSL4g/XKgDgfLCPYHrSAb0tYZjGtY6lt
         O4iwRJlOqZQ7Ty1BK9bcphEsWViSVTJfT0dM+glwPwG2APp5EMmEgFNB6ooVHFjQML
         P3AbW1CFJsWN2GeTJ+O47uAGsaAtcajy9EvXxzhzlsWU08HxCZhSHelLLyKRgfkmJI
         uXi4t02tVwt7A==
Date:   Sun, 27 Aug 2023 08:56:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] fstests: test fix for an agbno overflow in
 __xfs_getfsmap_datadev
Message-ID: <20230827155646.GA28202@frogsfrogsfrogs>
References: <20230823010046.GD11286@frogsfrogsfrogs>
 <20230823010239.GE11263@frogsfrogsfrogs>
 <20230827130644.nhdi6ihobn5qne3a@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230827130644.nhdi6ihobn5qne3a@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 27, 2023 at 09:06:44PM +0800, Zorro Lang wrote:
> On Tue, Aug 22, 2023 at 06:02:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Dave Chinner reported that xfs/273 fails if the AG size happens to be an
> > exact power of two.  I traced this to an agbno integer overflow when the
> > current GETFSMAP call is a continuation of a previous GETFSMAP call, and
> > the last record returned was non-shareable space at the end of an AG.
> > 
> > This is the regression test for that bug.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/935     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/935.out |    2 ++
> >  2 files changed, 57 insertions(+)
> >  create mode 100755 tests/xfs/935
> >  create mode 100644 tests/xfs/935.out
> > 
> > diff --git a/tests/xfs/935 b/tests/xfs/935
> > new file mode 100755
> > index 0000000000..a06f2fc8dc
> > --- /dev/null
> > +++ b/tests/xfs/935
> > @@ -0,0 +1,55 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 935
> > +#
> > +# Regression test for an agbno overflow bug in XFS GETFSMAP involving an
> > +# fsmap_advance call.  Userspace can indicate that a GETFSMAP call is actually
> > +# a continuation of a previous call by setting the "low" key to the last record
> > +# returned by the previous call.
> > +#
> > +# If the last record returned by GETFSMAP is a non-shareable extent at the end
> > +# of an AG and the AG size is exactly a power of two, the startblock in the low
> > +# key of the rmapbt query can be set to a value larger than EOAG.  When this
> > +# happens, GETFSMAP will return EINVAL instead of returning records for the
> > +# next AG.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick fsmap
> > +
> > +. ./common/filter
> > +
> > +_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> > +	"xfs: fix an agbno overflow in __xfs_getfsmap_datadev"
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_xfs_io_command fsmap
> > +_require_xfs_scratch_rmapbt
> > +
> > +_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> > +source $tmp.mkfs
> > +
> > +# Find the next power of two agsize smaller than whatever the default is.
> > +for ((p = 31; p > 0; p--)); do
> > +	desired_agsize=$((2 ** p))
> > +	test "$desired_agsize" -lt "$agsize" && break
> > +done
> > +
> > +echo "desired asize=$desired_agsize" >> $seqres.full
> > +_scratch_mkfs -d "agsize=${desired_agsize}b" | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> > +source $tmp.mkfs
> > +
> > +test "$desired_agsize" -eq "$agsize" || _notrun "wanted agsize=$desired_agsize, got $agsize"
> > +
> > +_scratch_mount
> > +$XFS_IO_PROG -c 'fsmap -n 1024 -v' $SCRATCH_MNT >> $tmp.big
> > +$XFS_IO_PROG -c 'fsmap -n 1 -v' $SCRATCH_MNT >> $tmp.small
> 
> This line reports:
> 
>   xfs_io: xfsctl(XFS_IOC_GETFSMAP) iflags=0x0 ["/mnt/xfstests/scratch"]: Invalid argument
> 
> when the test case fails. Is that normal?

Yes.  The attached bugfix should make that go away.

--D

> > +
> > +diff -Naurpw $tmp.big $tmp.small
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/935.out b/tests/xfs/935.out
> > new file mode 100644
> > index 0000000000..1b5422d1e3
> > --- /dev/null
> > +++ b/tests/xfs/935.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 935
> > +Silence is golden
> > 
> 
