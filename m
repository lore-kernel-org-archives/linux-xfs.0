Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE949C4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC4560F57
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhHLRFU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233815AbhHLRFT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 13:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E8C60FBF;
        Thu, 12 Aug 2021 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628787893;
        bh=XMFSORaL4+OSoDT7ZAKqfnoSPKYQZp2c9eWcBSgbff4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=NmU8HAk9b0dJNXkotwDCDsTSbmTbLmrHbbN4X00ZhHDjOxaYt/Vb50XGB41Wow7UI
         27Epd2Z6kN9ibFYurxK7E97BCugkAucUGGlqwbuxb23C2fnhrnyFJTQ5C4K0b2FXt7
         tV+q29NIEK/Cfi7IEO+w8eDho0htO9WEKCGdGWwlzo9I9LSZLpNtwDr8CrSlL2fgwA
         3ml7uhefjr1LidYqio8yj9RDafrzZdykbcyQnS3NG7cSa//JEerMvwZ8KE5APiPlf5
         3y50cAaYfIVMPMURIUvta+kCgCXFa+km19Ge8/JKlK0mCGi9WUxTDKgXwP/4Gid+s5
         UNBSfySMZci1g==
Date:   Thu, 12 Aug 2021 10:04:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] generic: test xattr operations only
Message-ID: <20210812170453.GP3601443@magnolia>
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
 <162743102476.3428896.4543035331031604848.stgit@magnolia>
 <20210812053452.7bz2qgnuhhgj7gl3@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812053452.7bz2qgnuhhgj7gl3@fedora>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 01:34:52PM +0800, Zorro Lang wrote:
> On Tue, Jul 27, 2021 at 05:10:24PM -0700, Darrick J. Wong wrote:
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
> > index 00000000..b19f8f73
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
> > +_begin_fstest soak attr long_rw stress
> 
> Should we add this test into 'auto' group too?

Yes, fixed.

> > +
> > +_cleanup()
> > +{
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> 
> Can a "wait" command help more at here?

Ok, I"ll add that.

--D

> Others looks good to me.
> 
> Thanks,
> Zorro
> 
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
> > +nr_ops=$((70000 * nr_cpus * TIME_FACTOR))
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
> 
