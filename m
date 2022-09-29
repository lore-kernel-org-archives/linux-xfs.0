Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64D8C32771
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Sep 2022 01:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbiI2Bu7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiI2Buc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 21:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AADF696D6
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 18:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664416202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0WmcH1WUECid4Wrx9gAxCwvjbzsgBfUhNTIMrFn9pAQ=;
        b=edIw/kunHgUDR5VItCia7h3bXrEmxJp7Pdq9YXlKL+peNI+HBoRGKglB3XkiZotctRddQ1
        TrkstfrX1mZOezN96ZCcGEI1kiuXbalyIhZrP2GFFsXOoO9hgarnb5uw27ebKNk3dJOkMW
        dlmhV+Do55BEi5SGqZT9dXPRdVwM+c4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-205-oSsSanHuNIKLVLD7qSwn0A-1; Wed, 28 Sep 2022 21:50:01 -0400
X-MC-Unique: oSsSanHuNIKLVLD7qSwn0A-1
Received: by mail-pg1-f199.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso115701pgk.18
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 18:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=0WmcH1WUECid4Wrx9gAxCwvjbzsgBfUhNTIMrFn9pAQ=;
        b=LR1vFxJp0I/nbQd4gdv2m5MtD6+Vq3cLpu3OSWzC6QLwRMt3JIs0NmVnbFAA3xMqxO
         Roms4atM+s2iI/chei5L4KH4/gnPyEgJsg6E3rSBxVGSgfTgj0bPefuE/kFu/0A63ojn
         ALBkSfpwS6l05B+nirRIB7zDaJ4AQ/mWfnvNQh2ZM6432tTW7FJEDzcY8m85gxPy2xLg
         Q1A+oiuE4kHaMjRH/xmwQBQBX/Glghu0PQikpvtAdjivFfGHViSKYJO4r1WcvJFxyiz+
         C3SMFOAeMgiNgRlDmdYF1XF74lqLh3zSxRXIfoMO60fz6/EGWHWmPca4AR4t79jG//eh
         Dmuw==
X-Gm-Message-State: ACrzQf1+I0lJtz4Lt4zQ3oKKp5QbRcxAAbHAa7hGlIbFLZgN6W5urQZZ
        1hR4+CrexdWZ2AFgBE2IzRX4wVqU2+LkLn831hCHZWVOQXVcFYnBtnbXfIjfmrJRCTxtbawlHRa
        V42jsuCRwkUUCg/RNCcA1
X-Received: by 2002:a63:5fd3:0:b0:440:4706:2239 with SMTP id t202-20020a635fd3000000b0044047062239mr93065pgb.605.1664416200249;
        Wed, 28 Sep 2022 18:50:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4cVC/sIy1bhG6cyIt+bYiJgX96GGKpYf/fczqBVc3N/hcsj8seL+PgIoYtMSVS/qD4hv7p4w==
X-Received: by 2002:a63:5fd3:0:b0:440:4706:2239 with SMTP id t202-20020a635fd3000000b0044047062239mr93047pgb.605.1664416199912;
        Wed, 28 Sep 2022 18:49:59 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u23-20020a1709026e1700b00176a579fae8sm2282084plk.210.2022.09.28.18.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 18:49:59 -0700 (PDT)
