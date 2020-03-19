Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DDEC4332E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 04:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EA3A20757
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 04:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCQS5HYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgCSEV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 00:21:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39015 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbgCSEV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Mar 2020 00:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584591717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BU2rY4UBlWy5lXhGaPVT0Ula6pHlFvguJKw995O2U4E=;
        b=KCQS5HYKfMssYkgwTU1m9pHoHmJj/VjinX0dms4pCyyqlPFQhtpDHGyH9Ab4MAVlL6oGsz
        cc49ZjMlRxp7h1EgEEsqaKvYq1MAwsxczi9aVE3zpecYmaB2HpH71d53WfYgnFzkECLpbP
        I/hfcRT9kNF3hJvZRtB1JJnEfCM9hh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150--mfJYjXEPKaV_T2HNid9xA-1; Thu, 19 Mar 2020 00:21:52 -0400
X-MC-Unique: -mfJYjXEPKaV_T2HNid9xA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D66478014C1;
        Thu, 19 Mar 2020 04:21:49 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7891460BF7;
        Thu, 19 Mar 2020 04:21:46 +0000 (UTC)
Date:   Thu, 19 Mar 2020 12:33:06 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     guaneryu@gmail.com, jtulak@redhat.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: remove xfs/191-input-validation
Message-ID: <20200319043306.GK14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, guaneryu@gmail.com,
        jtulak@redhat.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
References: <20200318172115.1120964-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318172115.1120964-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 18, 2020 at 06:21:15PM +0100, Christoph Hellwig wrote:
> This test has constantly failed since it was added, and the promised
> input validation never materialized.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Hmm... that's truth this case always fails. But a mkfs.xfs sanity test is
good.

We have a RHEL internal mkfs.xfs sanity test case, but it takes long time to
run, can't port to xfstests directly.
I don't know if Jan would like to improve this case, might make it simple,
remove those unstable test lines, rewrite the case to avoid unstable test
results? Or we remove this case, then write a new one?
I can do that too, if the xfs-devel thinks it worth.

Thanks,
Zorro

