Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F315C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Sep 2022 15:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiI3PDL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Sep 2022 11:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiI3PCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2022 11:02:49 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D4A15656E;
        Fri, 30 Sep 2022 08:01:54 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id i3so2959383qkl.3;
        Fri, 30 Sep 2022 08:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=vlZp+sJTGgxXgbpOtriiTjICX8tN3/EKzrlGeSIrUqU=;
        b=ZjgSM1QnJuOjPOMSkwtFWItFJJVTybe0eqndCtUks4ANDRhjFDXCZF64O10RBpp6pU
         nm1u31di4S/9F5lPdaCsbD++InQwjATyRNnzR2YxEcrYfaShgBvSZSsIc7T9IcB+wyd0
         QyKAJHeIrY9bFl+AYhZATufMTEcRm5gYIdyKkXwahGfJk7Za5HrAYlB2REy2kMyRRgM2
         5eTdNllkvf260ZMYVk+qewsYWVzVFiG3lxzJyW5ZpPDzlhli2AMHaHmFkgIb/5t2+l4D
         6MdhtYA9LQPLLgSn40TDQjKnQtZxBRPKpyPhyGMTsJRzOtKpMgOIflHSF+AEIAOuE7dS
         QxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vlZp+sJTGgxXgbpOtriiTjICX8tN3/EKzrlGeSIrUqU=;
        b=mgbV9RFDBtpumYFC0HgHJIP/HeMCGHkRJKHv+aB9oeRFyBzZ9GbWwJSaqyydJauxxy
         c98OcTgoMET32NBWZ79veIQI6/roY5XYV2xtNNflEuJf8335kfKrmiu3wYIoVcAI95qh
         znIVPlSvMoxC22jaam2IrB4C2Ics98VvuzhUMxPmY3/754KDJVPCkVxu2ucMkB621ig6
         PM0AYeufo5O6qy6RudnKJJdSQUp30INQjYrk7xKERZTaXyTDI7dM6pvCgFDr0swrrQBt
         6qSTTiQMsgV1/U38IqUnLcWL8A7J6WUvIX6v7lZmIU+mgZ/w7y9qzALPy5nKrN+vIEQz
         M8aQ==
X-Gm-Message-State: ACrzQf1H+ly0Pa26OZFq2H3VzG+3f6AgML46lBhx5XhJtXkZUkltkGat
        hdN3cTAv48G8Ln7maB6shv+crKTiFxAN8m0f
X-Google-Smtp-Source: AMsMyM6q6sJqlINPf+PEOYBOta7ZVGGoh2DqnUvBoJLBCoBWfhTlavY9RxQWBmFr1WCnMNn+yH+W9g==
X-Received: by 2002:a05:620a:1a89:b0:6ce:5176:ce95 with SMTP id bl9-20020a05620a1a8900b006ce5176ce95mr6217662qkb.128.1664550113294;
        Fri, 30 Sep 2022 08:01:53 -0700 (PDT)
Received: from ?IPV6:2601:18f:801:e210:abfc:537a:d62c:c353? ([2601:18f:801:e210:abfc:537a:d62c:c353])
        by smtp.gmail.com with ESMTPSA id c26-20020ac8519a000000b0035d4344a389sm2049730qtn.94.2022.09.30.08.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 08:01:52 -0700 (PDT)
Message-ID: <eae39d48-1fc1-09dc-7f5e-b1112c880584@gmail.com>
Date:   Fri, 30 Sep 2022 11:01:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH] xfs: test for fixing wrong root inode number
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Hironori Shiina <shiina.hironori@fujitsu.com>
References: <20220928210337.417054-1-shiina.hironori@fujitsu.com>
 <20220929014955.pxou2qymdumvijtt@zlang-mailbox>
