Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84634C77B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 02:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEYCQ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 22:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbjEYCQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 22:16:28 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EA9910C9
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 19:16:01 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPS id E468C5CC303;
        Wed, 24 May 2023 21:15:55 -0500 (CDT)
Message-ID: <3ec12fb5-dd30-be04-531e-3b6443f261ab@sandeen.net>
Date:   Wed, 24 May 2023 21:15:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: Corruption of in-memory data (0x8) detected at
 xfs_defer_finish_noroll on kernel 6.3
Content-Language: en-US
To:     Mike Pastore <mike@oobak.org>, linux-xfs@vger.kernel.org
References: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/2/23 2:14 PM, Mike Pastore wrote:
> Hi folks,
> 
> I was playing around with some blockchain projects yesterday and had
> some curious crashes while syncing blockchain databases on XFS
> filesystems under kernel 6.3.
> 
>    * kernel 6.3.0 and 6.3.1 (ubuntu mainline)
>    * w/ and w/o the discard mount flag
>    * w/ and w/o -m crc=0
>    * ironfish (nodejs) and ergo (jvm)
> 
> The hardware is as follows:
> 
>    * Asus PRIME H670-PLUS D4
>    * Intel Core i5-12400
>    * 32GB DDR4-3200 Non-ECC UDIMM
> 
> In all cases the filesystems were newly-created under kernel 6.3 on an
> LVM2 stripe and mounted with the noatime flag. Here is the output of
> the mkfs.xfs command (after reverting back to 6.2.14—which I realize
> may not be the most helpful thing, but here it is anyway):
> 
> $ sudo lvremove -f vgtethys/ironfish
> $ sudo lvcreate -n ironfish-L 10G -i2 vgtethys /dev/nvme[12]n1p3
>    Using default stripesize 64.00 KiB.
>    Logical volume "ironfish" created.
> $ sudo mkfs.xfs -m crc=0 -m uuid=b4725d43-a12d-42df-981a-346af2809fad
> -s size=4096 /dev/vgtethys/ironfish
> meta-data=/dev/vgtethys/ironfish isize=256    agcount=16, agsize=163824 blks
>           =                       sectsz=4096  attr=2, projid32bit=1
>           =                       crc=0        finobt=0, sparse=0, rmapbt=0
>           =                       reflink=0    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=2621184, imaxpct=25
>           =                       sunit=16     swidth=32 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Discarding blocks...Done.
> 
> The applications crash with I/O errors. Here's what I see in dmesg:
> 
> May 01 18:56:59 tethys kernel: XFS (dm-28): Internal error bno + len >
> gtbno at line 1908 of file fs/xfs/libxfs/xfs_alloc.c.  Caller
> xfs_free_ag_extent+0x14e/0x950 [xfs]
> May 01 18:56:59 tethys kernel: CPU: 2 PID: 48657 Comm: node Tainted: P

What proprietary module do you have loaded?

Does the problem reproduce without it?

-Eric
