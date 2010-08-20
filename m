Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7KNDR52259522 for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 18:13:28 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D2DA1747574
	for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 16:13:58 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MBt5hnbFpcfDZKla for
	<xfs@oss.sgi.com>; Fri, 20 Aug 2010 16:13:58 -0700 (PDT)
Message-ID: <4C6F0C35.3030007@sandeen.net>
Date: Fri, 20 Aug 2010 18:13:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Question about XFS recovery and error
References: <AANLkTi=prcC7ky3ikNTJ+py8XnALGf4THSOCUwqYhxaq@mail.gmail.com>
In-Reply-To: <AANLkTi=prcC7ky3ikNTJ+py8XnALGf4THSOCUwqYhxaq@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

Mike Gao wrote:
> The USB key is mounted automatically at boot and no error report with
> XFS recovery.
> But when I did a file copy on a USB key which XFS filesystem could be
> corrupted by some reason,
> I got endless repeat of ERROR message printed on the screen. 
> 
> Should XFS recovery this at the beginning when mounting? 
> 
> [42949387.250000] Starting XFS recovery on filesystem: sda (logdev:
> internal)
> [42949387.330000] Ending XFS recovery on filesystem: sda (logdev: internal)
> [42949388.600000] Starting XFS recovery on filesystem: sdb1 (logdev:
> internal)
> [42949388.640000] Ending XFS recovery on filesystem: sdb1 (logdev: internal)
> 

first off, the above is an indication that you're not cleanly unmounting
the filesystem.

> cp /mnt/USB0disk1/iCarly-4.ts ./iCarly-4-10.ts
> 
> [ 3234.740000] Filesystem "sda": XFS internal error
> xfs_btree_check_sblock at line 120 of file fs/xfs/xfs_btree.c.  Caller
> 0x8718e102
> [ 3234.740000]
> [ 3234.750000] regs can't be NULL.
> [ 3234.760000] Filesystem "sda": page discard on page 876a1914, inode
> 0x91, offset 91160576.
> [ 3235.150000] Filesystem "sda": XFS internal error
> xfs_btree_check_sblock at line 120 of file fs/xfs/xfs_btree.c.  Caller
> 0x8718e102

This is probably a result of a write cache which isn't properly flushed
during use prior to unplug (i.e. barriers; no idea what usb keys have
for write caches etc, but btree errors wouldn't be unheard of due to
lost/reordered writes due to write cache failure)

As to your other question, Michael is right, filesystems don't call out
to userspace repair tools when they encounter an error like this.

You could make xfs_repair run prior to mount, but I'd focus more on
why you're getting a corrupted filesystem in the first place.

-Eric

> Thanks,
> Mike
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
