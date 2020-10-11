Return-Path: <SRS0=HmrU=DS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DBCC433E7
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Oct 2020 05:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B47DA207E8
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Oct 2020 05:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgJKFB2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Oct 2020 01:01:28 -0400
Received: from out20-50.mail.aliyun.com ([115.124.20.50]:37425 "EHLO
        out20-50.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJKFB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Oct 2020 01:01:27 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07454672|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00752524-0.000230344-0.992244;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=guan@eryu.me;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.Ihgkprc_1602392482;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Ihgkprc_1602392482)
          by smtp.aliyun-inc.com(10.147.44.145);
          Sun, 11 Oct 2020 13:01:22 +0800
Date:   Sun, 11 Oct 2020 13:01:22 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] generic: test reflinked file corruption after short
 COW
Message-ID: <20201011050122.GU3853@desktop>
References: <b63354c6-795d-78e2-4002-83c08a373171@redhat.com>
 <72427003-febc-cc31-743d-41e25b314874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72427003-febc-cc31-743d-41e25b314874@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 04:22:13PM -0500, Eric Sandeen wrote:
> This test essentially creates an existing COW extent which
> covers the first 1M, and then does another IO that overlaps it,
> but extends beyond it.  The bug was that we did not trim the
> new IO to the end of the existing COW extent, and so the IO
> extended past the COW blocks and corrupted the reflinked files(s).
> 
> The bug came and went upstream.  It was introduced by:
> 
> 78f0cc9d55cb "xfs: don't use delalloc extents for COW on files with extsize hints"
> and (inadvertently) fixed as of:
> 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
> upstream, and in the 5.4 stable tree with:
> aee38af574a1 "xfs: trim IO to found COW extent limit"
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> 
> V2: Add stable tree fix commit in test description & commit log
> 
> diff --git a/tests/generic/612 b/tests/generic/612
> new file mode 100755
> index 00000000..5a765a0c
> --- /dev/null
> +++ b/tests/generic/612
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 612
> +#
> +# Regression test for reflink corruption present as of:
> +# 78f0cc9d55cb "xfs: don't use delalloc extents for COW on files with extsize hints"
> +# and (inadvertently) fixed as of:
> +# 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
> +# upstream, and in the 5.4 stable tree with:
> +# aee38af574a1 "xfs: trim IO to found COW extent limit"
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
> +. ./common/reflink
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +_require_test_reflink
> +
> +DIR=$TEST_DIR/dir.$seq
> +mkdir -p $DIR
> +rm -f $DIR/a $DIR/b
> +
> +# This test essentially creates an existing COW extent which
> +# covers the first 1M, and then does another IO that overlaps it,
> +# but extends beyond it.  The bug was that we did not trim the
> +# new IO to the end of the existing COW extent, and so the IO
> +# extended past the COW blocks and corrupted the reflinked files(s).
> +
> +# Make all files w/ 1m hints; create original 2m file
> +$XFS_IO_PROG -c "extsize 1048576" $DIR | _filter_xfs_io
> +$XFS_IO_PROG -c "cowextsize 1048576" $DIR | _filter_xfs_io

This only works on xfs, and prints extra message on btrfs like

+foreign file active, extsize command is for XFS filesystems only                                     
+foreign file active, cowextsize command is for XFS filesystems only

So I discard outputs of above xfs_io commands.

Thanks,
Eryu

> +
> +echo "Create file b"
> +$XFS_IO_PROG -f -c "pwrite -S 0x0 0 2m" -c fsync $DIR/b | _filter_xfs_io
> +
> +# Make a reflinked copy
> +echo "Reflink copy from b to a"
> +cp --reflink=always $DIR/b $DIR/a
> +
> +echo "Contents of b"
> +hexdump -C $DIR/b
> +
> +# Cycle mount to get stuff out of cache
> +_test_cycle_mount
> +
> +# Create a 1m-hinted IO at offset 0, then
> +# do another IO that overlaps but extends past the 1m hint
> +echo "Write to a"
> +$XFS_IO_PROG -c "pwrite -S 0xa 0k -b 4k 4k" \
> +       -c "pwrite -S 0xa 4k -b 1m 1m" \
> +       $DIR/a | _filter_xfs_io
> +
> +$XFS_IO_PROG -c fsync $DIR/a
> +
> +echo "Contents of b now:"
> +hexdump -C $DIR/b
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/612.out b/tests/generic/612.out
> new file mode 100644
> index 00000000..237a9638
> --- /dev/null
> +++ b/tests/generic/612.out
> @@ -0,0 +1,18 @@
> +QA output created by 612
> +Create file b
> +wrote 2097152/2097152 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Reflink copy from b to a
> +Contents of b
> +00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> +*
> +00200000
> +Write to a
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 1048576/1048576 bytes at offset 4096
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Contents of b now:
> +00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> +*
> +00200000
> diff --git a/tests/generic/group b/tests/generic/group
> index 4af4b494..bc115f21 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -614,3 +614,4 @@
>  609 auto quick rw
>  610 auto quick prealloc zero
>  611 auto quick attr
> +612 auto quick clone
