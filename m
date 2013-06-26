Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3CDC7F37
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 08:48:19 -0500 (CDT)
Message-ID: <51CAF11F.4050905@sgi.com>
Date: Wed, 26 Jun 2013 08:48:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 59/60] xfs: Add xfs_log_rlimit.c
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-60-git-send-email-david@fromorbit.com>
	<51C8B984.3090400@sgi.com> <20130624222708.GV29338@dastard>
	<51C9A3EF.70005@sgi.com> <20130626040518.GG29376@dastard>
In-Reply-To: <20130626040518.GG29376@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/25/13 23:05, Dave Chinner wrote:
> On Tue, Jun 25, 2013 at 09:06:39AM -0500, Mark Tinguely wrote:
>> On 06/24/13 17:27, Dave Chinner wrote:
>>> On Mon, Jun 24, 2013 at 04:26:28PM -0500, Mark Tinguely wrote:
>>>> On 06/18/13 23:51, Dave Chinner wrote:
>>>>> +	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
>>>>> +	 *    for the reservation because there are two log writes that can
>>>>> +	 *    require padding - the transaction data and the commit record which
>>>>> +	 *    are written separately and both can require padding to the LSU.
>>>>> +	 *    Consider that we can have an active CIL reservation holding 2*LSU,
>>>>> +	 *    but the CIL is not over a push threshold, in this case, if we
>>>>> +	 *    don't have enough log space for at one new transaction, which
>>>>> +	 *    includes another 2*LSU in the reservation, we will run into dead
>>>>> +	 *    loop situation in log space grant procedure. i.e.
>>>>> +	 *    xlog_grant_head_wait().
>>>>> +	 *
>>>>> +	 *    Hence the log size needs to be able to contain two maximally sized
>>>>> +	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
>>>>> +	 *
>>>>
>>>> Any thoughts on how we can separate the 2 * log stripe unit from the
>>>> reservation.
>>>
>>> You can't. The reservation, by definition, is the worse case log
>>> space usage for the transaction. Therefore, it has to take into
>>> account the LSU padding that may be necessary if this transaction is
>>> committed by itself to the log (e.g. wsync operation)
>>
>> I am thinking we should separate the extra 2*LSU allocated space
>> from the individual pieces of the transaction
>
> Why? How are you going to prevent log space deadlocks if we don't
> reserve that space for each individual transaction in a permanent
> transaction reservation?

Allocate 2 per transaction, not one per segment of a transaction.
It may be a wash for 2 or 3 segments per transaction, but would help if 
there are 10 segments per transaction.
>
>> (caused by
>> xfs_trans_rolls and xfs_bmap_finish) and associate it with the
>> transaction. Sync writes are for the transaction anyway and not the
>> pieces.
>
> Every transaction commit that is executed can require LSU padding
> because it could be the transaction the CIL steals the required LSU
> reservation from.  When CIL flushes occur - and hence when the LSU
> padding needs to be stolen from a transaction commit - is not under
> the control of the currently executing transaction.

I was thinking we need 2 (2*LSU) per transaction. One for a CIL push 
because it could be too large and one if it is sync transaction. In the 
mean time if another transaction pushes the log for one of the above 
reasons, the CIL will steal whatever is left over from the transaction 
and one of the (2*LSU) from that ticket.

>> It is the multiplication of the (2*LSU) by each piece of the
>> transaction that is the killer.
>> A mkdir will have 1.5MB of log reserved space just for the possible
>> LSU padding.
>
> A killer for what, exactly? This is the current status quo, and I
> don't see people having performance problems related to it....
>
>> The cil can steal the left over current ticket space and the global
>> LSU space.
>
> The space is avilable only if the current transaction _unit
> reservation_ has it reserved. Hence every unit reservation needs
> that space to be reserved.
>
> I'm not saying this is optimal - it is an architectural requirement
> that the log has always had and therefore *necessary*.

Killer only in the amount of space as the segments increase.

>>>> The added extended attribute calls for parent inode pointers
>>>> (especially xfs_rename() where it could add up to one and remove up
>>>> to two attributes) is causing a huge multiplication cnt for
>>>> reservation.
>>>
>>> So you are adding a attribute reservations to
>>> create/mkdir/rename/link transaction reservations? That doesn't seem
>>> like a good idea, and it's contrary to the direction we want to head
>>> with the transaction subsystem.  Can you post your patches so we
>>> some some context to the question you are asking?
>>>
>>> FWIW, the intended method of linking multiple independent
>>> transactions together for parent pointers into an atomic commit is
>>> this:
>>>
>>> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations
>>>
>>> While the text is somewhat out of date (talks about rolling
>>> transactions and being able to replace them), it predated the
>>> delayed logging implementation and hence doesn't take into account
>>> the obvious, simple extension that can be made to the CIL to
>>> implement this. i.e.  being able to hold the current CIL context
>>> open for a number of transactions to take place before releasing it
>>> again.
>>>
>>> The point of doing this is still relevant, however:
>>>
>>> "This may also allow us to split some of the large compound
>>> transactions into smaller, more self contained transactions. This
>>> would reduce reservation pressure on log space in the common case
>>> where all the corner cases in the transactions are not taken."
>>>
>>> IOWs, rather than building new, large "aggregation" transactions, we
>>> should be adding infrastructure to the CIL to allow atomic
>>> transaction aggregation techniques to be used and then just using
>>> the existing transaction infrastructure to implement operations such
>>> as "create with ACL"....
>>
>> I will have to think on this. I don't see how the allocation of log
>> space for a new transaction while holding locks is a good thing.
>
> Who said anything about requiring new locks? :)

