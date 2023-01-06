Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86903C3DA7A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Jan 2023 09:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjAFJ4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Jan 2023 04:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjAFJ4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2023 04:56:02 -0500
Received: from out30-7.freemail.mail.aliyun.com (out30-7.freemail.mail.aliyun.com [115.124.30.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E4110FA;
        Fri,  6 Jan 2023 01:55:59 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VYzme23_1672998956;
Received: from 30.97.56.214(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VYzme23_1672998956)
          by smtp.aliyun-inc.com;
          Fri, 06 Jan 2023 17:55:57 +0800
Message-ID: <3d9d3d69-4a6b-0661-97ea-facc33149c80@linux.alibaba.com>
Date:   Fri, 6 Jan 2023 17:55:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH V6 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Content-Language: en-US
To:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Cc:     "hsiangkao@linux.alibaba.com" <hsiangkao@linux.alibaba.com>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
References: <20221212055645.2067020-1-ZiyangZhang@linux.alibaba.com>
 <20221212055645.2067020-3-ZiyangZhang@linux.alibaba.com>
 <c984985a-ec53-9f32-ef93-946b0500bcd5@fujitsu.com>
 <0b95a29d-43ca-ba29-365f-9161a213dc17@linux.alibaba.com>
 <c9355efb-cebe-8efd-8844-1d00d649e602@fujitsu.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <c9355efb-cebe-8efd-8844-1d00d649e602@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023/1/3 17:58, xuyang2018.jy@fujitsu.com wrote:
> on  2023/01/03 17:29, Ziyang Zhang wrote
>> On 2023/1/3 14:54, xuyang2018.jy@fujitsu.com wrote:
>>>
>>>
>>> on 2022/12/12 13:56, Ziyang Zhang wrote:
>>>
>>>> Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
>>>> S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
>>>>
>>>> Actually we just observed it can fail after apply our inode
>>>> extent-to-btree workaround. The root cause is that the kernel may be
>>>> too good at allocating consecutive blocks so that the data fork is
>>>> still in extents format.
>>>>
>>>> Therefore instead of using a fixed number, let's make sure the number
>>>> of extents is large enough than (inode size - inode core size) /
>>>> sizeof(xfs_bmbt_rec_t).
>>>
>>> After this patch, xfs/083 and xfs/155 failed on my envrionment(6.1.0+
>>> kernel).
>>>
>>> the 083 fail as below:
>>> 1 fuzzing xfs with FUZZ_ARGS=-3 -n 32 and FSCK_PASSES=10
>>>     2 + create scratch fs
>>>     3 meta-data=/dev/sdb9              isize=512    agcount=4,
>>> agsize=529878 blks
>>>     4          =                       sectsz=512   attr=2, projid32bit=1
>>>     5          =                       crc=1        finobt=1, sparse=1,
>>> rmapbt=0
>>>     6          =                       reflink=0    bigtime=1
>>> inobtcount=1 nrext64=0
>>>     7 data     =                       bsize=4096   blocks=2119510,
>>> imaxpct=25
>>>     8          =                       sunit=0      swidth=0 blks
>>>     9 naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>>    10 log      =internal log           bsize=4096   blocks=16384, version=2
>>>    11          =                       sectsz=512   sunit=0 blks,
>>> lazy-count=1
>>>    12 realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>    13 + populate fs image
>>>    14 MOUNT_OPTIONS =  -o usrquota,grpquota,prjquota
>>>    15 + fill root ino chunk
>>>    16 + extents file
>>>    17 wrote 4096/4096 bytes at offset 0
>>>    18 4 KiB, 1 ops; 0.0187 sec (212.891 KiB/sec and 53.2226 ops/sec)
>>>    19 + btree extents file
>>>    20 wrote 2097152/2097152 bytes at offset 0
>>>    21 2 MiB, 2 ops; 0.0637 sec (31.370 MiB/sec and 31.3701 ops/sec)
>>>    22 + inline dir
>>>    23 + block dir
>>>    24 + leaf dir
>>>    25 + leafn dir
>>>    26 + node dir
>>>    27 + btree dir
>>>    28 + inline symlink
>>>    29 + extents symlink
>>>    30 + special
>>>    31 + local attr
>>>    32 + leaf attr
>>>    33 + node attr
>>>    34 + btree attr
>>>    35 + attr extents with a remote less-than-a-block value
>>>    36 + attr extents with a remote one-block value
>>>    37 + empty file
>>>    38 + freesp btree
>>>    39 wrote 4194304/4194304 bytes at offset 0
>>>    40 4 MiB, 4 ops; 0.0941 sec (42.470 MiB/sec and 42.4696 ops/sec)
>>>    41 + inobt btree
>>>    42 + real files
>>>    43 FILL FS
>>>    44 src_sz 2052 fs_sz 8342940 nr 203
>>>    45 failed to create ino 8578 dformat expected btree saw extents
>>>    46 failed to create ino 8578 dformat expected btree saw extents
>>>    47 (see /var/lib/xfstests/results//xfs/083.full for details)
>>>
>>>
>>> It seems this logic can't ensure to creat a btree format dir and it
>>> is a  extent format dir. Or I miss something?
>>>
>>>
>>> Best Regards
>>> Yang Xu
>>
>> Hi Yang,
>>
>> Looks like xfs/083 does call __populate_xfs_create_btree_dir.
> 
> Yes.
>> Could you please share your test environment and config in
>> detail and I will try to reproduce your report.
> 
> Of course, I use fedora31 and 6.1 kernel. xfsprogs uses upstream version 
> xfsprogs: Release v6.0.0.
> 
> local.config
> export TEST_DEV=/dev/sdb8
> export TEST_DIR=/mnt/xfstests/test
> export SCRATCH_DEV=/dev/sdb9
> export SCRATCH_MNT=/mnt/xfstests/scratch
> export XFS_MKFS_OPTIONS="-b size=4096 -m reflink=1"
> 
> 
> disk info:
> /dev/sdb8       566241280 608184319  41943040    20G 83 Linux
> /dev/sdb9       608186368 625142447  16956080   8.1G 83 Linux
> 
> 
> BTW, xfs/273 xfs/495 that called _scratch_populate_cached also failed 
> with this commit under selinux Permissive status and passed under 
> selinux  enforcing status. I guess the extend attr fork was filled
> in selinux enabled status, so we can create btree dir by smaller number 
> files.
> 


Hi Yang,

Could you please try this patch:

diff --git a/common/populate b/common/populate
index 44b4af16..bedcdc41 100644
--- a/common/populate
+++ b/common/populate
@@ -81,7 +81,7 @@ __populate_xfs_create_btree_dir() {
        # btree format.  Cycling the mount to use xfs_db is too slow, so
        # watch for when the extent count exceeds the space after the
        # inode core.
-       local max_nextents="$(((isize - icore_size) / 16))"
+       local max_nextents="$(((isize - icore_size) / 16 + 1))"
        local nr=0
 
        mkdir -p "${name}"

This will add 1 to max_nextents. Then xfs/083 will pass on my env(6.1 kernel,
6.0.0 xfsprogs, selinux disabled)

Regards,
Zhang
