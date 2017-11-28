Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750842AbdK1Gqa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 01:46:30 -0500
Subject: Re: [PATCH] xfs: Don't trim file extents during iomap
References: <1511437203-4329-1-git-send-email-nborisov@suse.com>
 <20171127174434.GB19379@magnolia> <20171128014746.GC21412@magnolia>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <154aef58-7f5a-9e69-f33c-2cff22efb009@suse.com>
Date: Tue, 28 Nov 2017 08:46:27 +0200
MIME-Version: 1.0
In-Reply-To: <20171128014746.GC21412@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, sandeen@redhat.com



On 28.11.2017 03:47, Darrick J. Wong wrote:
> On Mon, Nov 27, 2017 at 09:44:34AM -0800, Darrick J. Wong wrote:
>> On Thu, Nov 23, 2017 at 01:40:03PM +0200, Nikolay Borisov wrote:
>>> For file extents xfs currently calls xfs_bmapi_read with flag set to 0,
>>> meaning extents are going to be truncated to the requested range. Since the
>>> same codepath is used for fiemap this means xfs is special in that regard, since
>>> other filesystems (ext4/btrfs) do not trim extents for fiemap. Make the behavior
>>> consistent by always passing XFS_BMAPI_ENTIRE. A full xfstest run validated that
>>> this doesn't regress on ordinary read/write IO.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>
>> Looks ok, will also test...
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ...and now withdrawn.
> 
> Looking at iomap_apply, it seems we call ->iomap_begin, and at line 73 we
> trim an iomap that is longer than the range we requested:
> 
> /*
>  * Cut down the length to the one actually provided by the filesystem,
>  * as it might not be able to give us the whole size that we requested.
>  */
> if (iomap.offset + iomap.length < pos + length)
> 	length = iomap.offset + iomap.length - pos;
> 
> However, we do not trim the beginning off an iomap that starts before
> the 'pos' we passed to ->iomap_begin, so we're left with an iomap that
> can begin before the range.
> 
> FWIW I ran xfstests (like I told you to on IRC) and saw regressions
> in a whole bunch of tests:
> 
> generic/170 generic/287 generic/295 generic/326 generic/330 generic/333
> generic/372 xfs/214 xfs/237 xfs/249 xfs/258 xfs/346 xfs/420 xfs/421
> 
> From a brief glance it looks as though most of the iomap_apply'ers
> try to trim the iomap before using it, but clearly there's something
> wrong here.

Strange, I didn't see those failures o_O. Anyways, how about using
XFS_BMAPI_ENTIRE in case when IOMAP_REPORT is passed i.e the first
iteration of this patch.

> 
> --D
> 
>>
>>> ---
>>>  fs/xfs/xfs_iomap.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>>> index f179bdf1644d..8942324a4d3d 100644
>>> --- a/fs/xfs/xfs_iomap.c
>>> +++ b/fs/xfs/xfs_iomap.c
>>> @@ -1008,7 +1008,7 @@ xfs_file_iomap_begin(
>>>  	end_fsb = XFS_B_TO_FSB(mp, offset + length);
>>>  
>>>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
>>> -			       &nimaps, 0);
>>> +			       &nimaps, XFS_BMAPI_ENTIRE);
>>>  	if (error)
>>>  		goto out_unlock;
>>>  
>>> -- 
>>> 2.7.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
