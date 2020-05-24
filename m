Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA93C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 16:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D2820826
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 16:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgEXQqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 12:46:52 -0400
Received: from out20-62.mail.aliyun.com ([115.124.20.62]:33842 "EHLO
        out20-62.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgEXQqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 12:46:52 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08165852|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.349807-0.00123312-0.64896;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03293;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.HczEWtj_1590338808;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HczEWtj_1590338808)
          by smtp.aliyun-inc.com(10.147.42.22);
          Mon, 25 May 2020 00:46:48 +0800
Date:   Mon, 25 May 2020 00:46:48 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfstests: add test for xfs_repair progress reporting
Message-ID: <20200524164648.GB3363@desktop>
References: <20200519160125.GB17621@magnolia>
 <20200520035258.298516-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520035258.298516-1-ddouwsma@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 01:52:58PM +1000, Donald Douwsma wrote:
> xfs_repair's interval based progress has been broken for
> some time, create a test based on dmdelay to stretch out
> the time and use ag_stride to force parallelism.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
> Changes since v1:
> - Use _scratch_xfs_repair
> - Filter only repair output
> - Make the filter more tolerant of whitespace and plurals
> - Take golden output from 'xfs_repair: fix progress reporting'

I saw failures like below, and I'm using v5.7-rc4 kernel and v5.4.0
xfsprogs, is this expected failure?

@@ -2,8 +2,6 @@
 Format and populate
 Introduce a dmdelay
 Run repair
- - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
- - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
  - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
  - #:#:#: process known inodes and inode discovery - # of # inodes done
  - #:#:#: process newly discovered inodes - # of # allocation groups done
@@ -12,4 +10,3 @@
  - #:#:#: scanning filesystem freespace - # of # allocation groups done
  - #:#:#: setting up duplicate extent list - # of # allocation groups done
  - #:#:#: verify and correct link counts - # of # allocation groups done
- - #:#:#: zeroing log - # of # blocks done

> 
>  tests/xfs/516     | 76 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/516.out | 15 ++++++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/516
>  create mode 100644 tests/xfs/516.out
> 
> diff --git a/tests/xfs/516 b/tests/xfs/516
> new file mode 100755
> index 00000000..1c0508ef
> --- /dev/null
> +++ b/tests/xfs/516
> @@ -0,0 +1,76 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 516
> +#
> +# Test xfs_repair's progress reporting
> +#
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

	rm -f $tmp.*

As some common helpers would use $tmp. files as well.

> +	cd /
> +	_dmsetup_remove delay-test > /dev/null 2>&1

I think we could do _cleanup_delay here and discard the outputs.

> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmdelay
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_dm_target delay
> +
> +# Filter output specific to the formatters in xfs_repair/progress.c
> +# Ideally we'd like to see hits on anything that matches
> +# awk '/{FMT/' repair/progress.c
> +_filter_repair()

Function names with the leading underscore are reserved for common
helpers, filter_repair would be fine.

> +{
> +	sed -ne '
> +	s/[0-9]\+/#/g;
> +	s/^\s\+/ /g;
> +	s/\(second\|minute\)s/\1/g
> +	/#:#:#:/p
> +	'
> +}
> +
> +echo "Format and populate"
> +_scratch_populate_cached nofill > $seqres.full 2>&1
> +
> +echo "Introduce a dmdelay"
> +_init_delay
> +
> +# Introduce a read I/O delay
> +# The default in common/dmdelay is a bit too agressive
> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 100 $SCRATCH_DEV 0 0"
> +_load_delay_table $DELAY_READ
> +
> +echo "Run repair"
> +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> +        tee -a $seqres.full > $seqres.xfs_repair.out
> +
> +cat $seqres.xfs_repair.out | _filter_repair | sort -u

I agreed with Darrick here. redirect output to $tmp.repair is better, as
we already cleanup $tmp.* in _cleanup, and no one is cleaning up
$seqres.xfs_repair.out file.

> +
> +_cleanup_delay

We could remove this one if do it in _cleanup.

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/516.out b/tests/xfs/516.out
> new file mode 100644
> index 00000000..85018b93
> --- /dev/null
> +++ b/tests/xfs/516.out
> @@ -0,0 +1,15 @@
> +QA output created by 516
> +Format and populate
> +Introduce a dmdelay
> +Run repair
> + - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
> + - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
> + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> + - #:#:#: process known inodes and inode discovery - # of # inodes done
> + - #:#:#: process newly discovered inodes - # of # allocation groups done
> + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> + - #:#:#: scanning filesystem freespace - # of # allocation groups done
> + - #:#:#: setting up duplicate extent list - # of # allocation groups done
> + - #:#:#: verify and correct link counts - # of # allocation groups done
> + - #:#:#: zeroing log - # of # blocks done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 12eb55c9..aeeca23f 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -513,3 +513,4 @@
>  513 auto mount
>  514 auto quick db
>  515 auto quick quota
> +516 repair

Should be in auto group as well? Only tests in auto (and quick, which is
a sub-set of auto) will be run by default.

Thanks,
Eryu

> -- 
> 2.18.4
