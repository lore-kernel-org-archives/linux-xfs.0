Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:32924 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932371AbdCFP3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 10:29:46 -0500
Received: by mail-wr0-f172.google.com with SMTP id u48so119238211wrc.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2017 07:29:45 -0800 (PST)
Subject: Re: [PATCH 0/8 v2] Non-blocking AIO
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
 <20170306082546.GA14932@quack2.suse.cz>
 <d0789835-5bae-6f99-af4d-c0e60eadbab7@kernel.dk>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <9b64c78e-c984-cf29-8f79-c48332a4c450@scylladb.com>
Date: Mon, 6 Mar 2017 17:29:41 +0200
MIME-Version: 1.0
In-Reply-To: <d0789835-5bae-6f99-af4d-c0e60eadbab7@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org



On 03/06/2017 05:19 PM, Jens Axboe wrote:
> On 03/06/2017 01:25 AM, Jan Kara wrote:
>> On Sun 05-03-17 16:56:21, Avi Kivity wrote:
>>>> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
>>>> any of these conditions are met. This way userspace can push most
>>>> of the write()s to the kernel to the best of its ability to complete
>>>> and if it returns -EAGAIN, can defer it to another thread.
>>>>
>>> Is it not possible to push the iocb to a workqueue?  This will allow
>>> existing userspace to work with the new functionality, unchanged. Any
>>> userspace implementation would have to do the same thing, so it's not like
>>> we're saving anything by pushing it there.
>> That is not easy because until IO is fully submitted, you need some parts
>> of the context of the process which submits the IO (e.g. memory mappings,
>> but possibly also other credentials). So you would need to somehow transfer
>> this information to the workqueue.
> Outside of technical challenges, the API also needs to return EAGAIN or
> start blocking at some point. We can't expose a direct connection to
> queue work like that, and let any user potentially create millions of
> pending work items (and IOs).

You wouldn't expect more concurrent events than the maxevents parameter 
that was supplied to io_setup syscall; it should have reserved any 
resources needed.

>   That's why the current API is safe, even
> though it does suck that it block seemingly randomly for users.

