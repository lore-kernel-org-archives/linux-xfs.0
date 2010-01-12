Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CKPkIp067262 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 14:25:46 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C6AF15F726
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 12:26:40 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id H8hTnHm9hxu839es for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 12:26:40 -0800 (PST)
Message-ID: <4B4CDB00.1080103@sandeen.net>
Date: Tue, 12 Jan 2010 14:26:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: help investigating some xfs errors
References: <4B4C95F1.20106@gmx.net>
In-Reply-To: <4B4C95F1.20106@gmx.net>
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
To: Alexandru Coman <ghost_3k@gmx.net>
Cc: xfs@oss.sgi.com

Alexandru Coman wrote:
> Hello,
> 
> I'm having some problems with an XFS filesystem, and I'm wondering if
> anyone can point me in the right direction, it would be greatly appreciated.
> 
> I have several XFS filesystems on top of LVM in a RAID-1 (mdadm) created
> on a pair of 1TB SATA drives. Running on Linux (Debian, amd64). One of
> the XFS filesystems is 600GB in size (65% used), storing ~19 mil files
> under 100KB (jpeg), usually under high load (read+write). There are also
> a few other smaller XFS partitions on the same drives. It has been
> running like this for 11 months, until a few days ago when I started to
> get a lot of errors.
> 
> On Jan 10, I got a few lines with "ata3: hard resetting link", after

hardware problem...

> which the partition could not be accessed, I couldn't umount/mount it.
> All other partitions were fine. I rebooted the server, but that
> filesystem still wouldn't mount (it said "Structure needs cleaning"), I
> then ran xfs_repair on it, which reported that I needed to use the "-L"
> option to destroy the log. I then ran "xfs_repair -L" which appeared to
> fix a lot of errors, and then I was able to mount the filesystem again.
> Everything appeared to be ok at that point.
> 
> Jan 10 night: a lot of xfs call traces start to appear in the log
> 
> Jan 11: xfs call traces along with
> - xfs_force_shutdown(dm-4,0x8) called from line 1164 of file
> fs/xfs/xfs_trans.c.  Return address = 0xffffffffa01999ff
> - xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-4. 
> Returning error.

5 is EIO - your storage had an IO error, xfs reacted.

> - lots of "Filesystem "dm-4": xfs_log_force: error 5 returned."
> The filesystem disappeared, but I could unmount and mount it again with
> no errors. At this point I've also decided to update the kernel, and
> switched from 2.6.26 to 2.6.30 Then ran xfs_repair which again found a
> few errors.

after those IO errors, the fs may well be in bad shape, which
xfs_repair will do its best to fix.  You'll need to get your
hardware problems sorted out, it seems.

-Eric

> Jan 12:  xfs call traces along with:
> - Filesystem "dm-4": corrupt dinode 1293803384, extent total = 1,
> nblocks = 0.  Unmount and run xfs_repair.
> - Filesystem "dm-4": corrupt dinode 665458404, extent total = 1, nblocks
> = 0.  Unmount and run xfs_repair.
> - Filesystem "dm-4": corrupt dinode 225720890, extent total = 1, nblocks
> = 0.  Unmount and run xfs_repair.
> I then unmounted the fs and ran xfs_repair again. This time the output
> was massive compared to the previous runs, and it put around ~ 100.000
> files in lost+found.
> 
> Beside 3 lines on Jan 10 with "ata3: hard resetting link", there have
> been no sign of possible hardware problems. The raid and the hdd's
> appear to be fine, no errors. What's curious is that I'm experiencing
> problems only with the large XFS filesystem, and there hasn't been not
> even a single error in the logs about the other xfs partitions.
> 
> So, if anyone has any ideea what I can research next, to help me find
> out more information about what's happening here...
> 
> I've uploaded some detailed logs at  http://ghost3k.net/xfs1/
> 
> 
> Thanks,
> Alexandru Coman
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
