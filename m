Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 352157F60
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 19:35:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E216AC001
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 17:35:14 -0800 (PST)
Received: from mail-oa0-f46.google.com (mail-oa0-f46.google.com
	[209.85.219.46]) by cuda.sgi.com with ESMTP id Fej1WolbnN876xhI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Feb 2013 17:35:13 -0800 (PST)
Received: by mail-oa0-f46.google.com with SMTP id k1so7282197oag.19
	for <xfs@oss.sgi.com>; Mon, 04 Feb 2013 17:35:13 -0800 (PST)
Message-ID: <511061CD.8070206@inktank.com>
Date: Mon, 04 Feb 2013 19:35:09 -0600
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: memory barrier before wake_up_bit()
References: <510FDDE5.4050103@inktank.com> <510FDE17.9020207@inktank.com>
	<20130204230634.GN2667@dastard>
In-Reply-To: <20130204230634.GN2667@dastard>
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

On 02/04/2013 05:06 PM, Dave Chinner wrote:
> On Mon, Feb 04, 2013 at 10:13:11AM -0600, Alex Elder wrote:
>> In xfs_ifunlock() there is a call to wake_up_bit() after clearing
>> the flush lock on the xfs inode.  This is not guaranteed to be safe,
>> as noted in the comments above wake_up_bit() beginning with:
>>
>>     In order for this to function properly, as it uses
>>     waitqueue_active() internally, some kind of memory
>>     barrier must be done prior to calling this.
>>
>> I claim no mastery of the details and subtlety of memory barrier
>> use, but I believe the issue is that the call to waitqueue_active()
>> in __wake_up_bit(), could be operating on a value of "wq" that is
>> out of date.  This patch fixes this by inserting a call to smp_mb()
>> in xfs_iunlock before calling wake_up_bit(), along the lines of
>> what's done in unlock_new_inode().  A litte more explanation
>> follows.
>>
>>
>> In __xfs_iflock(), prepare_to_wait_exclusive() adds a wait queue
>> entry to the end of a bit wait queue before setting the current task
>> state to UNINTERRUPTIBLE.  And although setting the task state
>> issues a full smp_mb() (which ensures changes made are visible to
>> the rest of the system at that point) that alone does not guarantee
>> that other CPUs will instantly avail themselves of the updated
>> value.  A separate CPU needs to issue at least a read barrier in
>> order to ensure the wq value it uses to determine whether there are
>> waiters is up-to-date, and waitqueue_active() does not do that.
> 
> You can probably trim most of this and simply point at the comment
> describing wake_up_bit()....

Yeah, I know.  I just wanted to sort of say what I was
thinking to get confirmation (or correction).  I now
have a much better understanding of barriers than I did
before, but there are still corners I haven't wrapped
my head around.

Ben, please feel free do trim off this stuff as you
see fit.

					-Alex

> 
>> I came to suspect this code because we had a customer with a system
>> that was hung with one or more tasks stuck in __xfs_iflock().  A
>> little poking around the affected code led me to the comments in
>> wake_up_bit().
>>
>> Signed-off-by: Alex Elder <elder@inktank.com>
>> ---
>>  fs/xfs/xfs_inode.h |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
>> index 22baf6e..237e7f6 100644
>> --- a/fs/xfs/xfs_inode.h
>> +++ b/fs/xfs/xfs_inode.h
>> @@ -419,6 +419,7 @@ static inline void xfs_iflock(struct xfs_inode *ip)
>>  static inline void xfs_ifunlock(struct xfs_inode *ip)
>>  {
>>  	xfs_iflags_clear(ip, XFS_IFLOCK);
>> +	smp_mb();
>>  	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
> 
> ACK, smp_mb() is needed because spin_unlock() is not a memory
> barrier and so not everyone will have seen the bit being cleared.
> 
> Reviewed-by: Dave Chinner <david@fromorbit.com>
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
