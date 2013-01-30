Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 92E827F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 10:05:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71BFD8F804B
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 08:05:07 -0800 (PST)
Message-ID: <51094423.8000703@redhat.com>
Date: Wed, 30 Jan 2013 11:02:43 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 0/2] fix spinlock recursion on xa_lock in
	xfs_buf_item_push
References: <1359492157-30521-1-git-send-email-bfoster@redhat.com>
	<20130130060551.GG7255@disturbed.disaster>
	<5109291E.6090303@sgi.com>
In-Reply-To: <5109291E.6090303@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

(added Dave and the list back on CC)

On 01/30/2013 09:07 AM, Mark Tinguely wrote:
> On 01/30/13 00:05, Dave Chinner wrote:
>> On Tue, Jan 29, 2013 at 03:42:35PM -0500, Brian Foster wrote:
...
> 
>> So essentially what is happening here is that we are trying to lock
>> a stale buffer in the AIL to flush it. Well, we can't flush it from
>> the AIL, and indeed the next line of code is this:
>>
>>     if (!xfs_buf_trylock(bp))
>>         return XFS_ITEM_LOCKED;
>>
>>>>>>>     ASSERT(!(bip->bli_flags&  XFS_BLI_STALE));
>>
>> The only reason this ASSERT is not firing is that we are failing to
>> lock stale buffers. Hence we are relying on the failed lock to force
>> the log, instead of detecting that we need to force the log after we
>> drop the AIL lock and letting the caller handle it.
>>
>> So, wouldn't a better solution be to do something like simply like:
>>
>> +    if (bp->b_flags&  XBF_STALE)
>> +        return XFS_ITEM_PINNED;
>> +
>>     if (!xfs_buf_trylock(bp))
>>         return XFS_ITEM_LOCKED;
...
> 

Thanks guys. This certainly looks nicer than messing with the lock
wrapper, but is it susceptible to the same problem? In other words, does
this fix the problem or just tighten the window?

I'm going to go back to my original reproduction case and enable some
select tracepoints to try and get a specific sequence of events, but
given the code as it is, the problem seems to be that the buffer goes
from !pinned to pinned between the time we actually check for pinned and
try the buf lock.

So if the buf lock covers the pinned state (e.g., buffer gets locked,
added to a transaction, the transaction gets committed and pins and
unlocks the buffer, IIUC) and the stale state (buf gets locked, added to
a new transaction and inval'd before the original transaction was
written ?), but we don't hold the buf lock in xfs_buf_item_push(), how
can we guarantee the state of either doesn't change between the time we
check the flags and the time the lock fails?

> Makes sense. It would prevent the lock recursion. The more that I think
> about, we do not want to release xa_lock during an AIL scan.
> 

FWIW, the other log item abstractions appear to use this model (e.g.,
xfs_inode_item_push()), where it appears safe to drop xa_lock once the
actual object lock/ref is acquired and reacquire xa_lock before
returning. It looks like this behavior was introduced in:

43ff2122 xfs: on-stack delayed write buffer lists

Brian

> We would still want to see if the buffer is re-pinned (and not STALE) to
> the AIL.
> 
> --Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
