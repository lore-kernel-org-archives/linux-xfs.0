Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933086AbdBPUoX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Feb 2017 15:44:23 -0500
Subject: Re: [PATCH 6/7] nonblocking aio: xfs
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-7-rgoldwyn@suse.de>
 <20170214074326.GA20629@infradead.org>
 <9859c328-263a-e4eb-22f6-20cdda821654@suse.de>
 <be95fe38-ddbe-427e-df7f-7b54fe3b02a6@suse.de>
 <20170216202141.GA18385@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <a103fced-34bf-c072-eb86-8e47d45259e3@suse.de>
Date: Thu, 16 Feb 2017 14:44:17 -0600
MIME-Version: 1.0
In-Reply-To: <20170216202141.GA18385@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org



On 02/16/2017 02:21 PM, Christoph Hellwig wrote:
> On Wed, Feb 15, 2017 at 10:11:38AM -0600, Goldwyn Rodrigues wrote:
>>> I did not understand short writes. Where can I
>>> get a short write?
> 
> If you have a write request of N bytes, and you've already wrіtten
> M of them you return M from the *write system call instead of -EAGAIN.
> This is standard practice on e.g. sockets.

Oh, I assume that would be taken care of in the existing code, at least
with the modified patch. I will double check that anyways.

> 
>>>
>>> If I understand correctly, we do add the flag.
>>
>> Replying to myself to correct myself.
>>
>> On reading a bit more, I figured that we perform
>> xfs_file_iomap_begin->xfs_iomap_write_direct. At this point we have
>> already performed xfs_bmapi_read(). So, a check in xfs_file_iomap_begin
>> should be good enough. So, the flag required would be with iomap flags,
>> say IOMAP_NONBLOCKING. IOW, we don't need to go all the way to
>> xfs_bmap_write() and return when imap.br_startblock == HOLESTARTBLOCK.
> 
> Yes, except that reflinked files with shared extents will also need
> some additional special casing - for those xfs_bmapi_read can return
> an allocated extent, but we might still have to perform a block
> allocation for a write.
> 

Yes, I forgot that. I will put in a check for reflinks as well.

-- 
Goldwyn
