Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F60BC4742C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 989FF20790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LGUoTOZB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgJ2VDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:03:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33576 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJ2VDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:03:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKxAib193770;
        Thu, 29 Oct 2020 21:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2VG5+CMm+PaP/0Z8sXmibtHfcnjyh7JoDU3hSUmvRx4=;
 b=LGUoTOZBJM7by6Ox+MxhM3wcLQC2kAMFzibBnSgtJmOkpY1w08VWKMNvDl/NB8YPEoTe
 NLORvqVlc69lU322NmoVve0quG6s/UMIB8Az1PXM7sYgZeYHq3XsBrFG9uecfGsyD2WA
 tTUBTiVvFbBTu9ol2xqd7Yq0cJBpssE+pDCj6LxiILtf7mcFndxpyhyO8UX2MsuWJMVK
 BA6AhbtiErQywJ18TeoC2dDY6JAbDMiB42mJ7S5UH4IBbMdnKTRb/18SEs8IOOtMz3Bc
 BMKMAcb7pLlWIUF1GJ9fgLivHDdCMwvTwO5VxoAmdx7qYObcIn4LdvzcYCOpg4sJNgZX Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7m71vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 21:02:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKuBMM017906;
        Thu, 29 Oct 2020 21:00:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx60y13a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 21:00:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TL0rGF024358;
        Thu, 29 Oct 2020 21:00:53 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 14:00:52 -0700
Date:   Thu, 29 Oct 2020 14:00:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 1/4] generic: check userspace handling of extreme
 timestamps
Message-ID: <20201029205543.GC1061252@magnolia>
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
 <160382544101.1203848.15837078115947156573.stgit@magnolia>
 <CAOQ4uxh9ihsUTsuaFdDTkP4rguNyAfDKq3_k6y1iEpZ3qoU2TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh9ihsUTsuaFdDTkP4rguNyAfDKq3_k6y1iEpZ3qoU2TQ@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290146
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 12:34:57PM +0200, Amir Goldstein wrote:
> On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > These two tests ensure we can store and retrieve timestamps on the
> > extremes of the date ranges supported by userspace, and the common
> > places where overflows can happen.
> >
> > They differ from generic/402 in that they don't constrain the dates
> > tested to the range that the filesystem claims to support; we attempt
> > various things that /userspace/ can parse, and then check that the vfs
> > clamps and persists the values correctly.
> 
> So this test will fail when run on stable kernels before the vfs
> clamping changes
> and there is no require_* to mitigate that failure.

Yes, that is the intended outcome.  Those old kernels silently truncate
the high bits from those timestamps when inodes are flushed to disk, and
the only user-visible evidence of this comes much later when the system
reboots and suddenly the timestamps are wrong.  Clamping also seems a
little strange, but at least it's immediately obvious.

It is very surprising that you could set a timestamp of 2 Apr 2500 on
ext2, ls your shiny futuristic timestamp, reboot, and have it become
5 Nov 1955.  Only Marty McFly would be amused.

> At the time, I discussed this with Deepa and the result was the
> _check_dmesg_for part of _require_timestamp_range, which is incomplete.
> The complete check for kernel clamping support would be to run
> _require_timestamp_range (on the second half thereof) on a loop mounted
> ext2, so we know for sure that the kernel is going to emit the y2038 warning.

Uh... I don't think it's a sensible to require ext2 to test a different
filesystem.

> I am going to leave it to you and the maintainer the decide how
> critical that is,
> but I would suggest to at least factor out _require_timestamp_limits()
> which is true if either the filesystem timestamp range is known or the kernel
> emits y2038 warning.

TBH I had rather hoped that the VFS woulud have a way to export the
supported timestamp range by now, but that probably failed when
dhowells' big complicated fsinfo series died.

--D

> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/721     |  117 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/721.out |    1
> >  tests/generic/722     |  120 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/722.out |    1
> >  tests/generic/group   |    2 +
> >  5 files changed, 241 insertions(+)
> >  create mode 100755 tests/generic/721
> >  create mode 100644 tests/generic/721.out
> >  create mode 100755 tests/generic/722
> >  create mode 100644 tests/generic/722.out
> >
> >
> > diff --git a/tests/generic/721 b/tests/generic/721
> > new file mode 100755
> > index 00000000..9638fbfc
> > --- /dev/null
> > +++ b/tests/generic/721
> > @@ -0,0 +1,117 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 721
> > +#
> > +# Make sure we can store and retrieve timestamps on the extremes of the
> > +# date ranges supported by userspace, and the common places where overflows
> > +# can happen.
> > +#
> > +# This differs from generic/402 in that we don't constrain ourselves to the
> > +# range that the filesystem claims to support; we attempt various things that
> > +# /userspace/ can parse, and then check that the vfs clamps and persists the
> > +# values correctly.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_require_scratch
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs > $seqres.full
> > +_scratch_mount
> > +
> > +# Does our userspace even support large dates?
> > +test_bigdates=1
> > +touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
> > +
> > +# And can we do statx?
> > +test_statx=1
> > +($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
> > + $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
> > +       test_statx=0
> > +
> > +echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
> > +echo "xfs_io support of statx: $test_statx" >> $seqres.full
> > +
> > +touchme() {
> > +       local arg="$1"
> > +       local name="$2"
> > +
> > +       echo "$arg" > $SCRATCH_MNT/t_$name
> > +       touch -d "$arg" $SCRATCH_MNT/t_$name
> > +}
> > +
> > +report() {
> > +       local files=($SCRATCH_MNT/t_*)
> > +       for file in "${files[@]}"; do
> > +               echo "${file}: $(cat "${file}")"
> > +               TZ=UTC stat -c '%y %Y %n' "${file}"
> > +               test $test_statx -gt 0 && \
> > +                       $XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
> > +       done
> > +}
> > +
> > +# -2147483648 (S32_MIN, or classic unix min)
> > +touchme 'Dec 13 20:45:52 UTC 1901' s32_min
> > +
> > +# 2147483647 (S32_MAX, or classic unix max)
> > +touchme 'Jan 19 03:14:07 UTC 2038' s32_max
> > +
> > +# 7956915742, all twos
> > +touchme 'Feb 22 22:22:22 UTC 2222' all_twos
> > +
> > +if [ $test_bigdates -gt 0 ]; then
> > +       # 16299260424 (u64 nsec counter from s32_min, like xfs does)
> > +       touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
> > +
> > +       # 15032385535 (u34 time if you start from s32_min, like ext4 does)
> > +       touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
> > +
> > +       # 17179869183 (u34 time if you start from the unix epoch)
> > +       touchme 'May 30 01:53:03 UTC 2514' u34_max
> > +
> > +       # Latest date we can synthesize(?)
> > +       touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
> > +
> > +       # Earliest date we can synthesize(?)
> > +       touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
> > +fi
> > +
> > +# Query timestamps from incore
> > +echo before >> $seqres.full
> > +report > $tmp.times0
> > +cat $tmp.times0 >> $seqres.full
> > +
> > +_scratch_cycle_mount
> > +
> > +# Query timestamps from disk
> > +echo after >> $seqres.full
> > +report > $tmp.times1
> > +cat $tmp.times1 >> $seqres.full
> > +
> > +# Did they match?
> > +cmp -s $tmp.times0 $tmp.times1
> > +
> 
> Please use suffix $tmp.{before,after}_cycle_mount
> It makes the meaning of the diff in the test failure much clearer
> to a bystander.
> 
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/721.out b/tests/generic/721.out
> > new file mode 100644
> > index 00000000..087decb5
> > --- /dev/null
> > +++ b/tests/generic/721.out
> > @@ -0,0 +1 @@
> > +QA output created by 721
> 
> What? no "Silence is golden"? :-D
> 
> > diff --git a/tests/generic/722 b/tests/generic/722
> > new file mode 100755
> > index 00000000..3e8c553b
> > --- /dev/null
> > +++ b/tests/generic/722
> > @@ -0,0 +1,120 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 722
> > +#
> > +# Make sure we can store and retrieve timestamps on the extremes of the
> > +# date ranges supported by userspace, and the common places where overflows
> > +# can happen.  This test also ensures that the timestamps are persisted
> > +# correctly after a shutdown.
> > +#
> > +# This differs from generic/402 in that we don't constrain ourselves to the
> > +# range that the filesystem claims to support; we attempt various things that
> > +# /userspace/ can parse, and then check that the vfs clamps and persists the
> > +# values correctly.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_require_scratch
> > +_require_scratch_shutdown
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs > $seqres.full
> > +_scratch_mount
> > +
> > +# Does our userspace even support large dates?
> > +test_bigdates=1
> > +touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
> > +
> > +# And can we do statx?
> > +test_statx=1
> > +($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
> > + $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
> > +       test_statx=0
> > +
> > +echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
> > +echo "xfs_io support of statx: $test_statx" >> $seqres.full
> > +
> > +touchme() {
> > +       local arg="$1"
> > +       local name="$2"
> > +
> > +       echo "$arg" > $SCRATCH_MNT/t_$name
> > +       touch -d "$arg" $SCRATCH_MNT/t_$name
> > +}
> > +
> > +report() {
> > +       local files=($SCRATCH_MNT/t_*)
> > +       for file in "${files[@]}"; do
> > +               echo "${file}: $(cat "${file}")"
> > +               TZ=UTC stat -c '%y %Y %n' "${file}"
> > +               test $test_statx -gt 0 && \
> > +                       $XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
> > +       done
> > +}
> > +
> > +# -2147483648 (S32_MIN, or classic unix min)
> > +touchme 'Dec 13 20:45:52 UTC 1901' s32_min
> > +
> > +# 2147483647 (S32_MAX, or classic unix max)
> > +touchme 'Jan 19 03:14:07 UTC 2038' s32_max
> > +
> > +# 7956915742, all twos
> > +touchme 'Feb 22 22:22:22 UTC 2222' all_twos
> > +
> > +if [ $test_bigdates -gt 0 ]; then
> > +       # 16299260424 (u64 nsec counter from s32_min, like xfs does)
> > +       touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
> > +
> > +       # 15032385535 (u34 time if you start from s32_min, like ext4 does)
> > +       touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
> > +
> > +       # 17179869183 (u34 time if you start from the unix epoch)
> > +       touchme 'May 30 01:53:03 UTC 2514' u34_max
> > +
> > +       # Latest date we can synthesize(?)
> > +       touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
> > +
> > +       # Earliest date we can synthesize(?)
> > +       touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
> > +fi
> > +
> > +# Query timestamps from incore
> > +echo before >> $seqres.full
> > +report > $tmp.times0
> > +cat $tmp.times0 >> $seqres.full
> > +
> > +_scratch_shutdown -f
> > +_scratch_cycle_mount
> > +
> > +# Query timestamps from disk
> > +echo after >> $seqres.full
> > +report > $tmp.times1
> > +cat $tmp.times1 >> $seqres.full
> > +
> > +# Did they match?
> > +cmp -s $tmp.times0 $tmp.times1
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/722.out b/tests/generic/722.out
> > new file mode 100644
> > index 00000000..83acd5cf
> > --- /dev/null
> > +++ b/tests/generic/722.out
> > @@ -0,0 +1 @@
> > +QA output created by 722
> > diff --git a/tests/generic/group b/tests/generic/group
> > index cf4fdc23..b533d6b2 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -615,5 +615,7 @@
> >  610 auto quick prealloc zero
> >  611 auto quick attr
> >  612 auto quick clone
> > +721 auto quick atime bigtime
> > +722 auto quick atime bigtime
> 
> shutdown group please.
> 
> If we are going to use "bigtime" for generic tests to describe y2038 tests,
> perhaps add it to 258 and 402 as well?
> 
> Thanks,
> Amir.
