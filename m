Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1445CC2BA16
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 03:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB16207FF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 03:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c90Adcxr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390204AbgDCD5N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 23:57:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388951AbgDCD5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 23:57:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0333qmOr007312;
        Fri, 3 Apr 2020 03:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QsWw5V3Nbe7p/+k61bM3v9UqCmTRLb1F9AJM52lqSVI=;
 b=c90AdcxrlObEvNqiIJ7oh3gL5dark9WIEwgegTM0R1EIZ13PVymZ2a1J3RDYTPAxkyQv
 lFCotH1Alk/Uvp+a4NxjrQCjnOqvvvrwOhzf/EejODx3DGNd/nHXHwFIeEMH5T2m/hZ6
 257O7XTSBDvYeYaifcMyZ/AgMFaYV9ZtVB5Teaz4ZeMyAOG60ruKyLnjkZ5kBMJa64mN
 NGYRI9o9SfvMWpy42HlOF9TGDe9hAT18IOHp+GCG+j3hIjt2THIFHvmw8JlnaFi+vl/0
 IMPEKaZBdkM5fIjgwRHaXnCrHzmqYK+8Ck8QnIwVKFCErKvXCm+e8OQ2VCWItB67wewT 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqhyard-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 03:57:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0333v9Hb064372;
        Fri, 3 Apr 2020 03:57:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 304sjrgaqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 03:57:09 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0333uwwQ013005;
        Fri, 3 Apr 2020 03:56:58 GMT
Received: from localhost (/10.159.130.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 20:56:58 -0700
Date:   Thu, 2 Apr 2020 20:56:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: test PF_MEMALLOC interfering with accounting
 file write
Message-ID: <20200403035657.GK80283@magnolia>
References: <20200403033355.140984-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403033355.140984-1-ebiggers@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 08:33:55PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a regression test for the bug fixed by commit 10a98cb16d80 ("xfs:
> clear PF_MEMALLOC before exiting xfsaild thread").
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Changed since v1:
>     - Fix _require_bsd_process_accounting() to not leave process
>       accounting enabled.
>     - Removed RFC tag since the kernel fix is now in mainline.
>    
> 
>  common/config         |  1 +
>  common/rc             | 12 +++++++++
>  tests/generic/901     | 60 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/901.out |  2 ++
>  tests/generic/group   |  1 +
>  5 files changed, 76 insertions(+)
>  create mode 100644 tests/generic/901
>  create mode 100644 tests/generic/901.out
> 
> diff --git a/common/config b/common/config
> index 1116cb99..8023273d 100644
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
> index 454f5ccf..7d6ea90c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4168,6 +4168,18 @@ _check_xfs_scrub_does_unicode() {
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
> +	$ACCTON_PROG off >> $seqres.full
> +}
> +
>  init_rc
>  
>  ################################################################################
> diff --git a/tests/generic/901 b/tests/generic/901
> new file mode 100644
> index 00000000..c59300f1
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

_scratch_cycle_mount

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks for submitting a regression test!

--D

> +$ACCTON_PROG off >> $seqres.full
> +
> +echo "Silence is golden"
> +
> +status=0
> +exit
> diff --git a/tests/generic/901.out b/tests/generic/901.out
> new file mode 100644
> index 00000000..b206bc11
> --- /dev/null
> +++ b/tests/generic/901.out
> @@ -0,0 +1,2 @@
> +QA output created by 901
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index dc95b77b..61a67979 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -595,3 +595,4 @@
>  591 auto quick rw pipe splice
>  592 auto quick encrypt
>  593 auto quick encrypt
> +901 auto quick
> -- 
> 2.26.0
> 
