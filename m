Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49323 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932643AbdDGLel (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 07:34:41 -0400
Subject: Re: [PATCH 7/8] nowait aio: xfs
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-8-rgoldwyn@suse.de>
 <20170404065211.GD21942@infradead.org>
 <20170406225415.GC4864@birch.djwong.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <6cc69b0c-7af4-879e-1012-aae8ba5358bd@suse.de>
Date: Fri, 7 Apr 2017 06:34:28 -0500
MIME-Version: 1.0
In-Reply-To: <20170406225415.GC4864@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 04/06/2017 05:54 PM, Darrick J. Wong wrote:
> On Mon, Apr 03, 2017 at 11:52:11PM -0700, Christoph Hellwig wrote:
>>> +	if (unaligned_io) {
>>> +		/* If we are going to wait for other DIO to finish, bail */
>>> +		if ((iocb->ki_flags & IOCB_NOWAIT) &&
>>> +		     atomic_read(&inode->i_dio_count))
>>> +			return -EAGAIN;
>>>  		inode_dio_wait(inode);
>>
>> This checks i_dio_count twice in the nowait case, I think it should be:
>>
>> 	if (iocb->ki_flags & IOCB_NOWAIT) {
>> 		if (atomic_read(&inode->i_dio_count))
>> 			return -EAGAIN;
>> 	} else {
>> 		inode_dio_wait(inode);
>> 	}
>>
>>>  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
>>>  		if (flags & IOMAP_DIRECT) {
>>> +			/* A reflinked inode will result in CoW alloc */
>>> +			if (flags & IOMAP_NOWAIT) {
>>> +				error = -EAGAIN;
>>> +				goto out_unlock;
>>> +			}
>>
>> This is a bit pessimistic - just because the inode has any shared
>> extents we could still write into unshared ones.  For now I think this
>> pessimistic check is fine, but the comment should be corrected.
> 
> Consider what happens in both _reflink_{allocate,reserve}_cow.  If there
> is already an existing reservation in the CoW fork then we'll have to
> CoW and therefore can't satisfy the NOWAIT flag.  If there isn't already
> anything in the CoW fork, then we have to see if there are shared blocks
> by calling _reflink_trim_around_shared.  That performs a refcountbt
> lookup, which involves locking the AGF, so we also can't satisfy NOWAIT.
> 
> IOWs, I think this hunk has to move outside the IOMAP_DIRECT check to
> cover both write-to-reflinked-file cases.
> 

IOMAP_NOWAIT is set only with IOMAP_DIRECT since the nowait feature is
for direct-IO only. This is checked early on, when we are checking for
user-passed flags, and if not, -EINVAL is returned.


-- 
Goldwyn
