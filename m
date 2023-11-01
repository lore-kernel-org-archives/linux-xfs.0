Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9F9C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Nov 2023 06:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343684AbjKAGqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 02:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343549AbjKAGqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 02:46:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4321510D
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 23:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698821151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DtWSBKy+pJ4d1oGPsGdg7yXWIMqrMYv2TkJ0w13nPm0=;
        b=ZGqfR+vwQXI1o82YpvFpvAK1CZ3NCh+cE/tIFEkcivzXylxR3+hOn1i8c5qa0OJzLMI4e3
        rMasMlzfQZyJ8Q1jbEqcB9g19jKD2MJHe5AxA2FVCad5eaG1VkeRU+OrN17tDvZvSlVj97
        6S7SbBIuLLVhN8kSn6594vFg5KnM8To=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-fO39vnH_NeODtKKuVsLKHw-1; Wed, 01 Nov 2023 02:45:50 -0400
X-MC-Unique: fO39vnH_NeODtKKuVsLKHw-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5b95ee4ae94so2531481a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 23:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698821149; x=1699425949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtWSBKy+pJ4d1oGPsGdg7yXWIMqrMYv2TkJ0w13nPm0=;
        b=Lcq2YT60GedTLf4Klrel9sz5Wn19+pIDK3b19WUWa2xrDZ5fX08i1inx2KkavMVvoM
         WT/ShD5xYGv21dAbnXq/m912BuWoO3NI89xheIvdQpU13KDLRimUS50wCklioQuH1DB5
         Ryyf01n0xK3BEwud+vncaAW6hs/rDyqrFJMLFXljDQcHgkmxKHcTjVHN0sSn84KFRTK/
         MDUvDW13RD7i2rBFIhaYfhJMhxrFer8sI1FHNhEi9X4m8/3/zJvVfyLdTJLo8+zXq1Zz
         TbDn83eEclROdmtny8TFGz7jS2+jifp/zsCCWrK03SvTtTz1OemHGpRIxRwnH25MN0fp
         8ITA==
X-Gm-Message-State: AOJu0YxAQDkwrS9AY37bVTLXH7a11+bWAV6EpSAMnaaNPdjffrqsor67
        /jiLw2K5ZW61f18yyexl1gveYBs9HLGyUK5idbvYRzpU1Nnj5TuWLsvzFOVn9pv8t1fGrlCIvpZ
        DRuchs3/KYm0J0tLJXnZ/
X-Received: by 2002:a05:6a21:3389:b0:17d:b971:ebc3 with SMTP id yy9-20020a056a21338900b0017db971ebc3mr15275248pzb.0.1698821148962;
        Tue, 31 Oct 2023 23:45:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmcnbCXQjoBdhKM4Tp/qdXpXon8wZcdPMd3M5puKV4E+SzowWI40QgbORsSdq1fDGle0IHVQ==
X-Received: by 2002:a05:6a21:3389:b0:17d:b971:ebc3 with SMTP id yy9-20020a056a21338900b0017db971ebc3mr15275231pzb.0.1698821148551;
        Tue, 31 Oct 2023 23:45:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ev13-20020a17090aeacd00b002809d2d90e3sm241723pjb.8.2023.10.31.23.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 23:45:48 -0700 (PDT)
Date:   Wed, 1 Nov 2023 14:45:43 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Omar Sandoval <osandov@osandov.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH fstests v2] xfs: test refilling AGFL after lots of btree
 splits
Message-ID: <20231101064543.uruh3ljicwnedw7x@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
 <fe622bff22bca23648ed1154faeadce3ed51ad3b.1698699498.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe622bff22bca23648ed1154faeadce3ed51ad3b.1698699498.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 30, 2023 at 02:00:15PM -0700, Omar Sandoval wrote:
> This is a regression test for patch "xfs: fix internal error from AGFL
> exhaustion"), which is not yet merged. Without the fix, it will fail
> with a "Structure needs cleaning" error.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> Changes since v1 [1]:
> 
> - Fixed to check whether mkfs.xfs supports -m rmapbt.
> - Changed bare $XFS_DB calls to _scratch_xfs_db.
> - Expanded comment about what happens without the fix.
> 
> I didn't add a check for whether everything ended up in AG 0, because it
> wasn't clear to me what to do in that case. We could skip the test, but
> it also doesn't hurt to run it anyways.
> 
> 1: https://lore.kernel.org/linux-xfs/c7be2fe66a297316b934ddd3a1368b14f39a9f22.1698190540.git.osandov@osandov.com/
> 
>  tests/xfs/601     | 68 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/601.out |  2 ++

