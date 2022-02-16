Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F02C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 07:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiBPHIU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 02:08:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiBPHIN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 02:08:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9693E1E5F0E
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 23:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644995229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r9Eoz077WzDH1ilTxjcZfZBXYiekY8+r8h43XOO9apM=;
        b=OLpgCvSHKps7tJeJ9h0foeCxlqwhuxzacnyChgYwv/PpPLRoyug9tDJbPEon8SY5jG50IJ
        qJyGOXf5mYESyiqpE2uvcFuHNj1uABvCz9RnRjkRX0qbYnYbmbCQttXjaqZesrXXOzsksp
        oVfcGKgHLx84rwwQFVTOwy/e+GJIJT0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-CTCf7lX_PUmSEETEBRtuLA-1; Wed, 16 Feb 2022 02:07:08 -0500
X-MC-Unique: CTCf7lX_PUmSEETEBRtuLA-1
Received: by mail-pj1-f70.google.com with SMTP id j23-20020a17090a7e9700b001b8626c9170so4090502pjl.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 23:07:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=r9Eoz077WzDH1ilTxjcZfZBXYiekY8+r8h43XOO9apM=;
        b=pdtP/p2yfSsDuHQIl/vSUXE05i16vsoqn6zMVUFTmoM71ahh0DmKSwNqQTKhLNvb7n
         DvgKuTkTy9NIgIGeNWz1Ne0zM2AijvDnxWhc3Em5i8OCpLQiO/KawLIZFmdG3yxyYqtT
         CKb8cgz+7EovKYIYbcOQCNGCsYw5siTbQYhI5vcB8rOE6QlTvctcO23+IqjqJ67qeSjI
         0ysoE2Jy/mOwXGGZMON6nHCQ1zDlOlB9qJjbM04vCKxdIGhmTR+Opu2hnRDa/UqR+UxZ
         jFkrKAxv2j63rNyQaORg4XB7RHqxWeglpmsSdzOCONhHeJnkSECOmG1oOJEL90wyS7hb
         bM9A==
X-Gm-Message-State: AOAM532SH4ssr3gcMoXGdEmAi+ufkJ0r4mZVJMPxTWHp2qOnR+vjwBo1
        gO8ORu1sMGa4ms70SditScMeJkJqhNNCAzB9oOutqJ56ZeQZHHnu45vRngcnp9Nl7+DlesKEjyA
        Y8xlE7Pl+tLqfgWRns40Q
X-Received: by 2002:a17:902:d705:b0:14e:e5a2:1b34 with SMTP id w5-20020a170902d70500b0014ee5a21b34mr1269953ply.88.1644995227195;
        Tue, 15 Feb 2022 23:07:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhf7n22kGCM6RKgnXUMQ5yU6L4aLzY2xm1ke5OatXy3I0mv3GAJcHrsDeS8d2yA6zI8tKQ+Q==
X-Received: by 2002:a17:902:d705:b0:14e:e5a2:1b34 with SMTP id w5-20020a170902d70500b0014ee5a21b34mr1269928ply.88.1644995226871;
        Tue, 15 Feb 2022 23:07:06 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id my4sm8129298pjb.13.2022.02.15.23.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 23:07:06 -0800 (PST)
Date:   Wed, 16 Feb 2022 15:07:01 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc:     fstests@vger.kernel.org,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfsdump with bind-mounted filesystem
Message-ID: <20220216070701.ykfrl2nslh7m3qjm@zlang-mailbox>
Mail-Followup-To: Masayoshi Mizuma <msys.mizuma@gmail.com>,
        fstests@vger.kernel.org, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-xfs@vger.kernel.org
