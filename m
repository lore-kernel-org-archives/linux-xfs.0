Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B37C4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 04:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJBE1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 00:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiJBE1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 00:27:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD58532A8F
        for <linux-xfs@vger.kernel.org>; Sat,  1 Oct 2022 21:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664684836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Omy72SFP7rhZ5NcNm+ld6kd+vTb/JXOKGzq1vwsf4Qg=;
        b=Z1QHwMca5VEgaey8WxtKPXzZ0tGgj0hQQQpuPJxrarzpeX3S+cRhZ0rPOkj6Fu9ZCPceAZ
        Bmrcs875cELzwsq4yUq2J0Sd65gOty1Z5ZflHICAH19Yu3RUGC67Mga44VJxLPZOw5Laz3
        Di65NYYz5olSQNroubRl9yf3G7RvD6s=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-BQCNxir7MPKKasoiQrDLVQ-1; Sun, 02 Oct 2022 00:27:14 -0400
X-MC-Unique: BQCNxir7MPKKasoiQrDLVQ-1
Received: by mail-qv1-f69.google.com with SMTP id mz8-20020a0562142d0800b004b18a95b180so250326qvb.8
        for <linux-xfs@vger.kernel.org>; Sat, 01 Oct 2022 21:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Omy72SFP7rhZ5NcNm+ld6kd+vTb/JXOKGzq1vwsf4Qg=;
        b=ltmqAkgHCixhLY7NDr/K9CtFBGqLAVneJ9PDeKmQzzJ4CSERoGPqnDgLP5+MAztCAM
         Ey1KySK1CHlvwYUZKoCxcA1lG+8YYwSZog/6MTRxxuwK6Le6AyUJX/gIEllcc6F7DehB
         mzcPM6SNt+oQGhsUWvQHnaT0VBA9GauvuUEmKeX5/TbMukFXBvyHkgLYlohtt2ss9WWP
         1OYrmxsbit63GjyZtkui1BN456rgZF+M0Wm/OzupxDYrwOnhcy5wAkjAayGlCK+/mHex
         0EMUWr8bSm8FYdaBVbWUGV6w2ts2P8IWRJsVq0/HYqUPBFtVPlfKBIfw3zceWE1mSvsz
         R13Q==
X-Gm-Message-State: ACrzQf0wo6b/DgChTiASBwOjlV7FymWkmZObMOqK+4KuxLMl9fMLEGqA
        BBXzYnAev9g1cXZpVBQ88Tad9LYIQigGH2NiCErs0Xx9RTtc/J5YU228p4uJqjXWkfVKdHwkgxW
        dNF5V6anngM0b196flfOc
X-Received: by 2002:ae9:e206:0:b0:6cb:d54d:69ee with SMTP id c6-20020ae9e206000000b006cbd54d69eemr10822321qkc.466.1664684834070;
        Sat, 01 Oct 2022 21:27:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4CpvHH/v+0OLpuLK7KA3HnODDE02Rt6vyRLN2vzt1SwMuCJxW5+nvtw4t1bm2x8DH5PAF9pQ==
X-Received: by 2002:ae9:e206:0:b0:6cb:d54d:69ee with SMTP id c6-20020ae9e206000000b006cbd54d69eemr10822314qkc.466.1664684833731;
        Sat, 01 Oct 2022 21:27:13 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id he47-20020a05622a602f00b0031ef0081d77sm6057174qtb.79.2022.10.01.21.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 21:27:13 -0700 (PDT)
Date:   Sun, 2 Oct 2022 12:27:08 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Hironori Shiina <shiina.hironori@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: Re: [RFC PATCH] xfs: test for fixing wrong root inode number
Message-ID: <20221002042708.fshgqyqyhidgsx7z@zlang-mailbox>
References: <20220928210337.417054-1-shiina.hironori@fujitsu.com>
 <20220929014955.pxou2qymdumvijtt@zlang-mailbox>
 <eae39d48-1fc1-09dc-7f5e-b1112c880584@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eae39d48-1fc1-09dc-7f5e-b1112c880584@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 30, 2022 at 11:01:51AM -0400, Hironori Shiina wrote:
