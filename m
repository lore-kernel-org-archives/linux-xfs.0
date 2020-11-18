Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9236EC56202
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 02:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394F92468E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Nov 2020 02:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N5UHe9UH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgKRCZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 21:25:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50888 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRCZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 21:25:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI2KSq6060545;
        Wed, 18 Nov 2020 02:25:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=C99NlbDZWtDUxqZF57TpSgW4bQnyfW3UE7c/ZpHxB2g=;
 b=N5UHe9UHKNDQyM8UOjhW3ZIq8NEiMIH1ZV6qjPe9bq0seUXpsjRFa79X7kr7PRkUtOwZ
 qK70EODCqkzZQeAmFqAYLi3jbnjj2Xt6pCzd3lQflO/kCEC0SxK1fvXNiqxjffsTpmzk
 RXJR2K1qb7ONyjDIBPzT1Lzan+3vtGZm5hjtp6g9o78oytq2ZsQHGn60SBbAo+INJ4+O
 QMJsJVyyRw92s7/vLvmVsZajWWyXRP5QmgMgvlCPdvdY23RsSiSeORd4WIEUhTVOtJR9
 1OkNev91g6kI6elAszQESCxyoSMaA4lPWQwBXkzoRlns4EwhBCl23NIzhLNuDWnFIo79 zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34t76kwru3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 02:25:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AI2Jcwp032456;
        Wed, 18 Nov 2020 02:23:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34uspu5rpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Nov 2020 02:23:52 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AI2NpVA023813;
        Wed, 18 Nov 2020 02:23:52 GMT
Received: from localhost (/10.159.155.211)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Nov 2020 18:23:51 -0800
Date:   Tue, 17 Nov 2020 18:23:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>, t@magnolia
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: Check for extent overflow when swapping
 extents
Message-ID: <20201118022350.GA9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-11-chandanrlinux@gmail.com>
 <20201114000835.GA9695@magnolia>
 <5877518.Y88ADI1sEr@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5877518.Y88ADI1sEr@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=-1004 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011180013
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 17, 2020 at 09:05:25PM +0530, Chandan Babu R wrote:
> On Saturday 14 November 2020 5:38:35 AM IST Darrick J. Wong wrote:
> > On Fri, Nov 13, 2020 at 04:57:02PM +0530, Chandan Babu R wrote:
> > > This test verifies that XFS does not cause inode fork's extent count to
> > > overflow when swapping forks across two files.
> > > 
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  tests/xfs/530     | 115 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/530.out |  13 ++++++
> > >  tests/xfs/group   |   1 +
> > >  3 files changed, 129 insertions(+)
> > >  create mode 100755 tests/xfs/530
> > >  create mode 100644 tests/xfs/530.out
> > > 
> > > diff --git a/tests/xfs/530 b/tests/xfs/530
> > > new file mode 100755
> > > index 00000000..fccc6de7
> > > --- /dev/null
> > > +++ b/tests/xfs/530
> > > @@ -0,0 +1,115 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 530
> > > +#
> > > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > > +# swapping forks between files
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
> > > +. ./common/inject
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_debug
> > > +_require_xfs_scratch_rmapbt
> > > +_require_xfs_io_command "fcollapse"
> > > +_require_xfs_io_command "swapext"
> > 
> > FWIW it's going to be a while before the swapext command goes upstream.
> > Right now it's a part of the atomic file range exchange patchset.
> 
> Sorry, I didn't understand your statement. I have the following from my Linux
> machine,
> 
> root@debian-guest:~# /sbin/xfs_io 
> xfs_io> help swapext
> swapext <donorfile> -- Swap extents between files.
> 
>  Swaps extents between the open file descriptor and the supplied filename.
> 
> The above command causes the following code path to be invoked inside the
> kernel (assuming rmapbt feature is enabled),
> xfs_ioc_swapext() => xfs_swap_extents() => xfs_swap_extent_rmap().

Oops.  I forgot that my atomic extent swap series *enhances* that
command.  Please disregard the above. :/

--D

