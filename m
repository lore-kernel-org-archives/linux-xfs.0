Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751146AbcLLWd0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Dec 2016 17:33:26 -0500
Subject: Re: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
References: <4348f961-deda-8733-1cd7-dd7ca646bb6b@redhat.com>
 <20161212221442.GY4326@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5721b5ad-11e0-e016-22b6-3ca5fc1144fb@redhat.com>
Date: Mon, 12 Dec 2016 16:33:25 -0600
MIME-Version: 1.0
In-Reply-To: <20161212221442.GY4326@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jason L Tibbitts III <tibbs@math.uh.edu>

On 12/12/16 4:14 PM, Dave Chinner wrote:
> On Mon, Dec 12, 2016 at 04:00:26PM -0600, Eric Sandeen wrote:
>> Jason reported that a corrupted filesystem failed to replay
>> the log with a metadata block out of bounds warning:
>>
>> XFS (dm-2): _xfs_buf_find: Block out of range: block 0x80270fff8, EOFS 0x9c40000 
>>
>> _xfs_buf_find() and xfs_btree_get_bufs() return NULL if
>> that happens, and then when xfs_alloc_fix_freelist() calls
>> xfs_trans_binval() on that NULL bp, we oops with:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
>>
>> We don't handle _xfs_buf_find errors very well, every
>> caller higher up the stack gets to guess at why it failed.
>> But we should at least handle it somehow.  I chose EIO here
>> for lack of a better idea.  :)
>>
>> Reported-by: Jason L Tibbitts III <tibbs@math.uh.edu>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index effb64c..d125135 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -1640,6 +1640,10 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
>>  
>>  				bp = xfs_btree_get_bufs(args->mp, args->tp,
>>  					args->agno, fbno, 0);
>> +				if (!bp) {
>> +					error = -EIO;
>> +					goto error0;
>> +				}
> 
> If this happens, it's because the filesystem is corrupted, not
> because we had an IO error. -EFSCORRUPTED is more appropriate here,
> as the comment in _xfs_buf_find() says...

Ok, I thought I saw other places set EIO and ENOMEM, but it doesn't
matter to me ...  I'll resend w/ -EFSCORRUPTED.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 

