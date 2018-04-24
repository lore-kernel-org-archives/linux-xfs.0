Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:43012 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbeDXWRP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 18:17:15 -0400
Subject: Re: [PATCH 4/4] iomap: Use FUA for pure data O_DSYNC DIO writes
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-5-david@fromorbit.com>
 <20180421125405.hyx3bbkohdgvducq@quack2.suse.cz>
 <20180424173444.GA25233@infradead.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <2fb29b95-a39d-3ee7-249b-86614a8dcbb4@applied-asynchrony.com>
Date: Wed, 25 Apr 2018 00:07:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180424173444.GA25233@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On 04/24/18 19:34, Christoph Hellwig wrote:
> On Sat, Apr 21, 2018 at 02:54:05PM +0200, Jan Kara wrote:
>>> -		if (iocb->ki_flags & IOCB_DSYNC)
>>> +		if (iocb->ki_flags & IOCB_DSYNC) {
>>>   			dio->flags |= IOMAP_DIO_NEED_SYNC;
>>> +			/*
>>> +			 * We optimistically try using FUA for this IO.  Any
>>> +			 * non-FUA write that occurs will clear this flag, hence
>>> +			 * we know before completion whether a cache flush is
>>> +			 * necessary.
>>> +			 */
>>> +			dio->flags |= IOMAP_DIO_WRITE_FUA;
>>> +		}
>>
>> So I don't think this is quite correct. IOCB_DSYNC gets set also for O_SYNC
>> writes (in that case we also set IOCB_SYNC). And for those we cannot use
>> the FUA optimization AFAICT (definitely IOMAP_F_DIRTY isn't a safe
>> indicator of a need of full fsync for O_SYNC). Other than that the patch
>> looks good to me.
> 
> Oops, good catch. I think the above if should just be
> 
> 		if (iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC) == IOCB_DSYNC)) {
> 
> and we are fine.

The above line just gives parenthesis salad errors, so why not compromise
on:

	if ((iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC)) == IOCB_DSYNC) {

Unless my bit twiddling has completely left me I think this is what was
intended, and it actually compiles too.

cheers
Holger
