Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Sep 2006 04:37:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8RBbmaG029225
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:37:50 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9461CD118FE1
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:37:08 -0700 (PDT)
Received: from agami.com ([192.168.168.146])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8RBaaRC004312
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:36:36 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8RBaVqq015842
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 04:36:31 -0700
Message-ID: <451A618B.5080901@agami.com>
Date: Wed, 27 Sep 2006 17:03:31 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: Long sleep with i_mutex in xfs_flush_device(), affects NFS service
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
In-Reply-To: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: xfs@oss.sgi.com, nfs@lists.sourceforge.net

Hi Stephane,
> When the file system becomes nearly full, we eventually call down to 
> xfs_flush_device(), which sleeps for 0.5seconds, waiting for xfssyncd to 
> do some work. 
> xfs_flush_space()does
>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> before calling xfs_flush_device(), but i_mutex is still held, at least 
> when we're being called from under xfs_write(). 

1. I agree that the delay of 500 ms is not a deterministic wait.

2. xfs_flush_device is a big operation. It has to flush all the dirty 
pages possibly in the cache on the device. Depending upon the device, it 
might take significant amount of time. Keeping view of it, 500 ms in 
that unreasonable. Also, perhaps you would never want more than one 
request to be queued for device flush.
3. The hope is that after one big flush operation, it would be able to 
free up resources which are in transient state (over-reservation of 
blocks, delalloc, pending removes, ...). The whole operation is intended 
to make sure that ENOSPC is not returned unless really required.

4. This wait could be made deterministic by waiting for the syncer 
thread to complete when device flush is triggered.

> It seems like a fairly long time to hold a mutex. And I wonder whether it's really 

It might not be that good even if it doesn't. This can return pre-mature 
ENOSPC or it can queue many xfs_flush_device requests (which can make 
your system dead(-slow) anyway)

> necessary to keep going through that again and again for every new request after 
> we've hit NOSPC.
> 
> In particular this can cause a pileup when several threads are writing 
> concurrently to the same file. Some specialized apps might do that, and 
> nfsd threads do it all the time.
> 
> To reproduce locally, on a full file system:
> #!/bin/sh
> for i in `seq 30`; do
>   dd if=/dev/zero of=f bs=1 count=1 &
> done
> wait
> time that, it takes nearly exactly 15s.
> 
> The linux NFS client typically sends bunches of 16 requests, and so if 
> the client is writing a single file, some NFS requests are therefore 
> delayed by up to 8seconds, which is kind of long for NFS.
> 
> What's worse, when my linux NFS client writes out a file's pages, it 
> does not react immediately on receiving a NOSPC error. It will remember 
> and report the error later on close(), but it still tries and issues 
> write requests for each page of the file. So even if there isn't a 
> pileup on the i_mutex on the server, the NFS client still waits 0.5s for 
> each 32K (typically) request. So on an NFS client on a gigabit network, 
> on an already full filesystem, if I open and write a 10M file and 
> close() it, it takes 2m40.083s for it to issue all the requests, get an 
> NOSPC for each, and finally have my close() call return ENOSPC. That can 
> stretch to several hours for gigabyte-sized files, which is how I 
> noticed the problem.
> 
> I'm not too familiar with the NFS client code, but would it not be 
> possible for it to give up when it encounters NOSPC? Or is there some 
> reason why this wouldn't be desirable?
> 
> The rough workaround I have come up with for the problem is to have 
> xfs_flush_space() skip calling xfs_flush_device() if we are within 2secs 
> of having returned ENOSPC. I have verified that this workaround is 
> effective, but I imagine there might be a cleaner solution.

The fix would not be a good idea for standalone use of XFS.

         if (nimaps == 0) {
                 if (xfs_flush_space(ip, &fsynced, &ioflag))
                         return XFS_ERROR(ENOSPC);

                 error = 0;
                 goto retry;
         }

xfs_flush_space:
         case 2:
                 xfs_iunlock(ip, XFS_ILOCK_EXCL);
                 xfs_flush_device(ip);
                 xfs_ilock(ip, XFS_ILOCK_EXCL);
                 *fsynced = 3;
                 return 0;
         }
         return 1;

lets say that you don't enqueue it for another 2 secs. Then, in next 
retry it would return 1 and, hence, outer if condition would return 
ENOSPC. Please note that for standalone XFS, the application or client 
mostly don't retry and, hence, it might return premature ENOSPC.
You didn't notice this because, as you said, nfs client will retry in 
case of ENOSPC.

Assuming that you don't return *fsynced = 3 (instead *fsynced = 2), the 
code path will loop (because of retry) and CPU itself would become busy 
for no good job.

You might experiment by adding deterministic wait. When you enqueue, set 
  some flag. All others who come in between just get enqueued. Once, 
device flush is over wake up all. If flush could free enough resources, 
threads will proceed ahead and return. Otherwise, another flush would be 
enqueued to flush what might have come since last flush.

> Thanks
> 
> 
