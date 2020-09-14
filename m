Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589E8C2BC11
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 15:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B90A21BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 15:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PuX64+QL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgINPOO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 11:14:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45644 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgINPNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 11:13:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EF8qf8037099;
        Mon, 14 Sep 2020 15:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BpCrDazugHUKmn7YuRjh59aZKNxarzF9Y/D29Uqub8c=;
 b=PuX64+QLZQk3jX6eL0zGSL4K8WObZuO3i0/I3v943h7HUz+e7vaVuXn53kk4sXwgAoqy
 VmnUcBdMW5heflKwiapPJ10kfRqZDIQdG9KKkRxdCQL+JwEZp27i4uXc9i8tuWIc0EvK
 SqKuGHNYebcYJXHQU/GXu5gdOdVabh8GM2azaBlJRID015K/f0uGJhoFi7UIGIeD7z4z
 fONQXCssbrqwiU95euOolnNgHHWJZnfcTpnSW9QsqpQhTnAiR4D9By6aXr4Q46T3G9Dp
 +Yg6k+0AaRPw6dCQBbdUNgTwekP3/UzYi/rpuldDI45/tHLJl6Bstd32s+eBaxBHv9sq lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33gp9ky75a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Sep 2020 15:13:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EFBMXl062649;
        Mon, 14 Sep 2020 15:13:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h881r5ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 15:13:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08EFDmYY031786;
        Mon, 14 Sep 2020 15:13:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Sep 2020 15:13:47 +0000
Date:   Mon, 14 Sep 2020 08:13:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        guaneryu@gmail.com
Subject: Re: [PATCH] xfs: Check if rt summary/bitmap buffers are logged with
 correct xfs_buf type
Message-ID: <20200914151346.GX7955@magnolia>
References: <20200914090053.7220-1-chandanrlinux@gmail.com>
 <20200914103456.GN2937@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914103456.GN2937@dhcp-12-102.nay.redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009140124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009140124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:34:56PM +0800, Zorro Lang wrote:
> On Mon, Sep 14, 2020 at 02:30:53PM +0530, Chandan Babu R wrote:
> > This commit adds a test to check if growing a real-time device can end
> > up logging an xfs_buf with the "type" subfield of
> > bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> > occurs the following call trace is printed on the console,
> > 
> > XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> > Call Trace:
> >  xfs_buf_item_format+0x632/0x680
> >  ? kmem_alloc_large+0x29/0x90
> >  ? kmem_alloc+0x70/0x120
> >  ? xfs_log_commit_cil+0x132/0x940
> >  xfs_log_commit_cil+0x26f/0x940
> >  ? xfs_buf_item_init+0x1ad/0x240
> >  ? xfs_growfs_rt_alloc+0x1fc/0x280
> >  __xfs_trans_commit+0xac/0x370
> >  xfs_growfs_rt_alloc+0x1fc/0x280
> >  xfs_growfs_rt+0x1a0/0x5e0
> >  xfs_file_ioctl+0x3fd/0xc70
> >  ? selinux_file_ioctl+0x174/0x220
> >  ksys_ioctl+0x87/0xc0
> >  __x64_sys_ioctl+0x16/0x20
> >  do_syscall_64+0x3e/0x70
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> > files" is required to fix this issue.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/260     | 52 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/260.out |  2 ++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 55 insertions(+)
> >  create mode 100755 tests/xfs/260
> >  create mode 100644 tests/xfs/260.out
> > 
> > diff --git a/tests/xfs/260 b/tests/xfs/260
> > new file mode 100755
> > index 00000000..5fc1a5fc
> > --- /dev/null
> > +++ b/tests/xfs/260
> > @@ -0,0 +1,52 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 260
> > +#
> > +# Test to check if growing a real-time device can end up logging an
> > +# xfs_buf with the "type" subfield of bip->bli_formats->blf_flags set
> > +# to XFS_BLFT_UNKNOWN_BUF.

Please state explicitly that this is a regression test for "xfs: Set
xfs_buf type flag when growing summary/bitmap files".

> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
>      ^^^^
> I think this comment line is useless
> 
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_realtime
> > +
> > +MKFS_OPTIONS="-f -m reflink=0,rmapbt=0 -r rtdev=${SCRATCH_RTDEV},size=10M" \
> > + 	    _mkfs_dev $SCRATCH_DEV >> $seqres.full
> 
> Hmm... if you need a sized rtdev, the _scratch_mkfs really can't help that
> for now. You have to use _mkfs_dev(as you did) or make the helper to support
> rtdev size:)

Does "_scratch_mkfs -r size=10M" not work here?

> I don't know why you need "reflink=0,rmapbt=0", but not old xfsprogs doesn't
> supports this two options, so you might need _scratch_mkfs_xfs_supported()
> to check that. If they're not supported, they won't be enabled either. And
> better to add comment to explain why make sure reflink and rmapbt are disabled.

That's a bug in mkfs.xfs, which should be fixed by "mkfs: fix
reflink/rmap logic w.r.t.  realtime devices and crc=0 support".

> > +_scratch_mount -o rtdev=$SCRATCH_RTDEV
> 
> As I known, xfstests deal with SCRATCH_RTDEV things in common/rc _scratch_options()
> properly, _require_realtime with _scratch_mount are enough, don't need the
> "-o rtdev=$SCRATCH_RTDEV".
> 
> > +
> > +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> > +
> > +_scratch_unmount
> > +
> > +echo "Silence is golden"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> > new file mode 100644
> > index 00000000..18ca517c
> > --- /dev/null
> > +++ b/tests/xfs/260.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 260
> > +Silence is golden
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index ed0d389e..6f30a2e7 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -257,6 +257,7 @@
> >  257 auto quick clone
> >  258 auto quick clone
> >  259 auto quick
> > +260 auto
> 
> Better to add 'growfs' group, and if the case is quick enough, 'quick' is acceptable:)

And maybe the 'realtime' group.

--D

> >  261 auto quick quota
> >  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> >  263 auto quick quota
> > -- 
> > 2.28.0
> > 
> 
