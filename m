Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HMqSI7028133 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:52:28 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 289BC562553
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 15:52:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cQQFvxFEHCBgDvUm for <xfs@oss.sgi.com>;
	Mon, 17 Oct 2011 15:52:25 -0700 (PDT)
Date: Tue, 18 Oct 2011 09:52:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair v3.1.6 - Segmentation fault AND XFS internal error
	xfs_btree_check_sblock
Message-ID: <20111017225223.GU3159@dastard>
References: <4E9C3EEF.5080609@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E9C3EEF.5080609@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 17, 2011 at 04:42:55PM +0200, Richard Ems wrote:
> Hi all !
> 
> We have a XFS that started giving errors some days ago.  This is
> on an openSUSE 11.4 64 bit system.  The XFS is 12 TB big, 9.8 TB
> are used. Hardware RAID 6 on an Areca 1680 controller.
> 
> Mounting the XFS with ro,norecovery works almost always.
> 
> But xfs_repair crashes with a Segmentation fault. I tried both v3.1.4 from 
> openSUSE 11.4 and xfs_repair v3.1.6 downloaded from the git repo.

Ok, so not a new issue.

> Now after a reboot - the ___production___system completely freezed while running 
> the last xfs_repair v3.1.6 !!! - the XFS got mounted rw, but just trying to 
> touch a file generated the following error:
> 
> Oct 17 16:33:02 c3m kernel: [  794.628715] Filesystem "sdb1": XFS internal error xfs_btree_check_sblock at line 120 of file /usr/src/packages/BUILD/kernel-default-2.6.37.6/linux-2.6.37/fs/xfs/xfs_btree.c.  Caller 0xffffffffa0376cbe
> Oct 17 16:33:02 c3m kernel: [  794.628718] 
> Oct 17 16:33:02 c3m kernel: [  794.628722] Pid: 9066, comm: touch Not tainted 2.6.37.6-0.7-default #1
> Oct 17 16:33:02 c3m kernel: [  794.628724] Call Trace:
> Oct 17 16:33:02 c3m kernel: [  794.628737]  [<ffffffff81005819>] dump_trace+0x69/0x2e0
> Oct 17 16:33:02 c3m kernel: [  794.628744]  [<ffffffff814ba5c3>] dump_stack+0x69/0x6f
> Oct 17 16:33:02 c3m kernel: [  794.628776]  [<ffffffffa0376666>] xfs_btree_check_sblock+0x86/0x120 [xfs]
> Oct 17 16:33:02 c3m kernel: [  794.628864]  [<ffffffffa0376cbe>] xfs_btree_read_buf_block.clone.0+0x9e/0xc0 [xfs]
> Oct 17 16:33:02 c3m kernel: [  794.628947]  [<ffffffffa0378a3e>] xfs_btree_increment+0x1ee/0x290 [xfs]
> Oct 17 16:33:02 c3m kernel: [  794.629036]  [<ffffffffa038e522>] xfs_dialloc+0x5e2/0x900 [xfs]
> Oct 17 16:33:02 c3m kernel: [  794.629148]  [<ffffffffa0390bd5>] xfs_ialloc+0x75/0x6d0 [xfs]

A corrupt inode allocation btree - not a particularly common type of
corruption to be reported. Do you know what caused the errors to
start being reported? A crash, a bad disk, a raid rebuild, something
else?  That information always helps us understand how badly damaged
the filesystem might be....

> The last lines before the " xfs_repair -n -P /dev/sdb1 " Segmentation fault where:
> 
> would clear forw/back pointers in block 0 for attributes in inode 4319273
> bad attribute leaf magic # 0x250 for dir ino 4319273
> problem with attribute contents in inode 4319273
> would clear attr fork
> bad nblocks 2 for inode 4319273, would reset to 1
> bad anextents 1 for inode 4319273, would reset to 0
> -bash: line 5:  6488 Segmentation fault      /opt/xfsprogs-3.1.6/sbin/xfs_repair -n -P /dev/sdb1

And I'd guess that is failing on a different problem - a corrupt
inode most likely. You've build xfs-repair from the source code -
can yo urun it under gdb so we can see where it is dying?

> The complete " xfs_repair -n -P /dev/sdb1 " output file is 1.2 MB
> gzipped. If anyone wants to have a look at it please ask and I
> will send it as a private mail.

That sounds like there's a *lot* of damage to the filesystem. That
makes it even more important that we understand what caused the
damage in the first place....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
