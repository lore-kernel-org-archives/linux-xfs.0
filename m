Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3B9C63697
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 14:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3113420888
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 14:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgKVOqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 09:46:43 -0500
Received: from out20-73.mail.aliyun.com ([115.124.20.73]:37738 "EHLO
        out20-73.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbgKVOqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 09:46:43 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07599941|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0456755-0.000229841-0.954095;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047199;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.IzrZVtS_1606056393;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IzrZVtS_1606056393)
          by smtp.aliyun-inc.com(10.147.41.137);
          Sun, 22 Nov 2020 22:46:34 +0800
Date:   Sun, 22 Nov 2020 22:46:33 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] generic: add test for XFS forkoff miscalcution on 32-bit
 platform
Message-ID: <20201122144633.GM3853@desktop>
References: <20201118060258.1939824-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118060258.1939824-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 18, 2020 at 02:02:58PM +0800, Gao Xiang wrote:
> There is a regression that recent XFS_LITINO(mp) update causes
> xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.
> 
> Therefore, one result is
>   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> 
> Add a regression test in fstests generic to look after that since
> the testcase itself isn't xfs-specific.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> I have no usable 32-bit test environment to run xfstests, that is
> what I have checked:
>  - checked this new script can pass on x86_64;
>  - manually ran script commands on i386 buildroot with problematic
>    kernel and the filesystem got stuck on getfattr command.
> 
>  tests/generic/618     | 56 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/618.out |  4 ++++
>  tests/generic/group   |  1 +
>  3 files changed, 61 insertions(+)
>  create mode 100755 tests/generic/618
>  create mode 100644 tests/generic/618.out
> 
> diff --git a/tests/generic/618 b/tests/generic/618
> new file mode 100755
> index 00000000..997c6f75
> --- /dev/null
> +++ b/tests/generic/618
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test 618
> +#
> +# Verify that forkoff can be returned as 0 properly if it isn't
> +# able to fit inline for XFS.
> +# However, this test is fs-neutral and can be done quickly so
> +# leave it in generic
> +# This test verifies the problem fixed in kernel with commit
> +# xxxxxxxxxxxx ("xfs: fix forkoff miscalculation related to XFS_LITINO(mp)")

Would you please re-post when the commit is upstream? With the commit ID
updated.

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
> +. ./common/filter
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +_require_test
> +_require_attrs user
> +
> +localfile="${TEST_DIR}/testfile"

Usually we use a testfile prefixed with $seq, e.g.

localfile=${TEST_DIR}/$seq.testfile

And remove it before test to avoid side effects from previous runs.

rm -f $localfile
touch $localfile

> +
> +touch "${localfile}"
> +"${SETFATTR_PROG}" -n user.0 -v "`seq 0 80`" "${localfile}"
> +"${SETFATTR_PROG}" -n user.1 -v "`seq 0 80`" "${localfile}"

I'd be better to add comments on why we need two user attrs and why we
need such long attr value.

> +
> +# Make sure that changes are written to disk
> +_test_cycle_mount
> +
> +# check getfattr result as well

Also, better to document the test failure behavior, e.g. kernel crash or
hung or just a getfattr failure.

Thanks,
Eryu

> +_getfattr --absolute-names -ebase64 -d $localfile | tail -n +2 | sort
> +
> +status=0
> +exit
> diff --git a/tests/generic/618.out b/tests/generic/618.out
> new file mode 100644
> index 00000000..848fdc58
> --- /dev/null
> +++ b/tests/generic/618.out
> @@ -0,0 +1,4 @@
> +QA output created by 618
> +
> +user.0=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
> +user.1=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
> diff --git a/tests/generic/group b/tests/generic/group
> index 94e860b8..eca9d619 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -620,3 +620,4 @@
>  615 auto rw
>  616 auto rw io_uring stress
>  617 auto rw io_uring stress
> +618 auto quick attr
> -- 
> 2.18.4
