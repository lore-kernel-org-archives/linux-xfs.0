Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F126C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A7DC20716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 22:30:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RrDg84op"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCLWam (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 18:30:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCLWam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 18:30:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CMMYsI057875;
        Thu, 12 Mar 2020 22:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5E0Ou9cylFGDHKTX0J0AE9BF1u5TGOHHpLTHHzJst/Y=;
 b=RrDg84opDggO25u5gA7jWRskf0gN0YMZFoyGqjtRn+iTArAtuoVUq0KWKUQd0xzlT8FF
 JbXTslVCZm+QKXfzSlTIAzuHvoN/qlw66MCKoxTtuJwwz5CymTDnGffnQsv9uBU6Cc+E
 Xb0fxnbw4F23LWj/oe6f3/QHnNHgJOnb1PCtItt/LFd/ZEWlmWGLInfKS8751cETHoS5
 LoVDCb2q0RtKAF2ysiXRbbJjEKLPP36ZcN/8h+VZKs5SwwhYRwFnXoyu3bq1SoAh+6nh
 6xnXK8iB7B5z3YzGCl3HzeU7P/u1Wb1YH7jECIh8kN9jLmsqR1LGKrkL0bKQzz9wEHnY 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yqtaerycc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 22:30:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CMNm7R035911;
        Thu, 12 Mar 2020 22:30:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yqtac1upm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 22:30:39 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CMUc7g030106;
        Thu, 12 Mar 2020 22:30:38 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 15:30:38 -0700
Date:   Thu, 12 Mar 2020 15:30:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test PF_MEMALLOC interfering with
 accounting file write
Message-ID: <20200312223037.GF8044@magnolia>
References: <20200312221437.141484-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312221437.141484-1-ebiggers@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:14:37PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a regression test for the bug fixed by commit 10a98cb16d80 ("xfs:
> clear PF_MEMALLOC before exiting xfsaild thread").
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> RFC for now since the commit is in xfs/for-next only, and I'm not sure
> the commit ID is stable.

It's not stable until it lands in Linus tree, unfortunately. :(

>  common/config         |  1 +
>  common/rc             | 11 ++++++++
>  tests/generic/901     | 60 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/901.out |  2 ++
>  tests/generic/group   |  1 +
>  5 files changed, 75 insertions(+)
>  create mode 100644 tests/generic/901
>  create mode 100644 tests/generic/901.out
> 
> diff --git a/common/config b/common/config
> index 1116cb995..8023273da 100644
> --- a/common/config
> +++ b/common/config
> @@ -220,6 +220,7 @@ export DUPEREMOVE_PROG="$(type -P duperemove)"
>  export CC_PROG="$(type -P cc)"
>  export FSVERITY_PROG="$(type -P fsverity)"
>  export OPENSSL_PROG="$(type -P openssl)"
> +export ACCTON_PROG="$(type -P accton)"
>  
>  # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
>  # newer systems have udevadm command but older systems like RHEL5 don't.
> diff --git a/common/rc b/common/rc
> index 454f5ccf5..0bc4b14f2 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4168,6 +4168,17 @@ _check_xfs_scrub_does_unicode() {
>  	return 0
>  }
>  
> +# Require the 'accton' userspace tool and CONFIG_BSD_PROCESS_ACCT=y.
> +_require_bsd_process_accounting()
> +{
> +	_require_command "$ACCTON_PROG" accton
> +	$ACCTON_PROG on &> $tmp.test_accton
> +	cat $tmp.test_accton >> $seqres.full
> +	if grep 'Function not implemented' $tmp.test_accton; then
> +		_notrun "BSD process accounting support unavailable"
> +	fi

Should we run "$ACCTON_PROG off" here to turn process accounting back
off until the test needs it again?

Otherwise the logic looks sound.  Thanks for writing this up!

--D

> +}
> +
>  init_rc
>  
>  ################################################################################
> diff --git a/tests/generic/901 b/tests/generic/901
> new file mode 100644
> index 000000000..c59300f1b
> --- /dev/null
> +++ b/tests/generic/901
> @@ -0,0 +1,60 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright 2020 Google LLC
> +#
> +# FS QA Test No. 901
> +#
> +# Regression test for the bug fixed by commit 10a98cb16d80 ("xfs: clear
> +# PF_MEMALLOC before exiting xfsaild thread").  If the bug exists, a kernel
> +# WARNING should be triggered.  See the commit message for details.
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
> +	$ACCTON_PROG off >> $seqres.full
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
> +_supported_fs generic
> +_supported_os Linux
> +_require_bsd_process_accounting
> +_require_chattr S
> +_require_test
> +_require_scratch
> +
> +# To trigger the bug we must unmount a filesystem while BSD process accounting
> +# is enabled.  The accounting file must also be located on a different
> +# filesystem and have the sync flag set.
> +
> +accounting_file=$TEST_DIR/$seq
> +
> +rm -f $accounting_file
> +touch $accounting_file
> +$CHATTR_PROG +S $accounting_file
> +
> +_scratch_mkfs &>> $seqres.full
> +$ACCTON_PROG $accounting_file >> $seqres.full
> +_scratch_mount
> +_scratch_unmount
> +$ACCTON_PROG off >> $seqres.full
> +
> +echo "Silence is golden"
> +
> +status=0
> +exit
> diff --git a/tests/generic/901.out b/tests/generic/901.out
> new file mode 100644
> index 000000000..b206bc11d
> --- /dev/null
> +++ b/tests/generic/901.out
> @@ -0,0 +1,2 @@
> +QA output created by 901
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index dc95b77b3..61a679793 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -595,3 +595,4 @@
>  591 auto quick rw pipe splice
>  592 auto quick encrypt
>  593 auto quick encrypt
> +901 auto quick
> -- 
> 2.25.1
> 
