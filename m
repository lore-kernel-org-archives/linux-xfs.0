Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49896 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbfFYDFy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 23:05:54 -0400
Subject: Re: [PATCH 2/2] xfs: convert extents in place for ZERO_RANGE
References: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
 <25a2ebbc-0ec9-f5dd-eba0-4101c80837dd@sandeen.net>
 <20190625023954.GF7777@dread.disaster.area>
 <2b135e00-3bfd-f41a-7c43-a0518fc756fe@sandeen.net>
 <20190625030018.GC5387@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3f8037f0-08ff-98b2-6995-230e7bf33372@sandeen.net>
Date: Mon, 24 Jun 2019 22:05:51 -0500
MIME-Version: 1.0
In-Reply-To: <20190625030018.GC5387@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 6/24/19 10:00 PM, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 09:52:03PM -0500, Eric Sandeen wrote:
>> On 6/24/19 9:39 PM, Dave Chinner wrote:
>>> On Mon, Jun 24, 2019 at 07:48:11PM -0500, Eric Sandeen wrote:
>>>> Rather than completely removing and re-allocating a range
>>>> during ZERO_RANGE fallocate calls, convert whole blocks in the
>>>> range using xfs_alloc_file_space(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)
>>>> and then zero the edges with xfs_zero_range()
>>>
>>> That's what I originally used to implement ZERO_RANGE and that
>>> had problems with zeroing the partial blocks either side and
>>> unexpected inode size changes. See commit:
>>>
>>> 5d11fb4b9a1d xfs: rework zero range to prevent invalid i_size updates
>>
>> Yep I did see that.  It had a lot of hand-rolled partial block stuff
>> that seems more complex than this, no?  That commit didn't indicate
>> what the root cause of the failure actually was, AFAICT.
>>
>> (funny thought that I skimmed that commit just to see why we had
>> what we have, but didn't really intentionally re-implement it...
>> even though I guess I almost did...)
> 
> FWIW the complaint I had about the fragmentary behavior really only
> applied to fun and games when one fallocated an ext4 image and then ran
> mkfs.ext4 which uses zero range which fragmented the image...
> 
>>> I also remember discussion about zero range being inefficient on
>>> sparse files and fragmented files - the current implementation
>>> effectively defragments such files, whilst using XFS_BMAPI_CONVERT
>>> just leaves all the fragments behind.
>>
>> That's true - and it fragments unfragmented files.  Is ZERO_RANGE
>> supposed to be a defragmenter?
> 
> ...so please remember, the key point we were talking about when we
> discussed this a year ago was that if the /entire/ zero range maps to a
> single extent within eof then maybe we ought to just convert it to
> unwritten.

I remember you mentioning that, but honestly it seems like
overcomplication to say "ZERO_RANGE will also defragment extents
in the process, if it can..."

> Note also that for pmem there's a slightly different optimization --
> if the entire range is mapped by written extents (not necessarily
> contiguous, just no holes/cow/delalloc/unwritten bits) then we can use
> blkdev_issue_zeroout to zero memory and clear hwpoison cheaply.
> 
>>>> (Note that this changes the rounding direction of the
>>>> xfs_alloc_file_space range, because we only want to hit whole
>>>> blocks within the range.)
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>
>>>> <currently running fsx ad infinitum, so far so good>
>>
>> <still running, so far so good (4k blocks)>
>>
>>>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>>>> index 0a96c4d1718e..eae202bfe134 100644
>>>> --- a/fs/xfs/xfs_bmap_util.c
>>>> +++ b/fs/xfs/xfs_bmap_util.c
>>>> @@ -1164,23 +1164,25 @@ xfs_zero_file_space(
>>>>  
>>>>  	blksize = 1 << mp->m_sb.sb_blocklog;
>>>>  
>>>> +	error = xfs_flush_unmap_range(ip, offset, len);
>>>> +	if (error)
>>>> +		return error;
>>>>  	/*
>>>> -	 * Punch a hole and prealloc the range. We use hole punch rather than
>>>> -	 * unwritten extent conversion for two reasons:
>>>> -	 *
>>>> -	 * 1.) Hole punch handles partial block zeroing for us.
>>>> -	 *
>>>> -	 * 2.) If prealloc returns ENOSPC, the file range is still zero-valued
>>>> -	 * by virtue of the hole punch.
>>>> +	 * Convert whole blocks in the range to unwritten, then call iomap
>>>> +	 * via xfs_zero_range to zero the range.  iomap will skip holes and
>>>> +	 * unwritten extents, and just zero the edges if needed.  If conversion
>>>> +	 * fails, iomap will simply write zeros to the whole range.
>>>> +	 * nb: always_cow doesn't support unwritten extents.
>>>>  	 */
>>>> -	error = xfs_free_file_space(ip, offset, len);
>>>> -	if (error || xfs_is_always_cow_inode(ip))
>>>> -		return error;
>>>> +	if (!xfs_is_always_cow_inode(ip))
>>>> +		xfs_alloc_file_space(ip, round_up(offset, blksize),
>>>> +				     round_down(offset + len, blksize) -
>>>> +				     round_up(offset, blksize),
>>>> +				     XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT);
>>>
>>> If this fails with, say, corruption we should abort with an error,
>>> not ignore it. I think we can only safely ignore ENOSPC and maybe
>>> EDQUOT here...
>>
>> Yes, I suppose so, though if this encounters corruption I'd guess
>> xfs_zero_range probably would as well but that's just handwaving.
> 
> <nod>
> 
>>>> -	return xfs_alloc_file_space(ip, round_down(offset, blksize),
>>>> -				     round_up(offset + len, blksize) -
>>>> -				     round_down(offset, blksize),
>>>> -				     XFS_BMAPI_PREALLOC);
>>>> +	error = xfs_zero_range(ip, offset, len);
>>>
>>> What prevents xfs_zero_range() from changing the file size if
>>> offset + len is beyond EOF and there are allocated extents (from
>>> delalloc conversion) beyond EOF? (i.e. FALLOC_FL_KEEP_SIZE is set by
>>> the caller).
>>
>> nothing, but AFAIK it does the same today... even w/o extents past
>> EOF:
>>
>> $ xfs_io -f -c "truncate 0" -c "fzero 0 1m" testfile
> 
> fzero -k ?

$ xfs_io -f -c "truncate 0" -c "fzero -k 0 1m" testfile

$ ls -lh testfile
-rw-------. 1 sandeen sandeen 0 Jun 24 22:02 testfile

with or without my patches.

(with or without it also seems to allocate 1M past EOF...)

-Eric
