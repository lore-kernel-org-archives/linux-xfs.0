Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23125C7EE23
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 19:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjFETjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbjFETjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 15:39:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617489C;
        Mon,  5 Jun 2023 12:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E592B622C2;
        Mon,  5 Jun 2023 19:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468F3C433EF;
        Mon,  5 Jun 2023 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685993953;
        bh=H7/D2ej5dQDAxcSJpTGAfraPsX7wgky7E7JaUcXsSOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FY4ZQJvDFJ20RZ1cFdRLfm8vcn4Y1pxgeJKibvEuArFkZSJsCPJy+p9lrObqnqsXW
         QPBXhSz4jkYEaAsv16dyImE1fLyTZtqIQipXhAjREyfpxxn1xtlOqkvnpNOyJIUK40
         YoisXvWeLfAO4QTc9EB/Osd7AX0CJjV8VnlRj59t4ZVFYWksW1qPRR36dXUVY/n73N
         7q071A/mXiB2j9jdWuGEabHh6GCv8G7H+J0tN55s5hBkjuiJAM2gI4mjHha6HTw9gN
         5X1EZioCYe/SgdNQtTMowC+9IGXawu57b5w2qcmZutn+4S76iyBQTHngUzg250MTDl
         YDr+2n5cC84JA==
Date:   Mon, 5 Jun 2023 12:39:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] mkfs.xfs: test that shipped config files work properly
Message-ID: <20230605193912.GB1325469@frogsfrogsfrogs>
References: <1685993543-27714-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685993543-27714-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 02:32:23PM -0500, Eric Sandeen wrote:
> Sanity check the shipped mkfs.xfs config files by using
> them to format the scratch device.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  tests/xfs/569     | 32 ++++++++++++++++++++++++++++++++
>  tests/xfs/569.out |  2 ++
>  2 files changed, 34 insertions(+)
>  create mode 100755 tests/xfs/569
>  create mode 100644 tests/xfs/569.out
> 
> diff --git a/tests/xfs/569 b/tests/xfs/569
> new file mode 100755
> index 0000000..ebcaaab
> --- /dev/null
> +++ b/tests/xfs/569
> @@ -0,0 +1,32 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 569
> +#
> +# Check for any installed example mkfs config files and validate that
> +# mkfs.xfs can properly use them.
> +#
> +. ./common/preamble
> +_begin_fstest mkfs
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_scratch
> +
> +ls /usr/share/xfsprogs/mkfs/*.conf &>/dev/null || \
> +	_notrun "No mkfs.xfs config files installed"
> +
> +# We only fail if mkfs.xfs fails outright, ignoring warnings etc
> +echo "Silence is golden"
> +
> +for CONFIG in /usr/share/xfsprogs/mkfs/*.conf; do
> +	$MKFS_XFS_PROG -c options=$CONFIG -f $SCRATCH_DEV &>>$seqres.full || \
> +		_fail "mkfs.xfs config file $CONFIG failed"

Why not echo instead of _fail so we can see every config that failed,
not just the first one?

--D

> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/569.out b/tests/xfs/569.out
> new file mode 100644
> index 0000000..c7aaf10
> --- /dev/null
> +++ b/tests/xfs/569.out
> @@ -0,0 +1,2 @@
> +QA output created by 569
> +Silence is golden
> -- 
> 1.8.3.1
> 
