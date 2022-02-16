Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4FFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 14:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiBPOc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 09:32:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiBPOcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 09:32:55 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD9CC7C18;
        Wed, 16 Feb 2022 06:32:41 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id q4so425860qki.11;
        Wed, 16 Feb 2022 06:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/Ce3VvaXMKyJjbauhbe+va+fjMOD3i63CuQtk8aVVzA=;
        b=QQuYBXcTqL8jR43f+hSyiVl6MUM5tMjR1Gh+DT66Ffq9iTKHLk9+eV+ajvVUo2L94b
         Zj0x0DUOn+8K1rSs5kPQBlaNpq4jSXwDB066xEke2+hp1EHg7CMpzfU1JCAryg8xgJR6
         71gaMGgz/Fccu9AKsNUBorIDWr21pVV4LjMfHkVTxYeXVD70Xm16c0ktABPBhtdehFyb
         QDGKSknXXFUf6hiY41C/lMnRYrdkwTDJ9E2bDtuLD1RnRZlWLOFe8IHPyVwBycWw7Enr
         WAig4jGT9oUKk7lIwMv9kEHR6bM/SL0EgPJNBHfmMWMZskxcrlhuqOWf6qaHVmUuiKqu
         5QXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/Ce3VvaXMKyJjbauhbe+va+fjMOD3i63CuQtk8aVVzA=;
        b=pFd9zXiJbfCZZjaet0wJ3oBPrRBo7cQKOsmCz0juepPPR8UKocAjAuYCtcfwaOz+KY
         yE5hcs2a68EHEo2EfMrAMDEWT9V8x3Mqzk1JAwSnrQiHeORBCd2yBrw/XJE6aEK9qwnU
         B1WXjAyhTRyCltjweHxsu6HfLLKwX1Q4GfGRUJ6uVW4INTb0yFgr+mEAtuksD/cy2hJB
         szB1Dthdpis6o4BcOo8ZFwOqqd5bXuT2UefurEDAr6CJ3kY2C44qLKEyulj9uPeOc+wY
         Y0v16LUEkk4KausmlTOzYIihsXadK7ISklDyccYVPB+ywQexK3CgUOPZ2ryChDf2hhkH
         54MA==
X-Gm-Message-State: AOAM530kfO3hCXnaWZa+E0R18CCR5mZqSXDIyC3FEmYSRJAkdAyBraSM
        AAvCgYALxYxXu4Zl3kLVclKYaCtKNA==
X-Google-Smtp-Source: ABdhPJwAd4Le7Szv3MOLcIfUms6TOyjq6Q5YwDeBj/VYYclF3YCWQt/o+LPUp7cEJnY7AMa5ZIKQNQ==
X-Received: by 2002:a37:ad06:0:b0:4e1:2d6e:8bd7 with SMTP id f6-20020a37ad06000000b004e12d6e8bd7mr1392217qkm.668.1645021960632;
        Wed, 16 Feb 2022 06:32:40 -0800 (PST)
Received: from gabell (209-6-122-159.s2973.c3-0.arl-cbr1.sbo-arl.ma.cable.rcncustomer.com. [209.6.122.159])
        by smtp.gmail.com with ESMTPSA id a14sm21866729qtb.92.2022.02.16.06.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 06:32:40 -0800 (PST)
Date:   Wed, 16 Feb 2022 09:32:38 -0500
From:   Masayoshi Mizuma <msys.mizuma@gmail.com>
To:     fstests@vger.kernel.org,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfsdump with bind-mounted filesystem
Message-ID: <Yg0LBnCaT4rWbVLG@gabell>
References: <20220214203409.10309-1-msys.mizuma@gmail.com>
 <20220216070701.ykfrl2nslh7m3qjm@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216070701.ykfrl2nslh7m3qjm@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 16, 2022 at 03:07:01PM +0800, Zorro Lang wrote:
