Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdBOPaW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 10:30:22 -0500
Subject: Re: [PATCH 6/7] nonblocking aio: xfs
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-7-rgoldwyn@suse.de>
 <20170214074326.GA20629@infradead.org>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <9859c328-263a-e4eb-22f6-20cdda821654@suse.de>
Date: Wed, 15 Feb 2017 09:30:18 -0600
MIME-Version: 1.0
In-Reply-To: <20170214074326.GA20629@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org



On 02/14/2017 01:43 AM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2017 at 08:46:02PM -0600, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Please Cc the while series to all lists, otherwiwe it's impossible
> to review the thing.
> 
>>
>> If IOCB_NONBLOCKING is set:
>> 	+ Check if writing beyond end of file, if yes return EAGAIN
>> 	- check if writing to a hole which does not have allocated
>> 	  file blocks.
>> 	- Check if i_rwsem is immediately lockable in xfs_rw_ilock()
> 
> Why the + vs - above? 

A mistake. It does not mean anything besides bullets.

> 
>> -static inline void
>> +static inline int
>>  xfs_rw_ilock(
> 
> This function has been removed a while ago.

And thanks for putting in xfs_ilock_nowait(). This can't be done in a
cleaner way. I was very skeptical of adding yet another flag.

> 
>>  
>> +	if (iocb->ki_flags & IOCB_NONBLOCKING) {
>> +		struct xfs_bmbt_irec	imap;
>> +		xfs_fileoff_t           offset_fsb, end_fsb;
>> +		int			nimaps = 1, ret = 0;
>> +		end_fsb = XFS_B_TO_FSB(ip->i_mount, iocb->ki_pos + count);
>> +		if (XFS_B_TO_FSB(ip->i_mount, i_size_read(inode)) < end_fsb)
>> +			return -EAGAIN;
> 
> Bogus check, XFS supports async write beyond EOF if the space is
> preallocated.

I assume this will be covered by xfs_bmapi_write().

> 
>> +		/* Check if it is an unallocated hole */
>> +		offset_fsb = XFS_B_TO_FSBT(ip->i_mount, iocb->ki_pos);
>> +
>> +		ret = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
>> +				&nimaps, 0);
>> +		if (ret)
>> +			return ret;
>> +		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK)
>> +			return -EAGAIN;
> 
> This would need the ilock.  But extent list lookups are expensive,
> so please don't add another one here.  Just return when we hit the
> first unallocated extent in xfs_bmapi_write - either a short write or
> -EAGAIN if nothing has been written.

So in xfs_bmapi_write (and referring to), I would need a new flag, say
XFS_BMAPI_NOALLOC which would bail to error0, setting error=-EAGAIN if
need_alloc or was_delay is set. This flag XFS_BMAPI_NOALLOC is set in
xfs_iomap_write_direct(). I did not understand short writes. Where can I
get a short write?

If I understand correctly, we do add the flag.

> 
>>  	error = xfs_break_layouts(inode, iolock, true);
>>  	if (error)
>>  		return error;
> 
> Additionally this can drop the iolock, so you might get a new
> hole after it.
> 

-- 
Goldwyn
