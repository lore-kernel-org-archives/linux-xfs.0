Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2124CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 16:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD20364E56
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Feb 2021 16:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbhBHQvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 11:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233558AbhBHQvd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 11:51:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 179AD64E92;
        Mon,  8 Feb 2021 16:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612803053;
        bh=mp9oq01xEhkrJX3rloR5La3xHak9Dl03t2en5mGXsgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fNCwbFNROqKiGbsXLXX4hift3+BjwZcDAairorSR3Kmf5Qy0weSzknjV8B+2O/SMf
         MdJooHUI6IQocgGTxPXmZHpQDfvW7HTEUJBIVIGxq8tLrbNbq/jO/lVPJnodqVEfbb
         EL/aGztMcp3B71PlWcNH5sSXlUPlgQSgRCI59BkcqRMwlmrOJXSl8hF14zNrEP39U9
         no64mKWXAaBXIakjs9E0tLouAP7gmuNDEYgeR/xuY46Y990eQYJ14MJILTkH5fCV9C
         cIFexio36Pgba7G50+QjMlggLqW7DAmA1rfZay6Gy6nKGJZdatVzTETVU9hWNQArLf
         9DO4/fR7svH5Q==
Date:   Mon, 8 Feb 2021 08:50:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: test a regression in dquot type checking
Message-ID: <20210208165057.GO7193@magnolia>
References: <20210202194158.GR7193@magnolia>
 <20210207151439.GG2350@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207151439.GG2350@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 07, 2021 at 11:14:39PM +0800, Eryu Guan wrote:
> On Tue, Feb 02, 2021 at 11:41:58AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test for incorrect ondisk dquot type checking that
> > was introduced in Linux 5.9.  The bug is that we can no longer switch a
> > V4 filesystem from having group quotas to having project quotas (or vice
> > versa) without logging corruption errors.  That is a valid use case, so
> > add a regression test to ensure this can be done.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/766     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/766.out |    5 ++++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 69 insertions(+)
> >  create mode 100755 tests/xfs/766
> >  create mode 100644 tests/xfs/766.out
> > 
> > diff --git a/tests/xfs/766 b/tests/xfs/766
> > new file mode 100755
> > index 00000000..55bc03af
> > --- /dev/null
> > +++ b/tests/xfs/766
> > @@ -0,0 +1,63 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 766
> > +#
> > +# Regression test for incorrect validation of ondisk dquot type flags when
> > +# we're switching between group and project quotas while mounting a V4
> > +# filesystem.  This test doesn't actually force the creation of a V4 fs because
> > +# even V5 filesystems ought to be able to switch between the two without
> > +# triggering corruption errors.
> > +#
> > +# The appropriate XFS patch is:
> > +# xfs: fix incorrect root dquot corruption error when switching group/project
> > +# quota types
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
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_debug
> > +_require_quota
> > +_require_scratch
> 
> Also need _require_check_dmesg
> 
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format filesystem" | tee -a $seqres.full
> > +_scratch_mkfs > $seqres.full
> > +
> > +echo "Mount with project quota" | tee -a $seqres.full
> > +_qmount_option 'prjquota'
> > +_qmount
> > +_require_prjquota $SCRATCH_DEV
> > +
> > +echo "Mount with group quota" | tee -a $seqres.full
> > +_qmount_option 'grpquota'
> > +_qmount
> > +$here/src/feature -G $SCRATCH_DEV || echo "group quota didn't mount?"
> > +
> > +echo "Check dmesg for corruption"
> > +_check_dmesg_for corruption && \
> > +	echo "should not have seen corruption messages"
> 
> I'd do the following to print the dmesg in question as well, so we know
> what is actually failing the test.
> 
> _dmesg_since_test_start | grep corruption
> 
> A failure will look like
> 
>     --- tests/xfs/527.out       2021-02-07 23:00:46.679485872 +0800
>     +++ /root/workspace/xfstests/results//xfs_4k/xfs/527.out.bad        2021-02-07 23:10:16.745371039 +0800
>     @@ -3,3 +3,5 @@
>      Mount with project quota
>      Mount with group quota
>      Check dmesg for corruption
>     +[1211043.882535] XFS (dm-5): Metadata corruption detected at xfs_dquot_from_disk+0x1b4/0x1f0 [xfs], quota 0
>     +[1211043.890173] XFS (dm-5): Metadata corruption detected at xfs_dquot_from_disk+0x1b4/0x1f0 [xfs], quota 0
>     ...
> 
> I'll fix both on commit.

Oh!  Thank you!

--D

> Thanks,
> Eryu
> 
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/766.out b/tests/xfs/766.out
> > new file mode 100644
> > index 00000000..18bd99f0
> > --- /dev/null
> > +++ b/tests/xfs/766.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 766
> > +Format filesystem
> > +Mount with project quota
> > +Mount with group quota
> > +Check dmesg for corruption
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index fb78b0d7..cdca04b5 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -545,6 +545,7 @@
> >  763 auto quick rw realtime
> >  764 auto quick repair
> >  765 auto quick quota
> > +766 auto quick quota
> >  908 auto quick bigtime
> >  909 auto quick bigtime quota
> >  910 auto quick inobtcount
