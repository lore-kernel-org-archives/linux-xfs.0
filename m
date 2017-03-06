Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37683 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753636AbdCFQJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 11:09:01 -0500
Received: by mail-it0-f48.google.com with SMTP id 203so53068148ith.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2017 08:09:00 -0800 (PST)
Subject: Re: [PATCH 0/8 v2] Non-blocking AIO
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
 <20170306082546.GA14932@quack2.suse.cz>
 <d0789835-5bae-6f99-af4d-c0e60eadbab7@kernel.dk>
 <9b64c78e-c984-cf29-8f79-c48332a4c450@scylladb.com>
 <57c873b2-fed6-e717-fc4e-ed2e328173b6@kernel.dk>
 <c8c3cede-d69a-a47a-0b08-85072b386d77@scylladb.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f1415241-ddd0-8918-4a68-c5e1adf06e09@kernel.dk>
Date: Mon, 6 Mar 2017 09:08:57 -0700
MIME-Version: 1.0
In-Reply-To: <c8c3cede-d69a-a47a-0b08-85072b386d77@scylladb.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>, Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On 03/06/2017 08:59 AM, Avi Kivity wrote:
> On 03/06/2017 05:38 PM, Jens Axboe wrote:
>> On 03/06/2017 08:29 AM, Avi Kivity wrote:
>>>
>>> On 03/06/2017 05:19 PM, Jens Axboe wrote:
>>>> On 03/06/2017 01:25 AM, Jan Kara wrote:
>>>>> On Sun 05-03-17 16:56:21, Avi Kivity wrote:
>>>>>>> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
>>>>>>> any of these conditions are met. This way userspace can push most
>>>>>>> of the write()s to the kernel to the best of its ability to complete
>>>>>>> and if it returns -EAGAIN, can defer it to another thread.
>>>>>>>
>>>>>> Is it not possible to push the iocb to a workqueue?  This will allow
>>>>>> existing userspace to work with the new functionality, unchanged. Any
>>>>>> userspace implementation would have to do the same thing, so it's not like
>>>>>> we're saving anything by pushing it there.
>>>>> That is not easy because until IO is fully submitted, you need some parts
>>>>> of the context of the process which submits the IO (e.g. memory mappings,
>>>>> but possibly also other credentials). So you would need to somehow transfer
>>>>> this information to the workqueue.
>>>> Outside of technical challenges, the API also needs to return EAGAIN or
>>>> start blocking at some point. We can't expose a direct connection to
>>>> queue work like that, and let any user potentially create millions of
>>>> pending work items (and IOs).
>>> You wouldn't expect more concurrent events than the maxevents parameter
>>> that was supplied to io_setup syscall; it should have reserved any
>>> resources needed.
>> Doesn't matter what limit you apply, my point still stands - at some
>> point you have to return EAGAIN, or block. Returning EAGAIN without
>> the caller having flagged support for that change of behavior would
>> be problematic.
> 
> Doesn't it already return EAGAIN (or some other error) if you exceed 
> maxevents?

It's a setup thing. We check these limits when someone creates an IO
context, and carve out the specified entries form our global pool. Then
we free those "resources" when the io context is freed.

Right now I can setup an IO context with 1000 entries on it, yet that
number has NO bearing on when io_submit() would potentially block or
return EAGAIN.

We can have a huge gap on the intent signaled by io context setup, and
the reality imposed by what actually happens on the IO submission side.

-- 
Jens Axboe

