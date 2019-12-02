Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F3DC43215
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 19:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9CB20661
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 19:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BaOYTSEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfLBTb4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 14:31:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbfLBTb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 14:31:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2JTMgk139106;
        Mon, 2 Dec 2019 19:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vSRSUH8aA8ClNDYAP8x7bBWCS9Unp2ftSz7WyS4eud0=;
 b=BaOYTSEjATHSG+I9aJig7EpdB+Ywrvbhq/VXMOsGseiWaymniispWuiqYmsur9DtWyEI
 e6G5HBxkhRZrkk/4U+GX6kMQwq0N1Seb+wMEcD2nYvD+HmmVgDtV5NyZrMYdS6iblOhD
 VRjAfBkMCcIWqcrqzAnLxrEpPjrZ5GF0wQlPiMpUcFwwZH2pMOR27t9icbOXy+4SV6E/
 8BXEfwah4nazg25DWiba5kgBe9mMQT24X06vB5yjwyb40jWLW/Br1lv3J4jRrSHC3dBb
 2q4AB2MogiR6WNn0FMQN2yb51erlb1nJ8qkYhiW41LjaTAykJwhgKKdgrPh4+mMvw9IW GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wkgcq2aqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 19:31:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2JU9ID073890;
        Mon, 2 Dec 2019 19:31:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wm1xpsbqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 19:31:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2JVo4e025863;
        Mon, 2 Dec 2019 19:31:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 11:31:50 -0800
Date:   Mon, 2 Dec 2019 11:31:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, kernel-team@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: test truncating mixed written/unwritten XFS
 realtime extent
Message-ID: <20191202193149.GB7339@magnolia>
References: <2512a38027e5286eae01d4aa36726f49a94e523d.1574799173.git.osandov@fb.com>
 <20191127012646.GR6219@magnolia>
 <20191202192424.GA809204@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202192424.GA809204@vader>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 11:24:24AM -0800, Omar Sandoval wrote:
> On Tue, Nov 26, 2019 at 05:26:46PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 26, 2019 at 12:13:56PM -0800, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > The only XFS-specific part of this test is the setup, so we can make the
> > > rest a generic test. It's slow, though, as it needs to write 8GB to
> > > convert a big unwritten extent to written.
> > > 
> > > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > > ---
> > >  tests/generic/586     | 59 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/586.out |  2 ++
> > >  tests/generic/group   |  1 +
> > >  3 files changed, 62 insertions(+)
> > >  create mode 100755 tests/generic/586
> > >  create mode 100644 tests/generic/586.out
> > > 
> > > diff --git a/tests/generic/586 b/tests/generic/586
> > > new file mode 100755
> > > index 00000000..5bcad68b
> > > --- /dev/null
> > > +++ b/tests/generic/586
> > > @@ -0,0 +1,59 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2019 Facebook.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 586
> > > +#
> > > +# Test "xfs: fix realtime file data space leak" and "xfs: don't check for AG
> > > +# deadlock for realtime files in bunmapi". On XFS without the fix, rm will hang
> > > +# forever. On other filesystems, this just tests writing into big fallocates.
> > > +#
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
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +rm -f $seqres.full
> > > +
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_scratch
> > > +
> > > +maxextlen=$((0x1fffff))
> > 
> > /me wonders if we ought to move this to common/xfs and hoist the other
> > place (xfs/507) where we define this.
> > 
> > > +bs=4096
> > > +rextsize=4
> > > +
> > > +extra_options=""
> > > +if [[ $FSTYP = xfs && $USE_EXTERNAL = yes && -n $SCRATCH_RTDEV ]]; then
> > > +	extra_options="$extra_options -bsize=$bs"
> > 
> > Hm.  Could you rework this to _require_realtime, and if the caller
> > didn't set SCRATCH_RTDEV, create a file on the test device so that we
> > can always do the realtime test if the kernel supports it?  That will
> > ensure that this gets more testing that it does now...
> 
> Sorry, I don't follow. _require_realtime checks that SCRATCH_RTDEV was
> set. Did you mean something like this?
> 
> if [[ $USE_EXTERNAL = yes && -n $SCRATCH_RTDEV ]]; then
> 	use the configured rtdev
> else
> 	_require_test
> 	_require_scratch
> 	set up a loop device on the test filesystem as the rtdev
> fi

Yep, that's exactly what I meant.

--D

> > > +	extra_options="$extra_options -r extsize=$((bs * rextsize))"
> > > +	extra_options="$extra_options -d agsize=$(((maxextlen + 1) * bs / 2)),rtinherit=1"
> > 
> > ...particularly because I don't think very many people actually run
> > fstests with rt enabled /and/ rtinherit set to stress the realtime
> > allocator.
> > 
> > (I did a year ago and out came a torrent of bugs such that someone could
> > probably write themselves a nice year end bonus just fixing all that,
> > software is terrible :()
> > 
> > > +fi
> > > +_scratch_mkfs $extra_options >>$seqres.full 2>&1
> > > +_scratch_mount
> > > +_require_fs_space "$SCRATCH_MNT" "$(((maxextlen + 1) * bs / 1024))"
> > > +
> > > +fallocate -l $(((maxextlen + 1 - rextsize) * bs)) "$SCRATCH_MNT/file"
> > > +sync
> > 
> > $XFS_IO_PROG -c "falloc 0 <math expression>" -c fsync $SCRATCH_MNT/file
> 
> Will fix.
> 
> > (Hm ok, fallocate the first 2097148 blocks of the file...)
> 
> Oops, I'll add some explanations for all of this stuff.
> 
> Thanks for taking a look!
> 
> > > +fallocate -o $(((maxextlen + 1 - rextsize) * bs)) -l $((rextsize * bs)) "$SCRATCH_MNT/file"
> > > +sync
> > 
> > $XFS_IO_PROG -c "falloc <the -o expression> <the -l expression>" -c fsync $SCRATCH_MNT/file
> > 
> > (now fallocate blocks 2097148 to 2097152)
> > 
> > (Not sure why you do the last rtext separately...)
> > 
> > > +dd if=/dev/zero of="$SCRATCH_MNT/file" bs=$bs count=$((maxextlen + 2 - rextsize)) conv=notrunc status=none
> > > +sync
> > 
> > $XFS_IO_PROG -c "pwrite <count= expression> $bs" -c fsync $SCRATCH_MNT/file
> > 
> > (and finally write to block 2097149?)
> > 
> > --D
