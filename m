Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB56C54EE9
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Sep 2022 00:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiIDA4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Sep 2022 20:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDA4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Sep 2022 20:56:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03A54F64E
        for <linux-xfs@vger.kernel.org>; Sat,  3 Sep 2022 17:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662252959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JKteUWJAnNlpz67AZtKPmNwx71mbuFs8qZIp3HgLTeM=;
        b=PUBd9V/72YCElC3sATa79l1i1h4+AcUN4+waX31EHZBxOKVhjUe32SnJJZkl4JyohSobF/
        wtTJ3UGQxwLC0EZR3n7PsSyN40Xi6PQjA8Uofz68pTmlaTPcaoxk/E0LJxyD3RdZQngJGL
        aufkc4DW5S60cvY0Sw9sHSVaH26HlEg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-385-M9yrV9URNy2YTGylxXb4HA-1; Sat, 03 Sep 2022 20:55:57 -0400
X-MC-Unique: M9yrV9URNy2YTGylxXb4HA-1
Received: by mail-qk1-f199.google.com with SMTP id br15-20020a05620a460f00b006bc58c26501so4772989qkb.0
        for <linux-xfs@vger.kernel.org>; Sat, 03 Sep 2022 17:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=JKteUWJAnNlpz67AZtKPmNwx71mbuFs8qZIp3HgLTeM=;
        b=5CuT/V1BgeOD8PVDgeNMKx9qY+w9s9j8X07lOeDHRD9J7vD1shkiDg3BoAf4pYk6L9
         UWlhj7HZ5CKQHKRXwnkrzOaRODbbNv8iTZ0WqYrA+Afc4p8X07aGbHIFDa5WqvwwDlkx
         PX73HdcIyjLT/cdf9xGZF4RHYqzNWBUmWhXV13IFioure22cfj4Sexb8x9Tvm7uV+081
         ASspWwRc02hbKvHrgszHW9BN2LduseuxqkFQ9SjjUPUbW4kAhNhcGZZyDoPlVEjrx+l/
         XUenQwY9bW69KlNk+k6xYjp+51uN+UqUf6qrIEFyoGriaa7/MHTvGavrwHwHTQis1IIp
         JnQw==
X-Gm-Message-State: ACgBeo3sy+ozVK5Ttmm9kG5DIL2poxjCh13ZFu1sRBVbkbmJ+TKMU2TL
        0P422NHPCj1uaScoDWHvD+nfcgGLqWgTlCwy5bPC7pV7E+tpqx3GJZvFbfZ5m5g4kWx9DvGamE8
        ny7RFAJNICf93opDW0GCk
X-Received: by 2002:a05:622a:24a:b0:343:75d6:ad0a with SMTP id c10-20020a05622a024a00b0034375d6ad0amr34494859qtx.564.1662252956454;
        Sat, 03 Sep 2022 17:55:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5TDseCe887CWAXMwI0TIM0VIvi48wpMfitI++rqCqkIwUhwZmzh1BCcoYEjgVkGhTgOBT3Yw==
X-Received: by 2002:a05:622a:24a:b0:343:75d6:ad0a with SMTP id c10-20020a05622a024a00b0034375d6ad0amr34494851qtx.564.1662252956096;
        Sat, 03 Sep 2022 17:55:56 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m66-20020a375845000000b006b999c1030bsm4725499qkb.52.2022.09.03.17.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 17:55:55 -0700 (PDT)
Date:   Sun, 4 Sep 2022 08:55:49 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     fstests@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH fstests] xfs/554: xfs add illegal bestfree array size
 inject for leaf dir
Message-ID: <20220904005549.c3dzjutog724wykg@zlang-mailbox>
References: <20220902094046.3891252-1-guoxuenan@huawei.com>
 <20220903013921.wbmwkf6rs2iknqn6@zlang-mailbox>
 <e51811d6-be83-47ee-c4bb-7dc18f97df97@huawei.com>
 <20220903095755.ftrecvbfkt6drdwc@zlang-mailbox>
 <bdb78b9c-9e43-9eb5-1e26-0e33596c1420@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdb78b9c-9e43-9eb5-1e26-0e33596c1420@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 03, 2022 at 07:12:54PM +0800, Guo Xuenan wrote:
