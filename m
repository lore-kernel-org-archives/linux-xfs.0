Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Feb 2007 08:50:13 -0800 (PST)
Received: from info11.gawab.com (info11.gawab.com [204.97.230.49])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1FGo5m7022369
	for <xfs@oss.sgi.com>; Thu, 15 Feb 2007 08:50:07 -0800
Message-ID: <20070215161932.3230.qmail@info11.gawab.com>
From: "Ahmed El Zein" <a.elzein@gawab.net>
Subject: Re: xfs internal error on a new filesystem
Date: Thu, 15 Feb 2007 16:19:32 GMT
Content-Type: text/plain ; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Ramy M. Hassan " <ramy@gawab.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



David Chinner <dgc@sgi.com> wrote on 15 Feb 2007, 11:16 AM:
Subject: Re: xfs internal error on a new filesystem
>On Wed, Feb 14, 2007 at 10:24:27AM +0000, Ramy M. Hassan  wrote:
>> Hello,
>> We got the following xfs internal error on one of our production servers:
>> 
>> Feb 14 08:28:52 info6 kernel: [238186.676483] Filesystem "sdd8": XFS
>> internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c. 
>> Caller 0xf8b906e7
>
>Real stack looks to be:
>
> xfs_trans_cancel
> xfs_mkdir
> xfs_vn_mknod
> xfs_vn_mkdir
> vfs_mkdir
> sys_mkdirat
> sys_mkdir
>
>We aborted a transaction for some reason. We got an error somewhere in
>a mkdir while we had a dirty transaction.  Unfortunately, this tells us
>very
>little about the error that actually caused the shutdown.
>
>What is your filessytem layout? (xfs_info <mntpt>) How much memory
>do you have and were you near enomem conditions?

We have 1536 MB of ram. It is possible that at the time of the crash we
were near enomem conditions, I don;t know for sure but we have seen such
spikes on our servers.

root@info6:~# xfs_info /vol/6/
meta-data=/dev/sdd8              isize=256    agcount=16, agsize=7001584
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=112025248, imaxpct=25
         =                       sunit=16     swidth=64 blks, unwritten=0
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


>
>> We were able to unmount/remount the volume (didn't do xfs_repair because
>we
>> thought it might take long time, and the server was already in production
>> at the moement)
>
>Risky to run a production system on a filesystem that might be corrupted.
>You risk further problems if you don't run repair....
>
>> The file system was created less than 48hours ago, and 370G of sensitve
>> production data was moved to the server before it xfs crash.
>
>So that's not a "new" filesystem at all...
By new we meant 48 hours old.

>
>FWIW, did you do any offline testing before you put it into production?

We did some basic testing. But as a filesystem developer, how would you
test a filesystem so that you would be comfortable with the stability of 
the filesystem and be worry free in terms of faulty hardware? 

>
>> System details :
>> Kernel: 2.6.18
>> Controller: 3ware 9550SX-8LP (RAID 10)
>
>Can you describe your dm/md volume layout?

one unit, 8HDDs, a stripe of 4 mirrors.

>
>> We are wondering here if this problem is an indicator to data corruption
>on
>> disk ?
>
>It might be. You didn't run xfs_check or xfs_repair, so we don't know if
>there is any on disk corruption here.
>
>> is it really necessary to run xfs_repair ?
>
>If you want to know if you haven't left any landmines around for the
>filesystem to trip over again. i.e. You should run repair after any
>sort of XFS shutdown to make sure nothing is corrupted on disk.
>If nothing is corrupted on disk, then we are looking at an in-memory
>problem....
we will run repair tonight.

>
>> Do u recommend that we switch back to reiserfs ?
>
>Not yet.
>
>> Could it be a hardware related problems  ?
>
>Yes. Do you have ECC memory on your server? Have you run memtest86?
>Were there any I/O errors in the log prior to the shutdown message?
Yes, we have ECC memory.
We will try to run memtest86 as soon as possible.
There were no I/O errors in the log prior to the shutdown message.

Btw, this is a vmware image. /vol/6 is an exported physical partition.

>Cheers,
>
>Dave.
>-- 
>Dave Chinner
>Principal Engineer
>SGI Australian Software Group
>
