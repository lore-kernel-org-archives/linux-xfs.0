Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2U0WDZ6138174 for <xfs@oss.sgi.com>; Mon, 29 Mar 2010 19:32:13 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9385128AFE4
	for <xfs@oss.sgi.com>; Mon, 29 Mar 2010 17:33:57 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org
	(173-164-175-65-SFBA.hfc.comcastbusiness.net [173.164.175.65])
	by cuda.sgi.com with ESMTP id uFr1Txh9XGEBWb6o for
	<xfs@oss.sgi.com>; Mon, 29 Mar 2010 17:33:57 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2U0XtJH020601 for <xfs@oss.sgi.com>; Mon, 29 Mar 2010 17:33:57 -0700
Message-ID: <4BB146F3.3090806@tlinx.org>
Date: Mon, 29 Mar 2010 17:33:55 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: various disk probs...dump: structure needs cleaning (on home),
	on root: invalid arguments (still)
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
To: xfs-oss <xfs@oss.sgi.com>

This morning I got email from my dump job telling me it had a problem on my home
partition.

It said some files had "problems". (see below).  Any idea how this might have ha
ppened?

The system has been up for "some time"
  1:07pm  up 29 days  8:07,  5 users,  load average: 0.15, 0.13, 0.15,
so it hasn't been any recent power fail or such or reconfig.

Running kernel:
Linux Ishtar 2.6.27.29-0.1-vanilla #1 SMP 2009-08-15 17:53:59 +0200 x86_64 x86_6
(Suse 11.0).

Known probs? Fixed in later kerns?
messages at bottom as output from xfsdump

----------------

Also, I _believe_ some of my stability problems have increased since I started
trying to use "lvm" to maintain "snapshots" for enabling "previous versions" under
windows-clients with samba..

Seems like with only a few snapshots performance goes way down as each snapshot
needs to have duplicate data.  Since the Data doesn't change in the snapshots,
wouldn't the only change need to be the new file material written and the old 
snapshots would share the old files -- with the only writes being that which is
writing out the new material?

Wouldn't this work on xfs (or most filesystems), since all the "old" copies of the
files (which wouldn't be changing) could be the same inode (requiring no copies)
to be made?)  Seems like it would save alot of space in these snapshots -- there
*should* be no changes made to snapshots, as they are supposed to be read-only, 
static snapshots, though I suppose that isn't their only use.

Anyway -- the error below -- xfs_repair?
Solved in some newer kernel?"

Same for this error that I still get (it ISN'T related to busy or locked files --
too many on non-busy disks). -- only happens with xfs_fsr (and never used to before
about 6 months ago)....

Note -- only happens on root which is relatively static:
Mar 28 02:17:05 Ishtar fsr[19203]: / start inode=0
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=5982243: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=7584775: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=16784218: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=16784980: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=16789184: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=16792500: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=16792601: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=17181156: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=24019080: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=25978039: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=50337960: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19203]: XFS_IOC_SWAPEXT failed: ino=50349588: Invalid argument
Mar 28 02:17:05 Ishtar fsr[19204]: /usr start inode=0
Mar 28 02:17:06 Ishtar fsr[19207]: /var start inode=0
Mar 28 02:17:06 Ishtar fsr[19208]: /boot start inode=0
Mar 28 02:17:06 Ishtar fsr[19209]: /var/cache start inode=0
Mar 28 02:17:06 Ishtar fsr[19210]: /home start inode=0
Mar 28 02:17:07 Ishtar fsr[19213]: /Share start inode=0
Mar 28 02:17:07 Ishtar fsr[19214]: /backups start inode=0
Mar 28 02:17:08 Ishtar fsr[19215]: / start inode=0
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=5982243: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=7584775: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=16784218: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=16784980: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=16789184: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=16792500: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=16792601: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=17181156: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=24019080: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=25978039: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=50337960: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19215]: XFS_IOC_SWAPEXT failed: ino=50349588: Invalid argument
Mar 28 02:17:08 Ishtar fsr[19216]: /usr start inode=0
---
Unfortunately, I haven't been able to figure out how to run xfs_db on a live
partition -- keeps telling me there is a log to be replayed and I should mount
the partition...(BUT IT IS mounted!)...
Sigh...



---------------------
XFSDUMP messages
=========================





dump home failed
****
Dump fsname home, Mountpoint /home, Dumplevel=6
Notice: "-e" used in Xfsdump_options to allow exclusions
xfsdump -b 1m -l 6 -L home -e - /home | ( su -f -m backup -c " umask 027;nice -1
9 ionice -c3 gzip > home/home-100329-6-0431.dump.gz  " )
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 2.2.48 (dump format 3.0) - Running single-threaded
xfsdump: level 6 incremental dump of Ishtar:/home based on level 4 dump begun Sa
t Mar 27 04:31:30 2010
xfsdump: dump date: Mon Mar 29 04:31:41 2010
xfsdump: session id: d32fbafe-32d3-4246-9dd0-3d286812494f
xfsdump: session label: "home"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: pruning unneeded subtrees
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 19705400640 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: WARNING: could not open regular file ino 2148055983 mode 0x000081f8: St
ructure needs cleaning: not dumped
xfsdump: WARNING: could not get list of non-root attributes for nondir ino 21480
55983: Structure needs cleaning (117)
xfsdump: WARNING: could not get list of root attributes for nondir ino 214805598
3: Structure needs cleaning (117)
xfsdump: WARNING: could not get list of secure attributes for nondir ino 2148055
983: Structure needs cleaning (117)
/root/bin/dump1fs: line 81:  1416 Killed                  $xfsdump ${Blocksize:+
"-b"} $Blocksize ${Dumplevel:+"-l"} $Dumplevel ${Label:+"-L"} $Label ${Xfsdump_o
ptions:-} ${Destination:-"-"} $Mountpoint
      1417 Done                    | ( ${nice} --10 ${mbuffer} -q -b $nbuffs -s
$bsize 2> /dev/null )
      1418 Done                    | ( su -f -m backup -c "$umask $um;${Compress
:-} ${Compress_ops:-}                   >${Dmpfile}${Compress_ext}" )

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
