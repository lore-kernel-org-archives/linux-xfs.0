Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750995AbdE3QNp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 May 2017 12:13:45 -0400
Subject: Re: [PATCH 09/10] xfs: nowait aio support
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-10-rgoldwyn@suse.de>
 <20170528093113.GB14519@infradead.org>
 <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
 <20170529083338.GC1899@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <f105d585-e88c-b037-9905-d0c608c609d9@suse.de>
Date: Tue, 30 May 2017 11:13:29 -0500
MIME-Version: 1.0
In-Reply-To: <20170529083338.GC1899@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 05/29/2017 03:33 AM, Christoph Hellwig wrote:
> On Sun, May 28, 2017 at 09:38:26PM -0500, Goldwyn Rodrigues wrote:
>>
>>
>> On 05/28/2017 04:31 AM, Christoph Hellwig wrote:
>>> Despite my previous reviewed-by tag this will need another fix:
>>>
>>> xfs_file_iomap_begin needs to return EAGAIN if we don't have the extent
>>> list in memoery already.  E.g. something like this:
>>>
>>> 	if ((flags & IOMAP_NOWAIT) && !(ip->i_d.if_flags & XFS_IFEXTENTS)) {
>>> 		error = -EAGAIN;
>>> 		goto out_unlock;
>>> 	}
>>>
>>> right after locking the ilock.
>>>
>>
>> I am not sure if it is right to penalize the application to write to
>> file which has been freshly opened (and is the first one to open). It
>> basically means extent maps needs to be read from disk. Do you see a
>> reason it would have a non-deterministic wait if it is the only user? I
>> understand the block layer can block if it has too many requests though.
> 
> For either a read or a write we might have to read in the extent list
> (note that for few enough extents they are stored in the inode and
> we won't have to), in which case the call will block and by the
> semantics you define we'll need to return -EAGAIN.

Yes, that is right. I will include it in.

> 
> Btw, can you write a small blurb up for the man page to document these
> ѕemantics in man-page like language?
> 

Yes, but which man page would it belong to?
Should it be a subsection of errors in io_getevents/io_submit. We don't
want to add ERRORS to io_getevents() because it would be the return
value of the io_getevents call, and not the ones in the iocb structure.
Should it be a new man page, say for iocb(7/8)?



-- 
Goldwyn
