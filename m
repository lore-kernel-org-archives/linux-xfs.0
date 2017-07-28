Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38713 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdG1GFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2017 02:05:54 -0400
Received: by mail-wr0-f194.google.com with SMTP id g32so8520097wrd.5
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 23:05:54 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
References: <20170718172545.18065-1-hch@lst.de>
 <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com>
 <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com>
 <20170720074706.GA22218@lst.de>
 <0eb47db7-24de-a231-be9f-73d9ae1171fd@gmail.com>
 <20170720074924.GA22278@lst.de>
 <16f95f63-1111-9d3c-344c-6b42ddab3b55@gmail.com>
 <20170726130442.GA24681@lst.de>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <dfaa4bb9-1915-c1c6-af7e-38cb2d9ad6b7@gmail.com>
Date: Fri, 28 Jul 2017 09:05:51 +0300
MIME-Version: 1.0
In-Reply-To: <20170726130442.GA24681@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org



On 26.07.2017 16:04, Christoph Hellwig wrote:
> On Thu, Jul 20, 2017 at 05:58:42PM +0300, Nikolay Borisov wrote:
>>
>>
>> On 20.07.2017 10:49, Christoph Hellwig wrote:
>>> On Thu, Jul 20, 2017 at 10:47:50AM +0300, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 20.07.2017 10:47, Christoph Hellwig wrote:
>>>>> Odd.  And the patch to always just process a single extent from
>>>>> xfs_itruncate_extents fixes the issue for you, right?
>>>>
>>>> As far as I remember yes.
>>>
>>> Can you retest it under otherwise identical conditions?
>>
>> Okay, I confirm that indeed changing the define from 2 to 1 fixes the
>> issue.
> 
> But this is just on 4.4 and older, right?  We had issues in the
> allocation path there as well, which should be fixed in 4.11 and later,
> and in recrnt 4.9-stable releases.  Without those the allocation path
> might sometimes lock out of order as well.
> 

Couldn't repro on 4.11 and 4.10 (which supposedly shouldn't have the
fixes). I tried running generic/299 200 times on each kernel. Which
exactly are the patches in 4.11 which fix the alloc path?

