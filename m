Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:37756 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdIEPA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 11:00:29 -0400
Received: by mail-io0-f182.google.com with SMTP id j141so13278159ioj.4
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2017 08:00:29 -0700 (PDT)
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
 <20170905063139.GA679@infradead.org> <20170905064208.GB15686@vader>
 <2656563.n056MvCHVb@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <89dbce28-5798-f404-4dc8-a85aae36cdec@kernel.dk>
Date: Tue, 5 Sep 2017 09:00:26 -0600
MIME-Version: 1.0
In-Reply-To: <2656563.n056MvCHVb@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Omar Sandoval <osandov@osandov.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, sandeen@sandeen.net, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org

On 09/05/2017 01:37 AM, Chandan Rajendra wrote:
> On Tuesday, September 5, 2017 12:12:08 PM IST Omar Sandoval wrote:
>> On Mon, Sep 04, 2017 at 11:31:39PM -0700, Christoph Hellwig wrote:
>>> On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
>>>> Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
>>>> physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
>>>> physical sector size of loop devices. On ppc64, this causes loop devices
>>>> to have 64k as the physical sector size.
>>>
>>> Eek.  We'll need to revert the loop change ASAP!
>>
>> Most annoying patch series ever. It hasn't made it to Linus' tree yet,
>> right? We can revert (although the later change depends on that), fold
>> in a fix, or apply a fix on top of it, whatever Jens prefers.
>>
>>
> 
> My bad. 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 is the commit id from 
> Linux-next. I don't see this commit in Linus's git tree.

Right, it's only queued up, and scheduled for the 2nd part of the
block changes for 4.14. It should have been PAGE_CACHE_SIZE, but
we don't have that anymore...

Omar, are you sending a patch to fix this up?

-- 
Jens Axboe

