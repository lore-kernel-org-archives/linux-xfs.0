Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513C6C07545
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 20:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjJYUPs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJYUPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 16:15:48 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F097111
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 13:15:46 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5892832f8daso1038981a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 13:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1698264945; x=1698869745; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wNKFRrcGPKCw2urMVlYjSwpGmX50PHCHf7m+Ggr/ItU=;
        b=0oMP+nZgov3lwm/QG0dK5qWF5AQDMedyZwC5T+nYcHE5prN+NvdZpEXbSQj5mvOW3K
         Mpu3dy/z8T3Z3IeMRoGN/TYRnc+B3BFU+fz6ZWNmuDFbVAQNC60hUATC8bNPbAXqYeGu
         iJVUle14MSf4KH4/ETMhcvkQADO2pGETe3DOFS+UuhJBqdOCcFfLD117Tf5MyiJsGF5A
         repG4hVsq9Z3ecjno3JjaZt4XZS4DV9XT3Dnnfy5fB/lJR8aGyKhluKkfo4KqtHcXdrN
         B4M/z+RryAfnTpoNcbU7/xt9pKojliq0JOs5losRX0tqeWEwwJvqt98z/cHcqP5/jEyl
         rzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698264945; x=1698869745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNKFRrcGPKCw2urMVlYjSwpGmX50PHCHf7m+Ggr/ItU=;
        b=Jd15jIvgDI1Pxy8cP52bTn+aojXa9CFIFDkfNhlthjGUT/4bHRNYMk8uM/KdeGX2hg
         W2yfmWq7T1eeEUT67FrEUUvSLWALdId8nl4+7jwC0JgssMjZuVIiUWxu4h0e+t6/Hq24
         SgRxzWWEi2j4ej/jEuZIEZvP6gIDCsApo6EefZsGP7ET9KJZqs6k2ouZ8KQ2/0RXx3eR
         b58uVnWMWgrQBzPR3AEUjsOeiaSoKtJbjSToDn/9FhQWjh26mq6cwYBd+s819jISTySK
         d70/Z51kht6/weNYA2wlGwdRqjIkGhzWPrXJheOYnnYtyp1z7VxqU5EEOueBRazBTgnJ
         RzTA==
X-Gm-Message-State: AOJu0YzfjqAwFeIbIYITbyjimrrmdl2YX7Z794OOFhvMbzC8/RJ0Q1lR
        un0cGZ64DYujmpPJbE2PrC6uMalCdcCmSLKd3GI=
X-Google-Smtp-Source: AGHT+IFWre9y5UnZUXpG9XIHgHLhDKerCZ8Di3Xxue/0aJEEnDpUpBEtG8BpQ4sZafw2HaOA7+2EpQ==
X-Received: by 2002:a17:90b:3e87:b0:27c:f282:adac with SMTP id rj7-20020a17090b3e8700b0027cf282adacmr852056pjb.0.1698264945390;
        Wed, 25 Oct 2023 13:15:45 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::6:9893])
        by smtp.gmail.com with ESMTPSA id bv8-20020a17090af18800b0027df62a9e68sm286190pjb.13.2023.10.25.13.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 13:15:44 -0700 (PDT)
Date:   Wed, 25 Oct 2023 13:15:43 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH fstests] xfs: test refilling AGFL after lots of btree
 splits
Message-ID: <ZTl3b3dqgEHUZ+w/@telecaster>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com>
 <20231025152702.GE3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025152702.GE3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 08:27:02AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 24, 2023 at 04:37:42PM -0700, Omar Sandoval wrote:
> > This is a regression test for patch "xfs: fix internal error from AGFL
> > exhaustion"), which is not yet merged. Without the fix, it will fail
> > with a "Structure needs cleaning" error.
> 
> Will look at the actual code patch next...
> 
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> >  tests/xfs/601     | 62 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/601.out |  2 ++
> >  2 files changed, 64 insertions(+)
> >  create mode 100755 tests/xfs/601
> >  create mode 100644 tests/xfs/601.out
> > 
> > diff --git a/tests/xfs/601 b/tests/xfs/601
> > new file mode 100755
> > index 00000000..bbc5b443
> > --- /dev/null
> > +++ b/tests/xfs/601
> > @@ -0,0 +1,62 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) Meta Platforms, Inc. and affiliates.
> > +#
> > +# FS QA Test 601
> > +#
> > +# Regression test for patch "xfs: fix internal error from AGFL exhaustion".
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto prealloc punch
> > +
> > +. ./common/filter
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_test_program punch-alternating
> > +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: fix internal error from AGFL exhaustion"
> > +
> > +_scratch_mkfs -m rmapbt=0 | _filter_mkfs > /dev/null 2> "$tmp.mkfs"
> 
> Need to probe if mkfs.xfs actually supports rmapbt options first, since
> this bug applies to old fses from before rmap even existed, right?

Good point. Something like:

opts=
if $MKFS_XFS_PROG |& grep rmapbt; then
	opts="-m rmapbt=0"
fi
_scratch_mkfs $opts | _filter_mkfs > /dev/null 2> "$tmp.mkfs"

> (Or: What changes are needed to make the reproducer work with rmapbt
> enabled?)

We'd need to craft the filesystem in a way that a single operation
splits and adds a new level to the bnobt, cntbt, and rmapbt all at the
same time. It can probably be done, but I suspect it'd be much more
complicated :(

> > +. "$tmp.mkfs"
> > +_scratch_mount
> > +
> > +alloc_block_len=$((_fs_has_crcs ? 56 : 16))
> > +allocbt_leaf_maxrecs=$(((dbsize - alloc_block_len) / 8))
> > +allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
> > +
> > +# Create a big file with a size such that the punches below create the exact
> > +# free extents we want.
> > +num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
> > +$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
> 
> What happens if the allocations are all in some other AG?  The scratch
> device could be 100TB.

Yeah, this relies on all of the allocations going to AG 0, and the big
fallocate getting one contiguous extent. That always happened for me on
a few different sized filesystems, but I understand it's not guaranteed.
Maybe I should create the filesystem with -d agcount=1?

> > +# Fill in any small free extents in AG 0. After this, there should be only one,
> > +# large free extent.
> > +_scratch_unmount
> > +mapfile -t gaps < <($XFS_DB_PROG -c 'agf 0' -c 'addr cntroot' -c 'p recs' "$SCRATCH_DEV" |
> > +	$SED_PROG -rn 's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' |
> > +	tac | tail -n +2)
> 
> _scratch_xfs_db -c 'agf 0' -c 'addr cntroot' -c 'btdump' ?

Will fix.

> > +_scratch_mount
> > +for gap_i in "${!gaps[@]}"; do
> > +	gap=${gaps[$gap_i]}
> > +	$XFS_IO_PROG -c "falloc 0 $((gap * dbsize))" -f "$SCRATCH_MNT/gap$gap_i"
> > +done
> > +
> > +# Create enough free space records to make the bnobt and cntbt both full,
> > +# 2-level trees, plus one more record to make them split all the way to the
> > +# root and become 3-level trees. After this, there is a 7-block free extent in
> > +# the rightmost leaf of the cntbt, and all of the leaves of the cntbt other
> > +# than the rightmost two are full. Without the fix, the free list is also
> > +# empty.
> > +$XFS_IO_PROG -c "fpunch $dbsize $((7 * dbsize))" "$SCRATCH_MNT/big"
> > +"$here/src/punch-alternating" -o 9 "$SCRATCH_MNT/big"
> > +
> > +# Do an arbitrary operation that refills the free list. Without the fix, this
> > +# will allocate 6 blocks from the 7-block free extent in the rightmost leaf of
> > +# the cntbt, then try to insert the remaining 1 block free extent in the
> > +# leftmost leaf of the cntbt. But that leaf is full, so this tries to split the
> > +# leaf and fails because the free list is empty.
> > +$XFS_IO_PROG -c "fpunch 0 $dbsize" "$SCRATCH_MNT/big"
> > +
> > +echo "Silence is golden"
> 
> Without the fix applied, what happens now?  Does fpunch fail with EIO
> to taint the golden output?

It fails with EFSCORRUPTED/EUCLEAN and prints an error message as noted
in my commit message, yeah.

Thanks!

Omar
