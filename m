Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBABECAAD2
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 01:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbiIBBT3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 21:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbiIBBTV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 21:19:21 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98232A6AE0;
        Thu,  1 Sep 2022 18:19:20 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v5so433187plo.9;
        Thu, 01 Sep 2022 18:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=pDGIofX20XOXFmRT5L0BmUWHa+0q9FZCwKdeHLSAXCU=;
        b=Yz/aDMArhnuxDg1TmTexUH+I5AUzQeo7g1hBq4lz7wrenEjNBkXCSpEj9dlReBSWjL
         Ei37q+jznvVAW3tHzxqQZ83VBpYS+KqJOFngcqetntbSrga03qKIlds7xPRWeM7C8cuW
         UZWXGH2+YgfeAm9/zbbSmD8Y7W1Q3YXZBFNyEB9UTzxL4tr5UYS0juuRRScY8s2H2VgX
         4TOuIaeq7DolRNnmLQjOvJCj1nce8JL45bOZxL+OlJmqT3iQrTRmZC71Y7rIySRhAzoC
         Hokoln9cdl/hsFL6CV0k4sznBP0BsDt9Vg/HpFJ2Jn2oG97oIu49NiSX7QOGl/xfXtQ1
         Ytjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=pDGIofX20XOXFmRT5L0BmUWHa+0q9FZCwKdeHLSAXCU=;
        b=I0BE91EQknIAqxXK0EwOvBFRF1wntPW3QpPOOeh0f3iFyfzpZrSQu4RjkkQCF7BRlM
         DrEqhKep0vS8IHftif65VEUV4eCJukHF+GjASxaYFW1PHuwj8gXOVgnkHXiqvYWWKmZf
         Eb+2yXEd0ksOfsL2pavCz1uiixHEk8BOiAtPeEadayfasmefA5Y6//0j23PccTHBrH/V
         yELO1UkVo/ltzGKWemhbewOcXh9E8YEsxl1HBgfRzkcw+YLYuzYm5lSjqO8mU3HlD6qb
         wGkzVrmYVq4mo9Pw6FBtAepoloBAHwRMFJn0SLWtCgviOLFGQHgrtajUNegEsjMX3rbb
         n7TA==
X-Gm-Message-State: ACgBeo0wn9N+V2wkcipbhVRhebQptOK5h1t7wfH0bdj+CASa1UgfSj3L
        ImnMzdLfwNuErWb1irCFC+XdYZ7XNYeF6kvBVutyegdJ
X-Google-Smtp-Source: AA6agR4MQFTeZo+Ltc3pgimmCWIOgfaNT+7sAj4yiwuQ1+NJyA6tTt/QZqgJuMfw+CKvKQPkJL7Jhl3zUnmCCMo+1P0=
X-Received: by 2002:a17:90a:cb14:b0:1fd:c964:f708 with SMTP id
 z20-20020a17090acb1400b001fdc964f708mr2083064pjt.62.1662081560127; Thu, 01
 Sep 2022 18:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220825130042.1707017-1-chandan.babu@oracle.com>
In-Reply-To: <20220825130042.1707017-1-chandan.babu@oracle.com>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Fri, 2 Sep 2022 09:19:08 +0800
Message-ID: <CADJHv_uYEL7zqhG5AwE5G6Y+0PQdx1qW-yUQ_0U7LYsW4oYwvg@mail.gmail.com>
Subject: Re: [PATCH V3] xfs: Check if a direct write can result in a false
 ENOSPC error
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests <fstests@vger.kernel.org>, Zorro Lang <zlang@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good!

On Thu, Aug 25, 2022 at 9:04 PM Chandan Babu R <chandan.babu@oracle.com> wrote:
>
> This commit adds a test to check if a direct write on a delalloc extent
> present in CoW fork can result in a false ENOSPC error. The bug has been fixed
> by upstream commit d62113303d691 ("xfs: Fix false ENOSPC when performing
> direct write on a delalloc extent in cow fork").
>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
> Changelog:
> V2 -> V3:
>   1. Use _get_file_block_size instead of _get_block_size.
>
> V1 -> V2:
>   1. Use file blocks as units instead of bytes to specify file offsets.
>
>  tests/xfs/553     | 67 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/553.out |  9 +++++++
>  2 files changed, 76 insertions(+)
>  create mode 100755 tests/xfs/553
>  create mode 100644 tests/xfs/553.out
>
> diff --git a/tests/xfs/553 b/tests/xfs/553
> new file mode 100755
> index 00000000..e98c04ed
> --- /dev/null
> +++ b/tests/xfs/553
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 553
> +#
> +# Test to check if a direct write on a delalloc extent present in CoW fork can
> +# result in an ENOSPC error.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick clone
> +
> +# Import common functions.
> +. ./common/reflink
> +. ./common/inject
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_fixed_by_kernel_commit d62113303d691 \
> +       "xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
> +_require_scratch_reflink
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +_require_xfs_io_command "reflink"
> +_require_xfs_io_command "cowextsize"
> +
> +source=${SCRATCH_MNT}/source
> +destination=${SCRATCH_MNT}/destination
> +fragmented_file=${SCRATCH_MNT}/fragmented_file
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +blksz=$(_get_file_block_size $SCRATCH_MNT)
> +
> +echo "Create source file"
> +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 8192))" $source >> $seqres.full
> +
> +echo "Reflink destination file with source file"
> +$XFS_IO_PROG -f -c "reflink $source" $destination >> $seqres.full
> +
> +echo "Set destination file's cowextsize to 4096 blocks"
> +$XFS_IO_PROG -c "cowextsize $((blksz * 4096))" $destination >> $seqres.full
> +
> +echo "Fragment FS"
> +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 16384))" $fragmented_file \
> +            >> $seqres.full
> +sync
> +$here/src/punch-alternating $fragmented_file >> $seqres.full
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Create delalloc extent of length 4096 blocks in destination file's CoW fork"
> +$XFS_IO_PROG -c "pwrite 0 $blksz" $destination >> $seqres.full
> +
> +sync
> +
> +echo "Direct I/O write at 3rd block in destination file"
> +$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $destination \
> +            >> $seqres.full
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/553.out b/tests/xfs/553.out
> new file mode 100644
> index 00000000..9f5679de
> --- /dev/null
> +++ b/tests/xfs/553.out
> @@ -0,0 +1,9 @@
> +QA output created by 553
> +Format and mount fs
> +Create source file
> +Reflink destination file with source file
> +Set destination file's cowextsize to 4096 blocks
> +Fragment FS
> +Inject bmap_alloc_minlen_extent error tag
> +Create delalloc extent of length 4096 blocks in destination file's CoW fork
> +Direct I/O write at 3rd block in destination file
> --
> 2.35.1
>
