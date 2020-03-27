Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78A7C2D0E8
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 10:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88F3B20717
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 10:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgC0KZu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 06:25:50 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:46859 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726149AbgC0KZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 06:25:49 -0400
X-IronPort-AV: E=Sophos;i="5.72,311,1580745600"; 
   d="scan'208";a="87556795"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Mar 2020 18:25:43 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id D0FF149DF126;
        Fri, 27 Mar 2020 18:15:27 +0800 (CST)
Received: from [10.167.220.84] (10.167.220.84) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 27 Mar 2020 18:25:41 +0800
Subject: Re: [PATCH v4] xfs/191: update mkfs.xfs input results
To:     <zlang@redhat.com>, <hch@lst.de>
CC:     <fstests@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <1585304270-8790-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Message-ID: <5627154b-b717-831e-cee5-e64b53308150@cn.fujitsu.com>
Date:   Fri, 27 Mar 2020 18:25:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <1585304270-8790-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201)
X-yoursite-MailScanner-ID: D0FF149DF126.AF50D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



on 2020/03/27 18:17, Yang Xu wrote:
> When I run xfs/191 with upstream xfsprogs, I get the following
> errors because mkfs.xfs binary has changed a lot(use loop device
> to avoid stripe alignment affect).
cc linux-xfs guys
> 
> -------------------------
> pass -n size=2b /dev/loop0
> pass -d agsize=8192b /dev/loop0
> pass -d agsize=65536s /dev/loop0
> pass -d su=0,sw=64 /dev/loop0
> pass -d su=4096s,sw=64 /dev/loop0
> pass -d su=4096b,sw=64 /dev/loop0
> pass -l su=10b /dev/loop0
> fail -n log=15 /dev/loop0
> fail -r rtdev=/mnt/xfstests/test/191-input-validation.img /dev/loop0
> fail -r size=65536,rtdev=/mnt/xfstests/test/191-input-validation.img /dev/loop0
> fail -i log=10 /dev/loop
> --------------------------
> 
> "pass -d su=0,sw=64 /dev/loop0", expect fail, this behavior has been
> fixed by commit 16adcb88(mkfs: more sunit/swidth sanity checking).
> 
> "fail -n log=15 /dev/sda11" "fail -i log=10 /dev/sda11", expect pass,
> this option has been removed since commit 2cf637c(mkfs: remove
> logarithm based CLI option).
> 
> "fail -r size=65536,rtdev=$fsimg /dev/sda11" "fail -r rtdev=$fsimg
> /dev/sda11" works well if we disable reflink, fail if we enable
> reflink. It fails because reflink was not supported in realtime
> devices since commit bfa66ec(mkfs: don't create realtime filesystems
> with reflink enabled).
> 
> Since xfsprogs v4.15.0-rc1(commit 68344ba0f mkfs: introduce default
> configuration structure), we have deault sectorsize and blocksize.
> So some cases without 's' or 'b' suffix trun into pass.
> 
> Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
> ---
>   tests/xfs/191-input-validation | 46 ++++++++++++++++++++++------------
>   1 file changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
> index db427349..93a0b7e9 100755
> --- a/tests/xfs/191-input-validation
> +++ b/tests/xfs/191-input-validation
> @@ -20,6 +20,7 @@ _cleanup()
>   {
>   	cd /
>   	rm -f $tmp.*
> +	[ -n "$loopdev" ] && _destroy_loop_device $loopdev
>   }
>   
>   # get standard environment, filters and checks
> @@ -31,11 +32,9 @@ _cleanup()
>   # Modify as appropriate.
>   _supported_fs xfs
>   _supported_os Linux
> -_require_scratch_nocheck
> +_require_loop
>   _require_xfs_mkfs_validation
>   
> -
> -
>   rm -f $seqres.full
>   echo silence is golden
>   
> @@ -53,6 +52,12 @@ fssize=$((4 * 1024 * 1024 * 1024))
>   logsize=$((4 * 1024 * 1024 * 100))
>   fsimg=$TEST_DIR/$seq.img
>   
> +#create a loop device to test
> +loopimg=$TEST_DIR/$seq.loopimg
> +$XFS_IO_PROG -f -c "truncate $fssize" $loopimg
> +loopdev=$(_create_loop_device $loopimg)
> +SCRATCH_DEV=$loopdev
> +
>   do_mkfs_pass()
>   {
>   	echo >> $seqres.full
> @@ -111,11 +116,12 @@ do_mkfs_fail -b size=2s $SCRATCH_DEV
>   do_mkfs_fail -b size=2b $SCRATCH_DEV
>   do_mkfs_fail -b size=nfi $SCRATCH_DEV
>   do_mkfs_fail -b size=4096nfi $SCRATCH_DEV
> -do_mkfs_fail -n size=2s $SCRATCH_DEV
> -do_mkfs_fail -n size=2b $SCRATCH_DEV
>   do_mkfs_fail -n size=nfi $SCRATCH_DEV
>   do_mkfs_fail -n size=4096nfi $SCRATCH_DEV
>   
> +do_mkfs_pass -n size=2b $SCRATCH_DEV
> +do_mkfs_pass -n size=2b $SCRATCH_DEV
> +
>   # bad label length
>   do_mkfs_fail -L thisiswaytoolong $SCRATCH_DEV
>   
> @@ -129,6 +135,8 @@ do_mkfs_pass -d agsize=32M $SCRATCH_DEV
>   do_mkfs_pass -d agsize=1g $SCRATCH_DEV
>   do_mkfs_pass -d agsize=$((32 * 1024 * 1024)) $SCRATCH_DEV
>   do_mkfs_pass -b size=4096 -d agsize=8192b $SCRATCH_DEV
> +do_mkfs_pass -d agsize=8192b $SCRATCH_DEV
> +do_mkfs_pass -d agsize=65536s $SCRATCH_DEV
>   do_mkfs_pass -d sectsize=512,agsize=65536s $SCRATCH_DEV
>   do_mkfs_pass -s size=512 -d agsize=65536s $SCRATCH_DEV
>   do_mkfs_pass -d noalign $SCRATCH_DEV
> @@ -136,7 +144,10 @@ do_mkfs_pass -d sunit=0,swidth=0 $SCRATCH_DEV
>   do_mkfs_pass -d sunit=8,swidth=8 $SCRATCH_DEV
>   do_mkfs_pass -d sunit=8,swidth=64 $SCRATCH_DEV
>   do_mkfs_pass -d su=0,sw=0 $SCRATCH_DEV
> +do_mkfs_pass -d su=0,sw=64 $SCRATCH_DEV
>   do_mkfs_pass -d su=4096,sw=1 $SCRATCH_DEV
> +do_mkfs_pass -d su=4096s,sw=64 $SCRATCH_DEV
> +do_mkfs_pass -d su=4096b,sw=64 $SCRATCH_DEV
>   do_mkfs_pass -d su=4k,sw=1 $SCRATCH_DEV
>   do_mkfs_pass -d su=4K,sw=8 $SCRATCH_DEV
>   do_mkfs_pass -b size=4096 -d su=1b,sw=8 $SCRATCH_DEV
> @@ -147,8 +158,6 @@ do_mkfs_pass -s size=512 -d su=8s,sw=8 $SCRATCH_DEV
>   do_mkfs_fail -d size=${fssize}b $SCRATCH_DEV
>   do_mkfs_fail -d size=${fssize}s $SCRATCH_DEV
>   do_mkfs_fail -d size=${fssize}yerk $SCRATCH_DEV
> -do_mkfs_fail -d agsize=8192b $SCRATCH_DEV
> -do_mkfs_fail -d agsize=65536s $SCRATCH_DEV
>   do_mkfs_fail -d agsize=32Mbsdfsdo $SCRATCH_DEV
>   do_mkfs_fail -d agsize=1GB $SCRATCH_DEV
>   do_mkfs_fail -d agcount=1k $SCRATCH_DEV
> @@ -159,13 +168,10 @@ do_mkfs_fail -d sunit=64,swidth=0 $SCRATCH_DEV
>   do_mkfs_fail -d sunit=64,swidth=64,noalign $SCRATCH_DEV
>   do_mkfs_fail -d sunit=64k,swidth=64 $SCRATCH_DEV
>   do_mkfs_fail -d sunit=64,swidth=64m $SCRATCH_DEV
> -do_mkfs_fail -d su=0,sw=64 $SCRATCH_DEV
>   do_mkfs_fail -d su=4096,sw=0 $SCRATCH_DEV
>   do_mkfs_fail -d su=4097,sw=1 $SCRATCH_DEV
>   do_mkfs_fail -d su=4096,sw=64,noalign $SCRATCH_DEV
>   do_mkfs_fail -d su=4096,sw=64s $SCRATCH_DEV
> -do_mkfs_fail -d su=4096s,sw=64 $SCRATCH_DEV
> -do_mkfs_fail -d su=4096b,sw=64 $SCRATCH_DEV
>   do_mkfs_fail -d su=4096garabge,sw=64 $SCRATCH_DEV
>   do_mkfs_fail -d su=4096,sw=64,sunit=64,swidth=64 $SCRATCH_DEV
>   do_mkfs_fail -d sectsize=10,agsize=65536s $SCRATCH_DEV
> @@ -206,6 +212,7 @@ do_mkfs_pass -l sunit=64 $SCRATCH_DEV
>   do_mkfs_pass -l sunit=64 -d sunit=8,swidth=8 $SCRATCH_DEV
>   do_mkfs_pass -l sunit=8 $SCRATCH_DEV
>   do_mkfs_pass -l su=$((4096*10)) $SCRATCH_DEV
> +do_mkfs_pass -l su=10b $SCRATCH_DEV
>   do_mkfs_pass -b size=4096 -l su=10b $SCRATCH_DEV
>   do_mkfs_pass -l sectsize=512,su=$((4096*10)) $SCRATCH_DEV
>   do_mkfs_pass -l internal $SCRATCH_DEV
> @@ -228,7 +235,6 @@ do_mkfs_fail -l agnum=32 $SCRATCH_DEV
>   do_mkfs_fail -l sunit=0  $SCRATCH_DEV
>   do_mkfs_fail -l sunit=63 $SCRATCH_DEV
>   do_mkfs_fail -l su=1 $SCRATCH_DEV
> -do_mkfs_fail -l su=10b $SCRATCH_DEV
>   do_mkfs_fail -l su=10s $SCRATCH_DEV
>   do_mkfs_fail -l su=$((4096*10+1)) $SCRATCH_DEV
>   do_mkfs_fail -l sectsize=10,agsize=65536s $SCRATCH_DEV
> @@ -246,7 +252,6 @@ do_mkfs_fail -l version=0  $SCRATCH_DEV
>   
>   # naming section, should pass
>   do_mkfs_pass -n size=65536 $SCRATCH_DEV
> -do_mkfs_pass -n log=15 $SCRATCH_DEV
>   do_mkfs_pass -n version=2 $SCRATCH_DEV
>   do_mkfs_pass -n version=ci $SCRATCH_DEV
>   do_mkfs_pass -n ftype=0 -m crc=0 $SCRATCH_DEV
> @@ -257,6 +262,7 @@ do_mkfs_fail -n version=1 $SCRATCH_DEV
>   do_mkfs_fail -n version=cid $SCRATCH_DEV
>   do_mkfs_fail -n ftype=4 $SCRATCH_DEV
>   do_mkfs_fail -n ftype=0 $SCRATCH_DEV
> +do_mkfs_fail -n log=15 $SCRATCH_DE
>   
>   reset_fsimg
>   
> @@ -272,12 +278,21 @@ do_mkfs_pass -m crc=0 -n ftype=0 $SCRATCH_DEV
>   do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV
>   do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
>   
> +# realtime section, results depend on reflink
> +_scratch_mkfs_xfs_supported -m reflink=0 >/dev/null 2>&1
> +if [ $? -eq 0 ]; then
> +	do_mkfs_pass -m reflink=0 -r rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_pass -m reflink=0 -r size=65536,rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_fail -m reflink=1 -r rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_fail -m reflink=1 -r size=65536,rtdev=$fsimg $SCRATCH_DEV
> +else
> +	do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
> +	do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
> +fi
>   
>   # realtime section, should pass
> -do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
>   do_mkfs_pass -r extsize=4k $SCRATCH_DEV
>   do_mkfs_pass -r extsize=1G $SCRATCH_DEV
> -do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
>   do_mkfs_pass -r noalign $SCRATCH_DEV
>   
>   
> @@ -288,12 +303,10 @@ do_mkfs_fail -r extsize=2G $SCRATCH_DEV
>   do_mkfs_fail -r size=65536 $SCRATCH_DEV
>   
>   
> -
>   # inode section, should pass
>   do_mkfs_pass -i size=256 -m crc=0 $SCRATCH_DEV
>   do_mkfs_pass -i size=512 $SCRATCH_DEV
>   do_mkfs_pass -i size=2048 $SCRATCH_DEV
> -do_mkfs_pass -i log=10 $SCRATCH_DEV
>   do_mkfs_pass -i perblock=2 $SCRATCH_DEV
>   do_mkfs_pass -i maxpct=10 $SCRATCH_DEV
>   do_mkfs_pass -i maxpct=100 $SCRATCH_DEV
> @@ -317,6 +330,7 @@ do_mkfs_fail -i align=2 $SCRATCH_DEV
>   do_mkfs_fail -i sparse -m crc=0 $SCRATCH_DEV
>   do_mkfs_fail -i align=0 -m crc=1 $SCRATCH_DEV
>   do_mkfs_fail -i attr=1 -m crc=1 $SCRATCH_DEV
> +do_mkfs_fail -i log=10 $SCRATCH_DEV
>   
>   status=0
>   exit
> 


