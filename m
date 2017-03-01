Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750725AbdCARdu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 12:33:50 -0500
Subject: Re: [PATCH 1/8] nowait aio: Introduce IOCB_FLAG_NOWAIT
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-2-rgoldwyn@suse.de>
 <20170301153647.GA30631@infradead.org> <20170301155634.GA9630@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <cc3fc6ee-c48d-1b51-59b7-1e322d10a561@suse.de>
Date: Wed, 1 Mar 2017 10:57:17 -0600
MIME-Version: 1.0
In-Reply-To: <20170301155634.GA9630@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: jack@suse.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org



On 03/01/2017 09:56 AM, Christoph Hellwig wrote:
> On Wed, Mar 01, 2017 at 07:36:48AM -0800, Christoph Hellwig wrote:
>> Given that we aren't validating aio_flags in older kernels we can't
>> just add this flag as it will be a no-op in older kernels.  I think
>> we will have to add IOCB_CMD_PREADV2/IOCB_CMD_WRITEV2 opcodes that
>> properly validate all reserved fields or flags first.
>>
>> Once we do that I'd really prefer to use the same flags values
>> as preadv2/pwritev2 so that we'll only need one set of flags over
>> sync/async read/write ops.
> 
> I just took another look and we do verify that
> aio_reserved1/aio_reserved2 must be zero.  So I think we can just
> stick RWF_* into aio_reserved1 and fix that problem that way.
> 

RWF_* ? Isn't that kernel space flags? Or did you intend to say
IOCB_FLAG_*? If yes, we maintain two flag fields? aio_reserved1 (perhaps
renamed to aio_flags2) and aio_flags?

aio_reserved1 is also used to return key for the purpose of io_cancel,
but we should be able to fetch the flags before putting the key value
there. Still I am not comfortable using the same field for it because it
will be overwritten when io_submit returns.

Which brings me to the next question: What is the purpose of aio_key?
Why is aio_key set to KIOCB_KEY (which is zero) every time? You are not
differentiating the request by setting all the iocb's key to zero.


-- 
Goldwyn
