Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:50844 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752180AbdIRP27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:28:59 -0400
Received: by mail-io0-f171.google.com with SMTP id w94so2999719ioi.7
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 08:28:59 -0700 (PDT)
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
 fs/iomap.c:993
References: <1505746565.6990.18.camel@abdul.in.ibm.com>
 <20170918152706.GA11482@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
Date: Mon, 18 Sep 2017 09:28:55 -0600
MIME-Version: 1.0
In-Reply-To: <20170918152706.GA11482@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On 09/18/2017 09:27 AM, Christoph Hellwig wrote:
> On Mon, Sep 18, 2017 at 08:26:05PM +0530, Abdul Haleem wrote:
>> Hi,
>>
>> A warning is triggered from:
>>
>> file fs/iomap.c in function iomap_dio_rw
>>
>>     if (ret)
>>         goto out_free_dio;
>>
>>     ret = invalidate_inode_pages2_range(mapping,
>>             start >> PAGE_SHIFT, end >> PAGE_SHIFT);
>>>>  WARN_ON_ONCE(ret);
>>     ret = 0;
>>
>>     inode_dio_begin(inode);
> 
> This is expected and an indication of a problematic workload - which
> may be triggered by a fuzzer.

If it's expected, why don't we kill the WARN_ON_ONCE()? I get it all
the time running xfstests as well.

-- 
Jens Axboe