I meant we have to hold the inode locks between the directory code the 
the attribute code. If we do not, then the attributes quickly become out 
of line with the directory status.
>
> The initial implementation I was thinking of is basically a
> reference counter and a method for delaying CIL pushes until the
> reference count drops to zero.
>
> Indeed, if we push the aggregated space reservations up into this
> aggregated transaction, the individual transactions can just pull
> out of the space we already know is available to use. IOWs, it's
> relatively trivial to do in a way that leaves open many avenues for
> later optimisation....

sweet.

>
>>> FYI, we need this for all the operations that add attributes at
>>> create time, such as default ACLs and DMAPI/DMF attributes....
>>>
>>>> Those multiplications would be killers on 256KiB log
>>>> stripe units.
>>>
>>> Numbers, please?
>>>
>>> Cheers,
>>>
>>> Dave.
>>
>> /*
>>   * Various log count values.
>>   */
>> #define XFS_DEFAULT_LOG_COUNT           1
>> #define XFS_DEFAULT_PERM_LOG_COUNT      2
>> #define XFS_ITRUNCATE_LOG_COUNT         2
>> #define XFS_INACTIVE_LOG_COUNT          2
>> #define XFS_CREATE_LOG_COUNT            2
>> #define XFS_MKDIR_LOG_COUNT             3
>> #define XFS_SYMLINK_LOG_COUNT           3
>> #define XFS_REMOVE_LOG_COUNT            2
>> #define XFS_LINK_LOG_COUNT              2
>> #define XFS_RENAME_LOG_COUNT            2
>> #define XFS_WRITE_LOG_COUNT             2
>> #define XFS_ADDAFORK_LOG_COUNT          2
>> #define XFS_ATTRINVAL_LOG_COUNT         1
>> #define XFS_ATTRSET_LOG_COUNT           3
>> #define XFS_ATTRRM_LOG_COUNT            3
>>
>> Even if you are creative, the multipliers add up quickly.
>> xfs_rename will do the directory ops. possibly a attibset and up to
>> 2 attrrm and we have to hold the src and target inodes locks over
>> all the operations.
>
> We don't have to hold them locked across the entire operation
> because the VFS is holding them locked so nothing else can do a
> namespace operation which we are modifying them.

I find without holding the lock over both dir and attrib routines that 
remove occasionally can't find parent pointer attribute entry. I suspect 
remove racing in rename.

> Anyway, you're worried about multiplying out the existing
> reservations, but that's really not that big of a deal - it's just
> log space, and we've got lots of that to use, and we have plenty of
> avenues to optimise usage in future..
>
> e.g.  mkdir is a compound transaction that is really 2 different
> operations. The first is physical inode allocation, then second is
> allocating a free inode. the first only happens for 1 in every 64
> free inode allocations (rarer if we are also removing inodes, too).
> So most of the time we are reserving far more space in the log that
> we actually need to allocate an inode.
>
> The actual unit reservation for the create is the maximum of the two
> individual component reservations times the number of commits that
> will be required, and the total is the unit reservation times the
> number of commits needed. So for a create transaction, it's an
> overestimation of the worst case.
>
> Is that a problem? No. Can it be improved? Yes - see the comments
> about splitting out physical inode chunk allocation into the
> background here:
>
> http://xfs.org/index.php/Improving_inode_Caching#Contiguous_Inode_Allocation
>
> And suddenly we end up with mkdir/create/etc only requiring a single
> transaction reservation. There goes one of your 2*LSU paddings...
>
> What about attributes? The triple-stage transaction is only required
> when -replacing- an existing attribute. The first adds the new
> attribute, the second flips the complete/incomplete flags, and the
> third removes the old attributes. Just adding a new attribute only
> requires a single transaction and most attributes are never
> overwritten, so again we are almost always reserving far too much
> space for such an operation.
>
> Can we optimise this? Yes, we can. Let's disaggregate it - if we are
> replacing attribute content without changing the size or name, then
> we could just add a new transaction that logs a direct overwrite.
> That's a *tiny* transaction. If we are replacing an attribute of the
> same size with a new name, then it's a little more complex as we
> have to manipulate the hash index entries, but that is still a
> single, simple transaction. If we are adding, knowing we aren't
> doing a replacment, then that is a single transaction, too.
>
> Start to see how this greatly reduces the overall operational
> transaction reservations? We can build bigger and more complex
> transactions as part of the process, but optimisation of the
> reservations comes from separation into smaller, more fine-grained
> transactions and reservations.
>
> Keep in mind that from this perspective, I'm quite happy for an
> initial parent pointer implementation to start with gigantic
> create+attr/rename+attr transaction reservations. I'm also happy for
> it to take us 2-3 years to optimise/disaggegate the transactions to
> reduce the overhead to be smaller and more efficient.
>
> I don't expect the initial implementation to be perfect or even
> optimal - attempting to make it so puts us right into prematuve
> optimisation territory. Make parent pointers robust first, then we
> can worry about where we can optimise reservations down to the
> smallest possible subset.
>
> Cheers,
>
> Dave.

Thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