> On Mon, Feb 14, 2022 at 03:34:09PM -0500, Masayoshi Mizuma wrote:
> > From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > 
> > commit 25195eb ("xfsdump: handle bind mount target") introduced
> > a bug of xfsdump which doesn't store the files to the dump file
> > correctly when the root inode number is changed.
> > 
> > The commit 25195eb is reverted, and commit 0717c1c ("xfsdump: intercept
> > bind mount targets") which is in xfsdump v3.1.10 fixes the bug to reject
> > the filesystem if it's bind-mounted.
> > 
> > Test that xfsdump can reject the bind-mounted filesystem.
> > 
> > Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > ---
> >  tests/xfs/544     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/544.out |  2 ++
> >  2 files changed, 65 insertions(+)
> >  create mode 100755 tests/xfs/544
> >  create mode 100644 tests/xfs/544.out
> > 
> > diff --git a/tests/xfs/544 b/tests/xfs/544
> > new file mode 100755
> > index 00000000..1d586ebc
> > --- /dev/null
> > +++ b/tests/xfs/544
> > @@ -0,0 +1,63 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
> > +#
> > +# FS QA Test 544
> > +#
> > +# Regression test for commit:
> > +# 0717c1c ("xfsdump: intercept bind mount targets")
> > +
> > +. ./common/preamble
> > +_begin_fstest auto dump
> > +
> > +_cleanup()
> > +{
> > +	_cleanup_dump
> 
> Is this really needed?
> 
> > +	cd /
> > +	rm -r -f $tmp.*
> > +	$UMOUNT_PROG $mntpnt2 2> /dev/null
> > +	rmdir $mntpnt1/dir 2> /dev/null
> > +	$UMOUNT_PROG $mntpnt1 2> /dev/null
> > +	rmdir $mntpnt2 2> /dev/null
> > +	rmdir $mntpnt1 2> /dev/null
> > +	[ -n "$loopdev" ] && _destroy_loop_device $loopdev
> > +	rm -f "$TEST_DIR"/fsfile
> > +}
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/dump
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +
> > +mntpnt1=$TEST_DIR/MNT1
> > +mntpnt2=$TEST_DIR/MNT2
> > +
> > +
> > +# Set up
> > +$MKFS_XFS_PROG -s size=4096 -b size=4096 \
> > +	-dfile,name=$TEST_DIR/fsfile,size=8649728b,sunit=1024,swidth=2048 \
> > +	>> $seqres.full 2>&1 || _fail "mkfs failed"
> 
> Are "-s size=4096 -b size=4096 -d sunit=1024,swidth=2048" necessary? If so, better
> to add comments to explain why they're needed.
> 
> > +
> > +loopdev=$(_create_loop_device "$TEST_DIR"/fsfile)
> 
> Is loopdev necessary? If you need mkfs, can we just use SCRATCH_DEV, and bind $SCRATCH_MNT/someonedir
> on $TEST_DIR/someonedir ? E.g:
> 
> _cleanup()
> {
> 	$UMOUNT_PROG $TEST_DIR/dest 2> /dev/null
> 	cd /
> 	rm -r -f $tmp.*
> }
> 
> _scratch_mkfs > $seqres.full
> _scratch_mount
> mkdir $SCRATCH_MNT/src
> mkdir $TEST_DIR/dest
> $MOUNT_PROG --bind $SCRATCH_MNT/src $TEST_DIR/dest || _fail "Bind mount failed"
> $XFSDUMP_PROG -L session -M test -f $tmp.dump $TEST_DIR/dest >> $seqres.full 2>&1 && \
> 	echo "dump with bind-mounted should be failed, but passed."
> 
> echo "Silence is golden"
> ...
> 
> If you don't need mkfs, you can use $TEST_DIR (e.g. $TEST_DIR/src and $TEST_DIR/dest) to
> be bind mount source and target. Due to this case just trys to test xfsdump a bind mount,
> and make sure dump failed as expected. Am I right?

Thank you for pointing it out! Yes, you're right.
I'll remove the unnecessary parts and post the v2.

Thanks!
Masa

> 
> Thanks,
> Zorro
> 
> > +
> > +mkdir $mntpnt1 >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt1\" failed"
> > +
> > +_mount $loopdev $mntpnt1
> > +mkdir $mntpnt1/dir >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt1/dir\" failed"
> > +mkdir $mntpnt2 >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt2\" failed"
> > +
> > +
> > +# Test
> > +echo "*** dump with bind-mounted test ***" >> $seqres.full
> > +
> > +mount -o bind $mntpnt1/dir $mntpnt2
> > +
> > +$XFSDUMP_PROG -L session -M test -f $tmp.dump $mntpnt2 \
> > +	>> $seqres.full 2>&1 && echo "dump with bind-mounted should be failed, but passed."
> > +
> > +echo "Silence is golden"
> > +status=0
> > +exit
> > diff --git a/tests/xfs/544.out b/tests/xfs/544.out
> > new file mode 100644
> > index 00000000..fc7ebff3
> > --- /dev/null
> > +++ b/tests/xfs/544.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 544
> > +Silence is golden
> > -- 
> > 2.31.1
> > 
> 
