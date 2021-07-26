Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3429C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1B360F44
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbhGZQ2f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 12:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240417AbhGZQVh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 12:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78A4660F37;
        Mon, 26 Jul 2021 17:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318913;
        bh=dlBCmGaytFioU+IzHg/7V5rT4gMrDW4dQ6geZyza8k0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mk73q9jKczWo6Q46WDxrNTLCdY0dnUgPakINxc++lQ8PPGdh3gX6a0SCkSNtxskxa
         WDyJOpgNBlAzVB41uNBvmBkciRiyUVjjSihv7cEVW4CIsmJGO9T5FgcPozxMTnpPuH
         rGgF1pOQ5Uugvylh/Q+/AkS/fKaD/mHm2fQtvbwU/wacdNs7IJIw9UivqLvcpfPXm1
         jwvAzYqTXXepyv3fqMtNJ/iqLUz9T3lIyDJ/vwPgt843i6OuTVN+0/XVyZPSgBrR8N
         mtvlXOI5ykc4owlEYrGsu80IPATJUDZjDEquaf3OLt2I6M0RFk5ogY8bO4sj/nv064
         3TWqyNLKhL5/A==
Date:   Mon, 26 Jul 2021 10:01:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] generic: test xattr operations only
Message-ID: <20210726170152.GT559212@magnolia>
References: <162674332320.2650898.17601790625049494810.stgit@magnolia>
 <162674332866.2650898.16916837755915187962.stgit@magnolia>
 <YP2LJTF7mL9ooKxf@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YP2LJTF7mL9ooKxf@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 12:02:45AM +0800, Eryu Guan wrote:
> On Mon, Jul 19, 2021 at 06:08:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Exercise extended attribute operations.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/724     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/724.out |    2 ++
> >  2 files changed, 59 insertions(+)
> >  create mode 100755 tests/generic/724
> >  create mode 100644 tests/generic/724.out
> > 
> > 
> > diff --git a/tests/generic/724 b/tests/generic/724
> > new file mode 100755
> > index 00000000..f2f4a2ec
> > --- /dev/null
> > +++ b/tests/generic/724
> > @@ -0,0 +1,57 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 724
> > +#
> > +# Run an extended attributes fsstress run with multiple threads to shake out
> > +# bugs in the xattr code.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto attr
> > +
> > +_cleanup()
> > +{
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +
> > +_require_scratch
> > +_require_command "$KILLALL_PROG" "killall"
> > +
> > +echo "Silence is golden."
> > +
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +nr_cpus=$((LOAD_FACTOR * 4))
> > +nr_ops=$((700000 * nr_cpus * TIME_FACTOR))
> 
> This takes too long time to be an 'auto' test, it runs for 20min on my
> test vm and is still running, I think I have to kill it manually.
> 
> I noticed that generic/52[12] run long time fsx tests, and they are in
> 'soak long_rw' groups, perhaps this one fits there as well? And maybe
> 'stress' group too.

Oh, yikes, I sent this out configured for 700,000 xattr ops.  Let me
lower that to 70k.

--D

> 
> Thanks,
> Eryu
> 
> > +
> > +args=('-z' '-S' 'c')
> > +
> > +# Do some directory tree modifications, but the bulk of this is geared towards
> > +# exercising the xattr code, especially attr_set which can do up to 10k values.
> > +for verb in unlink rmdir; do
> > +	args+=('-f' "${verb}=1")
> > +done
> > +for verb in creat mkdir; do
> > +	args+=('-f' "${verb}=2")
> > +done
> > +for verb in getfattr listfattr; do
> > +	args+=('-f' "${verb}=3")
> > +done
> > +for verb in attr_remove removefattr; do
> > +	args+=('-f' "${verb}=4")
> > +done
> > +args+=('-f' "setfattr=20")
> > +args+=('-f' "attr_set=60")	# sets larger xattrs
> > +
> > +$FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/724.out b/tests/generic/724.out
> > new file mode 100644
> > index 00000000..164cfffb
> > --- /dev/null
> > +++ b/tests/generic/724.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 724
> > +Silence is golden.
> > 