> Hi Zorro:
> 
> On 2022/9/3 17:57, Zorro Lang wrote:
> > On Sat, Sep 03, 2022 at 11:51:13AM +0800, Guo Xuenan wrote:
> > > Hi Zorro：
> > > 
> > > On 2022/9/3 9:39, Zorro Lang wrote:
> > > > On Fri, Sep 02, 2022 at 05:40:46PM +0800, Guo Xuenan wrote:
> > > > > Test leaf dir allocting new block when bestfree array size
> > > > > less than data blocks count, which may lead to UAF.
> > > > > 
> > > > > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> > > > > ---
> > > > >    tests/xfs/554     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
> > > > >    tests/xfs/554.out |  6 ++++++
> > > > >    2 files changed, 54 insertions(+)
> > > > >    create mode 100755 tests/xfs/554
> > > > >    create mode 100644 tests/xfs/554.out
> > > > > 
> > > > > diff --git a/tests/xfs/554 b/tests/xfs/554
> > > > > new file mode 100755
> > > > > index 00000000..fcf45731
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/554
> > > > > @@ -0,0 +1,48 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > +# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test No. 554
> > > > > +#
> > > > > +# Test leaf dir bestfree array size match with dir disk size
> > > > Is it for a known bug? known commit id?
> > > The bug is being solved and waitting to be reviewed here[v1/v2].
> > > [v1]
> > > https://lore.kernel.org/all/20220902094046.3891252-1-guoxuenan@huawei.com/
> > > [v2]
> > > https://lore.kernel.org/all/20220831121639.3060527-1-guoxuenan@huawei.com/
> > > > > +#
> > > > > +. ./common/preamble
> > > > > +_begin_fstest auto quick
> > > > > +
> > > > > +# Import common functions.
> > > > > +. ./common/populate
> > > > > +
> > > > > +# real QA test starts here
> > > > > +_supported_fs xfs
> > > > > +_require_scratch
> > > > Do you need V5 xfs? Or v4 is fine?
> > > > _require_scratch_xfs_crc ??
> Both v4 and v5 have this problem,

OK, that's fine if you can reproduce this bug on both.

> > > > > +_require_check_dmesg
> > > > > +
> > > > > +echo "Format and mount"
> > > > > +_scratch_mkfs > $seqres.full 2>&1
> > > > > +_scratch_mount  >> $seqres.full 2>&1
> > If _scratch_mount fails, the testing will exit directly, so generally we just
> > run _scratch_mount.
> OK, you are right.
> > > > > +
> > > > > +echo "Create and check leaf dir"
> > > > > +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > > +dblksz="$($XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > Why do you need these two kinds of block size for xfs? And you sometimes
> > > > use the former, sometimes use the later? If you'd like to get the xfs data
> > > > block size, you can:
> > > > 
> > > >     _scratch_mkfs | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
> > > >     . $tmp.mkfs
> > > > 
> > > > Then "dbsize" is what you want.
> > > > 
> > > > > +leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > +node_lblk="$((64 * 1073741824 / blksz))"
> > > > I didn't see the "node_lblk" is used in this case, looks like you don't want to
> > > > get directory node blocks in this case.
> > > It's really needed here, must define leaf_lblk and node_lblk before calling
> > > __populate_check_xfs_dir
> > > or an waring will be printed by the function.
> > Oh, so these two global parameters are used for later __populate_check_xfs_dir.
> > Hmm.. are "blksz" and "dblksz" necessary too, for someone __populate_* helper
> > you used? I really don't understand why we need them both. These helpers are
> > written by Darrick, I think he learns about that more :)
> yes, there are same usage for eg. xfs/113 xfs/101 ...

OK, cc Darrick to ask why we need both dblksz and blksz at here?

> > > > > +__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dblksz / 12))"
> > > > > +leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
> > > > > +_scratch_unmount
> > > > > +__populate_check_xfs_dir "${leaf_dir}" "leaf"
> > > > > +
> > > > > +echo "Inject bad bestfress array size"
> > > > > +_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock 8388608" -c "write ltail.bestcount 0"
> > > > As you tried to detect xfs block size above, so it might not 4k block size, so
> > > > 8388608 is not fixed.
> > > > 
> > > > According to the kernel definition:
> > > >     #define XFS_DIR2_DATA_ALIGN_LOG 3
> > > >     #define XFS_DIR2_SPACE_SIZE     (1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
> > > >     #define XFS_DIR2_LEAF_SPACE     1
> > > >     #define XFS_DIR2_LEAF_OFFSET    (XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
> > > > 
> > > > The XFS_DIR2_LEAF_OFFSET = 1 * (1 << (32 + 3)) = 1<<35 = 34359738368 = 32GB, so
> > > > the fixed logical offset of leaf extent is 34359738368 bytes, then the offset
> > > > block number should be "34359738368 / dbsize". 8388608 is only for 4k block
> > > > size.
> > > Sorry, you are totally right! it should be "dblock ${leaf_lblk}"
> > That looks better.
> > 
> > > > > +
> > > > > +echo "Test add entry to dir"
> > > > > +_scratch_mount
> > > > > +touch ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/{1..100}.txt > /dev/null 2>&1
> > > > > +_scratch_unmount 2>&1
> > This "2>&1" looks useless, I think it can be removed
> OK, in v2 it will disappear :）
> > > > > +_repair_scratch_fs >> $seqres.full 2>&1
> > > > Can you explain more about this testing steps? The xfs has been corrupted, then
> > > > we expect is can be mounted. And create 100 new files on that corrupted dir,
> > > > do you expect the 100 files can be created successfully? Or what ever, even
> > > > nothing be created?
> > > since we have create an leaf dir,and set bestfree count to 0; then, need to
> > > touch some files to
> > > trigger the problem, the action will be failed as expected.
> > OK, I think you can add more comments to explain this part. Due to you make
> > a obvious corruption at first, then try to mount and write the corrupted fs,
> > there must be some error happen, so you'd better to explain what do you
> > expect, and what's not.
> Thanks a lot, and I'm happliy accept your suggestion, It's really a bit
> confusing here,
> I will add some specific description
> > > > What's the xfs_repair expect? Fix all curruption and left a clean xfs?
> > > Adding repair is really not necessary, only toavoid _check_xfs_filesystem
> > > warning
> > > " _check_xfs_filesystem: filesystem on /dev/sdb is inconsistent (r)"
> > Except you'd like to verify if xfs_repair can fix this corruption. Or replace
> > _require_scatch with _require_scratch_nocheck, that will help you avoid known
> > fs corruption warning. Then you can remove _repair_scratch_fs and above
> > _scratch_unmount.
> Yep, you got my point, since it's my fisrt contribution code for fstests,
> and
> I didn't figure out how to disable the post fsck execution. so great, I will
> add _require_scratch_nocheck.

