Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG1K1j8044813 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 19:20:01 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	imS0ihFYtKpnS7Zt for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 17:22:03 -0800 (PST)
Date: Fri, 16 Nov 2012 12:22:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/32 V2] xfs: verify dquot blocks as they are read from
	disk
Message-ID: <20121116012201.GN14281@dastard>
References: <1352721264-3700-18-git-send-email-david@fromorbit.com>
	<20121114065013.GE1710@dastard> <50A52CA3.3060604@sgi.com>
	<20121115204830.GG14281@dastard> <50A5583D.5070101@sgi.com>
	<20121115211608.GI14281@dastard> <50A55FEC.30106@sgi.com>
	<20121115220117.GJ14281@dastard> <50A56C2A.5000805@sgi.com>
	<20121115223358.GM14281@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121115223358.GM14281@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 16, 2012 at 09:33:58AM +1100, Dave Chinner wrote:
> On Thu, Nov 15, 2012 at 04:26:50PM -0600, Mark Tinguely wrote:
> > On 11/15/12 16:01, Dave Chinner wrote:
> > >On Thu, Nov 15, 2012 at 03:34:36PM -0600, Mark Tinguely wrote:
> > >>On 11/15/12 15:16, Dave Chinner wrote:
> > >>>On Thu, Nov 15, 2012 at 03:01:49PM -0600, Mark Tinguely wrote:
> > >>>>On 11/15/12 14:48, Dave Chinner wrote:
> > >>>>>On Thu, Nov 15, 2012 at 11:55:47AM -0600, Mark Tinguely wrote:
> > >>>>>>The xfs_quota program does not generate output with V2 which causes
> > >>>>>>xfstest 050 to fails.
> > >>>>>
> > >>>>>I don't think that has anything to do with this patch orthechange
> > >>>>>for V2 - V2 only changes quotacheck behaviour, and that doesn't
> > >>>>>impact xfs_quota behaviour. The test passes just fine here:
> > >>>>>
> > >>>>>$ sudo ./check 050
> > >>>>>FSTYP         -- xfs (debug)
> > >>>>>PLATFORM      -- Linux/x86_64 test-2 3.7.0-rc5-dgc+
> > >>>>>MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> > >>>>>MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> > >>>>>
> > >>>>>050 14s ... 15s
> > >>>>>Ran: 050
> > >>>>>Passed all 1 tests
> > >>>>>
> > >>>>>So perhaps there's something else going wrong on your machine?
> > >>>
> > >>>Curious. There aren't any errors in the syslog/dmesg saying that
> > >>>buffers failed verification during the quota check runs, are there?
> > >>>Also, what platform are you testing on?
> > >>
> > >>No error message in dmesg nor /var/log/messages
> > >>
> > >>This is a x86_64.
> > >>
> > >>It is running OSS with most recent commit:
> > >>
> > >>  commit 579b62faa5fb16ffeeb88cda5e2c4e95730881af
> > >>
> > >>Your two series:
> > >>	xfs: fixes for 3.7-rc6
> > >>	xfs: current queue for 3.8
> > >>
> > >>I added the XFS_SB_VERSION2_CRCBIT attribute to xfsprogs and enabled
> > >>it in mkfs.xfs and remade the test/scratch filesystems.
> > >
> > >That's likely your problem. Why are you testing with this bit set -
> > >that's to indicate that there are on disk format changes, and none
> > >of them occur in this patch set. Hence the kernel should be refusing
> > >to mount any filesystem with that bit set. As such, I'm using a
> > >standard userspace for all this regression testing, because
> > >filesystems with the CRC bit should be failed during mount on 3.8.
> > >
> > >/me goes looking....
> > >
> > >Ok, the kernel isn't refusing to mount when that bit is set. That's
> > >a bug in the patch that introduces the CRC bit that I borked when
> > >splitting it out of a larger patch. I'll send an updated patch (it's
> > >the xfs: add CRC infrastructure patch).
> > >
> > 
> > removing the attribute bit from the filesystem/tools does not change
> > the failure on 050 with V2 patches.
> 
> Can you join #xfs on freenode so we can discuss this in realtime?
> There's way too much latency on email....

To keep everyone in the loop:

TL,DR: A bug in xfs_quota, exposed by the repeated output fix, patch
already on the list to fix it.

Longer:

