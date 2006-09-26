Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 13:07:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8QK7aaG002239
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 13:07:37 -0700
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4042AD118FE5
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 11:54:22 -0700 (PDT)
Date: Tue, 26 Sep 2006 14:51:45 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
Message-ID: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
MIME-Version: 1.0
Subject: Long sleep with i_mutex in xfs_flush_device(), affects NFS service
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, nfs@lists.sourceforge.net

Hi,

I'm seeing an unpleasant behavior when an XFS file system becomes full, 
particularly when accessed over NFS. Both XFS and the linux NFS client 
appear to be contributing to the problem.

When the file system becomes nearly full, we eventually call down to 
xfs_flush_device(), which sleeps for 0.5seconds, waiting for xfssyncd to 
do some work.

xfs_flush_space()does
         xfs_iunlock(ip, XFS_ILOCK_EXCL);
before calling xfs_flush_device(), but i_mutex is still held, at least 
when we're being called from under xfs_write(). It seems like a fairly 
long time to hold a mutex. And I wonder whether it's really necessary to 
keep going through that again and again for every new request after we've 
hit NOSPC.

In particular this can cause a pileup when several threads are writing 
concurrently to the same file. Some specialized apps might do that, and 
nfsd threads do it all the time.

To reproduce locally, on a full file system:
#!/bin/sh
for i in `seq 30`; do
   dd if=/dev/zero of=f bs=1 count=1 &
done
wait
time that, it takes nearly exactly 15s.

The linux NFS client typically sends bunches of 16 requests, and so if the 
client is writing a single file, some NFS requests are therefore delayed 
by up to 8seconds, which is kind of long for NFS.

What's worse, when my linux NFS client writes out a file's pages, it does 
not react immediately on receiving a NOSPC error. It will remember and 
report the error later on close(), but it still tries and issues write 
requests for each page of the file. So even if there isn't a pileup on the 
i_mutex on the server, the NFS client still waits 0.5s for each 32K 
(typically) request. So on an NFS client on a gigabit network, on an 
already full filesystem, if I open and write a 10M file and close() it, it 
takes 2m40.083s for it to issue all the requests, get an NOSPC for each, 
and finally have my close() call return ENOSPC. That can stretch to 
several hours for gigabyte-sized files, which is how I noticed the 
problem.

I'm not too familiar with the NFS client code, but would it not be 
possible for it to give up when it encounters NOSPC? Or is there some 
reason why this wouldn't be desirable?

The rough workaround I have come up with for the problem is to have 
xfs_flush_space() skip calling xfs_flush_device() if we are within 2secs 
of having returned ENOSPC. I have verified that this workaround is 
effective, but I imagine there might be a cleaner solution.

Thanks
