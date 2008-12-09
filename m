Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB959uif027427 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 23:09:56 -0600
Message-ID: <493DFDBD.7060909@sgi.com>
Date: Tue, 09 Dec 2008 16:10:21 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [Fwd: [PATCH] Fix race in xfs_write() between direct and	buffered
	I/O with DMAPI]
References: <493779B1.3010703@sgi.com> <20081208225125.GA15647@infradead.org>
In-Reply-To: <20081208225125.GA15647@infradead.org>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Dec 04, 2008 at 05:33:21PM +1100, Lachlan McIlroy wrote:
>> --- a/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-22 15:47:38.000000000 +1000
>> +++ b/fs/xfs/linux-2.6/xfs_lrw.c	2008-09-22 15:50:56.000000000 +1000
>> @@ -707,7 +707,6 @@ start:
>> 		}
>> 	}
>>
>> -retry:
>> 	/* We can write back this queue in page reclaim */
>> 	current->backing_dev_info = mapping->backing_dev_info;
>>
>> @@ -763,6 +762,17 @@ retry:
>> 	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
>> 		ret = wait_on_sync_kiocb(iocb);
>>
>> +	isize = i_size_read(inode);
>> +	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
>> +		*offset = isize;
>> +
>> +	if (*offset > xip->i_size) {
>> +		xfs_ilock(xip, XFS_ILOCK_EXCL);
>> +		if (*offset > xip->i_size)
>> +			xip->i_size = *offset;
>> +		xfs_iunlock(xip, XFS_ILOCK_EXCL);
>> +	}
>> +
>> 	if (ret == -ENOSPC &&
>> 	    DM_EVENT_ENABLED(xip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
>> 		xfs_iunlock(xip, iolock);
> 
> Moving these updates to before the dmapi nospace callout provale doesn't
> make any changes to the non-dmapi codepath, so good from that
> perspective.  And as you say above it makes sense to have this update
> before the dmapi callout.
> 
>> @@ -776,20 +786,7 @@ retry:
>> 		xfs_ilock(xip, iolock);
>> 		if (error)
>> 			goto out_unlock_internal;
>> -		pos = xip->i_size;
>> -		ret = 0;
>> -		goto retry;
>> -	}
>> -
>> -	isize = i_size_read(inode);
>> -	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
>> -		*offset = isize;
>> -
>> -	if (*offset > xip->i_size) {
>> -		xfs_ilock(xip, XFS_ILOCK_EXCL);
>> -		if (*offset > xip->i_size)
>> -			xip->i_size = *offset;
>> -		xfs_iunlock(xip, XFS_ILOCK_EXCL);
>> +		goto start;
> 
> Again all this won't affect non-dmapi operations, so OK with my mainline
> hat on.  Now if we check what start does over the old retry labels:
> 
>  - calls generic_write_checks.  This could and should redo checks based
>    on the new inode size, ok.
>  - dmapi write even - shouldn't happen because eventsent is non-zero,
>    ok.
>  - O_DIRECT alignment validation.  Superflous, but harmless, ok.
>  - check for exclusive lock.  This is what you said you wanted, and
>    indded due to the lock dropping we need it.  But why don't
>    you duplicate this check in the dmapi case below so that we
>    only have to go to start once instead of possibly twice?
Thanks for looking at this Christoph.

I'm not sure what you mean by duplicating the checks.  I assume you
mean this check:

		if (!need_i_mutex && (mapping->nrpages || pos > xip->i_size)) {
			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
			iolock = XFS_IOLOCK_EXCL;
			need_i_mutex = 1;
			mutex_lock(&inode->i_mutex);
			xfs_ilock(xip, XFS_ILOCK_EXCL|iolock);
			goto start;
		}

This check is there because the default case for direct I/O is to
acquire the iolock in shared mode.  If we have work to do which
requires the iolock to be held exclusive then drop the lock and get
it again.  Since we dropped the lock then restart.

In the dmapi post-write event it doesn't matter if we have the
iolock shared or exclusive - it will be dropped regardless so I
don't see how checking the state of the iolock will allow us to
avoid a restart.

>  - i_new_size update - needed due to the possible i_size changes, ok
>  - ichgtime - if time passed since the last time we might want to
>    re-updated it, ok
>  - zero_eof, ok
>  - setuid clearing, superflous, but harmless.
> 
> So the patch looks good to me, but as mention above it might be possible
> to optimize it a littler more.
>   
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
