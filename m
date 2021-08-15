Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BC6C4320A
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA5C86120F
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Aug 2021 15:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbhHOPq4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 11:46:56 -0400
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:54553 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhHOPqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Aug 2021 11:46:55 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09703767|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0139779-0.000313177-0.985709;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047209;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.L.mBWsc_1629042383;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.L.mBWsc_1629042383)
          by smtp.aliyun-inc.com(10.147.42.135);
          Sun, 15 Aug 2021 23:46:24 +0800
Date:   Sun, 15 Aug 2021 23:46:23 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 1/3] generic: test xattr operations only
Message-ID: <YRk2zwCZ9YqgeyjG@desktop>
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
 <162743102476.3428896.4543035331031604848.stgit@magnolia>
 <20210812053452.7bz2qgnuhhgj7gl3@fedora>
 <20210812170453.GP3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812170453.GP3601443@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 10:04:53AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 12, 2021 at 01:34:52PM +0800, Zorro Lang wrote:
> > On Tue, Jul 27, 2021 at 05:10:24PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Exercise extended attribute operations.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/724     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/724.out |    2 ++
> > >  2 files changed, 59 insertions(+)
> > >  create mode 100755 tests/generic/724
> > >  create mode 100644 tests/generic/724.out
> > > 
> > > 
> > > diff --git a/tests/generic/724 b/tests/generic/724
> > > new file mode 100755
> > > index 00000000..b19f8f73
> > > --- /dev/null
> > > +++ b/tests/generic/724
> > > @@ -0,0 +1,57 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 724
> > > +#
> > > +# Run an extended attributes fsstress run with multiple threads to shake out
> > > +# bugs in the xattr code.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest soak attr long_rw stress
> > 
> > Should we add this test into 'auto' group too?
> 
> Yes, fixed.

I can fix that on commit.

> 
> > > +
> > > +_cleanup()
> > > +{
> > > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > 
> > Can a "wait" command help more at here?

There's no background process in this test, so it seems 'wait' won't
do anything.

Thanks,
Eryu

> 
> Ok, I"ll add that.
> 
> --D
> 
> > Others looks good to me.
> > 
> > Thanks,
> > Zorro
> > 
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +
> > > +_require_scratch
> > > +_require_command "$KILLALL_PROG" "killall"
> > > +
> > > +echo "Silence is golden."
> > > +
> > > +_scratch_mkfs > $seqres.full 2>&1
> > > +_scratch_mount >> $seqres.full 2>&1
> > > +
> > > +nr_cpus=$((LOAD_FACTOR * 4))
> > > +nr_ops=$((70000 * nr_cpus * TIME_FACTOR))
> > > +
> > > +args=('-z' '-S' 'c')
> > > +
> > > +# Do some directory tree modifications, but the bulk of this is geared towards
> > > +# exercising the xattr code, especially attr_set which can do up to 10k values.
> > > +for verb in unlink rmdir; do
> > > +	args+=('-f' "${verb}=1")
> > > +done
> > > +for verb in creat mkdir; do
> > > +	args+=('-f' "${verb}=2")
> > > +done
> > > +for verb in getfattr listfattr; do
> > > +	args+=('-f' "${verb}=3")
> > > +done
> > > +for verb in attr_remove removefattr; do
> > > +	args+=('-f' "${verb}=4")
> > > +done
> > > +args+=('-f' "setfattr=20")
> > > +args+=('-f' "attr_set=60")	# sets larger xattrs
> > > +
> > > +$FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/724.out b/tests/generic/724.out
> > > new file mode 100644
> > > index 00000000..164cfffb
> > > --- /dev/null
> > > +++ b/tests/generic/724.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 724
> > > +Silence is golden.
> > > 
> > 
