Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10184C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 20:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbiKQUnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 15:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiKQUnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 15:43:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E3F8CB93;
        Thu, 17 Nov 2022 12:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA1E862245;
        Thu, 17 Nov 2022 20:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C756C433D6;
        Thu, 17 Nov 2022 20:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668717785;
        bh=5Lq4xe5cgNu+AaGUjjFNdtv0sOaHcIgKiaEfZRlB058=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EOJ2CmR6H9J+qjM2ff+7taDAEjVebBZuVJmaZzhWmFsagLf0DIJtuphboXDJVjSVz
         N90RS+P9QD9GRQkyZ3wxxU+uJONXs622947lTpx5V6Rf5KEACbpOjqRa2G+rnXsftT
         gLoI3gfddPdMEdHHlyWu5vtUg4trGcKSkSTAtoXHeBl62y6mzU6q8i1mjDpjc+sNID
         QKc+9zjSqhk/qg/WVUNIo8/6/LRtgenuq1Dp3/Lh35ncKbFblPci557kuCrYoQ/Y23
         gx9k4+CXqukHJNZfnOqBE1EE4kHCDCyXWfzqCOLH5olBzAFkl4jKNInI7B3DP0WNFT
         AGSruj6dpS56g==
Date:   Thu, 17 Nov 2022 12:43:04 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1] xfstests: test xfs_spaceman fsuuid command
Message-ID: <Y3ac2K52hPnsQR8i@magnolia>
References: <20221109222630.85053-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109222630.85053-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 02:26:30PM -0800, Catherine Hoang wrote:
> Add a test to verify the xfs_spaceman fsuuid functionality.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  tests/xfs/557     | 31 +++++++++++++++++++++++++++++++
>  tests/xfs/557.out |  2 ++
>  2 files changed, 33 insertions(+)
>  create mode 100755 tests/xfs/557
>  create mode 100644 tests/xfs/557.out
> 
> diff --git a/tests/xfs/557 b/tests/xfs/557
> new file mode 100755
> index 00000000..0b41e693
> --- /dev/null
> +++ b/tests/xfs/557
> @@ -0,0 +1,31 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 557
> +#
> +# Test to verify xfs_spaceman fsuuid functionality
> +#
> +. ./common/preamble
> +_begin_fstest auto quick spaceman
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_spaceman_command "fsuuid"
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +expected_uuid="$(_scratch_xfs_admin -u)"

A future xfs_admin.sh will be ported to call xfs_io if the filesystem is
mounted, so you really ought to read the ondisk uuid straight from the
debugger before mounting, and query the kernel after mounting:

_scratch_mkfs >> $seqres.full
expected_uuid=$(_scratch_xfs_get_sb_field uuid)

_scratch_mount >> $seqres.full
actual_uuid=$($XFS_IO_PROG -c fsuuid $SCRATCH_MNT)
if [ "$expected_uuid" != "$actual_uuid" ]; then
	...
fi

--D

> +actual_uuid="$($XFS_SPACEMAN_PROG -c "fsuuid" $SCRATCH_MNT)"
> +
> +if [ "$expected_uuid" != "$actual_uuid" ]; then
> +        echo "expected UUID ($expected_uuid) != actual UUID ($actual_uuid)"
> +fi
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/557.out b/tests/xfs/557.out
> new file mode 100644
> index 00000000..1f1ae1d4
> --- /dev/null
> +++ b/tests/xfs/557.out
> @@ -0,0 +1,2 @@
> +QA output created by 557
> +Silence is golden
> -- 
> 2.25.1
> 
