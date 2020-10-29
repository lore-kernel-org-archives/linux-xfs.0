Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08BFC2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E9A2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:22:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cKvTjInK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgJ2SWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 14:22:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40116 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJ2SWQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 14:22:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TI9Loc017180;
        Thu, 29 Oct 2020 18:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mpgUYNPdzALNXv7f2kBqPfd2XvxPyHs+Qro4vQ1XGc8=;
 b=cKvTjInKSy1jgq08lQ/gLyEP7vA3hTlFppi2SyQi4UYUQTNLAbHBDAhZf0MiUd69dcDp
 yNdXsrYbibajxgF8y9jUGTwsIdHfWpmIZXt7W+u5033rwxpgccoBM1FMNSQfEJ1x7YSP
 nhTtFrKcnaE9QMxV7WPFde/eMgHbVuQ+aSoFdqOklJzC7hr71htiy/MyteNAET9HTZdo
 VjqvsAQPfT2CLSGJ7iiYo2+CofPEIFedPuSFDBDCAmLv+Wf6F4dMquXhUpJlyjwjB7vU
 hBBDR0g/GaJVC4ooldyJSqJwe1Ny5NRP94hEh4McpctkLOjs5a1xBcaK/lxB5M+dOTqP 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7m6bt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 18:22:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIACmX108492;
        Thu, 29 Oct 2020 18:22:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx60tqun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 18:22:14 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TIMDWb015565;
        Thu, 29 Oct 2020 18:22:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 11:22:12 -0700
Date:   Thu, 29 Oct 2020 11:22:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
Message-ID: <20201029182211.GT1061252@magnolia>
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
 <160382545965.1203848.17436126884496645934.stgit@magnolia>
 <CAOQ4uxiCe+fnXh6eeduWDbtaZQxMuj5UuU+B85j4z1OnbxthcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiCe+fnXh6eeduWDbtaZQxMuj5UuU+B85j4z1OnbxthcA@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 03:06:55PM +0200, Amir Goldstein wrote:
> On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Test that we can upgrade an existing filesystem to use bigtime.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Just some nits.
> Not adding RVB because I would rather someone with more understanding of quotas
> will review this.
> 
> > ---
> >  common/xfs        |   16 ++++++
> >  tests/xfs/908     |   87 ++++++++++++++++++++++++++++++
> >  tests/xfs/908.out |   10 +++
> >  tests/xfs/909     |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/909.out |    4 +
> >  tests/xfs/group   |    2 +
> >  6 files changed, 272 insertions(+)
> >  create mode 100755 tests/xfs/908
> >  create mode 100644 tests/xfs/908.out
> >  create mode 100755 tests/xfs/909
> >  create mode 100644 tests/xfs/909.out
> >
> >
> > diff --git a/common/xfs b/common/xfs
> > index 19ccee03..4274eee7 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1008,3 +1008,19 @@ _xfs_timestamp_range()
> >                 $dbprog -f -c 'timelimit --compact' | awk '{printf("%s %s", $1, $2);}'
> >         fi
> >  }
> > +
> > +_require_xfs_mkfs_bigtime()
> > +{
> > +       _scratch_mkfs_xfs_supported -m bigtime=1 >/dev/null 2>&1 \
> > +          || _notrun "mkfs.xfs doesn't have bigtime feature"
> > +}
> > +
> > +_require_xfs_scratch_bigtime()
> > +{
> > +       _require_scratch
> > +
> > +       _scratch_mkfs -m bigtime=1 > /dev/null
> > +       _try_scratch_mount || \
> > +               _notrun "bigtime not supported by scratch filesystem type: $FSTYP"
> > +       _scratch_unmount
> > +}
> > diff --git a/tests/xfs/908 b/tests/xfs/908
> > new file mode 100755
> > index 00000000..e368d66c
> > --- /dev/null
> > +++ b/tests/xfs/908
> > @@ -0,0 +1,87 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 908
> > +#
> > +# Check that we can upgrade a filesystem to support bigtime and that inode
> > +# timestamps work properly after the upgrade.
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
> > +. ./common/filter
> > +
> > +# We have very specific formatting parameters, so don't let things get complex
> > +# with realtime devices and external logs.
> > +unset USE_EXTERNAL
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_mkfs_crc
> > +_require_xfs_mkfs_bigtime
> > +_require_xfs_scratch_bigtime
> 
> Should we also explicitly require support for xfs_admin -O bigtime?

<shrug> I don't know.  Assuming all the xfsprogs support code goes in at
the same time, then the fact that you can format with bigtime means that
xfs_admin will support upgrading to bigtime.

> > diff --git a/tests/xfs/909.out b/tests/xfs/909.out
> > new file mode 100644
> > index 00000000..948502b7
> > --- /dev/null
> > +++ b/tests/xfs/909.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 909
> > +grace2 expiry is in range
> > +grace2 expiry after remount is in range
> > +Silence is golden.
> 
> Output is not silent ;-)

Will fix, thanks.

--D

> Thanks,
> Amir.
