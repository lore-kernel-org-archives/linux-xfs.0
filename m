Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF08C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 18:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A248B64E63
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 18:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhBJS7R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:59:17 -0500
Received: from sandeen.net ([63.231.237.45]:40946 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhBJS5J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 13:57:09 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 908B917264;
        Wed, 10 Feb 2021 12:56:28 -0600 (CST)
To:     Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <20210210170628.173200-1-bfoster@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] generic: test mapped write after shutdown and failed
 writeback
Message-ID: <aeafb8f1-c383-686f-c349-99bf6fef39e8@sandeen.net>
Date:   Wed, 10 Feb 2021 12:56:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210170628.173200-1-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/10/21 11:06 AM, Brian Foster wrote:
> XFS has a regression where it failed to check shutdown status in the
> write fault path. This produced an iomap warning if the page
> happened to recently fail a writeback attempt because writeback
> failure can clear Uptodate status on the page. Add a test for this
> scenario to help ensure mapped write failures are handled as
> expected in the event of filesystem shutdown.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This looks reasonable to me, I have run the same xfs_io tests when
looking at this behavior and they do provoke it.

This could maybe run on $TEST? But I don't really care much either
way.

I spot-checked this on ext4 and it passes.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
> 
> Note that this test currently fails on XFS. The fix is posted for review
> on linux-xfs:
> 
> https://lore.kernel.org/linux-xfs/20210210170112.172734-1-bfoster@redhat.com/
> 
> Brian
> 
>  tests/generic/999     | 45 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  4 ++++
>  tests/generic/group   |  1 +
>  3 files changed, 50 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..5e5408e7
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,45 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-only
> +# Copyright 2021 Red Hat, Inc.
> +#
> +# FS QA Test No. 999
> +#
> +# Test a write fault scenario on a shutdown fs.
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
> +	rm -f $tmp.*
> +}
> +
> +. ./common/rc
> +. ./common/filter
> +
> +rm -f $seqres.full
> +
> +_supported_fs generic
> +_require_scratch_nocheck
> +_require_scratch_shutdown
> +
> +_scratch_mkfs &>> $seqres.full
> +_scratch_mount
> +
> +# XFS had a regression where it failed to check shutdown status in the fault
> +# path. This produced an iomap warning because writeback failure clears Uptodate
> +# status on the page.
> +file=$SCRATCH_MNT/file
> +$XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> +	-c "mwrite 0 4k" $file | _filter_xfs_io
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..f55569ff
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,4 @@
> +QA output created by 999
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +fsync: Input/output error
> diff --git a/tests/generic/group b/tests/generic/group
> index b10fdea4..edd54ce5 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -625,3 +625,4 @@
>  620 auto mount quick
>  621 auto quick encrypt
>  622 auto shutdown metadata atime
> +999 auto quick shutdown
> 