> 
> 
> On 9/28/22 21:49, Zorro Lang wrote:
> > On Wed, Sep 28, 2022 at 05:03:37PM -0400, Hironori Shiina wrote:
> >> Test '-x' option of xfsrestore. With this option, a wrong root inode
> >> number is corrected. A root inode number can be wrong in a dump created
> >> by problematic xfsdump (v3.1.7 - v3.1.9) with blukstat misuse. This
> >> patch adds a dump with a wrong inode number created by xfsdump 3.1.8.
> >>
> >> Link: https://lore.kernel.org/linux-xfs/20201113125127.966243-1-hsiangkao@redhat.com/
> >> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
> >> ---
> >>  common/dump                    |   2 +-
> >>  src/root-inode-broken-dumpfile | Bin 0 -> 21648 bytes
> >>  tests/xfs/554                  |  37 +++++++++++++++++++++
> >>  tests/xfs/554.out              |  57 +++++++++++++++++++++++++++++++++
> >>  4 files changed, 95 insertions(+), 1 deletion(-)
> >>  create mode 100644 src/root-inode-broken-dumpfile
> >>  create mode 100644 tests/xfs/554
> >>  create mode 100644 tests/xfs/554.out
> >>
> >> diff --git a/common/dump b/common/dump
> >> index 8e0446d9..50b2ba03 100644
> >> --- a/common/dump
> >> +++ b/common/dump
> >> @@ -1003,7 +1003,7 @@ _parse_restore_args()
> >>          --no-check-quota)
> >>              do_quota_check=false
> >>              ;;
> >> -	-K|-R)
> >> +	-K|-R|-x)
> >>  	    restore_args="$restore_args $1"
> >>              ;;
> >>  	*)
> >> diff --git a/src/root-inode-broken-dumpfile b/src/root-inode-broken-dumpfile
> >> new file mode 100644
> >> index 0000000000000000000000000000000000000000..9a42e65d8047497be31f3abbaf4223ae384fd14d
> >> GIT binary patch
> >> literal 21648
> >> zcmeI)K}ge49KiAC_J<CEBr!0AwBf~zbCHB}5DyxL6eU8Jnqylvayj;2VuG+d)TN6;
> >> z5J8vlAaw9hXi(UousT$Sin@BRJfwHM)O+*2*njz_zc+h*ckuV#@BMuKe;;JbgTL{<
> >> z!SwZ9zC#ERe%reLe5&cz2e}qM<!i2dXQHt^{^`d1Qx{)MMzW#$%dR@J={0`IRsGx4
> >> z(yn@Oi-nBqCOVIG?&{kpwnv~&w_>6_ozY1^fph=w8(=^oTg&wOe=(WQByyQ_Hfd|4
> >> z^o76<0!zn#v>k3blbU)nzx=KF^}-G%R;OaQYsHwGDkO`kD^@q^(_Ac_8H<gKj^>a0
> >> z6p*%BK>q#b>2EE%^!@f?Z`-p+tI@M}qmMm@zMJk>K1U^=d~G^NUG?X4vkvKtOf-3Y
> >> zpVM9YgM9Y7{*P0ApJNUh^uk1wCnA6V0tg_000IagfB*srAb<b@2q1s}0tg_000Iag
> >> zfB*srAb<b@2q1s}0tg_000IagfB*srAb<b@2q1s}0tg_000IagfB*srAb`MM1p>_h
> >> z2-R=Q9ooK1{l9<Dy8IIMUVXr9BW9uI1x7};j+kij|5kLI^32no;n|PvqD74ZOlJ#n
> >> z0-~CKSlx#liMS>jt232#==00xPqwp;gsZrjc?`PPxaCE~>3(^o5-%+Nj=HegJFK2b
> >> z=l5zT4IDgO=sJ1zp=jyrALvcQJK|j;sN2_jUmobjN<!S6m1{G<LZ^+JP;T!|3{9)w
> >> eGf&ioo}iw|li2&4IyG;z<}vrl)Mic2`t2{52##q0
> >>
> >> literal 0
> >> HcmV?d00001
> > 
> > Please don't try to add a binary file to fstests directly.
> > 
> >>
> >> diff --git a/tests/xfs/554 b/tests/xfs/554
> >> new file mode 100644
> >> index 00000000..13bc62c7
> >> --- /dev/null
> >> +++ b/tests/xfs/554
> >> @@ -0,0 +1,37 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
> >> +#
> >> +# FS QA Test No. 554
> >> +#
> >> +# Test restoring a dumpfile with a wrong root inode number created by
> >> +# xfsdump 3.1.8.
> >> +# This test restores the checked-in broken dump with '-x' flag.
> >> +#
> >> +
> >> +. ./common/preamble
> >> +_begin_fstest auto quick dump
> >> +
> >> +# Import common functions.
> >> +. ./common/dump
> >> +
> >> +# real QA test starts here
> >> +_supported_fs xfs
> >> +_require_scratch
> > 
> > The -x option is a new feature for xfsdump, not all system support that. So
> > we need to _notrun if test on a system doesn't support it. A separated
> > _require_* helper would be better if there'll be more testing about this
> > new feature. Or a local detection in this case is fine too (can be moved as
> > a common helper later).
> > 
> >> +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> >> +_scratch_mount
> >> +
> >> +# Create dumpdir for comparing with restoredir
> >> +rm -rf $dump_dir
> >> +mkdir $dump_dir || _fail "failed to mkdir $restore_dir"
> >           ^^                                  ^^
> > 
> > Are you trying to create a dump dir or restore dir?
> > 
> >> +touch $dump_dir/FILE_1019
> >> +
> >> +_do_restore_toc -x -f $here/src/root-inode-broken-dumpfile
> > 
> > Why I didn't see how you generate this broken dumpfile in this case?
> > 
> > Oh... I see, you want to store a dumpfile in fstests source code directly.
> > I thought you submited that file accidentally...
> > 
> > No, we don't do things like this way, please try to generate the dumpfile
> > in this test case at first, then restore it. For example using xfs_db to
> > break a xfs, or using some tricky method (likes xfs/545).
> > 
> 
> Thank you for the comments. I will try another approach. I'm having
> trouble creating a dumpfile for this test. Because xfsdump was already
> fixed, xfsdump no longer generates a corrupted dumpfile even if there is
> a lower inode number than a root inode.

Oh, I see. You can try, but I think it's hard. It maybe not suitable to be a
fstests case, if it has to depend on a binary fs dump file. If so, We can cover
it on other place, with this existed "bad" dump file.

Thanks,
Zorro

> 
> >> +
> >> +_do_restore_file -x -f $here/src/root-inode-broken-dumpfile -L stress_545
> >> +_diff_compare_sub
> >> +_ls_nodate_compare_sub
> >> +
> >> +# success, all done
> >> +status=0
> >> +exit
> >> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> >> new file mode 100644
> >> index 00000000..40a3f3a4
> >> --- /dev/null
> >> +++ b/tests/xfs/554.out
> >> @@ -0,0 +1,57 @@
> >> +QA output created by 554
> >> +Contents of dump ...
> >> +xfsrestore  -x -f DUMP_FILE -t
> >> +xfsrestore: using file dump (drive_simple) strategy
> >> +xfsrestore: searching media for dump
> >> +xfsrestore: examining media file 0
> >> +xfsrestore: dump description: 
> >> +xfsrestore: hostname: xfsdump
> >> +xfsrestore: mount point: SCRATCH_MNT
> >> +xfsrestore: volume: SCRATCH_DEV
> >> +xfsrestore: session time: TIME
> >> +xfsrestore: level: 0
> >> +xfsrestore: session label: "stress_545"
> >> +xfsrestore: media label: "stress_tape_media"
> >> +xfsrestore: file system ID: ID
> >> +xfsrestore: session id: ID
> >> +xfsrestore: media ID: ID
> >> +xfsrestore: searching media for directory dump
> >> +xfsrestore: reading directories
> >> +xfsrestore: found fake rootino #128, will fix.
> >> +xfsrestore: fix root # to 1024 (bind mount?)
> >> +xfsrestore: 2 directories and 2 entries processed
> >> +xfsrestore: directory post-processing
> >> +xfsrestore: reading non-directory files
> >> +xfsrestore: table of contents display complete: SECS seconds elapsed
> >> +xfsrestore: Restore Status: SUCCESS
> >> +
> >> +dumpdir/FILE_1019
> >> +Restoring from file...
> >> +xfsrestore  -x -f DUMP_FILE  -L stress_545 RESTORE_DIR
> >> +xfsrestore: using file dump (drive_simple) strategy
> >> +xfsrestore: searching media for dump
> >> +xfsrestore: examining media file 0
> >> +xfsrestore: found dump matching specified label:
> >> +xfsrestore: hostname: xfsdump
> >> +xfsrestore: mount point: SCRATCH_MNT
> >> +xfsrestore: volume: SCRATCH_DEV
> >> +xfsrestore: session time: TIME
> >> +xfsrestore: level: 0
> >> +xfsrestore: session label: "stress_545"
> >> +xfsrestore: media label: "stress_tape_media"
> >> +xfsrestore: file system ID: ID
> >> +xfsrestore: session id: ID
> >> +xfsrestore: media ID: ID
> >> +xfsrestore: searching media for directory dump
> >> +xfsrestore: reading directories
> >> +xfsrestore: found fake rootino #128, will fix.
> >> +xfsrestore: fix root # to 1024 (bind mount?)
> >> +xfsrestore: 2 directories and 2 entries processed
> >> +xfsrestore: directory post-processing
> >> +xfsrestore: restoring non-directory files
> >> +xfsrestore: restore complete: SECS seconds elapsed
> >> +xfsrestore: Restore Status: SUCCESS
> >> +Comparing dump directory with restore directory
> >> +Files DUMP_DIR/FILE_1019 and RESTORE_DIR/DUMP_SUBDIR/FILE_1019 are identical
> >> +Comparing listing of dump directory with restore directory
> >> +Files TMP.dump_dir and TMP.restore_dir are identical
> >> -- 
> >> 2.37.3
> >>
> > 
> 

