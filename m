Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39850 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752447AbeEAPBB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 11:01:01 -0400
Subject: Re: [PATCH 4/5] xfs: implement online get/set fs label
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
 <20180501141833.GG4525@bfoster.bfoster>
 <f52bedee-9432-1f58-dc11-a59d2a7d6359@sandeen.net>
 <20180501144238.GH4525@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0a7630e2-79bb-7d47-8a10-031b666f2c77@sandeen.net>
Date: Tue, 1 May 2018 10:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <20180501144238.GH4525@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 5/1/18 9:42 AM, Brian Foster wrote:
> On Tue, May 01, 2018 at 09:27:30AM -0500, Eric Sandeen wrote:


>>>> +	/* invalidate any cached bdev page for userspace visibility */
>>>> +	mapping = mp->m_ddev_targp->bt_bdev->bd_inode->i_mapping;
>>>> +	error = invalidate_inode_pages2_range(mapping, 0, 0);
>>>> +	if (error)
>>>> +		goto out;
>>>
>>> A more detailed comment on why this is necessary would be helpful. :)
>>
>> Why we need to invalidate cached pages on the block device?  I thought that
>> was clear from the comment, but I can add more words.
>>
> 
> I'm not really sure what "userspace visibility" means. Wouldn't
> userspace just call the get label ioctl?

It could, but we also have blkid which reads the block device directly
today, even when mounted.  They need to co-exist, and blkid needs to see
the label change /on the block device/ after it's modified while mounted.

>> /*
>>  * The block device may have cached pages for the block device from previous
>>  * reads in userspace, and we want i.e. blkid to see the new info, so invalidate
>>  * any cached pages now.
>>  */
>>
>> Like that?
>>
> 
> I suppose. Does something actually break without this? Why do we care
> about bdev inode cache invalidation here and not with any other
> superblock modifications?

Because there's no other situation or utility that I'm aware of which reads
a mounted block device directly, and is gathering data which may now change
while mounted.

IOWSs, blkid reads things like label, uuid, fs type, etc, but none of those
can (could) change while mounted; now label /can/ change, and blkid must 
see it.

i.e. we don't want:

# blkid -s LABEL /dev/sdc1 
/dev/sdc1: LABEL="oldlabel" 

# xfs_io -c "label newlabel" /mnt/sdc1
label = newlabel

# blkid -s LABEL /dev/sdc1 
/dev/sdc1: LABEL="oldlabel" 

- we want to see the /new/ label.

>>>> +
>>>> +	/* update the backup superblocks like userspace does */
>>>> +	if (mutex_trylock(&mp->m_growlock)) {
>>>> +		error = xfs_update_secondary_supers(mp, mp->m_sb.sb_agcount, 0);
>>>> +		mutex_unlock(&mp->m_growlock);
>>>> +	}
>>>
>>> It looks like growfs returns an error if the lock not available. Did you
>>> intend to perform the primary update and then skip the secondary updates
>>> if the lock is not acquired?
>>>
>>> Perhaps we should just trylock earlier and hold the lock across the
>>> entire operation..? It's not like grow or relabel are frequent
>>> operations.
>>
>> yeah, I was on the fence about this.  Updating the secondaries with the new label
>> is not strictly required; repair doesn't care at all, and online repair considers
>> it a "preen" action.  TBH I was lazily unsure about growlock vs. m_sb_lock nesting
>> and didn't want to risk getting it wrong.
>>
> 
> I have no strong preference either way, but ISTM we should decide
> whether to update secondary supers or not.

Ok.  I'll wait for the growfs lock to ensure we do the secondary updates, I guess.
Doing everything else and then returning -EBUSY for the secondaries would be
confusing IMHO.

-Eric

