Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE55C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 10:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE8E221E7
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 10:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ig8bxPgy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgINKVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 06:21:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726355AbgINKVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 06:21:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600078865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lUqvad6Pt61pF1//ofRX4AnBMdfUTPjjkvR03BvG1a4=;
        b=Ig8bxPgyfDv92JLfNb/utVBCn8LqkwoI7JAokknrylcOGKYaRgmIMs8FymSKGFOkrpFoEw
        9a3cV2X+Iaxuh9T2UFqRPi+rMqdSpMabbjVrqcY5GLfGpau+hRaqqfBjKBixxwkKCq7IPM
        iu08OmqrrQhD6l0UTdvKhw16TNO57kQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-hlYkTXV4MqCIiabLdVcNlQ-1; Mon, 14 Sep 2020 06:21:03 -0400
X-MC-Unique: hlYkTXV4MqCIiabLdVcNlQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBCAE104D3E0;
        Mon, 14 Sep 2020 10:21:01 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62A681014163;
        Mon, 14 Sep 2020 10:21:01 +0000 (UTC)
Date:   Mon, 14 Sep 2020 18:34:56 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        guaneryu@gmail.com, darrick.wong@oracle.com
Subject: Re: [PATCH] xfs: Check if rt summary/bitmap buffers are logged with
 correct xfs_buf type
Message-ID: <20200914103456.GN2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        guaneryu@gmail.com, darrick.wong@oracle.com
References: <20200914090053.7220-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914090053.7220-1-chandanrlinux@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 02:30:53PM +0530, Chandan Babu R wrote:
> This commit adds a test to check if growing a real-time device can end
> up logging an xfs_buf with the "type" subfield of
> bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> occurs the following call trace is printed on the console,
> 
> XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> Call Trace:
>  xfs_buf_item_format+0x632/0x680
>  ? kmem_alloc_large+0x29/0x90
>  ? kmem_alloc+0x70/0x120
>  ? xfs_log_commit_cil+0x132/0x940
>  xfs_log_commit_cil+0x26f/0x940
>  ? xfs_buf_item_init+0x1ad/0x240
>  ? xfs_growfs_rt_alloc+0x1fc/0x280
>  __xfs_trans_commit+0xac/0x370
>  xfs_growfs_rt_alloc+0x1fc/0x280
>  xfs_growfs_rt+0x1a0/0x5e0
>  xfs_file_ioctl+0x3fd/0xc70
>  ? selinux_file_ioctl+0x174/0x220
>  ksys_ioctl+0x87/0xc0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x3e/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> files" is required to fix this issue.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/260     | 52 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/260.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 55 insertions(+)
>  create mode 100755 tests/xfs/260
>  create mode 100644 tests/xfs/260.out
> 
> diff --git a/tests/xfs/260 b/tests/xfs/260
> new file mode 100755
> index 00000000..5fc1a5fc
> --- /dev/null
> +++ b/tests/xfs/260
> @@ -0,0 +1,52 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 260
> +#
> +# Test to check if growing a real-time device can end up logging an
> +# xfs_buf with the "type" subfield of bip->bli_formats->blf_flags set
> +# to XFS_BLFT_UNKNOWN_BUF.
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
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
     ^^^^
I think this comment line is useless

> +_supported_fs generic
> +_supported_os Linux
> +_require_realtime
> +
> +MKFS_OPTIONS="-f -m reflink=0,rmapbt=0 -r rtdev=${SCRATCH_RTDEV},size=10M" \
> + 	    _mkfs_dev $SCRATCH_DEV >> $seqres.full

Hmm... if you need a sized rtdev, the _scratch_mkfs really can't help that
for now. You have to use _mkfs_dev(as you did) or make the helper to support
rtdev size:)

I don't know why you need "reflink=0,rmapbt=0", but not old xfsprogs doesn't
supports this two options, so you might need _scratch_mkfs_xfs_supported()
to check that. If they're not supported, they won't be enabled either. And
better to add comment to explain why make sure reflink and rmapbt are disabled.

> +_scratch_mount -o rtdev=$SCRATCH_RTDEV

As I known, xfstests deal with SCRATCH_RTDEV things in common/rc _scratch_options()
properly, _require_realtime with _scratch_mount are enough, don't need the
"-o rtdev=$SCRATCH_RTDEV".

> +
> +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> +
> +_scratch_unmount
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> new file mode 100644
> index 00000000..18ca517c
> --- /dev/null
> +++ b/tests/xfs/260.out
> @@ -0,0 +1,2 @@
> +QA output created by 260
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ed0d389e..6f30a2e7 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -257,6 +257,7 @@
>  257 auto quick clone
>  258 auto quick clone
>  259 auto quick
> +260 auto

Better to add 'growfs' group, and if the case is quick enough, 'quick' is acceptable:)

>  261 auto quick quota
>  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  263 auto quick quota
> -- 
> 2.28.0
> 

