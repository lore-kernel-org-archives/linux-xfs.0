Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3J8Nh7S029135 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 03:23:43 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24B5B15C51D9
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 01:27:08 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tODGaLhOQVL67ic3 for <xfs@oss.sgi.com>;
	Tue, 19 Apr 2011 01:27:08 -0700 (PDT)
Date: Tue, 19 Apr 2011 18:27:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair crashing (versions 3.1.4 and 3.1.5)
Message-ID: <20110419082705.GI23985@dastard>
References: <BANLkTikh1i3aYgXNZut+AGT-1kz=aqv-Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikh1i3aYgXNZut+AGT-1kz=aqv-Eg@mail.gmail.com>
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
To: Anisse Astier <anisse@astier.eu>
Cc: xfs@oss.sgi.com

On Mon, Apr 18, 2011 at 09:24:22PM +0200, Anisse Astier wrote:
> Hi,
> 
> (first of all, I'm not subscribed to the list, Please cc-me on all replies)
> 
> On an ARM NAS, using kernel 2.6.36.2 I managed to crash my root xfs partition.
> 
> xfs_repair cannot then repair this partition and is crashing itself.
> 
> # xfs_info  /dev/sda2
> meta-data=/dev/sda2              isize=256    agcount=32, agsize=7615249 blks
>          =                       sectsz=512   attr=1
> data     =                       bsize=4096   blocks=243687968, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 
> 
> 
> I did a SMART test to ensure the disk didn't have any bad block:
> SMART Error Log Version: 1
> No Errors Logged
> 
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed without error       00%      8327         -
> 
> The dmesg log (on another recovery system with kernel 2.6.36-rc2) ; I
> tried to mount the system :
> [ 1003.257446] XFS mounting filesystem sda2
> [ 1003.301519] Starting XFS recovery on filesystem: sda2 (logdev: internal)
> [ 1003.303068] XFS: bad number of regions (28024) in inode log format
> [ 1003.303142] XFS: log mount/recovery failed: error 5
> [ 1003.303419] XFS: log mount failed

Something has corrupted the log....

> I then had no other choice than suppressing the log with xfs_repair -L.

Yup.

> xfs_repair crashed, but I was able to mount the filesystem(ro), but
> once I tried accessing the corrupt files, xfs would go mad:
> [13717.138896] UDF-fs: No partition found (1)
> [13717.202112] XFS mounting filesystem sda2
> [13717.274885] Ending clean XFS mount for filesystem: sda2
> [43969.970648] sshd (1039): /proc/1039/oom_adj is deprecated, please
> use /proc/1039/oom_score_adj instead.
> [107180.252602] Filesystem "sda2": corrupt dinode 805341224, (btree
> extents).  Unmount and run xfs_repair.

Quite likely, zeroing the log effectively corrupts the filesystem.

.....
> directory flags set on non-directory inode 2283178100, would fix bad flags.
> bad key in bmbt root (is 73434, would reset to 74194) in inode
> 2283178100 data fork
> bad fwd (right) sibling pointer (saw 145202888 should be NULLDFSBNO)
> Segmentation fault

Hmmm. The very next line doesn't appear before the segfault, making
me think that it's the printf that is causing it to crash.

        if (check_dups == 0 &&
                cursor.level[0].right_fsbno != NULLDFSBNO)  {
                do_warn(
        _("bad fwd (right) sibling pointer (saw %llu should be NULLDFSBNO)\n"),
                        cursor.level[0].right_fsbno);

We get this line of output.

                do_warn(
        _("\tin inode %u (%s fork) bmap btree block %llu\n"),
                        XFS_AGINO_TO_INO(mp, agno, ino), forkname,
                        cursor.level[0].fsbno);

But not this one. I wonder if passing a 64bit number to a %u format
string (shoul dbe %llu) causes problems on ARM? All the variables
are valid as they are printed or accessed elsewhere in the function,
so that's the only thing I can think of without a stack trace to
tell me otherwise....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
