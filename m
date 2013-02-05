Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C7907F63
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 19:38:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EB5C8F8039
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 17:38:45 -0800 (PST)
Received: from mail-oa0-f46.google.com (mail-oa0-f46.google.com
	[209.85.219.46]) by cuda.sgi.com with ESMTP id 5dqropoN8e00IYCC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Feb 2013 17:38:43 -0800 (PST)
Received: by mail-oa0-f46.google.com with SMTP id k1so7365320oag.33
	for <xfs@oss.sgi.com>; Mon, 04 Feb 2013 17:38:43 -0800 (PST)
Message-ID: <511062A0.5010800@inktank.com>
Date: Mon, 04 Feb 2013 19:38:40 -0600
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: another memory barrier before wake_up_bit()
References: <510FDDE5.4050103@inktank.com> <510FDE23.9050801@inktank.com>
	<20130204232617.GO2667@dastard>
In-Reply-To: <20130204232617.GO2667@dastard>
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

On 02/04/2013 05:26 PM, Dave Chinner wrote:
> On Mon, Feb 04, 2013 at 10:13:23AM -0600, Alex Elder wrote:
>> In xfs_inode_item_unpin() there is a call to wake_up_bit() following
>> an independent test for whether waiters should be awakened.  This
>> requires a memory barrier in order to guarantee correct operation
>> (see the comment above wake_up_bit()).
>>
>> Signed-off-by: Alex Elder <elder@inktank.com>
>> ---
>>  fs/xfs/xfs_inode_item.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
>> index d041d47..a7cacf7 100644
>> --- a/fs/xfs/xfs_inode_item.c
>> +++ b/fs/xfs/xfs_inode_item.c
>> @@ -474,8 +474,10 @@ xfs_inode_item_unpin(
>>
>>  	trace_xfs_inode_unpin(ip, _RET_IP_);
>>  	ASSERT(atomic_read(&ip->i_pincount) > 0);
>> -	if (atomic_dec_and_test(&ip->i_pincount))
>> -		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
>> +	if (!atomic_dec_and_test(&ip->i_pincount))
>> +		return;
>> +	smp_mb();
>> +	wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> 
> I'm not sure this a barrier is actually needed here.  The "wake up"
> bit is never stored or cleared anywhere in this case, it is used
> only to define a wait channel and directed wake up. Hence the "need
> a barrier so all CPUs see the cleared bit" case doesn't arise here.
> We use an atomic variable instead, and that makes it safe.
> 
> If you read Documentation/atomic_ops.txt, you'll find that atomic
> modification operations are required to have explicit barrier
> semantics. i.e. that atomic_dec_and_test() must behave like it has
> both a smp_mb() before and after the atomic operation. i.e:
> 
> 	Unlike the above routines, it is required that explicit memory
> 	barriers are performed before and after the operation.  It must be
> 	done such that all memory operations before and after the atomic
> 	operation calls are strongly ordered with respect to the atomic
> 	operation itself.
> 
> So, the smp_mb() that is added here is redundant - the
> atomic_dec_and_test() call already has the necesary memory barriers
> that wake_up_bit() requires.

I hadn't looked at that in as much detail, but now that you point it
out I concur.

I retract this patch.

Thanks.

					-Alex

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
