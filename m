Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37454 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754206AbdCFPZj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 10:25:39 -0500
Received: by mail-it0-f46.google.com with SMTP id 203so52112804ith.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2017 07:25:38 -0800 (PST)
Subject: Re: [PATCH 0/8 v2] Non-blocking AIO
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
 <20170306082546.GA14932@quack2.suse.cz>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d0789835-5bae-6f99-af4d-c0e60eadbab7@kernel.dk>
Date: Mon, 6 Mar 2017 08:19:14 -0700
MIME-Version: 1.0
In-Reply-To: <20170306082546.GA14932@quack2.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, Avi Kivity <avi@scylladb.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On 03/06/2017 01:25 AM, Jan Kara wrote:
> On Sun 05-03-17 16:56:21, Avi Kivity wrote:
>>> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
>>> any of these conditions are met. This way userspace can push most
>>> of the write()s to the kernel to the best of its ability to complete
>>> and if it returns -EAGAIN, can defer it to another thread.
>>>
>>
>> Is it not possible to push the iocb to a workqueue?  This will allow
>> existing userspace to work with the new functionality, unchanged. Any
>> userspace implementation would have to do the same thing, so it's not like
>> we're saving anything by pushing it there.
> 
> That is not easy because until IO is fully submitted, you need some parts
> of the context of the process which submits the IO (e.g. memory mappings,
> but possibly also other credentials). So you would need to somehow transfer
> this information to the workqueue.

Outside of technical challenges, the API also needs to return EAGAIN or
start blocking at some point. We can't expose a direct connection to
queue work like that, and let any user potentially create millions of
pending work items (and IOs). That's why the current API is safe, even
though it does suck that it block seemingly randomly for users.

-- 
Jens Axboe

