Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE39BC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 16:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73DCA64EC6
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 16:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhCNQji (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Mar 2021 12:39:38 -0400
Received: from out20-37.mail.aliyun.com ([115.124.20.37]:39732 "EHLO
        out20-37.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbhCNQja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Mar 2021 12:39:30 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07462925|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0396938-0.00234665-0.95796;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Jkz3dmB_1615739965;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Jkz3dmB_1615739965)
          by smtp.aliyun-inc.com(10.147.41.143);
          Mon, 15 Mar 2021 00:39:26 +0800
Date:   Mon, 15 Mar 2021 00:39:25 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: test mkfs min log size calculation w/ rt
 volumes
Message-ID: <YE48Pfe9dC4OJ7Up@desktop>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
 <161526482563.1214319.7317631500409765514.stgit@magnolia>
 <YE4i/cxYGi4mGQB5@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE4i/cxYGi4mGQB5@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 14, 2021 at 10:51:41PM +0800, Eryu Guan wrote:
> On Mon, Mar 08, 2021 at 08:40:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In "mkfs: set required parts of the realtime geometry before computing
> > log geometry" we made sure that mkfs set up enough of the fs geometry to
> > compute the minimum xfs log size correctly when formatting the
> > filesystem.  This is the regression test for that issue.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/761     |   45 +++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/761.out |    1 +
> >  tests/xfs/group   |    1 +
> >  3 files changed, 47 insertions(+)
> >  create mode 100755 tests/xfs/761
> >  create mode 100644 tests/xfs/761.out
> > 
> > 
> > diff --git a/tests/xfs/761 b/tests/xfs/761
> > new file mode 100755
> > index 00000000..b9770d90
> > --- /dev/null
> > +++ b/tests/xfs/761
> > @@ -0,0 +1,45 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 761
> > +#
> > +# Make sure mkfs sets up enough of the rt geometry that we can compute the
> > +# correct min log size for formatting the fs.
> > +#
> > +# This is a regression test for the xfsprogs commit 31409f48 ("mkfs: set
> > +# required parts of the realtime geometry before computing log geometry").
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
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_realtime
> > +
> > +rm -f $seqres.full
> > +
> > +# Format a tiny filesystem to force minimum log size, then see if it mounts
> > +_scratch_mkfs -r size=1m -d size=100m > $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/761.out b/tests/xfs/761.out
> > new file mode 100644
> > index 00000000..8c9d9e90
> > --- /dev/null
> > +++ b/tests/xfs/761.out
> > @@ -0,0 +1 @@
> > +QA output created by 761
> 
> Need "Silence is golden" in .out file if you're going to respin it,
> otherwise I can fix it on commit.

Never mind, I've applied it with .out file fixed, and added 'mount'
group as Chandan suggested.

Thanks,
Eryu
