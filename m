Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04Lp42I046356 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 15:51:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B84F61D0C6E5
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 13:53:10 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	DiTsuVoltC2D86Tn for <xfs@oss.sgi.com>;
	Tue, 04 Jan 2011 13:53:10 -0800 (PST)
Date: Wed, 5 Jan 2011 08:53:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Simultaneously mounting one XFS partition on multiple machines
Message-ID: <20110104215306.GM15179@dastard>
References: <AANLkTi=B_zhQG9P22gXcb40JZT=VnEUedTW9xxcuN4cP@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=B_zhQG9P22gXcb40JZT=VnEUedTW9xxcuN4cP@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 04, 2011 at 09:46:39AM -0800, Patrick J. LoPresti wrote:
> Hey, what's the worst that could happen?

That's just asking for trouble. ;)

> I recently learned that some of my colleagues have configured two
> Linux systems to simultaneously mount a single XFS partition residing
> on shared storage.  Specifically, "system R" has the partition mounted
> read-only while "system W" has it mounted read/write.
> 
> I told them that this sounds like a very bad idea because XFS is not a
> clustered file system.  But they are skeptical because "it seems to be
> working fine".  I need to know what the actual risks are and whether
> they can be mitigated.

Ok, so it will appear to work fine most of the time...

> This partition holds large amounts of essentially archival data; that
> is, it is read frequently but written rarely.  When they do want to
> write to it, they do so via system W and then reboot system R.

You could probably just run "echo 3 > /proc/sys/vm/drop_caches" or
just umount/mount the device again to get the same effect as
rebooting.

> I am no expert on XFS, but there are essentially two risks that I can see:
> 
> Risk 1: When making changes via system W, the view of the file system
> from system R can become corrupted or inconsistent.  My colleagues are
> aware of this and believe they can live with it, as long as the
> underlying file system is not being damaged ("we can just reboot").

Yup, so long as system R does not cache anything, or the caches are
dropped after system W writes, you should be fine. However, there is a
window between system W starting to write and system R
being rebooted that system R could read inconsistent metadata and/or
data. There's not much you can do about that apart from take system
R offline while system W is writing.

> Risk 2: Any time the file system is mounted, even read-only, it will
> replay the journal if it is non-empty.  (At least, I believe this is
> true.  Could one of you please confirm or deny?)  So if machine R
> should reboot while the journal is non-empty, it will replay it,
> causing fairly unpredictable on-disk corruption.

Yup.

> Here are my questions.
> 
> 1) When can a read-only XFS mount write to the disk, exactly?

Log recovery only. Use mount -o ro,norecovery to avoid that.

> 2) If I do a "sync" on machine W (and perform no further writes), will
> that truncate the journal?

FYI, the journal cannot be truncated - it is a fixed size circular
log.

To get the log clean, I'd freeze the filesystem on system W while
system R mounts. e.g:

	system W		system R
				unmount <fs>
	write data
	freeze fs
				mount -o ro,norecovery <fs>
	unfreeze fs

> 3) What am I missing?

1. NFS/CIFS. No need for shared access to the block device. NFs
works pretty well for read only access, especially if you put a
dedicated 10GbE link between the two machines...

2. Snapshots. If you must share the block device, snapshot the
active filesystem and mount that readonly on system R - the snapshot
will be unchanging. When system W knows a snapshot is unmounted and
finished with, it can delete it.  That is:


	system W		system R
	write data
	....
	write data
	snapshot <fs.ss2>
				umount <fs.ss1>
				mount -o ro,norecovery <fs.ss2>
	delete snapshot <fs.ss1>
	....
	write data
	.....
	write data
	snapshot <fs.ss3>
				umount <fs.ss2>
				mount -o ro,norecovery <fs.ss3>
	delete snapshot <fs.ss2>
	....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