The xfs/601 has been taken by:
  39f88c55 ("generic: test FALLOC_FL_UNSHARE when pagecache is not loaded")

I'll change this case to another number.

...
Hi Darrick, I just noticed that commit has "generic", but that's a case in
tests/xfs, and there's not "_supported_fs xfs" in xfs/601. Do you want to
move it to be a generic case?

>  2 files changed, 70 insertions(+)
>  create mode 100755 tests/xfs/601
>  create mode 100644 tests/xfs/601.out
> 
> diff --git a/tests/xfs/601 b/tests/xfs/601
> new file mode 100755
> index 00000000..68df6ac0
> --- /dev/null
> +++ b/tests/xfs/601
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) Meta Platforms, Inc. and affiliates.
> +#
> +# FS QA Test 601
> +#
> +# Regression test for patch "xfs: fix internal error from AGFL exhaustion".
> +#
> +. ./common/preamble
> +_begin_fstest auto prealloc punch
> +
> +. ./common/filter
> +
> +_supported_fs xfs
> +_require_scratch

_require_xfs_io_command "fpunch" ?

I can help to add that, others look good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +_require_test_program punch-alternating
> +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: fix internal error from AGFL exhaustion"
> +
> +# Disable the rmapbt so we only need to worry about splitting the bnobt and
> +# cntbt at the same time.
> +opts=
> +if $MKFS_XFS_PROG |& grep -q rmapbt; then
> +	opts="-m rmapbt=0"
> +fi
> +_scratch_mkfs $opts | _filter_mkfs > /dev/null 2> "$tmp.mkfs"
> +. "$tmp.mkfs"
> +_scratch_mount
> +
> +alloc_block_len=$((_fs_has_crcs ? 56 : 16))
> +allocbt_leaf_maxrecs=$(((dbsize - alloc_block_len) / 8))
> +allocbt_node_maxrecs=$(((dbsize - alloc_block_len) / 12))
> +
> +# Create a big file with a size such that the punches below create the exact
> +# free extents we want.
> +num_holes=$((allocbt_leaf_maxrecs * allocbt_node_maxrecs - 1))
> +$XFS_IO_PROG -c "falloc 0 $((9 * dbsize + num_holes * dbsize * 2))" -f "$SCRATCH_MNT/big"
> +
> +# Fill in any small free extents in AG 0. After this, there should be only one,
> +# large free extent.
> +_scratch_unmount
> +mapfile -t gaps < <(_scratch_xfs_db -c 'agf 0' -c 'addr cntroot' -c btdump |
> +	$SED_PROG -rn 's/^[0-9]+:\[[0-9]+,([0-9]+)\].*/\1/p' |
> +	tac | tail -n +2)
> +_scratch_mount
> +for gap_i in "${!gaps[@]}"; do
> +	gap=${gaps[$gap_i]}
> +	$XFS_IO_PROG -c "falloc 0 $((gap * dbsize))" -f "$SCRATCH_MNT/gap$gap_i"
> +done
> +
> +# Create enough free space records to make the bnobt and cntbt both full,
> +# 2-level trees, plus one more record to make them split all the way to the
> +# root and become 3-level trees. After this, there is a 7-block free extent in
> +# the rightmost leaf of the cntbt, and all of the leaves of the cntbt other
> +# than the rightmost two are full. Without the fix, the free list is also
> +# empty.
> +$XFS_IO_PROG -c "fpunch $dbsize $((7 * dbsize))" "$SCRATCH_MNT/big"
> +"$here/src/punch-alternating" -o 9 "$SCRATCH_MNT/big"
> +
> +# Do an arbitrary operation that refills the free list. Without the fix, this
> +# will allocate 6 blocks from the 7-block free extent in the rightmost leaf of
> +# the cntbt, then try to insert the remaining 1 block free extent in the
> +# leftmost leaf of the cntbt. But that leaf is full, so this tries to split the
> +# leaf and fails because the free list is empty, returning EFSCORRUPTED.
> +$XFS_IO_PROG -c "fpunch 0 $dbsize" "$SCRATCH_MNT/big"
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/xfs/601.out b/tests/xfs/601.out
> new file mode 100644
> index 00000000..0d70c3e5
> --- /dev/null
> +++ b/tests/xfs/601.out
> @@ -0,0 +1,2 @@
> +QA output created by 601
> +Silence is golden
> -- 
> 2.41.0
> 
> 

