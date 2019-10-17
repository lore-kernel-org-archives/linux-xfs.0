Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF66ECE58E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 11:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEFD32082C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 11:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502149AbfJQLta (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:49:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502148AbfJQLt3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Oct 2019 07:49:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0CB8C89B009;
        Thu, 17 Oct 2019 11:49:29 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47ECF5D71C;
        Thu, 17 Oct 2019 11:49:28 +0000 (UTC)
Date:   Thu, 17 Oct 2019 07:49:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH RFC] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <20191017114926.GB20114@bfoster>
References: <a1a28793-6fc3-fb53-2ec3-646f1a758443@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1a28793-6fc3-fb53-2ec3-646f1a758443@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 17 Oct 2019 11:49:29 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 17, 2019 at 05:40:51PM +0800, kaixuxia wrote:
> There is ABBA deadlock bug between the AGI and AGF when performing
> rename() with RENAME_WHITEOUT flag, and add this testcase to make
> sure the rename() call works well.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

This runs in about 5-7s on my VM and reproduced the deadlock on the
first try with the kernel fix reverted. Very nice. Thanks for working
this into a cleaner test!

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/generic/579     | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/579.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 59 insertions(+)
>  create mode 100755 tests/generic/579
>  create mode 100644 tests/generic/579.out
> 
> diff --git a/tests/generic/579 b/tests/generic/579
> new file mode 100755
> index 0000000..d6b0042
> --- /dev/null
> +++ b/tests/generic/579
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> +#
> +# FS QA Test No. 579
> +#
> +# Regression test for:
> +#    bc56ad8c74b8: ("xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT")
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1        # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +        cd /
> +        rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/renameat2
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs generic
> +_require_scratch
> +_require_renameat2 whiteout
> +
> +_scratch_mkfs > $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount >> $seqres.full 2>&1
> +
> +# start a create and rename(rename_whiteout) workload. These processes
> +# occur simultaneously may cause the deadlock between AGI and AGF with
> +# RENAME_WHITEOUT.
> +$FSSTRESS_PROG -z -n 100 -p 100 \
> +		-f creat=5 \
> +		-f rwhiteout=5 \
> +		-d $SCRATCH_MNT/fsstress >> $seqres.full 2>&1
> +
> +echo Silence is golden
> +
> +# Failure comes in the form of a deadlock.
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/579.out b/tests/generic/579.out
> new file mode 100644
> index 0000000..06f4633
> --- /dev/null
> +++ b/tests/generic/579.out
> @@ -0,0 +1,2 @@
> +QA output created by 579
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 6f9c4e1..21870d2 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -581,3 +581,4 @@
>  576 auto quick verity encrypt
>  577 auto quick verity
>  578 auto quick rw clone
> +579 auto rename
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
