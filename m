Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfGINwd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jul 2019 09:52:33 -0400
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing
 case
References: <20190703075502.79782-1-yuchao0@huawei.com>
 <20190708160346.GA17715@infradead.org>
From: Chao Yu <chao@kernel.org>
Message-ID: <1c3f46ba-c1e4-3177-d77e-627995bc8f21@kernel.org>
Date: Tue, 9 Jul 2019 21:52:27 +0800
MIME-Version: 1.0
In-Reply-To: <20190708160346.GA17715@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: andreas.gruenbacher@gmail.com
Cc: Christoph Hellwig <hch@infradead.org>, Chao Yu <yuchao0@huawei.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, gaoxiang25@huawei.com

On 2019-7-9 0:03, Christoph Hellwig wrote:
> On Wed, Jul 03, 2019 at 03:55:02PM +0800, Chao Yu wrote:
>> Some filesystems like erofs/reiserfs have the ability to pack tail
>> data into metadata, e.g.:
>> IOMAP_MAPPED [0, 8192]
>> IOMAP_INLINE [8192, 8200]
>>
>> However current IOMAP_INLINE type has assumption that:
>> - inline data should be locating at page #0.
>> - inline size should equal to .i_size
>> Those restriction fail to convert to use iomap IOMAP_INLINE in erofs,
>> so this patch tries to relieve above limits to make IOMAP_INLINE more
>> generic to cover tail-packing case.
>>
>> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> 
> This looks good to me, but I'd also like to see a review and gfs2
> testing from Andreas.

Thanks for your reply. :)

Well, so, Andreas, could you please take a look at this patch and do related
test on gfs2 if you have time?

Thanks,

> 
