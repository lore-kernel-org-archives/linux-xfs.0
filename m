Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DE6C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 21:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 485F964E02
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 21:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhBVVXB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 16:23:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhBVVW7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 16:22:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF4F64E02;
        Mon, 22 Feb 2021 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614028938;
        bh=WBh5qWgfM7G56vrwoGlbZeOtR2U0q3m8T55gWBCj5m4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pSqRlusZz+bxWE8ZEm6/mrrQXJofwqr0Qw4ljds/bUOJTlDjAvBiqInvgCxocspW7
         oknFAf4VmlZ9gmnBfYEFMcnAJh5ltlzP3/LA7JzWNp5+w1QW9Hx1TZJ7qhk4Sb/+F9
         Kgw2UyDwrqQUTI1/jgIwHxUebksk/QZ9JfizoQ9lYbCCNS00IqaolcRDZieCTHkdYR
         ouaunTIxmE6sVM4OobS0eEQf0ejovKwp6kw9wsQ2CUft/8oLLtkjSDUXUrO0YI75Ym
         9ECm6PlLGowzpKKrwSZYkdUAi7dCdr2VeEeQ7CJ6TPlWKWVr/tW6+NBcKhz77m3j2D
         N6ExCR8QBJZ/Q==
Date:   Mon, 22 Feb 2021 13:22:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Add test for printing deprec. mount options
Message-ID: <20210222212217.GD7272@magnolia>
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220221549.290538-2-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 20, 2021 at 11:15:48PM +0100, Pavel Reichl wrote:
> Verify that warnings about deprecated mount options are properly
> printed.
> 
> Verify that no excessive warnings are printed during remounts.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  tests/xfs/528     | 88 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/528.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 91 insertions(+)
>  create mode 100755 tests/xfs/528
>  create mode 100644 tests/xfs/528.out
> 
> diff --git a/tests/xfs/528 b/tests/xfs/528
> new file mode 100755
> index 00000000..0fc57cef
> --- /dev/null
> +++ b/tests/xfs/528
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.. All Rights Reserved.
> +#
> +# FS QA Test 528
> +#
> +# Verify that warnings about deprecated mount options are properly printed.
> +#  
> +# Verify that no excessive warnings are printed during remounts.
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +_require_check_dmesg
> +_supported_fs xfs
> +_require_scratch
> +
> +log_tag()
> +{
> +	echo "fstests $seqnum [tag]" > /dev/kmsg

_require_check_dmesg?

> +}
> +
> +dmesg_since_test_tag()
> +{
> +        dmesg | tac | sed -ne "0,\#fstests $seqnum \[tag\]#p" | \
> +                tac
> +}
> +
> +check_dmesg_for_since_tag()
> +{
> +        dmesg_since_test_tag | egrep -q "$1"
> +}
> +
> +echo "Silence is golden."
> +
> +log_tag
> +
> +# Test mount
> +for VAR in {attr2,ikeep,noikeep}; do
> +	_scratch_mkfs > $seqres.full 2>&1
> +	_scratch_mount -o $VAR
> +	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
> +		echo "Could not find deprecation warning for $VAR"

I think this is going to regress on old stable kernels that don't know
about the mount option deprecation, right?  Shouldn't there be some
logic to skip the test in that case?

--D

> +	umount $SCRATCH_MNT
> +done
> +
> +# Test mount with default options (attr2 and noikeep) and remount with
> +# 2 groups of options
> +# 1) the defaults (attr2, noikeep)
> +# 2) non defaults (noattr2, ikeep)
> +_scratch_mount
> +for VAR in {attr2,noikeep}; do
> +	log_tag
> +	mount -o $VAR,remount $SCRATCH_MNT
> +	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated." && \
> +		echo "Should not be able to find deprecation warning for $VAR"
> +done
> +for VAR in {noattr2,ikeep}; do
> +	log_tag
> +	mount -o $VAR,remount $SCRATCH_MNT
> +	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
> +		echo "Could not find deprecation warning for $VAR"
> +done
> +umount $SCRATCH_MNT
> +
> +# success, all done
> +status=0
> +exit
> +
> diff --git a/tests/xfs/528.out b/tests/xfs/528.out
> new file mode 100644
> index 00000000..762dccc0
> --- /dev/null
> +++ b/tests/xfs/528.out
> @@ -0,0 +1,2 @@
> +QA output created by 528
> +Silence is golden.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index e861cec9..ad3bd223 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -525,3 +525,4 @@
>  525 auto quick mkfs
>  526 auto quick mkfs
>  527 auto quick quota
> +528 auto quick mount
> -- 
> 2.29.2
> 