> > 
> > Do you want me to try to speed that up?
> > 
> > --D
> > 
> > > +_require_xfs_io_error_injection "reduce_max_iextents"
> > > +
> > > +echo "* Swap extent forks"
> > > +
> > > +echo "Format and mount fs"
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount >> $seqres.full
> > > +
> > > +bsize=$(_get_block_size $SCRATCH_MNT)
> > > +
> > > +srcfile=${SCRATCH_MNT}/srcfile
> > > +donorfile=${SCRATCH_MNT}/donorfile
> > > +
> > > +echo "Create \$donorfile having an extent of length 17 blocks"
> > > +xfs_io -f -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" -c fsync $donorfile \
> > > +       >> $seqres.full
> > > +
> > > +# After the for loop the donor file will have the following extent layout
> > > +# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
> > > +echo "Fragment \$donorfile"
> > > +for i in $(seq 5 10); do
> > > +	start_offset=$((i * bsize))
> > > +	xfs_io -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
> > > +done
> > > +donorino=$(stat -c "%i" $donorfile)
> > > +
> > > +echo "Create \$srcfile having an extent of length 18 blocks"
> > > +xfs_io -f -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" -c fsync $srcfile \
> > > +       >> $seqres.full
> > > +
> > > +echo "Fragment \$srcfile"
> > > +# After the for loop the src file will have the following extent layout
> > > +# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
> > > +for i in $(seq 1 7); do
> > > +	start_offset=$((i * bsize))
> > > +	xfs_io -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
> > > +done
> > > +srcino=$(stat -c "%i" $srcfile)
> > > +
> > > +_scratch_unmount >> $seqres.full
> > > +
> > > +echo "Collect \$donorfile's extent count"
> > > +donor_nr_exts=$(_scratch_get_iext_count $donorino data || \
> > > +		_fail "Unable to obtain inode fork's extent count")
> > > +
> > > +echo "Collect \$srcfile's extent count"
> > > +src_nr_exts=$(_scratch_get_iext_count $srcino data || \
> > > +		_fail "Unable to obtain inode fork's extent count")
> > > +
> > > +_scratch_mount >> $seqres.full
> > > +
> > > +echo "Inject reduce_max_iextents error tag"
> > > +xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > > +
> > > +echo "Swap \$srcfile's and \$donorfile's extent forks"
> > > +xfs_io -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
> > > +
> > > +_scratch_unmount >> $seqres.full
> > > +
> > > +echo "Check for \$donorfile's extent count overflow"
> > > +nextents=$(_scratch_get_iext_count $donorino data || \
> > > +		_fail "Unable to obtain inode fork's extent count")
> > > +if (( $nextents == $src_nr_exts )); then
> > > +	echo "\$donorfile: Extent count overflow check failed"
> > > +fi
> > > +
> > > +echo "Check for \$srcfile's extent count overflow"
> > > +nextents=$(_scratch_get_iext_count $srcino data || \
> > > +		_fail "Unable to obtain inode fork's extent count")
> > > +if (( $nextents == $donor_nr_exts )); then
> > > +	echo "\$srcfile: Extent count overflow check failed"
> > > +fi
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/530.out b/tests/xfs/530.out
> > > new file mode 100644
> > > index 00000000..996af959
> > > --- /dev/null
> > > +++ b/tests/xfs/530.out
> > > @@ -0,0 +1,13 @@
> > > +QA output created by 530
> > > +* Swap extent forks
> > > +Format and mount fs
> > > +Create $donorfile having an extent of length 17 blocks
> > > +Fragment $donorfile
> > > +Create $srcfile having an extent of length 18 blocks
> > > +Fragment $srcfile
> > > +Collect $donorfile's extent count
> > > +Collect $srcfile's extent count
> > > +Inject reduce_max_iextents error tag
> > > +Swap $srcfile's and $donorfile's extent forks
> > > +Check for $donorfile's extent count overflow
> > > +Check for $srcfile's extent count overflow
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index bc3958b3..81a15582 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -527,3 +527,4 @@
> > >  527 auto quick
> > >  528 auto quick reflink
> > >  529 auto quick reflink
> > > +530 auto quick
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
