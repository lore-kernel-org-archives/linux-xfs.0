Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43990 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728014AbfHABhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:37:13 -0400
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
 <20190731203324.7vjwlejmwpghpvqi@fiona>
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <800ff77a-7cd1-5fa1-fcf7-e41264a3f189@cn.fujitsu.com>
Date: Thu, 1 Aug 2019 09:37:04 +0800
MIME-Version: 1.0
In-Reply-To: <20190731203324.7vjwlejmwpghpvqi@fiona>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, gujx@cn.fujitsu.com, david@fromorbit.com, qi.fuli@fujitsu.com, caoj.fnst@cn.fujitsu.com



On 8/1/19 4:33 AM, Goldwyn Rodrigues wrote:
> On 19:49 31/07, Shiyang Ruan wrote:
>> This patchset aims to take care of this issue to make reflink and dedupe
>> work correctly in XFS.
>>
>> It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and "Btrfs
>> iomap".  I picked up some patches related and made a few fix to make it
>> basically works fine.
>>
>> For dax framework:
>>    1. adapt to the latest change in iomap.
>>
>> For XFS:
>>    1. report the source address and set IOMAP_COW type for those write
>>       operations that need COW.
>>    2. update extent list at the end.
>>    3. add file contents comparison function based on dax framework.
>>    4. use xfs_break_layouts() to support dax.
> 
> Shiyang,
> 
> I think you used the older patches which does not contain the iomap changes
> which would call iomap_begin() with two iomaps. I have it in the btrfs-iomap

Oh, Sorry for my carelessness.  This patchset is built on your "Btrfs 
iomap".  I didn't point it out in cover letter.

> branch and plan to update it today. It is built on v5.3-rcX, so it should
> contain the changes which moves the iomap code to the different directory.
> I will build the dax patches on top of that.
> However, we are making a big dependency chain here 
Don't worry.  It's fine for me.  I'll follow your updates.

> 

-- 
Thanks,
Shiyang Ruan.
