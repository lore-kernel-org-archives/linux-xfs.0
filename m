Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DDFEB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 08:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjF1Iid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 04:38:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:21996 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjF1Idm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 04:33:42 -0400
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QrXSB22ZvzlWMg;
        Wed, 28 Jun 2023 14:56:42 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 14:59:26 +0800
Message-ID: <6129fa9a-73aa-99e5-6231-88a1cc60f189@huawei.com>
Date:   Wed, 28 Jun 2023 14:59:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] mkfs.xfs: fix segmentation fault caused by accessing a
 null pointer
To:     Dave Chinner <david@fromorbit.com>
CC:     <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        <linux-xfs@vger.kernel.org>, <louhongxiang@huawei.com>,
        <liuzhiqiang26@huawei.com>
References: <48402a8a-95db-f7b5-196e-32f3b4b2bf4e@huawei.com>
 <ZJNxj+Tm0cIDKaAR@dread.disaster.area>
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <ZJNxj+Tm0cIDKaAR@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/6/22 5:54, Dave Chinner 写道:
> On Wed, Jun 21, 2023 at 05:25:27PM +0800, Wu Guanghao wrote:
>> We encountered a segfault while testing the mkfs.xfs + iscsi.
>>
>> (gdb) bt
>> #0 libxfs_log_sb (tp=0xaaaafaea0630) at xfs_sb.c:810
>> #1 0x0000aaaaca991468 in __xfs_trans_commit (tp=<optimized out>, tp@entry=0xaaaafaea0630, regrant=regrant@entry=true) at trans.c:995
>> #2 0x0000aaaaca991790 in libxfs_trans_roll (tpp=tpp@entry=0xfffffe1f3018) at trans.c:103
>> #3 0x0000aaaaca9bcde8 in xfs_dialloc_roll (agibp=0xaaaafaea2fa0, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1561
>> #4 xfs_dialloc_try_ag (ok_alloc=true, new_ino=<synthetic pointer>, parent=0, pag=0xaaaafaea0210, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1698
>> #5 xfs_dialloc (tpp=tpp@entry=0xfffffe1f31c8, parent=0, mode=mode@entry=16877, new_ino=new_ino@entry=0xfffffe1f3128) at xfs_ialloc.c:1776
>> #6 0x0000aaaaca9925b0 in libxfs_dir_ialloc (tpp=tpp@entry=0xfffffe1f31c8, dp=dp@entry=0x0, mode=mode@entry=16877, nlink=nlink@entry=1, rdev=rdev@entry=0, cr=cr@entry=0xfffffe1f31d0,
>>     fsx=fsx@entry=0xfffffe1f36a4, ipp=ipp@entry=0xfffffe1f31c0) at util.c:525
>> #7 0x0000aaaaca988fac in parseproto (mp=0xfffffe1f36c8, pip=0x0, fsxp=0xfffffe1f36a4, pp=0xfffffe1f3370, name=0x0) at proto.c:552
>> #8 0x0000aaaaca9867a4 in main (argc=<optimized out>, argv=<optimized out>) at xfs_mkfs.c:4217
>>
>> (gdb) p bp
>> $1 = 0x0
>>
>> ```
>> void
>> xfs_log_sb(
>>         struct xfs_trans        *tp)
>> {
>>         // iscsi offline
>>         ...
>>         // failed to read sb, bp = NULL
>>         struct xfs_buf          *bp = xfs_trans_getsb(tp);
>>         ...
>> }
>> ```
>>
>> When writing data to sb, if the device is abnormal at this time,
>> the bp may be empty. Using it without checking will result in
>> a segfault.
> 
> xfs_trans_getsb() is not supposed to fail. In the kernel code (which
> this is a copy of) it can't fail because the superblock buffer is
> always pinned in memory at mount time and so is *never read from the
> storage* after mount.
> 
Thank you for your suggestion. Later, I will send a patch for the V2 patch.

Thanks,
Guanghao
> Hence something similar needs to be in userspace with libxfs_getsb()
> so that the superblock is only read when setting up the initial
> mount state in libxfs....
> 
>> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
>> index 6cac2531..73079df1 100644
>> --- a/libxfs/xfs_attr_leaf.c
>> +++ b/libxfs/xfs_attr_leaf.c
>> @@ -668,7 +668,7 @@ xfs_sbversion_add_attr2(
>>         spin_lock(&mp->m_sb_lock);
>>         xfs_add_attr2(mp);
>>         spin_unlock(&mp->m_sb_lock);
>> -       xfs_log_sb(tp);
>> +       ASSERT(!xfs_log_sb(tp));
> 
> FWIW, that's never a valid conversion nor a valid way to handle
> something that can fail. That turns the code into code that is only
> executed on debug builds, and it will panic the debug build rather
> than handle the error.....
> 
> -Dave.
> 