Date:   Thu, 29 Sep 2022 09:49:55 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [RFC PATCH] xfs: test for fixing wrong root inode number
Message-ID: <20220929014955.pxou2qymdumvijtt@zlang-mailbox>
References: <20220928210337.417054-1-shiina.hironori@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928210337.417054-1-shiina.hironori@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 28, 2022 at 05:03:37PM -0400, Hironori Shiina wrote:
> Test '-x' option of xfsrestore. With this option, a wrong root inode
> number is corrected. A root inode number can be wrong in a dump created
> by problematic xfsdump (v3.1.7 - v3.1.9) with blukstat misuse. This
> patch adds a dump with a wrong inode number created by xfsdump 3.1.8.
> 
> Link: https://lore.kernel.org/linux-xfs/20201113125127.966243-1-hsiangkao@redhat.com/
> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
> ---
>  common/dump                    |   2 +-
>  src/root-inode-broken-dumpfile | Bin 0 -> 21648 bytes
>  tests/xfs/554                  |  37 +++++++++++++++++++++
>  tests/xfs/554.out              |  57 +++++++++++++++++++++++++++++++++
>  4 files changed, 95 insertions(+), 1 deletion(-)
>  create mode 100644 src/root-inode-broken-dumpfile
>  create mode 100644 tests/xfs/554
>  create mode 100644 tests/xfs/554.out
> 
> diff --git a/common/dump b/common/dump
> index 8e0446d9..50b2ba03 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -1003,7 +1003,7 @@ _parse_restore_args()
>          --no-check-quota)
>              do_quota_check=false
>              ;;
> -	-K|-R)
> +	-K|-R|-x)
>  	    restore_args="$restore_args $1"
>              ;;
>  	*)
> diff --git a/src/root-inode-broken-dumpfile b/src/root-inode-broken-dumpfile
> new file mode 100644
> index 0000000000000000000000000000000000000000..9a42e65d8047497be31f3abbaf4223ae384fd14d
> GIT binary patch
> literal 21648
> zcmeI)K}ge49KiAC_J<CEBr!0AwBf~zbCHB}5DyxL6eU8Jnqylvayj;2VuG+d)TN6;
> z5J8vlAaw9hXi(UousT$Sin@BRJfwHM)O+*2*njz_zc+h*ckuV#@BMuKe;;JbgTL{<
> z!SwZ9zC#ERe%reLe5&cz2e}qM<!i2dXQHt^{^`d1Qx{)MMzW#$%dR@J={0`IRsGx4
> z(yn@Oi-nBqCOVIG?&{kpwnv~&w_>6_ozY1^fph=w8(=^oTg&wOe=(WQByyQ_Hfd|4
> z^o76<0!zn#v>k3blbU)nzx=KF^}-G%R;OaQYsHwGDkO`kD^@q^(_Ac_8H<gKj^>a0
> z6p*%BK>q#b>2EE%^!@f?Z`-p+tI@M}qmMm@zMJk>K1U^=d~G^NUG?X4vkvKtOf-3Y
> zpVM9YgM9Y7{*P0ApJNUh^uk1wCnA6V0tg_000IagfB*srAb<b@2q1s}0tg_000Iag
> zfB*srAb<b@2q1s}0tg_000IagfB*srAb<b@2q1s}0tg_000IagfB*srAb`MM1p>_h
> z2-R=Q9ooK1{l9<Dy8IIMUVXr9BW9uI1x7};j+kij|5kLI^32no;n|PvqD74ZOlJ#n
> z0-~CKSlx#liMS>jt232#==00xPqwp;gsZrjc?`PPxaCE~>3(^o5-%+Nj=HegJFK2b
> z=l5zT4IDgO=sJ1zp=jyrALvcQJK|j;sN2_jUmobjN<!S6m1{G<LZ^+JP;T!|3{9)w
> eGf&ioo}iw|li2&4IyG;z<}vrl)Mic2`t2{52##q0
> 
> literal 0
> HcmV?d00001

Please don't try to add a binary file to fstests directly.

> 
> diff --git a/tests/xfs/554 b/tests/xfs/554
> new file mode 100644
> index 00000000..13bc62c7
> --- /dev/null
> +++ b/tests/xfs/554
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
> +#
> +# FS QA Test No. 554
> +#
> +# Test restoring a dumpfile with a wrong root inode number created by
> +# xfsdump 3.1.8.
> +# This test restores the checked-in broken dump with '-x' flag.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick dump
> +
> +# Import common functions.
> +. ./common/dump
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch

The -x option is a new feature for xfsdump, not all system support that. So
we need to _notrun if test on a system doesn't support it. A separated
_require_* helper would be better if there'll be more testing about this
new feature. Or a local detection in this case is fine too (can be moved as
a common helper later).

> +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +_scratch_mount
> +
> +# Create dumpdir for comparing with restoredir
> +rm -rf $dump_dir
> +mkdir $dump_dir || _fail "failed to mkdir $restore_dir"
          ^^                                  ^^

Are you trying to create a dump dir or restore dir?

> +touch $dump_dir/FILE_1019
> +
> +_do_restore_toc -x -f $here/src/root-inode-broken-dumpfile

Why I didn't see how you generate this broken dumpfile in this case?

Oh... I see, you want to store a dumpfile in fstests source code directly.
I thought you submited that file accidentally...

No, we don't do things like this way, please try to generate the dumpfile
in this test case at first, then restore it. For example using xfs_db to
break a xfs, or using some tricky method (likes xfs/545).

> +
> +_do_restore_file -x -f $here/src/root-inode-broken-dumpfile -L stress_545
> +_diff_compare_sub
> +_ls_nodate_compare_sub
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> new file mode 100644
> index 00000000..40a3f3a4
> --- /dev/null
> +++ b/tests/xfs/554.out
> @@ -0,0 +1,57 @@
> +QA output created by 554
> +Contents of dump ...
> +xfsrestore  -x -f DUMP_FILE -t
> +xfsrestore: using file dump (drive_simple) strategy
> +xfsrestore: searching media for dump
> +xfsrestore: examining media file 0
> +xfsrestore: dump description: 
> +xfsrestore: hostname: xfsdump
> +xfsrestore: mount point: SCRATCH_MNT
> +xfsrestore: volume: SCRATCH_DEV
> +xfsrestore: session time: TIME
> +xfsrestore: level: 0
> +xfsrestore: session label: "stress_545"
> +xfsrestore: media label: "stress_tape_media"
> +xfsrestore: file system ID: ID
> +xfsrestore: session id: ID
> +xfsrestore: media ID: ID
> +xfsrestore: searching media for directory dump
> +xfsrestore: reading directories
> +xfsrestore: found fake rootino #128, will fix.
> +xfsrestore: fix root # to 1024 (bind mount?)
> +xfsrestore: 2 directories and 2 entries processed
> +xfsrestore: directory post-processing
> +xfsrestore: reading non-directory files
> +xfsrestore: table of contents display complete: SECS seconds elapsed
> +xfsrestore: Restore Status: SUCCESS
> +
> +dumpdir/FILE_1019
> +Restoring from file...
> +xfsrestore  -x -f DUMP_FILE  -L stress_545 RESTORE_DIR
> +xfsrestore: using file dump (drive_simple) strategy
> +xfsrestore: searching media for dump
> +xfsrestore: examining media file 0
> +xfsrestore: found dump matching specified label:
> +xfsrestore: hostname: xfsdump
> +xfsrestore: mount point: SCRATCH_MNT
> +xfsrestore: volume: SCRATCH_DEV
> +xfsrestore: session time: TIME
> +xfsrestore: level: 0
> +xfsrestore: session label: "stress_545"
> +xfsrestore: media label: "stress_tape_media"
> +xfsrestore: file system ID: ID
> +xfsrestore: session id: ID
> +xfsrestore: media ID: ID
> +xfsrestore: searching media for directory dump
> +xfsrestore: reading directories
> +xfsrestore: found fake rootino #128, will fix.
> +xfsrestore: fix root # to 1024 (bind mount?)
> +xfsrestore: 2 directories and 2 entries processed
> +xfsrestore: directory post-processing
> +xfsrestore: restoring non-directory files
> +xfsrestore: restore complete: SECS seconds elapsed
> +xfsrestore: Restore Status: SUCCESS
> +Comparing dump directory with restore directory
> +Files DUMP_DIR/FILE_1019 and RESTORE_DIR/DUMP_SUBDIR/FILE_1019 are identical
> +Comparing listing of dump directory with restore directory
> +Files TMP.dump_dir and TMP.restore_dir are identical
> -- 
> 2.37.3
> 

