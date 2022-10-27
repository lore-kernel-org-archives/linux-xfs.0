Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3B7FA3741
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbiJ0RBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbiJ0RBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:01:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F43F17FD5A;
        Thu, 27 Oct 2022 10:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19787B82719;
        Thu, 27 Oct 2022 17:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7F3C433C1;
        Thu, 27 Oct 2022 17:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890074;
        bh=xSHpNj50OsQ7WTvgu55ptBGascXdBOjRTufcpN4MLCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bpxnCUR/TvZxXqr4uLYquVnsQQcV12wY7QhCgRMiEsgljqqqsI9cRgU7n90hq2/wO
         88hW6Co5n/iEEPyvdtL3YFxzUWz7atD8A6UPbPrL4t9mnZCUoOtBZ8aD/vlZ+/eabm
         dHU7yMXZzDDjP+geF0KP4e/i4kpRXghWj/wd7Eu25T5LBoubvzPT6a3TGbjtZfoh0U
         fgIhSGsCAxDW60IsZuCvp9QyvB2a2VLc/6Q5tkmKWvUMJ8tft6G6rz4zOzqcKgvdmJ
         xaPlJpHGPqdAcBUNjJEH17JGmgCFR+SqXXlUcDcHP60beuCjQwM12v8mvIazKOLNa7
         y8OCe0qFLwWUg==
Date:   Thu, 27 Oct 2022 10:01:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: new test on xfs with corrupted sb_inopblock
Message-ID: <Y1q5Wkkzq/7PIeyL@magnolia>
References: <20221027164254.1472306-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027164254.1472306-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 12:42:54AM +0800, Zorro Lang wrote:
> There's a known bug fix 392c6de98af1 ("xfs: sanitize sb_inopblock in
> xfs_mount_validate_sb"). So try to corrupt the sb_inopblock of xfs,
> to cover this bug.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/xfs/555     | 27 +++++++++++++++++++++++++++
>  tests/xfs/555.out |  4 ++++
>  2 files changed, 31 insertions(+)
>  create mode 100755 tests/xfs/555
>  create mode 100644 tests/xfs/555.out
> 
> diff --git a/tests/xfs/555 b/tests/xfs/555
> new file mode 100755
> index 00000000..7f46a9af
> --- /dev/null
> +++ b/tests/xfs/555
> @@ -0,0 +1,27 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 555
> +#
> +# Corrupt xfs sb_inopblock, make sure no crash. This's a test coverage of
> +# 392c6de98af1 ("xfs: sanitize sb_inopblock in xfs_mount_validate_sb")

_fixed_by_kernel_commit?

> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch_nocheck
> +
> +_scratch_mkfs >>$seqres.full
> +
> +echo "corrupt inopblock of sb 0"
> +_scratch_xfs_set_metadata_field "inopblock" "500" "sb 0" >> $seqres.full
> +echo "try to mount ..."
> +_try_scratch_mount 2>> $seqres.full && _fail "mount should not succeed"
> +
> +echo "no crash or hang"

You might want to check the scratch fs to make sure repair will deal
with the problem...?

--D

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/555.out b/tests/xfs/555.out
> new file mode 100644
> index 00000000..36c3446e
> --- /dev/null
> +++ b/tests/xfs/555.out
> @@ -0,0 +1,4 @@
> +QA output created by 555
> +corrupt inopblock of sb 0
> +try to mount ...
> +no crash or hang
> -- 
> 2.31.1
> 
