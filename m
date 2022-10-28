Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA27C38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 16:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiJ1QZt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 12:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJ1QZs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 12:25:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C70718D461;
        Fri, 28 Oct 2022 09:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F76B8247D;
        Fri, 28 Oct 2022 16:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61F8C433C1;
        Fri, 28 Oct 2022 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666974344;
        bh=OJcs+eCQsVqhS9Ha0A2D5CZWrcwuzwsQLs6iPtCNqAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iR/cnEcxegl9TEALp2+Cgkl6WUDjrdtqfeJiDTbDEP4ALVFwZsi5kClNhOvOk2sBR
         Rm3FZy111oSpA5uyndKtUBNNwjK3p93Ev4OH9WfWo2CYRfqjvc75VeTOUWhWYpQ6b2
         awBbDB1XHEUP1UPCCTsb3WeNpE8OiPSKFd5TGiBloIV+do1uGWajuRP1MTBb5y3PKF
         Y8pG/XM7pnxvJlljd7OncPmciwy+Ye7L9BFu40zegrVqTefCTp0L/3rj4DK5sYUkSb
         td/b54mrfQSTS/CUBsuMXP3PDCLiQOQT6Ls93rVAamcpTqZ41ya40Jt/XxvXeLRdNY
         jeKHYnFQjiUGQ==
Date:   Fri, 28 Oct 2022 09:25:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: new test on xfs with corrupted sb_inopblock
Message-ID: <Y1wCiERfVq34IoYb@magnolia>
References: <20221028154337.1788413-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028154337.1788413-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 11:43:37PM +0800, Zorro Lang wrote:
> There's a known bug fix 392c6de98af1 ("xfs: sanitize sb_inopblock in
> xfs_mount_validate_sb"). So try to corrupt the sb_inopblock of xfs,
> to cover this bug.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> V2 does below changes:
> 1) Add _fixed_by_kernel_commit ...
> 2) Repair and check the xfs at the test end
> 
> Thanks,
> Zorro
> 
>  tests/xfs/555     | 32 ++++++++++++++++++++++++++++++++
>  tests/xfs/555.out |  6 ++++++
>  2 files changed, 38 insertions(+)
>  create mode 100755 tests/xfs/555
>  create mode 100644 tests/xfs/555.out
> 
> diff --git a/tests/xfs/555 b/tests/xfs/555
> new file mode 100755
> index 00000000..a4024501
> --- /dev/null
> +++ b/tests/xfs/555
> @@ -0,0 +1,32 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 555
> +#
> +# Corrupt xfs sb_inopblock, make sure no crash. This's a test coverage of
> +# 392c6de98af1 ("xfs: sanitize sb_inopblock in xfs_mount_validate_sb")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_fixed_by_kernel_commit 392c6de98af1 \
> +	"xfs: sanitize sb_inopblock in xfs_mount_validate_sb"
> +_require_scratch

This /might/ want a _require_xfs_db_command "write" too, but that might
not be necessary since iirc 'write' has been in db for a long time now.

Either way, this test looks ok to me so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
> +_scratch_mkfs >>$seqres.full
> +echo "corrupt inopblock of sb 0"
> +_scratch_xfs_set_metadata_field "inopblock" "500" "sb 0" >> $seqres.full
> +echo "try to mount ..."
> +_try_scratch_mount 2>> $seqres.full && _fail "mount should not succeed!"
> +echo "no crash or hang"
> +echo "repair corrupted sb 0"
> +_scratch_xfs_repair >> $seqres.full 2>&1
> +echo "check fs"
> +_scratch_xfs_repair -n >> $seqres.full 2>&1 || echo "fs isn't fixed!"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/555.out b/tests/xfs/555.out
> new file mode 100644
> index 00000000..4f1b01a2
> --- /dev/null
> +++ b/tests/xfs/555.out
> @@ -0,0 +1,6 @@
> +QA output created by 555
> +corrupt inopblock of sb 0
> +try to mount ...
> +no crash or hang
> +repair corrupted sb 0
> +check fs
> -- 
> 2.31.1
> 