>  tests/xfs/191-input-validation     | 322 -----------------------------
>  tests/xfs/191-input-validation.out |   2 -
>  tests/xfs/group                    |   1 -
>  3 files changed, 325 deletions(-)
>  delete mode 100755 tests/xfs/191-input-validation
>  delete mode 100644 tests/xfs/191-input-validation.out
> 
> diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
> deleted file mode 100755
> index db427349..00000000
> --- a/tests/xfs/191-input-validation
> +++ /dev/null
> @@ -1,322 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
> -#
> -# FS QA Test No. xfs/191
> -#
> -# mkfs.xfs input validation test. Designed to break mkfs.xfs if it doesn't
> -# filter garbage input or invalid option combinations correctly.
> -#
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> -
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1	# failure is the default!
> -trap "_cleanup; exit \$status" 0 1 2 3 15
> -
> -_cleanup()
> -{
> -	cd /
> -	rm -f $tmp.*
> -}
> -
> -# get standard environment, filters and checks
> -. ./common/rc
> -. ./common/filter
> -
> -# real QA test starts here
> -
> -# Modify as appropriate.
> -_supported_fs xfs
> -_supported_os Linux
> -_require_scratch_nocheck
> -_require_xfs_mkfs_validation
> -
> -
> -
> -rm -f $seqres.full
> -echo silence is golden
> -
> -# clear out any options to mkfs first. We want to test realtime and external log
> -# devices if we can, but we also want to control them ourselves.
> -logdev=$SCRATCH_LOGDEV
> -rtdev=$SCRATCH_RTDEV
> -
> -MKFS_OPTIONS=
> -SCRATCH_LOGDEV=
> -SCRATCH_RTDEV=
> -
> -# limit the image size of the filesystem being created to something small
> -fssize=$((4 * 1024 * 1024 * 1024))
> -logsize=$((4 * 1024 * 1024 * 100))
> -fsimg=$TEST_DIR/$seq.img
> -
> -do_mkfs_pass()
> -{
> -	echo >> $seqres.full
> -	echo "pass expected $*" >> $seqres.full
> -	$MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
> -	[ $? -ne 0 ] && echo "fail $*"
> -}
> -
> -do_mkfs_fail()
> -{
> -	echo >> $seqres.full
> -	echo "fail expected $*" >> $seqres.full
> -	$MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
> -	[ $? -eq 0 ] && echo "pass $*"
> -}
> -
> -reset_fsimg()
> -{
> -	rm -f $fsimg
> -	$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
> -}
> -
> -reset_fsimg
> -
> -do_mkfs_pass $SCRATCH_DEV
> -
> -# basic "should fail" options
> -
> -# specifying sector sizes in sectors or blocks or garbage
> -do_mkfs_fail -s size=2s $SCRATCH_DEV
> -do_mkfs_fail -d sectsize=2s $SCRATCH_DEV
> -do_mkfs_fail -l sectsize=2s $SCRATCH_DEV
> -do_mkfs_fail -s size=2b $SCRATCH_DEV
> -do_mkfs_fail -d sectsize=2b $SCRATCH_DEV
> -do_mkfs_fail -l sectsize=2b $SCRATCH_DEV
> -
> -do_mkfs_fail -s size=grot $SCRATCH_DEV
> -do_mkfs_fail -s size=2yerk $SCRATCH_DEV
> -do_mkfs_fail -d sectsize=blah $SCRATCH_DEV
> -do_mkfs_fail -d sectsize=2foo $SCRATCH_DEV
> -do_mkfs_fail -l sectsize=nggh $SCRATCH_DEV
> -do_mkfs_fail -l sectsize=2nggh $SCRATCH_DEV
> -
> -# conflicting sector/block sizes
> -do_mkfs_fail -s size=512 -d sectsize=1024 $SCRATCH_DEV
> -do_mkfs_fail -s size=512 -l sectsize=1024 $SCRATCH_DEV
> -do_mkfs_fail -d sectsize=2048 -l sectsize=1024 $SCRATCH_DEV
> -
> -do_mkfs_fail -b size=512 -s size=1024 $SCRATCH_DEV
> -do_mkfs_fail -b size=512 -d sectsize=1024 $SCRATCH_DEV
> -do_mkfs_fail -b size=512 -l sectsize=1024 $SCRATCH_DEV
> -
> -# specifying block sizes in sectors without specifying sector size
> -# or in blocks or garbage
> -do_mkfs_fail -b size=2s $SCRATCH_DEV
> -do_mkfs_fail -b size=2b $SCRATCH_DEV
> -do_mkfs_fail -b size=nfi $SCRATCH_DEV
> -do_mkfs_fail -b size=4096nfi $SCRATCH_DEV
> -do_mkfs_fail -n size=2s $SCRATCH_DEV
> -do_mkfs_fail -n size=2b $SCRATCH_DEV
> -do_mkfs_fail -n size=nfi $SCRATCH_DEV
> -do_mkfs_fail -n size=4096nfi $SCRATCH_DEV
> -
> -# bad label length
> -do_mkfs_fail -L thisiswaytoolong $SCRATCH_DEV
> -
> -# basic "should pass" data section tests
> -do_mkfs_pass $SCRATCH_DEV
> -do_mkfs_pass -d name=$SCRATCH_DEV
> -do_mkfs_pass -d size=$fssize $SCRATCH_DEV
> -do_mkfs_pass -d agcount=32 $SCRATCH_DEV
> -do_mkfs_pass -d agsize=32m $SCRATCH_DEV
> -do_mkfs_pass -d agsize=32M $SCRATCH_DEV
> -do_mkfs_pass -d agsize=1g $SCRATCH_DEV
> -do_mkfs_pass -d agsize=$((32 * 1024 * 1024)) $SCRATCH_DEV
> -do_mkfs_pass -b size=4096 -d agsize=8192b $SCRATCH_DEV
> -do_mkfs_pass -d sectsize=512,agsize=65536s $SCRATCH_DEV
> -do_mkfs_pass -s size=512 -d agsize=65536s $SCRATCH_DEV
> -do_mkfs_pass -d noalign $SCRATCH_DEV
> -do_mkfs_pass -d sunit=0,swidth=0 $SCRATCH_DEV
> -do_mkfs_pass -d sunit=8,swidth=8 $SCRATCH_DEV
> -do_mkfs_pass -d sunit=8,swidth=64 $SCRATCH_DEV
> -do_mkfs_pass -d su=0,sw=0 $SCRATCH_DEV
> -do_mkfs_pass -d su=4096,sw=1 $SCRATCH_DEV
> -do_mkfs_pass -d su=4k,sw=1 $SCRATCH_DEV
> -do_mkfs_pass -d su=4K,sw=8 $SCRATCH_DEV
> -do_mkfs_pass -b size=4096 -d su=1b,sw=8 $SCRATCH_DEV
> -do_mkfs_pass -d sectsize=512,su=8s,sw=8 $SCRATCH_DEV
> -do_mkfs_pass -s size=512 -d su=8s,sw=8 $SCRATCH_DEV
> -
> -# invalid data section tests
> -do_mkfs_fail -d size=${fssize}b $SCRATCH_DEV
> -do_mkfs_fail -d size=${fssize}s $SCRATCH_DEV
> -do_mkfs_fail -d size=${fssize}yerk $SCRATCH_DEV
> -do_mkfs_fail -d agsize=8192b $SCRATCH_DEV
> -do_mkfs_fail -d agsize=65536s $SCRATCH_DEV
> -do_mkfs_fail -d agsize=32Mbsdfsdo $SCRATCH_DEV
> -do_mkfs_fail -d agsize=1GB $SCRATCH_DEV
> -do_mkfs_fail -d agcount=1k $SCRATCH_DEV
> -do_mkfs_fail -d agcount=6b $SCRATCH_DEV
> -do_mkfs_fail -d agcount=32,agsize=32m $SCRATCH_DEV
> -do_mkfs_fail -d sunit=0,swidth=64 $SCRATCH_DEV
> -do_mkfs_fail -d sunit=64,swidth=0 $SCRATCH_DEV
> -do_mkfs_fail -d sunit=64,swidth=64,noalign $SCRATCH_DEV
> -do_mkfs_fail -d sunit=64k,swidth=64 $SCRATCH_DEV
> -do_mkfs_fail -d sunit=64,swidth=64m $SCRATCH_DEV
> -do_mkfs_fail -d su=0,sw=64 $SCRATCH_DEV
> -do_mkfs_fail -d su=4096,sw=0 $SCRATCH_DEV
> -do_mkfs_fail -d su=4097,sw=1 $SCRATCH_DEV
> -do_mkfs_fail -d su=4096,sw=64,noalign $SCRATCH_DEV
> -do_mkfs_fail -d su=4096,sw=64s $SCRATCH_DEV
> -do_mkfs_fail -d su=4096s,sw=64 $SCRATCH_DEV
> -do_mkfs_fail -d su=4096b,sw=64 $SCRATCH_DEV
> -do_mkfs_fail -d su=4096garabge,sw=64 $SCRATCH_DEV
> -do_mkfs_fail -d su=4096,sw=64,sunit=64,swidth=64 $SCRATCH_DEV
> -do_mkfs_fail -d sectsize=10,agsize=65536s $SCRATCH_DEV
> -do_mkfs_fail -d sectsize=512s,agsize=65536s $SCRATCH_DEV
> -
> -reset_fsimg
> -
> -# file section, should pass
> -do_mkfs_pass $fsimg
> -do_mkfs_pass -d file=0 $SCRATCH_DEV
> -do_mkfs_pass -d size=$fssize,file=1,name=$fsimg
> -do_mkfs_pass -d size=$fssize,file $fsimg
> -do_mkfs_pass -d size=$fssize $fsimg
> -do_mkfs_pass -d size=$fssize,name=$fsimg
> -do_mkfs_pass -d size=$((fssize/2)) $fsimg
> -# again this one, to check that we didn't truncated the file
> -do_mkfs_pass -d size=$fssize $fsimg
> -rm -f $fsimg
> -do_mkfs_pass -d file,size=$fssize $fsimg
> -
> -reset_fsimg
> -
> -# file section, should fail
> -do_mkfs_fail -d file=1 $SCRATCH_DEV
> -do_mkfs_fail -d file $fsimg # no size given
> -rm -f $fsimg
> -do_mkfs_fail $fsimg
> -do_mkfs_fail -d size=$fssize $fsimg
> -
> -reset_fsimg
> -
> -# log section, should pass
> -do_mkfs_pass -l size=$logsize -d size=$fssize $SCRATCH_DEV
> -do_mkfs_pass -l agnum=2 $SCRATCH_DEV
> -do_mkfs_pass -l size=4096b $SCRATCH_DEV
> -do_mkfs_pass -l sectsize=512 $SCRATCH_DEV
> -do_mkfs_pass -l sunit=64 $SCRATCH_DEV
> -do_mkfs_pass -l sunit=64 -d sunit=8,swidth=8 $SCRATCH_DEV
> -do_mkfs_pass -l sunit=8 $SCRATCH_DEV
> -do_mkfs_pass -l su=$((4096*10)) $SCRATCH_DEV
> -do_mkfs_pass -b size=4096 -l su=10b $SCRATCH_DEV
> -do_mkfs_pass -l sectsize=512,su=$((4096*10)) $SCRATCH_DEV
> -do_mkfs_pass -l internal $SCRATCH_DEV
> -$XFS_IO_PROG -f -c "truncate $logsize" $fsimg
> -do_mkfs_pass -l logdev=$fsimg $SCRATCH_DEV
> -do_mkfs_pass -l name=$fsimg $SCRATCH_DEV
> -do_mkfs_pass -l lazy-count=0 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -l lazy-count=1 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -l version=1 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -l version=2 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -l version=2 $SCRATCH_DEV
> -
> -# log section, should fail
> -do_mkfs_fail -l size=${fssize}b $SCRATCH_DEV
> -do_mkfs_fail -l size=${fssize}s $SCRATCH_DEV
> -do_mkfs_fail -l size=${fssize}yerk $SCRATCH_DEV
> -do_mkfs_fail -l agnum=1k $SCRATCH_DEV
> -do_mkfs_fail -l agnum=6b $SCRATCH_DEV
> -do_mkfs_fail -l agnum=32 $SCRATCH_DEV
> -do_mkfs_fail -l sunit=0  $SCRATCH_DEV
> -do_mkfs_fail -l sunit=63 $SCRATCH_DEV
> -do_mkfs_fail -l su=1 $SCRATCH_DEV
> -do_mkfs_fail -l su=10b $SCRATCH_DEV
> -do_mkfs_fail -l su=10s $SCRATCH_DEV
> -do_mkfs_fail -l su=$((4096*10+1)) $SCRATCH_DEV
> -do_mkfs_fail -l sectsize=10,agsize=65536s $SCRATCH_DEV
> -do_mkfs_fail -l sectsize=512s,agsize=65536s $SCRATCH_DEV
> -do_mkfs_fail -l internal=0 $SCRATCH_DEV
> -reset_fsimg
> -do_mkfs_fail -l internal=1,logdev=$fsimg $SCRATCH_DEV
> -do_mkfs_fail -l lazy-count=1garbage $SCRATCH_DEV
> -do_mkfs_fail -l lazy-count=2 $SCRATCH_DEV
> -do_mkfs_fail -l lazy-count=0 -m crc=1 $SCRATCH_DEV
> -do_mkfs_fail -l version=1 -m crc=1 $SCRATCH_DEV
> -do_mkfs_fail -l version=0  $SCRATCH_DEV
> -
> -
> -
> -# naming section, should pass
> -do_mkfs_pass -n size=65536 $SCRATCH_DEV
> -do_mkfs_pass -n log=15 $SCRATCH_DEV
> -do_mkfs_pass -n version=2 $SCRATCH_DEV
> -do_mkfs_pass -n version=ci $SCRATCH_DEV
> -do_mkfs_pass -n ftype=0 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -n ftype=1 $SCRATCH_DEV
> -
> -# naming section, should fail
> -do_mkfs_fail -n version=1 $SCRATCH_DEV
> -do_mkfs_fail -n version=cid $SCRATCH_DEV
> -do_mkfs_fail -n ftype=4 $SCRATCH_DEV
> -do_mkfs_fail -n ftype=0 $SCRATCH_DEV
> -
> -reset_fsimg
> -
> -# metadata section, should pass
> -do_mkfs_pass -m crc=1,finobt=1 $SCRATCH_DEV
> -do_mkfs_pass -m crc=1,finobt=0 $SCRATCH_DEV
> -do_mkfs_pass -m crc=0,finobt=0 $SCRATCH_DEV
> -do_mkfs_pass -m crc=1 -n ftype=1 $SCRATCH_DEV
> -do_mkfs_pass -m crc=0 -n ftype=1 $SCRATCH_DEV
> -do_mkfs_pass -m crc=0 -n ftype=0 $SCRATCH_DEV
> -
> -# metadata section, should fail
> -do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV
> -do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
> -
> -
> -# realtime section, should pass
> -do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
> -do_mkfs_pass -r extsize=4k $SCRATCH_DEV
> -do_mkfs_pass -r extsize=1G $SCRATCH_DEV
> -do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
> -do_mkfs_pass -r noalign $SCRATCH_DEV
> -
> -
> -# realtime section, should fail
> -do_mkfs_fail -r rtdev=$SCRATCH_DEV
> -do_mkfs_fail -r extsize=256 $SCRATCH_DEV
> -do_mkfs_fail -r extsize=2G $SCRATCH_DEV
> -do_mkfs_fail -r size=65536 $SCRATCH_DEV
> -
> -
> -
> -# inode section, should pass
> -do_mkfs_pass -i size=256 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -i size=512 $SCRATCH_DEV
> -do_mkfs_pass -i size=2048 $SCRATCH_DEV
> -do_mkfs_pass -i log=10 $SCRATCH_DEV
> -do_mkfs_pass -i perblock=2 $SCRATCH_DEV
> -do_mkfs_pass -i maxpct=10 $SCRATCH_DEV
> -do_mkfs_pass -i maxpct=100 $SCRATCH_DEV
> -do_mkfs_pass -i maxpct=0 $SCRATCH_DEV
> -do_mkfs_pass -i align=0 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -i align=1 -m crc=1 $SCRATCH_DEV
> -do_mkfs_pass -i attr=1 -m crc=0 $SCRATCH_DEV
> -do_mkfs_pass -i attr=2 $SCRATCH_DEV
> -do_mkfs_pass -i projid32bit $SCRATCH_DEV
> -do_mkfs_pass -i sparse=0 $SCRATCH_DEV
> -do_mkfs_pass -i sparse -m crc $SCRATCH_DEV
> -
> -
> -# inode section, should fail
> -do_mkfs_fail -i size=256 -m crc $SCRATCH_DEV
> -do_mkfs_fail -i size=128 $SCRATCH_DEV
> -do_mkfs_fail -i size=513 $SCRATCH_DEV
> -do_mkfs_fail -i size=4096 $SCRATCH_DEV
> -do_mkfs_fail -i maxpct=110 $SCRATCH_DEV
> -do_mkfs_fail -i align=2 $SCRATCH_DEV
> -do_mkfs_fail -i sparse -m crc=0 $SCRATCH_DEV
> -do_mkfs_fail -i align=0 -m crc=1 $SCRATCH_DEV
> -do_mkfs_fail -i attr=1 -m crc=1 $SCRATCH_DEV
> -
> -status=0
> -exit
> diff --git a/tests/xfs/191-input-validation.out b/tests/xfs/191-input-validation.out
> deleted file mode 100644
> index 020bd625..00000000
> --- a/tests/xfs/191-input-validation.out
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -QA output created by 191-input-validation
> -silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 12eb55c9..8487892f 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -188,7 +188,6 @@
>  188 ci dir auto
>  189 mount auto quick
>  190 rw auto quick
> -191-input-validation auto quick mkfs
>  192 auto quick clone
>  193 auto quick clone
>  194 rw auto
> -- 
> 2.24.1
> 

