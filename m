Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99438C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F42207D8
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LFemkb06"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgESQBd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 12:01:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37318 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729211AbgESQBc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 12:01:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JFvRgo166411;
        Tue, 19 May 2020 16:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6sgfnmYjH4Ag+H52JByKogSR54UMt/4K86xC9eUO4xo=;
 b=LFemkb06e9NfjeDkd1ylJqto8CD8DMKU6Pya81WApvLBIZaRZJqKRInlMj540aIeoKe/
 cBwdJI6V8QbAcUkVVGA8fVE9XrZGlL7P54XQU0jE3ReTp9Qu4w8pQwWRh6setQ24UGOw
 c6T6OJwBzwqWUoyzHCqp02JiBryl0A3uTvmfNbIk5wVYu5axVdwuuvSz4pdjBKqOkYak
 joqt3k6XKaubFxZDQUJbRmSLPWAz+W0/BiEDlhFkZYbhcL6D7R6gG8WNI6nbjx9Lzn7w
 g/c9N/qZUm8rtbrZAXZZKh5QT6/gCvZkaXNtkba6bC6+Lfr8QYzSwU4eoW4QIwB2sNFU +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tne788-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 16:01:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JFwORg067178;
        Tue, 19 May 2020 16:01:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 314gm584v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 16:01:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JG1Rjw021335;
        Tue, 19 May 2020 16:01:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 09:01:26 -0700
Date:   Tue, 19 May 2020 09:01:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfstests: add test for xfs_repair progress reporting
Message-ID: <20200519160125.GB17621@magnolia>
References: <20200519065512.232760-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519065512.232760-1-ddouwsma@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 04:55:12PM +1000, Donald Douwsma wrote:
> xfs_repair's interval based progress has been broken for
> some time, create a test based on dmdelay to stretch out
> the time and use ag_stride to force parallelism.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  tests/xfs/516     | 72 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/516.out | 15 ++++++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 88 insertions(+)
>  create mode 100755 tests/xfs/516
>  create mode 100644 tests/xfs/516.out
> 
> diff --git a/tests/xfs/516 b/tests/xfs/516
> new file mode 100755
> index 00000000..5ad57fbc
> --- /dev/null
> +++ b/tests/xfs/516
> @@ -0,0 +1,72 @@
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
> +	cd /
> +	_dmsetup_remove delay-test > /dev/null 2>&1
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
> +{
> +	sed -ne '
> +	s/[0-9]\+/#/g;
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
> +$XFS_REPAIR_PROG -o ag_stride=4 -t 1 $DELAY_DEV >> $seqres.full 2>&1

Hmm... if the scratch device had an external log device, this raw
invocation of repair won't run because it won't have the log parameter.
Normally I'd say just use _scratch_xfs_repair here, but since there's a
delay device involved, things get trickier...

...or maybe they don't?

	SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride...

might work, seeing as we do that in a few places...

> +cat $seqres.full | _filter_repair | sort -u

You also might want to redirect the repair output to a separate file so
that you can filter and sort /only/ the repair output in the process of
logging the repair results to stdout and $seqres.full.

--D

> +
> +_cleanup_delay
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/516.out b/tests/xfs/516.out
> new file mode 100644
> index 00000000..bc824d7f
> --- /dev/null
> +++ b/tests/xfs/516.out
> @@ -0,0 +1,15 @@
> +QA output created by 516
> +Format and populate
> +Introduce a dmdelay
> +Run repair
> +	- #:#:#: Phase #: #% done - estimated remaining time # minutes, # seconds
> +	- #:#:#: Phase #: elapsed time # second - processed # inodes per minute
> +	- #:#:#: Phase #: elapsed time # seconds - processed # inodes per minute
> +        - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> +        - #:#:#: process known inodes and inode discovery - # of # inodes done
> +        - #:#:#: process newly discovered inodes - # of # allocation groups done
> +        - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> +        - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> +        - #:#:#: scanning filesystem freespace - # of # allocation groups done
> +        - #:#:#: setting up duplicate extent list - # of # allocation groups done
> +        - #:#:#: verify and correct link counts - # of # allocation groups done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 12eb55c9..aeeca23f 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -513,3 +513,4 @@
>  513 auto mount
>  514 auto quick db
>  515 auto quick quota
> +516 repair
> -- 
> 2.18.4
> 