Content-Language: en-US
From:   Hironori Shiina <shiina.hironori@gmail.com>
In-Reply-To: <20220929014955.pxou2qymdumvijtt@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/28/22 21:49, Zorro Lang wrote:
> On Wed, Sep 28, 2022 at 05:03:37PM -0400, Hironori Shiina wrote:
>> Test '-x' option of xfsrestore. With this option, a wrong root inode
>> number is corrected. A root inode number can be wrong in a dump created
>> by problematic xfsdump (v3.1.7 - v3.1.9) with blukstat misuse. This
>> patch adds a dump with a wrong inode number created by xfsdump 3.1.8.
>>
>> Link: https://lore.kernel.org/linux-xfs/20201113125127.966243-1-hsiangkao@redhat.com/
>> Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
>> ---
>>  common/dump                    |   2 +-
>>  src/root-inode-broken-dumpfile | Bin 0 -> 21648 bytes
>>  tests/xfs/554                  |  37 +++++++++++++++++++++
>>  tests/xfs/554.out              |  57 +++++++++++++++++++++++++++++++++
>>  4 files changed, 95 insertions(+), 1 deletion(-)
>>  create mode 100644 src/root-inode-broken-dumpfile
>>  create mode 100644 tests/xfs/554
>>  create mode 100644 tests/xfs/554.out
>>
>> diff --git a/common/dump b/common/dump
>> index 8e0446d9..50b2ba03 100644
>> --- a/common/dump
>> +++ b/common/dump
>> @@ -1003,7 +1003,7 @@ _parse_restore_args()
>>          --no-check-quota)
>>              do_quota_check=false
>>              ;;
>> -	-K|-R)
>> +	-K|-R|-x)
>>  	    restore_args="$restore_args $1"
>>              ;;
>>  	*)
>> diff --git a/src/root-inode-broken-dumpfile b/src/root-inode-broken-dumpfile
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..9a42e65d8047497be31f3abbaf4223ae384fd14d
>> GIT binary patch
>> literal 21648
>> zcmeI)K}ge49KiAC_J<CEBr!0AwBf~zbCHB}5DyxL6eU8Jnqylvayj;2VuG+d)TN6;
>> z5J8vlAaw9hXi(UousT$Sin@BRJfwHM)O+*2*njz_zc+h*ckuV#@BMuKe;;JbgTL{<
>> z!SwZ9zC#ERe%reLe5&cz2e}qM<!i2dXQHt^{^`d1Qx{)MMzW#$%dR@J={0`IRsGx4
>> z(yn@Oi-nBqCOVIG?&{kpwnv~&w_>6_ozY1^fph=w8(=^oTg&wOe=(WQByyQ_Hfd|4
>> z^o76<0!zn#v>k3blbU)nzx=KF^}-G%R;OaQYsHwGDkO`kD^@q^(_Ac_8H<gKj^>a0
>> z6p*%BK>q#b>2EE%^!@f?Z`-p+tI@M}qmMm@zMJk>K1U^=d~G^NUG?X4vkvKtOf-3Y
>> zpVM9YgM9Y7{*P0ApJNUh^uk1wCnA6V0tg_000IagfB*srAb<b@2q1s}0tg_000Iag
>> zfB*srAb<b@2q1s}0tg_000IagfB*srAb<b@2q1s}0tg_000IagfB*srAb`MM1p>_h
>> z2-R=Q9ooK1{l9<Dy8IIMUVXr9BW9uI1x7};j+kij|5kLI^32no;n|PvqD74ZOlJ#n
>> z0-~CKSlx#liMS>jt232#==00xPqwp;gsZrjc?`PPxaCE~>3(^o5-%+Nj=HegJFK2b
>> z=l5zT4IDgO=sJ1zp=jyrALvcQJK|j;sN2_jUmobjN<!S6m1{G<LZ^+JP;T!|3{9)w
>> eGf&ioo}iw|li2&4IyG;z<}vrl)Mic2`t2{52##q0
>>
>> literal 0
>> HcmV?d00001
> 
> Please don't try to add a binary file to fstests directly.
> 
>>
>> diff --git a/tests/xfs/554 b/tests/xfs/554
>> new file mode 100644
>> index 00000000..13bc62c7
>> --- /dev/null
>> +++ b/tests/xfs/554
>> @@ -0,0 +1,37 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
>> +#
>> +# FS QA Test No. 554
>> +#
>> +# Test restoring a dumpfile with a wrong root inode number created by
>> +# xfsdump 3.1.8.
>> +# This test restores the checked-in broken dump with '-x' flag.
>> +#
>> +
>> +. ./common/preamble
>> +_begin_fstest auto quick dump
>> +
>> +# Import common functions.
>> +. ./common/dump
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_require_scratch
> 
> The -x option is a new feature for xfsdump, not all system support that. So
> we need to _notrun if test on a system doesn't support it. A separated
> _require_* helper would be better if there'll be more testing about this
> new feature. Or a local detection in this case is fine too (can be moved as
> a common helper later).
> 
>> +_scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
>> +_scratch_mount
>> +
>> +# Create dumpdir for comparing with restoredir
>> +rm -rf $dump_dir
>> +mkdir $dump_dir || _fail "failed to mkdir $restore_dir"
>           ^^                                  ^^
> 
> Are you trying to create a dump dir or restore dir?
> 
>> +touch $dump_dir/FILE_1019
>> +
>> +_do_restore_toc -x -f $here/src/root-inode-broken-dumpfile
> 
> Why I didn't see how you generate this broken dumpfile in this case?
> 
> Oh... I see, you want to store a dumpfile in fstests source code directly.
> I thought you submited that file accidentally...
> 
> No, we don't do things like this way, please try to generate the dumpfile
> in this test case at first, then restore it. For example using xfs_db to
> break a xfs, or using some tricky method (likes xfs/545).
> 

Thank you for the comments. I will try another approach. I'm having
trouble creating a dumpfile for this test. Because xfsdump was already
fixed, xfsdump no longer generates a corrupted dumpfile even if there is
a lower inode number than a root inode.

>> +
>> +_do_restore_file -x -f $here/src/root-inode-broken-dumpfile -L stress_545
>> +_diff_compare_sub
>> +_ls_nodate_compare_sub
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
>> new file mode 100644
>> index 00000000..40a3f3a4
>> --- /dev/null
>> +++ b/tests/xfs/554.out
>> @@ -0,0 +1,57 @@
>> +QA output created by 554
>> +Contents of dump ...
>> +xfsrestore  -x -f DUMP_FILE -t
>> +xfsrestore: using file dump (drive_simple) strategy
>> +xfsrestore: searching media for dump
>> +xfsrestore: examining media file 0
>> +xfsrestore: dump description: 
>> +xfsrestore: hostname: xfsdump
>> +xfsrestore: mount point: SCRATCH_MNT
>> +xfsrestore: volume: SCRATCH_DEV
>> +xfsrestore: session time: TIME
>> +xfsrestore: level: 0
>> +xfsrestore: session label: "stress_545"
>> +xfsrestore: media label: "stress_tape_media"
>> +xfsrestore: file system ID: ID
>> +xfsrestore: session id: ID
>> +xfsrestore: media ID: ID
>> +xfsrestore: searching media for directory dump
>> +xfsrestore: reading directories
>> +xfsrestore: found fake rootino #128, will fix.
>> +xfsrestore: fix root # to 1024 (bind mount?)
>> +xfsrestore: 2 directories and 2 entries processed
>> +xfsrestore: directory post-processing
>> +xfsrestore: reading non-directory files
>> +xfsrestore: table of contents display complete: SECS seconds elapsed
>> +xfsrestore: Restore Status: SUCCESS
>> +
>> +dumpdir/FILE_1019
>> +Restoring from file...
>> +xfsrestore  -x -f DUMP_FILE  -L stress_545 RESTORE_DIR
>> +xfsrestore: using file dump (drive_simple) strategy
>> +xfsrestore: searching media for dump
>> +xfsrestore: examining media file 0
>> +xfsrestore: found dump matching specified label:
>> +xfsrestore: hostname: xfsdump
>> +xfsrestore: mount point: SCRATCH_MNT
>> +xfsrestore: volume: SCRATCH_DEV
>> +xfsrestore: session time: TIME
>> +xfsrestore: level: 0
>> +xfsrestore: session label: "stress_545"
>> +xfsrestore: media label: "stress_tape_media"
>> +xfsrestore: file system ID: ID
>> +xfsrestore: session id: ID
>> +xfsrestore: media ID: ID
>> +xfsrestore: searching media for directory dump
>> +xfsrestore: reading directories
>> +xfsrestore: found fake rootino #128, will fix.
>> +xfsrestore: fix root # to 1024 (bind mount?)
>> +xfsrestore: 2 directories and 2 entries processed
>> +xfsrestore: directory post-processing
>> +xfsrestore: restoring non-directory files
>> +xfsrestore: restore complete: SECS seconds elapsed
>> +xfsrestore: Restore Status: SUCCESS
>> +Comparing dump directory with restore directory
>> +Files DUMP_DIR/FILE_1019 and RESTORE_DIR/DUMP_SUBDIR/FILE_1019 are identical
>> +Comparing listing of dump directory with restore directory
>> +Files TMP.dump_dir and TMP.restore_dir are identical
>> -- 
>> 2.37.3
>>
> 