References: <20220214203409.10309-1-msys.mizuma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214203409.10309-1-msys.mizuma@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 14, 2022 at 03:34:09PM -0500, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> commit 25195eb ("xfsdump: handle bind mount target") introduced
> a bug of xfsdump which doesn't store the files to the dump file
> correctly when the root inode number is changed.
> 
> The commit 25195eb is reverted, and commit 0717c1c ("xfsdump: intercept
> bind mount targets") which is in xfsdump v3.1.10 fixes the bug to reject
> the filesystem if it's bind-mounted.
> 
> Test that xfsdump can reject the bind-mounted filesystem.
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  tests/xfs/544     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/544.out |  2 ++
>  2 files changed, 65 insertions(+)
>  create mode 100755 tests/xfs/544
>  create mode 100644 tests/xfs/544.out
> 
> diff --git a/tests/xfs/544 b/tests/xfs/544
> new file mode 100755
> index 00000000..1d586ebc
> --- /dev/null
> +++ b/tests/xfs/544
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
> +#
> +# FS QA Test 544
> +#
> +# Regression test for commit:
> +# 0717c1c ("xfsdump: intercept bind mount targets")
> +
> +. ./common/preamble
> +_begin_fstest auto dump
> +
> +_cleanup()
> +{
> +	_cleanup_dump

Is this really needed?

> +	cd /
> +	rm -r -f $tmp.*
> +	$UMOUNT_PROG $mntpnt2 2> /dev/null
> +	rmdir $mntpnt1/dir 2> /dev/null
> +	$UMOUNT_PROG $mntpnt1 2> /dev/null
> +	rmdir $mntpnt2 2> /dev/null
> +	rmdir $mntpnt1 2> /dev/null
> +	[ -n "$loopdev" ] && _destroy_loop_device $loopdev
> +	rm -f "$TEST_DIR"/fsfile
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/dump
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +
> +mntpnt1=$TEST_DIR/MNT1
> +mntpnt2=$TEST_DIR/MNT2
> +
> +
> +# Set up
> +$MKFS_XFS_PROG -s size=4096 -b size=4096 \
> +	-dfile,name=$TEST_DIR/fsfile,size=8649728b,sunit=1024,swidth=2048 \
> +	>> $seqres.full 2>&1 || _fail "mkfs failed"

Are "-s size=4096 -b size=4096 -d sunit=1024,swidth=2048" necessary? If so, better
to add comments to explain why they're needed.

> +
> +loopdev=$(_create_loop_device "$TEST_DIR"/fsfile)

Is loopdev necessary? If you need mkfs, can we just use SCRATCH_DEV, and bind $SCRATCH_MNT/someonedir
on $TEST_DIR/someonedir ? E.g:

_cleanup()
{
	$UMOUNT_PROG $TEST_DIR/dest 2> /dev/null
	cd /
	rm -r -f $tmp.*
}

_scratch_mkfs > $seqres.full
_scratch_mount
mkdir $SCRATCH_MNT/src
mkdir $TEST_DIR/dest
$MOUNT_PROG --bind $SCRATCH_MNT/src $TEST_DIR/dest || _fail "Bind mount failed"
$XFSDUMP_PROG -L session -M test -f $tmp.dump $TEST_DIR/dest >> $seqres.full 2>&1 && \
	echo "dump with bind-mounted should be failed, but passed."

echo "Silence is golden"
...

If you don't need mkfs, you can use $TEST_DIR (e.g. $TEST_DIR/src and $TEST_DIR/dest) to
be bind mount source and target. Due to this case just trys to test xfsdump a bind mount,
and make sure dump failed as expected. Am I right?

Thanks,
Zorro

> +
> +mkdir $mntpnt1 >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt1\" failed"
> +
> +_mount $loopdev $mntpnt1
> +mkdir $mntpnt1/dir >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt1/dir\" failed"
> +mkdir $mntpnt2 >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt2\" failed"
> +
> +
> +# Test
> +echo "*** dump with bind-mounted test ***" >> $seqres.full
> +
> +mount -o bind $mntpnt1/dir $mntpnt2
> +
> +$XFSDUMP_PROG -L session -M test -f $tmp.dump $mntpnt2 \
> +	>> $seqres.full 2>&1 && echo "dump with bind-mounted should be failed, but passed."
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/xfs/544.out b/tests/xfs/544.out
> new file mode 100644
> index 00000000..fc7ebff3
> --- /dev/null
> +++ b/tests/xfs/544.out
> @@ -0,0 +1,2 @@
> +QA output created by 544
> +Silence is golden
> -- 
> 2.31.1
> 

