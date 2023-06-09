Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797B4C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 14:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjFIOw4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 10:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjFIOwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2023 10:52:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4F52D48
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 07:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 486AF64253
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 14:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF4FC433EF;
        Fri,  9 Jun 2023 14:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686322373;
        bh=4NGvV5lBBw/XaWd6YnFgWFZFW++j3KpL5p+L8strs9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pwvDHrfx62flDNnV1bHGc2lUW3iPM0PNNBXpFqfxr9i6UcRr7oDoK3UICdpYRXKtM
         ZreeumXbQZcPz2t3+U68hXlHrciLda7kpGms6BklDW5F04H1vZd2JbX4iTBddkUDQM
         PsqicXlPnkbG/nmirv0oZHN5byZ7Ur1ev3bTs6ulu+863DahsfdGSRA2fEzwoIyrgk
         nIx1MGUvu1F9sHUQ4Md72/WGVgYvyN449MW8LASofkdUSuenmRcTB7dhgwwoRPV5XG
         ryiIoy/ku6g7bZk2TR9K9k3YMkjZrV8RM28DyxvMpMfGb2cTD0IDdNrZJEx0dbTlUr
         6Df7CZm/IyPmw==
Date:   Fri, 9 Jun 2023 07:52:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfstests: add test for xfs_repair progress reporting
Message-ID: <20230609145253.GY1325469@frogsfrogsfrogs>
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
 <20230531064024.1737213-2-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531064024.1737213-2-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Tests ought to be cc'd to fstests@vger.kernel.org.

On Wed, May 31, 2023 at 04:40:24PM +1000, Donald Douwsma wrote:
> Confirm that xfs_repair reports on its progress if -o ag_stride is
> enabled.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
> Changes since v3
> - Rebase after tests/xfs/groups removal (tools/convert-group), drop _supported_os
> - Shorten the delay, remove superfluous dm-delay parameters
> Changes since v2:
> - Fix cleanup handling and function naming
> - Added to auto group
> Changes since v1:
> - Use _scratch_xfs_repair
> - Filter only repair output
> - Make the filter more tolerant of whitespace and plurals
> - Take golden output from 'xfs_repair: fix progress reporting'
> 
>  tests/xfs/999     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out | 15 +++++++++++
>  2 files changed, 81 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..9e799f66
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 521
> +#
> +# Test xfs_repair's progress reporting
> +#
> +. ./common/preamble
> +_begin_fstest auto repair
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_cleanup_delay > /dev/null 2>&1
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/dmdelay
> +. ./common/populate
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_scratch
> +_require_dm_target delay
> +
> +# Filter output specific to the formatters in xfs_repair/progress.c
> +# Ideally we'd like to see hits on anything that matches
> +# awk '/{FMT/' xfsprogs-dev/repair/progress.c
> +filter_repair()
> +{
> +	sed -nre '
> +	s/[0-9]+/#/g;
> +	s/^\s+/ /g;
> +	s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
> +	/#:#:#:/p
> +	'
> +}
> +
> +echo "Format and populate"
> +_scratch_populate_cached nofill > $seqres.full 2>&1
> +
> +echo "Introduce a dmdelay"
> +_init_delay
> +DELAY_MS=38

I wonder if this is where _init_delay should gain a delay_ms argument?

_init_delay() {
	local delay_ms="${1:-10000}"

	...
	DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $delay_ms $SCRATCH_DEV 0 0"
}


> +# Introduce a read I/O delay
> +# The default in common/dmdelay is a bit too agressive
> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
> +_load_delay_table $DELAY_READ
> +
> +echo "Run repair"
> +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> +        tee -a $seqres.full > $tmp.repair
> +
> +cat $tmp.repair | filter_repair | sort -u
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..e27534d8
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,15 @@
> +QA output created by 999
> +Format and populate
> +Introduce a dmdelay
> +Run repair
> + - #:#:#: Phase #: #% done - estimated remaining time {progres}
> + - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minute
> + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> + - #:#:#: process known inodes and inode discovery - # of # inodes done
> + - #:#:#: process newly discovered inodes - # of # allocation groups done
> + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> + - #:#:#: scanning filesystem freespace - # of # allocation groups done
> + - #:#:#: setting up duplicate extent list - # of # allocation groups done
> + - #:#:#: verify and correct link counts - # of # allocation groups done
> + - #:#:#: zeroing log - # of # blocks done

Otherwise seems fine to me, assuming nothing goes nuts if rt devices or
whatever happen to be configured. ;)

--D

> -- 
> 2.39.3
> 
