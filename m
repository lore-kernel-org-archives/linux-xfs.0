Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0105.outbound.protection.outlook.com ([104.47.34.105]:35079
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934281AbeCMQA1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Mar 2018 12:00:27 -0400
From: Robert Dorr <rdorr@microsoft.com>
Subject: RE: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes
Date: Tue, 13 Mar 2018 16:00:24 +0000
Message-ID: <BN6PR21MB074023CEF5DE1B70D0AA2363B8D20@BN6PR21MB0740.namprd21.prod.outlook.com>
References: <20180301014144.28892-1-david@fromorbit.com>
 <CAA9_cmebHisbzU9CHVpq77UrtCTev_yT=3_SWhUX5oZNOJZwcw@mail.gmail.com>
 <CY4PR21MB074130B753A5BF81332A5171B8D20@CY4PR21MB0741.namprd21.prod.outlook.com>
 <20180313051037.GC18129@dastard>
In-Reply-To: <20180313051037.GC18129@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Scott Konersmann <scottkon@microsoft.com>, Slava Oks <slavao@microsoft.com>, Jasraj Dange <jasrajd@microsoft.com>, Michael Nelson <micn@microsoft.com>

Very helpful, allow me to provide some concrete scenarios.  SQL Server has =
data and log files and we honor WAL to provide for proper crash recovery an=
d durability of the database.

	*	http://www.microsoft.com/technet/prodtechnol/sql/2000/maintain/sqlIObasi=
cs.mspx=20
	*	http://download.microsoft.com/download/4/f/8/4f8f2dc9-a9a7-4b68-98cb-163=
482c95e0b/SQLIOBasicsCh2.doc=20

---------------------------------------------------------------------------=
------------------
#1 Scenario - Write vs Flush and io_getevents Ordering
---------------------------------------------------------------------------=
------------------
If SQL Server opens data and log files with O_DIRECT | O_DSYNC

1.	T1 - SQL Server issues io_submit (IOCB_CMD_WRITE) for data file Page
		xfs_write_file_iter issues xfs_file_dio_aio_write (W1)
		As you pointed out the return is -EIOCBQUEUED (from the block device dire=
ct I/O queue insert when !sync) so T1 can continue forward and would skip t=
he generic_write_sync in xfs_write_file_iter

2.	T2 - SQL Server is waiting on io_getevents for the I/O (W1) posted by T1=
 via the same async kernel I/O context
	When the W1 is considered complete SQL Server can truncate/reuse our datab=
ase log file.  I need to validate that the kernel only returns from io_gete=
vents for W1 processed by hardware before F1 was issued and completed, then=
 SQL Server can safely truncate the database transaction log.
=09
	The code shows iomap_dio_complete_work that I expected to issue the REQ_PR=
EFLUSH for the O_DSYNC based write and prevent the completion from getting =
to the io_getevents caller.  The patch moved this to the iomap_dio_complete=
 which I believe meets my needs. =20

I think the answer is the iomap* logic makes sure to issue generic_write_sy=
nc for O_DSYNC W1 after W1 is completed by hardware and then waits for comp=
letion of the flush request (REQ_PREFLUSH) before W1 is returned to the AIO=
 completion ring, preventing io_getevents from processing W1 before the flu=
sh occurs and completes.   I just need proper confirmation from the experts=
 on this code that this is the expected behavior.

---------------------------------------------------------------------------=
------------------
#2 Dynamic determination of performant FUA capabilities
---------------------------------------------------------------------------=
------------------
For SQL Server using O_DIRECT | O_DSYNC on current kernels is very performa=
nce impacting.   Instead we enable a mode for SQL that opens O_DIRECT only =
and issues fsync/fdatasync when we are hardening log files or checkpointing=
 data files.   This reduces the write, flush, write, flush pattern allowing=
 for write, write, write, ... then flush as we only issue flush requests wh=
en required to maintain the data integrity boundaries of SQL Server.  The p=
erformance is significantly better then the device flush for each write as =
you can imagine.

Testing shows the FUA enhancement is better then the write, flush pattern. =
  For SQL Server we want to dynamically open with O_DIRECT | O_DSYNC when R=
EQ_FUA can be properly used and open with O_DIRECT and leverage SQL Server'=
s alternate flush scheme when running on older kernel or a system that does=
 not support FUA (SATA, IDE, ...)


-----Original Message-----
From: Dave Chinner <david@fromorbit.com>=20
Sent: Tuesday, March 13, 2018 12:11 AM
To: Robert Dorr <rdorr@microsoft.com>
Cc: Dan Williams <dan.j.williams@intel.com>; linux-xfs@vger.kernel.org; Chr=
istoph Hellwig <hch@lst.de>; linux-fsdevel <linux-fsdevel@vger.kernel.org>;=
 Jan Kara <jack@suse.cz>; Theodore Ts'o <tytso@mit.edu>; Matthew Wilcox <ma=
wilcox@microsoft.com>; Scott Konersmann <scottkon@microsoft.com>; Slava Oks=
 <slavao@microsoft.com>; Jasraj Dange <jasrajd@microsoft.com>; Michael Nels=
on <micn@microsoft.com>
Subject: Re: [PATCH] [RFC] iomap: Use FUA for pure data O_DSYNC DIO writes

[This sender failed our fraud detection checks and may not be who they appe=
ar to be. Learn about spoofing at http://aka.ms/LearnAboutSpoofing]

On Tue, Mar 13, 2018 at 12:15:28AM +0000, Robert Dorr wrote:
> Hello all.  I have a couple of follow-up questions around this effort,=20
> thanks you all for all your kind inputs, patience and knowledge=20
> transfer.
>
> 1.    How does xfs or ext4 make sure a pattern of WS followed by
> FWS does not allow the write (WS) completion to be visible before the=20
> flush completes?

I'm not sure what you are asking here. You need to be more precise about wh=
at these IOs are, who dispatched them and what their dependencies are. Wher=
e exactly did that FWS (REQ_FLUSH) come from?

I think, though, you're asking questions about IO ordering at the wrong lev=
el - filesystems serialise and order IO, not the block layer. Hence what yo=
u see at the block layer is not necessary a reflection of the ordering the =
filesystem is doing.

(I've already explained this earlier today in a different thread:
https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fmarc.inf=
o%2F%3Fl%3Dlinux-xfs%26m%3D152091489100831%26w%3D2&data=3D04%7C01%7Crdorr%4=
0microsoft.com%7C19bb64450eba4b0f2c8308d588a0c4e1%7C72f988bf86f141af91ab2d7=
cd011db47%7C1%7C0%7C636565146506974722%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4w=
LjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwifQ%3D%3D%7C100&sdata=3Do0CgiPt1dsfA=
LFS5fXHRGy2jlD1t4HIBjjqD%2BqOKnb4%3D&reserved=3D0)

That's why I ask about the operation causing a REQ_FLUSH to be issued to th=
e storage device, as that cannot be directly issued from userspace. It will=
 occur as a side effect of a data integrity operation the filesystem is ask=
ed to perform, but without knowing the relationship between the integrity o=
peration and the write in question an answer cannot be given.

It may would be better to describe your IO ordering and integrity requireme=
nts at a higher level (e.g. the syscall layer), because then we know what y=
ou are trying to acheive rather that trying to understand your problem from=
 context-less questions about "IO barriers" that don't actually exist...

> I suspected the write was held in
> iomap_dio_complete_work but with the generic_write_sync change in the=20
> patch would a O_DSYNC write request to a DpoFua=3D0 block queue allow T2=
=20
> to see the completion via io_getevents before T1 completed the actual=20
> flush?

Yes, that can happen as concurrent data direct IO are not serialised agains=
t each other and will always race to completion without providing any order=
ing guarantees.  IOWs, if you have an IO ordering dependency in your applic=
ation, then that ordering dependency needs to be handled in the application=
.

> 2.    How will my application be able to dynamically determine if
> xfs and ext4 have the performance enhancement for FUA or I need engage=20
> alternate methods to use fsync/fdatasync at strategic locations?

You don't. The filesystem will provide the same integrity guarantees in eit=
her case - FUA is just a performance optimisation that will get used if you=
r hardware supports it. Applications should not care what capabilities the =
storage hardawre has - the kernel should do what is fastest and most reliab=
le for the underlying storage....

> 3.    Are there any plans yet to optimize ext4 as well?

Not from me.

> 4.    Before the patched code the xfs_file_write_iter would call
> generic_write_sync and that calls submit_io_wait.  Does this hold the=20
> thread issuing the io_submit so it is unable to drive more async I/O?

No, -EIOCBQUEUED is returned to avoid blocking.
AIO calls generic_write_sync() from the IO completion path via a worker thr=
ead so it's all done asynchronously.


Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
