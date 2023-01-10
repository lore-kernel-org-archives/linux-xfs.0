Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F02C61DB3
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Jan 2023 07:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjAJHTh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Jan 2023 02:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjAJHTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2023 02:19:36 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AC8F40;
        Mon,  9 Jan 2023 23:19:33 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VZI1-lx_1673335168;
Received: from 30.97.56.223(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VZI1-lx_1673335168)
          by smtp.aliyun-inc.com;
          Tue, 10 Jan 2023 15:19:29 +0800
Message-ID: <3a8baf86-e447-dead-e14d-93d504f84b3b@linux.alibaba.com>
Date:   Tue, 10 Jan 2023 15:19:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH V6 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Content-Language: en-US
To:     "djwong@kernel.org" <djwong@kernel.org>,
        "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>,
        dchinner@redhat.com
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "hsiangkao@linux.alibaba.com" <hsiangkao@linux.alibaba.com>,
        "allison.henderson@oracle.com" <allison.henderson@oracle.com>
References: <20221212055645.2067020-1-ZiyangZhang@linux.alibaba.com>
 <20221212055645.2067020-3-ZiyangZhang@linux.alibaba.com>
 <c984985a-ec53-9f32-ef93-946b0500bcd5@fujitsu.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <c984985a-ec53-9f32-ef93-946b0500bcd5@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023/1/3 14:54, xuyang2018.jy@fujitsu.com wrote:
> 
> 
> on 2022/12/12 13:56, Ziyang Zhang wrote:
> 
>> Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
>> S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
>>
>> Actually we just observed it can fail after apply our inode
>> extent-to-btree workaround. The root cause is that the kernel may be
>> too good at allocating consecutive blocks so that the data fork is
>> still in extents format.
>>
>> Therefore instead of using a fixed number, let's make sure the number
>> of extents is large enough than (inode size - inode core size) /
>> sizeof(xfs_bmbt_rec_t).
> 
> After this patch, xfs/083 and xfs/155 failed on my envrionment(6.1.0+ 
> kernel).
> 
> the 083 fail as below:
> 1 fuzzing xfs with FUZZ_ARGS=-3 -n 32 and FSCK_PASSES=10
>    2 + create scratch fs
>    3 meta-data=/dev/sdb9              isize=512    agcount=4, 
> agsize=529878 blks
>    4          =                       sectsz=512   attr=2, projid32bit=1
>    5          =                       crc=1        finobt=1, sparse=1, 
> rmapbt=0
>    6          =                       reflink=0    bigtime=1 
> inobtcount=1 nrext64=0
>    7 data     =                       bsize=4096   blocks=2119510, 
> imaxpct=25
>    8          =                       sunit=0      swidth=0 blks
>    9 naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>   10 log      =internal log           bsize=4096   blocks=16384, version=2
>   11          =                       sectsz=512   sunit=0 blks, 
> lazy-count=1
>   12 realtime =none                   extsz=4096   blocks=0, rtextents=0
>   13 + populate fs image
>   14 MOUNT_OPTIONS =  -o usrquota,grpquota,prjquota
>   15 + fill root ino chunk
>   16 + extents file
>   17 wrote 4096/4096 bytes at offset 0
>   18 4 KiB, 1 ops; 0.0187 sec (212.891 KiB/sec and 53.2226 ops/sec)
>   19 + btree extents file
>   20 wrote 2097152/2097152 bytes at offset 0
>   21 2 MiB, 2 ops; 0.0637 sec (31.370 MiB/sec and 31.3701 ops/sec)
>   22 + inline dir
>   23 + block dir
>   24 + leaf dir
>   25 + leafn dir
>   26 + node dir
>   27 + btree dir
>   28 + inline symlink
>   29 + extents symlink
>   30 + special
>   31 + local attr
>   32 + leaf attr
>   33 + node attr
>   34 + btree attr
>   35 + attr extents with a remote less-than-a-block value
>   36 + attr extents with a remote one-block value
>   37 + empty file
>   38 + freesp btree
>   39 wrote 4194304/4194304 bytes at offset 0
>   40 4 MiB, 4 ops; 0.0941 sec (42.470 MiB/sec and 42.4696 ops/sec)
>   41 + inobt btree
>   42 + real files
>   43 FILL FS
>   44 src_sz 2052 fs_sz 8342940 nr 203
>   45 failed to create ino 8578 dformat expected btree saw extents
>   46 failed to create ino 8578 dformat expected btree saw extents
>   47 (see /var/lib/xfstests/results//xfs/083.full for details)
> 
> 
> It seems this logic can't ensure to creat a btree format dir and it
> is a  extent format dir. Or I miss something?
> 
> 
> Best Regards
> Yang Xu

Hi all,

__populate_xfs_create_btree_dir() will delete 50% files
after creating all the files if we set "missing" to 1(true).
This may transform the data fork from BTREE format to EXTENT
format by merging blocks.

Without setting "missing", I find that xfs/083 xfs/155 xfs/273
and xfs/495 pass.

BTW, I have heard that Dave has wrote allocation speedup code
and thank Dave for looking into this as well.

Regards,
Zhang


