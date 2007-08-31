Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 19:12:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7V2Ci4p030880
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 19:12:50 -0700
Message-ID: <46D7799F.5030609@sgi.com>
Date: Fri, 31 Aug 2007 12:14:55 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com> <46D64CAD.6050705@sgi.com> <46D67FE6.20205@sgi.com>
In-Reply-To: <46D67FE6.20205@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Lachlan McIlroy wrote:
>> Timothy Shimmin wrote:
>>> Lachlan McIlroy wrote:
>>>> Log replay of clustered inodes currently ignores the flushiter
>>>> field in the inode that is used to determine if the on-disk inode
>>>> is more up to date than the copy in the log.  As a result during
>>>> log replay the newer inode is being overwritten with an older
>>>> version and file size updates are being lost.
>>>>
>>>> I haven't handled the case of the flushiter counter overflowing
>>>> but that shouldn't be a problem in this case.  The log buffer
>>>> contains newly created inodes so their flushiter values will be 0
>>>> and the on-disk inodes should not be much greater.
>>>>
>>>> Lachlan
>>>>
>>>
>>> Still would want to understand why blf_flags doesn't have
>>> XFS_BLI_INODE_ALLOC_BUF set and so we could test that
>>> - I didn't understand Dave's (dgc) response about that earlier.
>>> But anyway...:)
>>>
>>>
>>> Just some nit-picks:
>>>
>>> * instead of a comment and then calling xfs_recover_inode
>>>   why don't we just give the function a better name.
>>>   When I see the name I think it is going to recover the inode
>>>   but instead it is just a flush_iter check and matching
>>>   the magic#s.
>> What would you like the function to be called?
>>
> Dunno :)
> xfs_flushiter_check
> 
>>>
>>> * My style preference is for option 2 over option 1:
>>>   1.
>>>     if (a) {
>>>        return 1;
>>>     }
>>>     return 0;
>>>
>>>   2.
>>>     return a;
>>>
>>>   But I understand the predicate is long and sometimes people like
>>>   to add tracing/debug for the alternate paths in which case (1)
>>>   is handy for that. I just like simplicity.
>> I can change that.  It just looks odd when the body of the function
>> is after the return statement.
>>
> It doesn't look funny to me :-)
> But I'm not really fussed - do what you prefer.
> 
>>>
>>> * Also it is funny to return a boolean for error in the call.
>>>   Although, I see that is consistent with the rest of the function.
>> Yep, keeping consistent with coding standards.
> Well consistent with that function at least :)
> 
>>
>>>   But I'm not sure this is an error...
>>>   Hmmmm...I'm a bit confused.
>>>   So you are _almost_ combining an error check with a flushiter check?
>>>   If one buffer is an inode magic# and the other isn't then we
>>>   have an error right - and could report it - but we are not doing 
>>> that here.
>> Not exactly.  If what's on disk is not an inode but the log item is
>> then that could be because we haven't written the inode to disk yet
>> and we need to perform recovery.
> Yeah, I was thinking about that afterward.
> The item's format which gives the blk# for the buf to read could
> be a block which hasn't been used for an inode yet.
> 
> OOI,
> Say the inode block was freed in the past and we freshly allocate one using
> this inode buf item in replay, so that the old block has the inode magic#
> but it has an old large flushiter. We then say it is newer when
> really it is older.
Yeah that could be a problem.  Knew this flushiter thing was a hack - if
we logged every inode change we wouldn't have to worry what is on disk we
could just play back the log.

> We could check for zero mode or different gen#.
That might work, thanks.  I suppose the existing flushiter check will need
this extra sanity too.

> Or perhaps we reset the flushiter when we free the inode or
> do we go thru a different replay path.
Not sure how this would work.

> 
> 
>  > If what's on disk is an inode but
>> the log item is not an inode then what we are about to recover is not
>> an inode and we abort the check.
> Well yes we are only interested in inode buf items.
> 
>> If neither on-disk nor log item are
>> inodes then we've got no business continuing the check.
> Well as above it aint even an inode in the log.
> 
>>
>>>   If we have an inode buf and the flushiter on the item is older than 
>>> the ondisk buffer
>>>   one then it is not an error but we just don't want to recover it.
>> Exactly.
>>
> So its not an error then yet we are calling it that.
> So perhaps we could have:
> 
> if (!error && !old_inode_item) {
> ....
> 
> --Tim
> 
> 
> 
> 
> 
> 
>>> --- fs/xfs/xfs_log_recover.c_1.322    2007-08-27 17:45:45.000000000 
>>> +1000
>>> +++ fs/xfs/xfs_log_recover.c    2007-08-30 11:50:44.000000000 +1000
>>> @@ -1866,6 +1866,27 @@ xlog_recover_do_inode_buffer(
>>>  }
>>>
>>>  /*
>>> + * Check if we need to recover an inode from a buffer
>>> + */
>>> +int
>>> +xfs_recover_inode(
>>> +    char    *dest,
>>> +    char    *src)
>>> +{
>>> +    xfs_dinode_t    *dip = (xfs_dinode_t *)dest;
>>> +    xfs_dinode_t    *dilp = (xfs_dinode_t*)src;
>>> +
>>> +    if ((be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC) &&
>>> +        (be16_to_cpu(dilp->di_core.di_magic) == XFS_DINODE_MAGIC) &&
>>> +        (be16_to_cpu(dilp->di_core.di_flushiter) <
>>> +            be16_to_cpu(dip->di_core.di_flushiter))) {
>>> +        return 1;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +/*
>>>   * Perform a 'normal' buffer recovery.  Each logged region of the
>>>   * buffer should be copied over the corresponding region in the
>>>   * given buffer.  The bitmap in the buf log format structure indicates
>>> @@ -1917,6 +1938,13 @@ xlog_recover_do_reg_buffer(
>>>                             -1, 0, XFS_QMOPT_DOWARN,
>>>                             "dquot_buf_recover");
>>>          }
>>> +        /*
>>> +         * Sanity check if this is an inode buffer.
>>> +         */
>>> +        if (!error)
>>> +            error = xfs_recover_inode(xfs_buf_offset(bp,
>>> +                    (uint)bit << XFS_BLI_SHIFT),
>>> +                    item->ri_buf[i].i_addr);
>>>          if (!error)
>>>              memcpy(xfs_buf_offset(bp,
>>>                  (uint)bit << XFS_BLI_SHIFT),    /* dest */
>>>
>>>
> 
> 
> 
