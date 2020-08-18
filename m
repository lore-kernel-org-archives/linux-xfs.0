Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CED1C433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 18:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F6AE20789
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 18:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aZyLS0eQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHRSXd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 14:23:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRSXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 14:23:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IIHbMa014399;
        Tue, 18 Aug 2020 18:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NN8i0Cw8bq50077C5nEOsc/DhPgJvSUymZwggh92HrM=;
 b=aZyLS0eQzOWn6YCl0HKtZC4Vt1/ipodlBlN8HGXQoIkKt2m6lCYwkFmoGlcFq7T6xPgm
 nYtNsKcFSUgM7xq5JI6xfQkfEyxPVWr2h9mB3sw8p2XVwviXb4Vkn5pNQyy0o/BRSPb8
 8zIf/EGUDgCdUxM5HGkTL2C70NeF39aZlF4/0vMyiU4l/5L4D6PEeDv8FuWQZ8XA1n+L
 t9dYNXbFbzLqE8H0UjH509Q4BfrMXzWW6IQgRip3dx7gsf+DgWioAW2NYFht8+GM/H1B
 ej5fXsAuVBz/wUBIudCYmGFFuHrupAqx0U+JafyAPkhpMZWF879e5aks6j38cI1sTUog gQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nmegkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 18:23:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IIIFEm091811;
        Tue, 18 Aug 2020 18:23:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32xsfs76t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 18:23:30 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IINTl9000352;
        Tue, 18 Aug 2020 18:23:29 GMT
Received: from localhost (/10.159.135.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 11:23:23 -0700
Date:   Tue, 18 Aug 2020 11:23:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
Message-ID: <20200818182322.GX6096@magnolia>
References: <159770525400.3960575.11977829712550002800.stgit@magnolia>
 <159770527916.3960575.1560206777561534458.stgit@magnolia>
 <CAOQ4uxg9MG8N=hF++y=RtXLo7Up0wM3uF=tC3HW8c2ivWsjqCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg9MG8N=hF++y=RtXLo7Up0wM3uF=tC3HW8c2ivWsjqCA@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 09:16:21AM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Test that we can upgrade an existing filesystem to use bigtime.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/xfs        |   16 +++++++++++
> >  tests/xfs/908     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/908.out |    3 ++
> >  tests/xfs/909     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/909.out |   12 ++++++++
> >  tests/xfs/group   |    2 +
> >  6 files changed, 184 insertions(+)
> >  create mode 100755 tests/xfs/908
> >  create mode 100644 tests/xfs/908.out
> >  create mode 100755 tests/xfs/909
> >  create mode 100644 tests/xfs/909.out
> >
> >
> > diff --git a/common/xfs b/common/xfs
> > index 252a5c0d..c0735a51 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -985,3 +985,19 @@ _xfs_timestamp_range()
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
> > index 00000000..e313e14b
> > --- /dev/null
> > +++ b/tests/xfs/908
> > @@ -0,0 +1,74 @@
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
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_xfs_mkfs_crc
> > +_require_xfs_mkfs_bigtime
> > +_require_xfs_scratch_bigtime
> > +
> > +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> > +       _notrun "Userspace does not support dates past 2038."
> > +
> > +rm -f $seqres.full
> > +
> > +# Format V5 filesystem without bigtime support and populate it
> > +_scratch_mkfs -m crc=1,bigtime=0 > $seqres.full
> > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +touch $SCRATCH_MNT/a
> > +touch $SCRATCH_MNT/b
> > +ls -la $SCRATCH_MNT/* >> $seqres.full
> > +
> > +_scratch_unmount
> > +_check_scratch_fs
> > +
> > +# Now upgrade to bigtime support
> > +_scratch_xfs_admin -O bigtime >> $seqres.full
> > +_check_scratch_fs
> > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> > +
> > +# Mount again, look at our files
> > +_scratch_mount >> $seqres.full
> > +ls -la $SCRATCH_MNT/* >> $seqres.full
> > +
> > +# Modify some timestamps
> > +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> > +
> > +_scratch_cycle_mount
> > +
> > +# Did the timestamp survive?
> > +ls -la $SCRATCH_MNT/* >> $seqres.full
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> > +
> 
> Darrick,
> 
> These tests look great, but I wonder.
> generic/402 has more test coverage than above.
> It tests several data points and it tests them with and without mount cycle.

Um... these two tests exist to make sure that /upgrading/ works, whereas
generic/402 tests whatever it finds on the formatted scratch filesystem.

> With your current tests, bigtime will enjoy this test coverage only if
> the entire
> run is configured with custom XFS_MKFS_OPTIONS or when bigtime
> becomes default for mkfs.

I don't understand the line of reasoning.  Both tests format with
specific mkfs options, or skip the test entirely if mkfs doesn't know
what bigtime is.

> Do you think we should have a temporary clone of generic/402 for xfs which
> enables bigtime for the time being?

<shrug> I pushed most of my testing to the cloud, so I just spawn enough
VMs so that one of them will test bigtime=0 and another does
bigtime=1...

--D

> Thanks,
> Amir.
