Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A146D7F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 09:06:44 -0500 (CDT)
Message-ID: <51C9A3EF.70005@sgi.com>
Date: Tue, 25 Jun 2013 09:06:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 59/60] xfs: Add xfs_log_rlimit.c
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-60-git-send-email-david@fromorbit.com>
	<51C8B984.3090400@sgi.com> <20130624222708.GV29338@dastard>
In-Reply-To: <20130624222708.GV29338@dastard>
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

On 06/24/13 17:27, Dave Chinner wrote:
> On Mon, Jun 24, 2013 at 04:26:28PM -0500, Mark Tinguely wrote:
>> On 06/18/13 23:51, Dave Chinner wrote:
>>> +	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
>>> +	 *    for the reservation because there are two log writes that can
>>> +	 *    require padding - the transaction data and the commit record which
>>> +	 *    are written separately and both can require padding to the LSU.
>>> +	 *    Consider that we can have an active CIL reservation holding 2*LSU,
>>> +	 *    but the CIL is not over a push threshold, in this case, if we
>>> +	 *    don't have enough log space for at one new transaction, which
>>> +	 *    includes another 2*LSU in the reservation, we will run into dead
>>> +	 *    loop situation in log space grant procedure. i.e.
>>> +	 *    xlog_grant_head_wait().
>>> +	 *
>>> +	 *    Hence the log size needs to be able to contain two maximally sized
>>> +	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
>>> +	 *
>>
>> Any thoughts on how we can separate the 2 * log stripe unit from the
>> reservation.
>
> You can't. The reservation, by definition, is the worse case log
> space usage for the transaction. Therefore, it has to take into
> account the LSU padding that may be necessary if this transaction is
> committed by itself to the log (e.g. wsync operation)

I am thinking we should separate the extra 2*LSU allocated space from 
the individual pieces of the transaction (caused by xfs_trans_rolls and 
xfs_bmap_finish) and associate it with the transaction. Sync writes are 
for the transaction anyway and not the pieces. It is the multiplication 
of the (2*LSU) by each piece of the transaction that is the killer.
A mkdir will have 1.5MB of log reserved space just for the possible LSU 
padding.

The cil can steal the left over current ticket space and the global LSU 
space.

>
>> The added extended attribute calls for parent inode pointers
>> (especially xfs_rename() where it could add up to one and remove up
>> to two attributes) is causing a huge multiplication cnt for
>> reservation.
>
> So you are adding a attribute reservations to
> create/mkdir/rename/link transaction reservations? That doesn't seem
> like a good idea, and it's contrary to the direction we want to head
> with the transaction subsystem.  Can you post your patches so we
> some some context to the question you are asking?
>
> FWIW, the intended method of linking multiple independent
> transactions together for parent pointers into an atomic commit is
> this:
>
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations
>
> While the text is somewhat out of date (talks about rolling
> transactions and being able to replace them), it predated the
> delayed logging implementation and hence doesn't take into account
> the obvious, simple extension that can be made to the CIL to
> implement this. i.e.  being able to hold the current CIL context
> open for a number of transactions to take place before releasing it
> again.
>
> The point of doing this is still relevant, however:
>
> "This may also allow us to split some of the large compound
> transactions into smaller, more self contained transactions. This
> would reduce reservation pressure on log space in the common case
> where all the corner cases in the transactions are not taken."
>
> IOWs, rather than building new, large "aggregation" transactions, we
> should be adding infrastructure to the CIL to allow atomic
> transaction aggregation techniques to be used and then just using
> the existing transaction infrastructure to implement operations such
> as "create with ACL"....

I will have to think on this. I don't see how the allocation of log 
space for a new transaction while holding locks is a good thing.

>
> FYI, we need this for all the operations that add attributes at
> create time, such as default ACLs and DMAPI/DMF attributes....
>
>> Those multiplications would be killers on 256KiB log
>> stripe units.
>
> Numbers, please?
>
> Cheers,
>
> Dave.

/*
  * Various log count values.
  */
#define XFS_DEFAULT_LOG_COUNT           1
#define XFS_DEFAULT_PERM_LOG_COUNT      2
#define XFS_ITRUNCATE_LOG_COUNT         2
#define XFS_INACTIVE_LOG_COUNT          2
#define XFS_CREATE_LOG_COUNT            2
#define XFS_MKDIR_LOG_COUNT             3
#define XFS_SYMLINK_LOG_COUNT           3
#define XFS_REMOVE_LOG_COUNT            2
#define XFS_LINK_LOG_COUNT              2
#define XFS_RENAME_LOG_COUNT            2
#define XFS_WRITE_LOG_COUNT             2
#define XFS_ADDAFORK_LOG_COUNT          2
#define XFS_ATTRINVAL_LOG_COUNT         1
#define XFS_ATTRSET_LOG_COUNT           3
#define XFS_ATTRRM_LOG_COUNT            3

Even if you are creative, the multipliers add up quickly.
xfs_rename will do the directory ops. possibly a attibset and up to 2 
attrrm and we have to hold the src and target inodes locks over all the 
operations.

Thanks for the ideas.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
