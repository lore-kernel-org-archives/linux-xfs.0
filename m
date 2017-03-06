Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36448 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753485AbdCFPjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 10:39:14 -0500
Received: by mail-it0-f48.google.com with SMTP id h10so51464866ith.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2017 07:38:20 -0800 (PST)
Subject: Re: [PATCH 0/8 v2] Non-blocking AIO
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
 <20170306082546.GA14932@quack2.suse.cz>
 <d0789835-5bae-6f99-af4d-c0e60eadbab7@kernel.dk>
 <9b64c78e-c984-cf29-8f79-c48332a4c450@scylladb.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57c873b2-fed6-e717-fc4e-ed2e328173b6@kernel.dk>
Date: Mon, 6 Mar 2017 08:38:18 -0700
MIME-Version: 1.0
In-Reply-To: <9b64c78e-c984-cf29-8f79-c48332a4c450@scylladb.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>, Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On 03/06/2017 08:29 AM, Avi Kivity wrote:
> 
> 
> On 03/06/2017 05:19 PM, Jens Axboe wrote:
>> On 03/06/2017 01:25 AM, Jan Kara wrote:
>>> On Sun 05-03-17 16:56:21, Avi Kivity wrote:
>>>>> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
>>>>> any of these conditions are met. This way userspace can push most
>>>>> of the write()s to the kernel to the best of its ability to complete
>>>>> and if it returns -EAGAIN, can defer it to another thread.
>>>>>
>>>> Is it not possible to push the iocb to a workqueue?  This will allow
>>>> existing userspace to work with the new functionality, unchanged. Any
>>>> userspace implementation would have to do the same thing, so it's not like
>>>> we're saving anything by pushing it there.
>>> That is not easy because until IO is fully submitted, you need some parts
>>> of the context of the process which submits the IO (e.g. memory mappings,
>>> but possibly also other credentials). So you would need to somehow transfer
>>> this information to the workqueue.
>> Outside of technical challenges, the API also needs to return EAGAIN or
>> start blocking at some point. We can't expose a direct connection to
>> queue work like that, and let any user potentially create millions of
>> pending work items (and IOs).
> 
> You wouldn't expect more concurrent events than the maxevents parameter 
> that was supplied to io_setup syscall; it should have reserved any 
> resources needed.

Doesn't matter what limit you apply, my point still stands - at some
point you have to return EAGAIN, or block. Returning EAGAIN without
the caller having flagged support for that change of behavior would
be problematic.

And for this to really work, aio would need some serious help in
how it applies limits. It looks like a hot mess.

-- 
Jens Axboe

