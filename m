Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C106C32796
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 16:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245351AbiHWQrF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343784AbiHWQqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 12:46:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8A7C7FAF;
        Tue, 23 Aug 2022 07:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB566B8191E;
        Tue, 23 Aug 2022 14:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A7BC433C1;
        Tue, 23 Aug 2022 14:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661264911;
        bh=1MtnzPedujxaeQqskAInC5MQZi5DdXIRqiIgbQJ0P9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dyf8o4L+Yq3k5XdvTdot1BN3t7UxqOaNp3TGIpnRFxakOVhzWguSCHg6CAbMnxWrs
         eEA5MxDPJwxC2Iuwr+rc077XBhL92lpmPspJjUq5IXAQ194rFq6RXXHGBuipskbFmQ
         qQckzge/40HfzFDwUq+gTiHkKlbrYTJsNnm6v07WVhQ19oO4DY/d39poyTwPCMgAIY
         mH4FH/dhkE1evJ9Yugh9ci13tclREExLnkQNRByjmk9GPr72DwAHcncjQMNpCEBS35
         vu82Cr75Vin0ZaTrY97LJr1BmUVj5KwIXnGDO76wHkWWsnl2j1FeXPz7JjGu2P9YoH
         y+4x6k19cDbJA==
Date:   Tue, 23 Aug 2022 07:28:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Check if a direct write can result in a false
 ENOSPC error
Message-ID: <YwTkDrlpzPc2TXDC@magnolia>
References: <20220823090433.1164296-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823090433.1164296-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 23, 2022 at 02:34:33PM +0530, Chandan Babu R wrote:
> This commit adds a test to check if a direct write on a delalloc extent
> present in CoW fork can result in a false ENOSPC error. The bug has been fixed
> by upstream commit d62113303d691 ("xfs: Fix false ENOSPC when performing
> direct write on a delalloc extent in cow fork").
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  tests/xfs/553     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/553.out |  9 +++++++
>  2 files changed, 72 insertions(+)
>  create mode 100755 tests/xfs/553
>  create mode 100644 tests/xfs/553.out
> 
> diff --git a/tests/xfs/553 b/tests/xfs/553
> new file mode 100755
> index 00000000..78ed0995
> --- /dev/null
> +++ b/tests/xfs/553
> @@ -0,0 +1,63 @@
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
> +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
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
> +echo "Create source file"
> +$XFS_IO_PROG -f -c "pwrite 0 32M" $source >> $seqres.full
> +
> +echo "Reflink destination file with source file"
> +$XFS_IO_PROG -f -c "reflink $source" $destination >> $seqres.full
> +
> +echo "Set destination file's cowextsize"
> +$XFS_IO_PROG -c "cowextsize 16M" $destination >> $seqres.full
> +
> +echo "Fragment FS"
> +$XFS_IO_PROG -f -c "pwrite 0 64M" $fragmented_file >> $seqres.full
> +sync
> +$here/src/punch-alternating $fragmented_file >> $seqres.full
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Create 16MiB delalloc extent in destination file's CoW fork"
> +$XFS_IO_PROG -c "pwrite 0 4k" $destination >> $seqres.full
> +
> +sync
> +
> +echo "Direct I/O write at 12k file offset in destination file"
> +$XFS_IO_PROG -d -c "pwrite 12k 8k" $destination >> $seqres.full

Does this still work if the blocksize is 64k? ;)

(The rest of the test code looks ok to me)

--D

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/553.out b/tests/xfs/553.out
> new file mode 100644
> index 00000000..a2e91678
> --- /dev/null
> +++ b/tests/xfs/553.out
> @@ -0,0 +1,9 @@
> +QA output created by 553
> +Format and mount fs
> +Create source file
> +Reflink destination file with source file
> +Set destination file's cowextsize
> +Fragment FS
> +Inject bmap_alloc_minlen_extent error tag
> +Create 16MiB delalloc extent in destination file's CoW fork
> +Direct I/O write at 12k file offset in destination file
> -- 
> 2.35.1
> 
