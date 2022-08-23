Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5764AC32789
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 16:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244934AbiHWQih (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244954AbiHWQh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 12:37:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D529BB41;
        Tue, 23 Aug 2022 07:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E840615A1;
        Tue, 23 Aug 2022 14:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC84C433D6;
        Tue, 23 Aug 2022 14:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661265834;
        bh=U6jRPh8vjbsJky5sN8ChZLF2pMdZd2lpZNkdDx2ZLs4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FmtSdjbD3Jt3h4M6fM+8yFnOvZn3JjCijyYPaSmBmaehplcAJed+lwN12H4LtyK3m
         NL3mvLftbYVPPTMeLhKOoE63c9XtdDyJMXX6z2Z0+kHBVCBLyY22lk99CKUZX1mlPl
         c73OX0ZEv1ImdrYmXeLdDjp6KaQWz8omFP6NS8mHKqzrLeh6iQTkQqXQSmcKtG4kaD
         o1inyZRzGETMDFo/hP1i4ZFnVS0Bnh9xc88tHmodqEycycSEgPvYxR7g+8MJWrHpav
         lQtiAtu988yQ4f1dzm2byZ1sV20YVH7F8S7E+0YVVdCTR8JW1SJFizF0olX+rQpkbO
         L3WIccwFSsZZw==
Date:   Tue, 23 Aug 2022 07:43:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, amir73il@gmail.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: new test to verify selinux label of whiteout
 inode
Message-ID: <YwTnqpnK9rH7Ori4@magnolia>
References: <20220714145632.998355-1-zlang@kernel.org>
 <20220725061327.266746-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725061327.266746-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 25, 2022 at 02:13:27PM +0800, Zorro Lang wrote:
> A but on XFS cause renameat2() with flags=RENAME_WHITEOUT doesn't
> apply an selinux label. That's quite different with other fs (e.g.
> ext4, tmpfs).
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Thanks the review points from Amir, this v2 did below changes:
> 1) Add "whiteout" group
> 2) Add commit ID from xfs-linux xfs-5.20-merge-2 (will change if need)
> 3) Rebase to latest fstests for-next branch
> 
> Thanks,
> Zorro
> 
>  tests/generic/693     | 64 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/693.out |  2 ++
>  2 files changed, 66 insertions(+)
>  create mode 100755 tests/generic/693
>  create mode 100644 tests/generic/693.out
> 
> diff --git a/tests/generic/693 b/tests/generic/693
> new file mode 100755
> index 00000000..adf191c4
> --- /dev/null
> +++ b/tests/generic/693
> @@ -0,0 +1,64 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Copyright.  All Rights Reserved.
> +#
> +# FS QA Test No. 693
> +#
> +# Verify selinux label can be kept after RENAME_WHITEOUT. This is
> +# a regression test for:
> +#   70b589a37e1a ("xfs: add selinux labels to whiteout inodes")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rename attr whiteout
> +
> +# Import common functions.
> +. ./common/attr
> +. ./common/renameat2
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_require_attrs
> +_require_renameat2 whiteout
> +
> +_fixed_by_kernel_commit 70b589a37e1a \
> +	xfs: add selinux labels to whiteout inodes
> +
> +get_selinux_label()
> +{
> +	local label
> +
> +	label=`_getfattr --absolute-names -n security.selinux $@ | sed -n 's/security.selinux=\"\(.*\)\"/\1/p'`
> +	if [ ${PIPESTATUS[0]} -ne 0 -o -z "$label" ];then
> +		_fail "Fail to get selinux label: $label"
> +	fi
> +	echo $label
> +}
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +# SELINUX_MOUNT_OPTIONS will be set in common/config if selinux is enabled
> +if [ -z "$SELINUX_MOUNT_OPTIONS" ]; then
> +	_notrun "Require selinux to be enabled"
> +fi
> +# This test need to verify selinux labels in objects, so unset this selinux
> +# mount option
> +export SELINUX_MOUNT_OPTIONS=""
> +_scratch_mount
> +
> +touch $SCRATCH_MNT/f1
> +echo "Before RENAME_WHITEOUT" >> $seqres.full
> +ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
> +# Expect f1 and f2 have same label after RENAME_WHITEOUT
> +$here/src/renameat2 -w $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
> +echo "After RENAME_WHITEOUT" >> $seqres.full
> +ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
> +label1=`get_selinux_label $SCRATCH_MNT/f1`
> +label2=`get_selinux_label $SCRATCH_MNT/f2`

The operations of this test look ok to me, but the piece I do not know
is the higher level context of whether or not it's appropriate for
whiteout inodes to have selinux labels, or if the selinux developers
even care.  Perhaps they should be cc'd?  (And maybe I should've made
Eric do that for the kernel patch...sigh...)

--D

> +if [ "$label1" != "$label2" ];then
> +	echo "$label1 != $label2"
> +fi
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/693.out b/tests/generic/693.out
> new file mode 100644
> index 00000000..01884ea5
> --- /dev/null
> +++ b/tests/generic/693.out
> @@ -0,0 +1,2 @@
> +QA output created by 693
> +Silence is golden
> -- 
> 2.31.1
> 
