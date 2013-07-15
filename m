Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C7BA7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 01:47:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E66BA8F8033
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 23:47:38 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id ESUAcgkyttUSYTL0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 23:47:36 -0700 (PDT)
Date: Mon, 15 Jul 2013 08:47:34 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Corruption of root fs during git bisect of drm system hang
Message-ID: <20130715064734.GA361@x4>
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130715022841.GH5228@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 2013.07.15 at 12:28 +1000, Dave Chinner wrote:
> On Fri, Jul 12, 2013 at 09:07:21AM +0200, Markus Trippelsdorf wrote:
> > On 2013.07.12 at 12:17 +1000, Dave Chinner wrote:
> > > On Thu, Jul 11, 2013 at 11:07:55AM +0200, Markus Trippelsdorf wrote:
> > > > On 2013.07.10 at 23:12 -0500, Stan Hoeppner wrote:
> > > > > On 7/10/2013 10:58 PM, Dave Chinner wrote:
> > > > > > On Thu, Jul 11, 2013 at 05:36:21AM +0200, Markus Trippelsdorf wrote:
> > > > > 
> > > > > >> I was loosing my KDE settings bit by bit with every reboot during the
> > > > > >> bisection. First my window-rules disappeared, then my desktop background
> > > > > >> changed to default, then my taskbar moved from top to the bottom, etc.
> > > > > >> In the end I had to restore all my .files from backup. 
> > > > > > 
> > > > > > That's not filesystem corruption. That sounds more like someone not
> > > > > > using fsync in the apropriate place when overwriting a file....
> > > > > 
> > > > t@ubunt:~# xfs_repair /dev/sdb
> > > > Phase 1 - find and verify superblock...
> > > > Phase 2 - using internal log
> > > >         - zero log...
> > > >         - scan filesystem freespace and inode maps...
> > > > agi unlinked bucket 0 is 683435008 in ag 2 (inode=4978402304)
> > > > agi unlinked bucket 1 is 683435009 in ag 2 (inode=4978402305)
> > > >         - found root inode chunk
> > > 
> > > Again, these are signs that log recovery has not completed
> > > successfully or that for some reason it thought the log was clean.
> > > Can you please post the dmesg output after the crash when you go
> > > through the mount/unmount process before you run xfs_repair?
> > 
> > Sure.
> > First boot after crash:
> >  XFS (sdb2): Mounting Filesystem
> >  XFS (sdb2): Starting recovery (logdev: internal)
> >  XFS (sdb2): Ending recovery (logdev: internal)
> > 
> > Second boot after crash:
> >  XFS (sdb2): Mounting Filesystem
> >  XFS (sdb2): Ending clean mount 
> > 
> > I then boot Ubuntu from another disc to run xfs_repair.
> 
> That's what shoul dhave been in the initial description of your
> problem.
> 
> > And looking through my logs I see this WARNING:
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 439 at fs/inode.c:280 drop_nlink+0x33/0x40()
> > CPU: 0 PID: 439 Comm: gconfd-2 Not tainted 3.10.0-08982-g6d128e1-dirty #42
> > Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
> >  0000000000000009 ffffffff8157d030 0000000000000000 ffffffff81060788
> >  ffff8801f8608cc8 ffff880205998230 ffff8801f7bede58 0000000000000000
> >  ffff8801f86083c0 ffffffff8110ce93 ffff8801f8608b40 ffffffff811b7104
> > Call Trace:
> >  [<ffffffff8157d030>] ? dump_stack+0x41/0x51
> >  [<ffffffff81060788>] ? warn_slowpath_common+0x68/0x80
> >  [<ffffffff8110ce93>] ? drop_nlink+0x33/0x40
> >  [<ffffffff811b7104>] ? xfs_droplink+0x24/0x60
> >  [<ffffffff811b84ed>] ? xfs_remove+0x24d/0x380
> >  [<ffffffff811b1657>] ? xfs_vn_unlink+0x37/0x80
> >  [<ffffffff8110414e>] ? vfs_unlink+0x6e/0xe0
> >  [<ffffffff8110432a>] ? do_unlinkat+0x16a/0x220
> >  [<ffffffff810f4fa9>] ? SyS_faccessat+0x149/0x200
> >  [<ffffffff81583292>] ? system_call_fastpath+0x16/0x1b
> 
> When did that occur? Before the crash, after the first/second mount?
> after you ran repair?

After the first mount.

> > Some further observations:
> > 
> > When I boot 3.2.0 after the crash log recovery works fine.
> > 
> > When I boot 3.9.0 after the crash I get the following:
> > 
> > [    2.332989] XFS (sdc2): Mounting Filesystem
> > [    2.406206] XFS (sdc2): Starting recovery (logdev: internal)
> > [    2.418147] XFS (sdc2): log record CRC mismatch: found 0xdbcaef48, expected 0x69e7934e.
> 
> Just informational - indicating that the log records don't have
> valid CRCs in them because 3.2 didn't calculate them. If you are
> getting them when after a crash on a 3.9+ kernel, then there's a
> problem writing to the log....

The crash always occurred on the current Linus tree kernel...

> > When I boot the current Linus tree after the crash log recovery fails silently.
> 
> dmesg output, please. Indeed, what does "fails silently" mean? the
> filesystem doesn't mount but no error is given?

Again, there is no dmesg output. XFS tells me that it's "Ending recovery
(logdev: internal)" without any errors, when indeed it didn't recover
the log at all. It then mounts the filesystem normally (rw) in this
unclean state. That's when the WARNING I postend above happend.

The fact that when I boot 3.2.0 after the crash (that occurred running
the current Linus tree) log recovery works just fine, point to the new
CRC implementation as the reason for this bug. 

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
