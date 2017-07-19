Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34525 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754087AbdGSPJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 11:09:33 -0400
Received: by mail-wm0-f68.google.com with SMTP id p204so441156wmg.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2017 08:09:32 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
References: <20170718172545.18065-1-hch@lst.de>
 <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com>
Message-ID: <09500343-740e-0178-c60a-6ea5e6993c11@gmail.com>
Date: Wed, 19 Jul 2017 18:09:29 +0300
MIME-Version: 1.0
In-Reply-To: <ac50dda7-6147-1bb2-78ed-b49dafaec242@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org



On 19.07.2017 16:11, Nikolay Borisov wrote:
> 
> 
> On 18.07.2017 20:25, Christoph Hellwig wrote:
>> Just like in the allocator we must avoid touching multiple AGs out of
>> order when freeing blocks, as freeing still locks the AGF and can cause
>> the same AB-BA deadlocks as in the allocation path.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.d> Reported-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
> 
> Unfortunately I this patch is not enough. I just tested on a 3.12 kernel ( the issue was easiest to repro there) 
> and I still get stack traces. I will also test on a 4.4-based kernel as well but I assume the results are going to
> be the same. 

I can confirm that on 4.4 I also hit the same deadlock. So this patch is
not sufficient.
