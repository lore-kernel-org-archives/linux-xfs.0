Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709B3C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 16:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiKIQvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 11:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiKIQvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 11:51:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3E51EEF4;
        Wed,  9 Nov 2022 08:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 99D5ECE1FE3;
        Wed,  9 Nov 2022 16:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD671C433C1;
        Wed,  9 Nov 2022 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668012705;
        bh=ScExPiaZqx2HlutJDhwEJn2QRR5/82Ondv3X1/oizGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sI3Xzc+iFbmZhfCrT3mMModxLux/wICXLRJmdHEwyQpEVQRSmNq6XrJyA7J5Jx85P
         oL0rrYiZOZ2y572YRvI0MdloThxYeV+SVhxqzDyuSccg+zdl5Y8oEdrPGBzuc4uKX7
         8vFJfXoV+fc9y93LaAhRMzkxBJQtV7kWwDfW1c3tTL/fySen6yOO+/vUEOK3aQ1QOV
         XUbhP9xZGMEKJBJiSSXGP906tuc3j9zktgAa7/wr+M/s0rJkIh9GAFAaggWUxZYccL
         BLRRSR2Ef+rHJFRewr6jh5JSyN41qzfdhYTYIQixrZ7TrxIWcmbrtKvjQYZQC6xZAi
         YpoS8PQ05va7g==
Date:   Wed, 9 Nov 2022 08:51:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] generic: shutdown might leave NULL files with nonzero
 di_size
Message-ID: <Y2vaoY486TpfKXM3@magnolia>
References: <20221109130746.3669020-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109130746.3669020-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 09:07:46PM +0800, Zorro Lang wrote:
> An old issue might cause on-disk inode sizes are logged prematurely
> via the free eofblocks path on file close. Then fs shutdown might
> leave NULL files but their di_size > 0.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Hi,
> 
> V2 replace xfs_io fiemap command with stat command.
> V3 replace the stat with the filefrag command, and change the supported_fs
> from xfs to generic.
> 
> Thanks,
> Zorro
> 
>  tests/generic/999     | 46 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  5 +++++
>  2 files changed, 51 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..ca666de7
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,46 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 999
> +#
> +# Test an issue in the truncate codepath where on-disk inode sizes are logged
> +# prematurely via the free eofblocks path on file close.
> +#
> +. ./common/preamble
> +_begin_fstest auto shutdown
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_require_scratch_shutdown
> +_require_command "$FILEFRAG_PROG" filefrag
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Create many small files with one extent at least"
> +for ((i=0; i<10000; i++));do
> +	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
> +done
> +
> +echo "Shutdown the fs suddently"
> +_scratch_shutdown
> +
> +echo "Cycle mount"
> +_scratch_cycle_mount
> +
> +echo "Check file's (di_size > 0) extents"
> +for f in $(find $SCRATCH_MNT -type f -size +0);do
> +	# Check if the file has any extent
> +	$FILEFRAG_PROG -v $f > $tmp.filefrag
> +	grep -Eq ': 0 extents found' $tmp.filefrag
> +	if [ $? -eq 0 ];then

Bash nit: You could compress these two lines to:

	if grep -E -q ': 0 extents found' $tmp.filefrag; then

But otherwise this looks good.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +		echo " - $f get no extents, but its di_size > 0"
> +		cat $tmp.filefrag
> +		break
> +	fi
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..50008783
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,5 @@
> +QA output created by 999
> +Create many small files with one extent at least
> +Shutdown the fs suddently
> +Cycle mount
> +Check file's (di_size > 0) extents
> -- 
> 2.31.1
> 