[16/11/12 09:41] <dchinner> tinguely: ping
[16/11/12 09:41] <tinguely> The xfstests 050 must be something I am doing wrong on the x86_64 machine because I just tried the same source on a x86_32 machine and they work fine.
[16/11/12 09:41] <dchinner> what does strace tell you?
[16/11/12 09:42] <dchinner> is xfs_quota actually getting anything back from the kernel?
[16/11/12 09:52] <tinguely> I don;t see xfs_quota doing a ioctl.
[16/11/12 09:58] <dchinner> it's quotactl() cals you need to look for, not ioctl
[16/11/12 09:58] <dchinner> something like:
[16/11/12 09:58] <dchinner> quotactl(Q_XGETQUOTA|0x2 /* ???QUOTA */, "/dev/vdb", 0, {version=1, flags=XFS_PROJ_QUOTA, .....
[16/11/12 09:59] <dchinner> all I've done is modified 050 so it doesn't remove it's temporary files
[16/11/12 09:59] <tinguely> there are none. It seems like the program dies immediately
[16/11/12 09:59] <dchinner> what command are you running?
[16/11/12 10:00] <dchinner> can you pastebin the strace output?
[16/11/12 10:01] <tinguely> There is only one call to /usr/bin/quota and one to /usr/sbin/xfs_quota
[16/11/12 10:02] <dchinner> I'm not sure what you are running - you are tracing 050?
[16/11/12 10:03] <dchinner> what you need to do is modify 050 to not remove temporary files (comment it out of the cleanup function)
[16/11/12 10:03] <dchinner> run 050
[16/11/12 10:03] <dchinner> then find the projid files in /tmp
[16/11/12 10:03] <dchinner> mount scratch with project quota
[16/11/12 10:04] <dchinner> and run the last xfs_quota comand under strace like:
[16/11/12 10:04] <dchinner> $ sudo strace xfs_quota -x -D /tmp/6345.projects -P /tmp/6345.projid -c "repquota -birnN -p" /dev/vdb
[16/11/12 10:25] <tinguely> after the libraries are loaded xfs_quota does:
[16/11/12 10:25] <tinguely> access("/proc/self/mounts", R_OK)       = 0
[16/11/12 10:25] <tinguely> open("/proc/self/mounts", O_RDONLY)     = 3
[16/11/12 10:25] <tinguely> fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
[16/11/12 10:25] <tinguely> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0e4e147000
[16/11/12 10:25] <tinguely> read(3, "rootfs / rootfs rw 0 0\ndevtmpfs "..., 1024) = 1024
[16/11/12 10:25] <tinguely> read(3, "cls 0 0\ncgroup /sys/fs/cgroup/bl"..., 1024) = 788
[16/11/12 10:25] <tinguely> stat("/test2", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0
[16/11/12 10:25] <tinguely> close(3)                                = 0
[16/11/12 10:25] <tinguely> munmap(0x7f0e4e147000, 4096)            = 0
[16/11/12 10:25] <tinguely> open("/tmp/8282.projects", O_RDONLY)    = 3
[16/11/12 10:25] <tinguely> fstat(3, {st_mode=S_IFREG|0644, st_size=9, ...}) = 0
[16/11/12 10:25] <tinguely> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0e4e147000
[16/11/12 10:26] <tinguely> read(3, "1:/test2\n", 4096)             = 9
[16/11/12 10:26] <tinguely> stat("/test2", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0
[16/11/12 10:26] <tinguely> stat("/test2", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0
[16/11/12 10:26] <tinguely> read(3, "", 4096)                       = 0
[16/11/12 10:26] <tinguely> close(3)                                = 0
[16/11/12 10:26] <tinguely> munmap(0x7f0e4e147000, 4096)            = 0
[16/11/12 10:26] <tinguely> exit_group(0)                           = ?
[16/11/12 10:26] <tinguely> scratch is mounted: /dev/sda3 /test2 xfs rw,pquota 0 0
[16/11/12 10:26] <dchinner> what command did you run?
[16/11/12 10:27] * sandeen points at a pastebin ;)
[16/11/12 10:27] <dchinner> FWIW, it is faster and better to use pastebins for large amounts of info (e.g. pastebin.org)
[16/11/12 10:27] <tinguely> strace xfs_quota -D /tmp/8282.projects -P /tmp/8282.projid -x  -c "repquota -birnN -p" /dev/sda3
[16/11/12 10:27] <dchinner> snap!
[16/11/12 10:29] <dchinner> so it hasn't tried to read the projid file at all
[16/11/12 10:31] <dchinner> tinguely: how is xfs-quota supposed to translate /dev/sda3 to a filesystem mount point?
[16/11/12 10:32] <tinguely> sorry got SCRATCH_MNT and SCRATCH_DEV switched on the copy.
[16/11/12 10:33] <dchinner> no, the test does lookup via SCRATCH_DEV
[16/11/12 10:34] <dchinner> what's in /proc/self/mounts ?
[16/11/12 10:34] <tinguely> /dev/sda2 /test1 xfs rw,relatime,attr2,inode64,noquota 0 0
[16/11/12 10:34] <tinguely> /dev/sda3 /test2 xfs rw,relatime,attr2,inode64,prjquota 0 0
[16/11/12 10:37] <tinguely> open("/proc/self/mounts", O_RDONLY)     = 3
[16/11/12 10:37] <tinguely> open("/tmp/8282.projects", O_RDONLY)    = 3
[16/11/12 10:38] <tinguely> read(3, "1:/test2\n", 4096)             = 9
[16/11/12 10:38] <tinguely> stat("/test2", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0
[16/11/12 10:38] <tinguely> stat("/test2", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0
[16/11/12 10:38] <tinguely> read(3, "", 4096)                       = 0
[16/11/12 10:38] <tinguely> close(3)                                = 0
[16/11/12 10:38] <tinguely> munmap(0x7fc89aa63000, 4096)            = 0
[16/11/12 10:38] <tinguely> exit_group(0)                           = ?
[16/11/12 10:40] <dchinner> Ok, so it's terminating somewhere in xfs_quota
[16/11/12 10:40] <dchinner> i.e. not a kernel problem
[16/11/12 10:41] <tinguely> yep. 
[16/11/12 10:41] * dchinner goes and updates his test machines to his current xfsprogs dev tree rather than the current -rc
[16/11/12 10:42] <tinguely> I will do a full source tree update tomorrow. don't know why v1 works.
[16/11/12 10:49] <dchinner> I see that the problem is a recent modification to xfs_quota
[16/11/12 10:50] <dchinner> i.e. the patch to stop outputs being repeated multiple times
[16/11/12 10:50] <dchinner> if you add the "-a" flag, it works
[16/11/12 10:51] <dchinner> the problem has something to do with the way the fstable is initialised
[16/11/12 10:52] <sandeen> dchinner, which commit?  I don't see much in quota/ ?
[16/11/12 10:52] <dchinner> it's not committed yet
[16/11/12 10:52] <dchinner> it's a patch I sent a week ago or so
[16/11/12 10:53] <sandeen> oh
[16/11/12 11:03] <tinguely> xfs_quota: fix report command parsing
[16/11/12 11:05] <tinguely> yep, I had that installed.
[16/11/12 11:15] <dchinner> there's some deeper screwiness going on with xfs-quota here
[16/11/12 11:15] <dchinner> the original version works if you give it the command line "-c" option
[16/11/12 11:15] <dchinner> but if you run the same command interactively, it gives no output
[16/11/12 11:16] <dchinner> so it looks like all I've done is expose an existing bug
[16/11/12 11:17] <tinguely> Do you want me to tell Rich to hold commiting the patch?
[16/11/12 11:18] <dchinner> yes, all I've done is made the command line version get called in exactly the same way as the interactive command is called
[16/11/12 11:18] <dchinner> tinguely: doesn't matter, either way it is a separate patch
[16/11/12 11:18] <tinguely> okay, lets put it in. It is not a major issue.
[16/11/12 11:20] <dchinner> ok, now I understand a bit better
[16/11/12 11:21] <dchinner> this is a maze of twisty passages
[16/11/12 11:22] <dchinner> the original problem was that the report command was being called multiple times, once for each entry in the fs table
[16/11/12 11:24] <dchinner> this is very non-obvious, because the iteration of the table is done via a callback that is only executed if the command is not marked as CMD_FLAG_GLOBAL
[16/11/12 11:25] <dchinner> and that table iteration is done by setting a global variable "fs_path" to a different index in the table in teh callback
[16/11/12 11:26] <dchinner> Now the fs table contains more than just mount points - it also contains project quota root directories
[16/11/12 11:26] <dchinner> and the initialisation of the table uses the fs_path global variable to initialise the entry
[16/11/12 11:26] <dchinner> so when initialisation is complete, fs_path points at teh last entry that was entered into the table.
[16/11/12 11:27] <dchinner> That will *always* be a project path if they are configured on the system.
[16/11/12 11:28] <dchinner> so now, if we treat the report command as global, we don't ever re-initialise fs_path to point to the device/mountpt that was specified on the command line
[16/11/12 11:28] <tinguely> ouch
[16/11/12 11:29] <dchinner> and so when the report command is run, it points to a project path and ignores it.
[16/11/12 11:32] <dchinner> the original problem was that for a given report command, it can iterate the entire fstable itself (e.g. the -a flag for "all mounts"), so when it gets called for each table entry, and iterates the entire table itself, you get multiple outputs
[16/11/12 11:34] <dchinner> so the original fix for this is good, it's just left us tripping over an incorrectly initialised fs_path pointer.
....
[16/11/12 12:14] <dchinner> patch sent


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