Sure, welcome more patches from you :)

> > > > > +
> > > > > +# check demsg error
> > > > > +_check_dmesg
> > > > Which above step will trigger a dmesg you want to check? What kind of dmesg do
> > > dmesg eg:
> > > [   80.543884] XFS (sdb): Internal error xfs_dir2_data_use_free at line 1200
> > > of file fs/xfs/libxfs/xfs_dir2_data.c.  Caller
> > > xfs_dir2_data_use_free+0xb3/0xeb0
> > > [   80.545141] CPU: 2 PID: 2978 Comm: touch Not tainted 6.0.0-rc3+ #115
> > > [   80.545715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > > 1.13.0-1ubuntu1.1 04/01/2014
> > > [   80.546546] Call Trace:
> > > [   80.546785]  <TASK>
> > > [   80.546985]  dump_stack_lvl+0x4d/0x66
> > > [   80.547335] xfs_corruption_error+0x132/0x150
> > > [   80.548391]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> > > [   80.548901]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> > > [   80.549319]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> > > [   80.550190] xfs_dir2_data_use_free+0x198/0xeb0
> > > [   80.550718]  ? xfs_dir2_data_use_free+0xb3/0xeb0
> > > [   80.551140] xfs_dir2_leaf_addname+0xa59/0x1ac0
> > > [   80.551881]  ? _raw_spin_unlock_irqrestore+0x42/0x80
> > > [   80.552403]  ? xfs_dir2_leaf_search_hash+0x300/0x300
> > > or
> > > [  201.405239] BUG: KASAN: slab-out-of-bounds in
> > > xfs_dir2_leaf_addname+0x1995/0x1ac0
> > > [  201.406179] Write of size 2 at addr ffff888078c33000 by task touch/7433
> > > [  201.407010]
> > > [  201.407217] CPU: 6 PID: 7433 Comm: touch Not tainted 6.0.0-rc3+ #115
> > > [  201.408016] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > > 1.13.0-1ubuntu1.1 04/01/2014
> > > [  201.409143] Call Trace:
> > > [  201.409461]  <TASK>
> > > [  201.409740]  dump_stack_lvl+0x4d/0x66
> > > [  201.410214]  print_report.cold+0xf6/0x691
> > > [  201.410730]  ? xfs_dir3_data_init+0x18e/0x960
> > > 
> > > UAF/slab-out-of bound etc...
> > Look at the _check_dmesg, it checks "Internal error" and "\bBUG:" etc, so I
> > think it can catch above dmesg error, you can remove this _check_dmesg and
> > run again, to make sure if it works as you wish.
> OK, I will check it again.
> > > > you want to check? I think xfstests checks dmesg at the end of each test case,
> > > > except you need to check some special one, or need a special filter?
> > > check demsg without filter seems enough, so i did not add special filter.
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > +
> > > > > +# success, all done
> > > > > +status=0
> > > > > +exit
> > > > > diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> > > > > new file mode 100644
> > > > > index 00000000..ea1f30cc
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/554.out
> > > > > @@ -0,0 +1,6 @@
> > > > > +QA output created by 554
> > > > > +Format and mount
> > > > > +Create and check leaf dir
> > > > > +Inject bad bestfress array size
> > > > > +ltail.bestcount = 0
> > > > > +Test add entry to dir
> > > > > -- 
> > > > > 2.25.1
> > > > > 
> > > > .
> > .
> Thanks
> Xuenan
> 

