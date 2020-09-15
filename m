Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A838DC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 16:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626E020809
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 16:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f39i3x1S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgIOQor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 12:44:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbgIOQnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 12:43:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FG4cEA080508;
        Tue, 15 Sep 2020 16:07:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zWzVSSeKnRNECwrg4Jmzy5DljoWnEjk1lOAJbginv+E=;
 b=f39i3x1SCJuEW2ypmcYuY0+RQDzFO7AgyhakpJlMP7FeW+0SiXBHVvfMaF5b5/vjsqJF
 PsVslVEifgI6GfYrDZWa3SZhioP2ar+tZgfMmf+Z5MRe0RFDnZA+PCtJg0tTveA2S8Qm
 E8tIvTrMgHqpiqeb5zrNgohW2LDsFRY8EkxGZm3EVpCJmq+HP4woq5qwlmXBz5C7+DCD
 0bM030BYiEsJHMvC5MHYplUWZbKqsRF53xKhmncdtXWtt2MINasjW3L92PI2uTyAkngT
 93wkNnvWevIXLRBlJNgQAi9fAvlJf/Uwr9uKMRt28rcpgK4i3OjbkpEWsTVdQ3fJ3QuN 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dfppx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 16:07:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FFjq4b091119;
        Tue, 15 Sep 2020 16:05:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm30tb7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 16:05:00 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FG4x0p029097;
        Tue, 15 Sep 2020 16:04:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 16:04:58 +0000
Date:   Tue, 15 Sep 2020 09:04:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com
Subject: Re: [PATCH V2] xfs: Check if rt summary/bitmap buffers are logged
 with correct xfs_buf type
Message-ID: <20200915160458.GB7955@magnolia>
References: <20200915054748.1765-1-chandanrlinux@gmail.com>
 <20200915071922.GO2937@dhcp-12-102.nay.redhat.com>
 <2327937.js4hDJpFsT@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2327937.js4hDJpFsT@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 15, 2020 at 12:53:22PM +0530, Chandan Babu R wrote:
> On Tuesday 15 September 2020 12:49:22 PM IST Zorro Lang wrote:
> > On Tue, Sep 15, 2020 at 11:17:48AM +0530, Chandan Babu R wrote:
> > > This commit adds a test to check if growing a real-time device can end
> > > up logging an xfs_buf with the "type" subfield of
> > > bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> > > occurs the following call trace is printed on the console,
> > > 
> > > XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> > > Call Trace:
> > >  xfs_buf_item_format+0x632/0x680
> > >  ? kmem_alloc_large+0x29/0x90
> > >  ? kmem_alloc+0x70/0x120
> > >  ? xfs_log_commit_cil+0x132/0x940
> > >  xfs_log_commit_cil+0x26f/0x940
> > >  ? xfs_buf_item_init+0x1ad/0x240
> > >  ? xfs_growfs_rt_alloc+0x1fc/0x280
> > >  __xfs_trans_commit+0xac/0x370
> > >  xfs_growfs_rt_alloc+0x1fc/0x280
> > >  xfs_growfs_rt+0x1a0/0x5e0
> > >  xfs_file_ioctl+0x3fd/0xc70
> > >  ? selinux_file_ioctl+0x174/0x220
> > >  ksys_ioctl+0x87/0xc0
> > >  __x64_sys_ioctl+0x16/0x20
> > >  do_syscall_64+0x3e/0x70
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > 
> > > The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> > > files" is required to fix this issue.
> > > 
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  tests/xfs/260     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/260.out |  2 ++
> > >  tests/xfs/group   |  1 +
> > >  3 files changed, 56 insertions(+)
> > >  create mode 100755 tests/xfs/260
> > >  create mode 100644 tests/xfs/260.out
> > > 
> > > diff --git a/tests/xfs/260 b/tests/xfs/260
> > > new file mode 100755
> > > index 00000000..078d4a11
> > > --- /dev/null
> > > +++ b/tests/xfs/260
> > > @@ -0,0 +1,53 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 260
> > > +#
> > > +# Test to check if growing a real-time device can end up logging an xfs_buf with
> > > +# the "type" subfield of bip->bli_formats->blf_flags set to
> > > +# XFS_BLFT_UNKNOWN_BUF.
> > > +#
> > > +# This is a regression test for the kernel patch "xfs: Set xfs_buf type flag
> > > +# when growing summary/bitmap files".
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_supported_os Linux
> > > +_require_realtime
> > > +
> > > +_scratch_mkfs -r size=10M  >> $seqres.full
> > > +
> > > +_scratch_mount >> $seqres.full
> > > +
> > > +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> > > +
> > > +_scratch_unmount
> > > +
> > > +echo "Silence is golden"
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> > > new file mode 100644
> > > index 00000000..18ca517c
> > > --- /dev/null
> > > +++ b/tests/xfs/260.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 260
> > > +Silence is golden
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index ed0d389e..68676064 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -257,6 +257,7 @@
> > >  257 auto quick clone
> > >  258 auto quick clone
> > >  259 auto quick
> > > +260 auto quick growfs realtime
> > 
> > There's not 'realtime' group before. Although I don't have a objection to add
> > this group, if you'd like to add this one, my personal opinion is using another
> > patch to add all 'rt' related cases into this group, or don't use this group
> > name alone.
> 
> Ok. I will write another patch to collect all realtime tests in one group. I
> will base the current patch on top of that. 

Thank you. :)

I've started using the 'realtime' tag for a bunch of rt regression tests
that I've started collecting in my dev tree, which is why I suggested it
here.

--D

> > 
> > Besides this nitpicking, others looks good to me.
> > 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > Thanks,
> > Zorro
> > 
> > >  261 auto quick quota
> > >  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > >  263 auto quick quota
> > 
> > 
> 
> -- 
> chandan
> 
> 
> 
