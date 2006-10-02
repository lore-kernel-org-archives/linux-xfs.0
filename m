Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 07:46:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k92EkkaG028497
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 07:46:47 -0700
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41564D17722B
	for <xfs@oss.sgi.com>; Mon,  2 Oct 2006 07:46:05 -0700 (PDT)
Date: Mon, 2 Oct 2006 10:45:12 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <451A618B.5080901@agami.com>
Message-ID: <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
 <451A618B.5080901@agami.com>
MIME-Version: 1.0
Subject: Re: Long sleep with i_mutex in xfs_flush_device(), affects NFS
 service
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: xfs@oss.sgi.com

On Wed, 27 Sep 2006, Shailendra Tripathi wrote:

> Hi Stephane,
>>  When the file system becomes nearly full, we eventually call down to
>>  xfs_flush_device(), which sleeps for 0.5seconds, waiting for xfssyncd to
>>  do some work. xfs_flush_space()does
>>          xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>  before calling xfs_flush_device(), but i_mutex is still held, at least
>>  when we're being called from under xfs_write(). 
>
> 1. I agree that the delay of 500 ms is not a deterministic wait.
>
> 2. xfs_flush_device is a big operation. It has to flush all the dirty pages 
> possibly in the cache on the device. Depending upon the device, it might take 
> significant amount of time. Keeping view of it, 500 ms in that unreasonable. 
> Also, perhaps you would never want more than one request to be queued for 
> device flush.
> 3. The hope is that after one big flush operation, it would be able to free 
> up resources which are in transient state (over-reservation of blocks, 
> delalloc, pending removes, ...). The whole operation is intended to make sure 
> that ENOSPC is not returned unless really required.

Yes I had surmised as much. That last part is still a little vague to 
me... But my two points were:

-It's a long time to hold a mutex. The code bothers to drop the 
xfs_ilock, so I'm wondering whether the i_mutex had been forgotten?

-Once we've actually hit ENOSPC, do we need to try again? Isn't it 
possible to tell when resources have actually been freed?

> 4. This wait could be made deterministic by waiting for the syncer thread to 
> complete when device flush is triggered.

I remember that some time ago, there wasn't any xfs_syncd, and the 
flushing operation was performed by the task wanting the free space. And 
it would cause deadlocks. So I presume we would have to be careful if we 
wanted to wait on sync.

>>  The rough workaround I have come up with for the problem is to have
>>  xfs_flush_space() skip calling xfs_flush_device() if we are within 2secs
>>  of having returned ENOSPC. I have verified that this workaround is
>>  effective, but I imagine there might be a cleaner solution.
>
> The fix would not be a good idea for standalone use of XFS.
>
>         if (nimaps == 0) {
>                 if (xfs_flush_space(ip, &fsynced, &ioflag))
>                         return XFS_ERROR(ENOSPC);
>
>                 error = 0;
>                 goto retry;
>         }
>
> xfs_flush_space:
>         case 2:
>                 xfs_iunlock(ip, XFS_ILOCK_EXCL);
>                 xfs_flush_device(ip);
>                 xfs_ilock(ip, XFS_ILOCK_EXCL);
>                 *fsynced = 3;
>                 return 0;
>         }
>         return 1;
>
> lets say that you don't enqueue it for another 2 secs. Then, in next retry it 
> would return 1 and, hence, outer if condition would return ENOSPC. Please 
> note that for standalone XFS, the application or client mostly don't retry 
> and, hence, it might return premature ENOSPC.
>
> You didn't notice this because, as you said, nfs client will retry in case of 
> ENOSPC.

I'm not entirely sure I follow your explanation. The *fsynced variable is 
local to the xfs_iomap_write_delay() caller, so each call will go through 
the three steps in xfs_flush_space(). What my workaround does is, if we've 
done the xfs_flush_device() thing and still hit ENOSPC within the last two 
seconds, and we've just tried again the first two xfs_flush_space() steps, 
then we skip the third step and return ENOSPC. So yes the file system 
might not be exactly entirely full anymore, which is why I say it's a 
rough workaround, but it seems to me the discrepancy shouldn't be very big 
either. Whatever free space might have been missed would have had to be 
freed after the last ENOSPC return, and must be such that only another 
xfs_flush_device() call will make it available.

It seems to me ENOSPC has never been something very exact anyway: df 
(statfs) often still shows a few remaining free blocks even on a full file 
system. Apps can't really calculate how many blocks will be needed for 
inodes, btrees and directories, so the number of remaining data blocks is 
an approximation. I am not entirely sure that what xfs_flush_device_work() 
does is quite deterministic, and as you said the wait period is arbitrary. 
And I don't particularly care to get every single last byte out of my file 
system, as long as there are no flagrant inconsistencies such as rm -fr 
not freeing up some space.

> Assuming that you don't return *fsynced = 3 (instead *fsynced = 2), the code 
> path will loop (because of retry) and CPU itself would become busy for no 
> good job.

Indeed.

> You might experiment by adding deterministic wait. When you enqueue, set 
> some flag. All others who come in between just get enqueued. Once, device 
> flush is over wake up all. If flush could free enough resources, threads will 
> proceed ahead and return. Otherwise, another flush would be enqueued to flush 
> what might have come since last flush.

But how do you know whether you need to flush again, or whether your file 
system is really full this time? And there's still the issue with the 
i_mutex.

Perhaps there's a way to evaluate how much resources are "in transient 
state" as you put it. Otherwise, we could set a flag when ENOSPC is 
returned, and have that flag cleared at appropriate places in the code 
where blocks are actually freed. I keep running into various deadlocks 
related to full file systems, so I'm wary of clever solutions :-).

[Dropped nfs@lists.sourceforge.net from Cc, as this discussion is quite 
specific to xfs.]
