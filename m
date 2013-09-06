Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 844647F53
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 06:29:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C34F304075
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 04:29:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5VaYazKEGBjuV8Jl for
	<xfs@oss.sgi.com>; Fri, 06 Sep 2013 04:29:39 -0700 (PDT)
Message-ID: <5229BBC6.5000808@redhat.com>
Date: Fri, 06 Sep 2013 07:25:58 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 03/11] xfs: support the XFS_BTNUM_FINOBT free inode
	btree type
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-4-git-send-email-bfoster@redhat.com>
	<20130905005428.GQ23571@dastard> <5228AE80.5050908@redhat.com>
	<20130906000754.GO12779@dastard>
In-Reply-To: <20130906000754.GO12779@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/05/2013 08:07 PM, Dave Chinner wrote:
> On Thu, Sep 05, 2013 at 12:17:04PM -0400, Brian Foster wrote:
>> On 09/04/2013 08:54 PM, Dave Chinner wrote:
>>> On Tue, Sep 03, 2013 at 02:25:00PM -0400, Brian Foster wrote:
...
>>>
>>> What we really need here is for xfs_ialloc_log_agi to consider that
>>> there are two distinct regions for range logging - the first spaces
>>> from offset 0 to offset of agi_unlinked, and the second is from the
>>> the offset of agi_free_root to the end of the xfs_agi_t....
>>>
>>> It's abit messy, I know, but we couldn't easily add new padding to
>>> the AGI in the existing range logging area like was done for the AGF
>>> because of the unlinked list hash table already defining the end of
>>> the range logging region....
>>>
>>
>> ... but where would that ever happen? The existing invocations of
>> xfs_ialloc_log_agi() seem to log either the agi inode count values or
>> the btree root/level values (i.e., never the range across both). I think
>> I've introduced at least a couple new invocations throughout this set,
>> but I've not changed that model (i.e., an XFS_AGI_FREECOUNT instance in
>> the new lookup code and an XFS_AGI_FREE_ROOT|*_LEVEL instance in the new
>> btree code).
> 
> Right, we don't current log across the range because of the way the
> code is currently written, but there's no rule that says that
> logging fields must be done this way.
> 
> I can see that there may be reason for logging
> XFS_AGI_FREE_ROOT|*_LEVEL and XFS_AGI_NEW_INODE all in one go -
> pointing new inode allocation at recently freed inodes is not
> unreasonable, and if we split the finobt and update agi_newino in
> the one update, we will log across this gap.
> 

For the sake of argument, it seems a little strange to me to set an
inode level value in the agi in the context of a btree operation, such
as a split...

>> My understanding of this code is that the range to log is defined at
>> invocation time to xfs_iallog_log_agi(), so if the callers never specify
>> a range that includes the unlinked bits in a single call, we won't set
>> that range in the buffer log item code. In other words, even if we
>> ultimately happen to log both ranges in the agi, the lower level code
>> will never expand the logged region. Therefore, this shouldn't happen
>> unless a single invocation that specifies one of the
>> XFS_AGI_FREE_ROOT/LEVEL bits also specifies one of the existing agi bits.
> 
> Yes, we can avoid that by logging te regions separately, but that
> then puts the onus on the future developers and reviewers to
> remember this landmine and avoid it.
> 

... but I agree with the general premise. It's certainly a landmine.

>> I could see breaking this up as a matter of preparation for future
>> fields or calls that would introduce logging that kind of range, but at
>> the same time (and assuming my interpretation of above is correct),
>> that's a bit of code that serves no purpose for the foreseeable future.
>> Perhaps a comment in xfs_ialloc_log_agi() and the one caller that uses
>> the AGI_FREE_* bits to document this restriction is sufficient?
> 
> Given it is only a few lines of extra code in xfs_ialloc_log_agi(),
> I'd prefer that the code documents and deals with the different
> regions internally. That way we can forget about it completely for the
> future and never have to worry about it again.
> 
> Keep in mind that I'm looking at this from a code maintenance
> timescale of at least 5-10 years into the future here - a few
> minutes extra fixing this right now could save us a lot of hassle
> years down the track. ;)
> 

Fair enough. If it's at least a reasonably likely scenario, then I'm on
board with the better safe than sorry approach. ;)

Brian

>>>>  #ifdef DEBUG
>>>> diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
>>>> index 0cdb88b..7923292 100644
>>>> --- a/fs/xfs/xfs_ialloc_btree.c
>>>> +++ b/fs/xfs/xfs_ialloc_btree.c
>>>> @@ -62,10 +62,18 @@ xfs_inobt_set_root(
>>>>  {
>>>>  	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
>>>>  	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
>>>> -
>>>> -	agi->agi_root = nptr->s;
>>>> -	be32_add_cpu(&agi->agi_level, inc);
>>>> -	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
>>>> +	int			fields;
>>>> +
>>>> +	if (cur->bc_btnum == XFS_BTNUM_INO) {
>>>> +		agi->agi_root = nptr->s;
>>>> +		be32_add_cpu(&agi->agi_level, inc);
>>>> +		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
>>>> +	} else {
>>>> +		agi->agi_free_root = nptr->s;
>>>> +		be32_add_cpu(&agi->agi_free_level, inc);
>>>> +		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
>>>> +	}
>>>> +	xfs_ialloc_log_agi(cur->bc_tp, agbp, fields);
>>>>  }
>>>
>>> I suspect that it would be better to have separate functions for
>>> these differences i.e. xfs_inobt_set_root() and
>>> xfs_finobt_set_root(), and set up separate btree ops structure
>>> forthe two different trees. Most of the code is still identical,
>>> but the differences in root structures can easily be handled without
>>> putting switches in the code everywhere.
>>>
>>
>> Ok, I'm assuming the suggestion is to only create new functions for the
>> implementations that differ.
> 
> Exactly.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
