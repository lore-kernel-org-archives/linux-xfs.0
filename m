Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FETJjH192594 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 09:29:19 -0500
Subject: Re: no space left on device with 662G free
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4C90D080.5090004@mrc-lmb.cam.ac.uk>
References: <4C90D080.5090004@mrc-lmb.cam.ac.uk>
Date: Wed, 15 Sep 2010 09:30:00 -0500
Message-ID: <1284561000.2452.1.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
Cc: xfs@oss.sgi.com

On Wed, 2010-09-15 at 14:56 +0100, Dave Howorth wrote:
> Hello,
> 
> I recently started using XFS when I set up a new server and I'm having a
> problem when copying data on to it from an old server. cp reports errors
> like:
> 
> cp: cannot create symbolic link
> `/nfs/scop4/data/trembl/xml/releases/2006-01-10/Q6RXU6.xml': No space
> left on device

Please send the output of this command:

    xfs_info /dev/mapper/vg--storage-lv--data

I'm pretty sure you've run out of inodes.

					-Alex

> and later
> 
> cp: cannot create directory
> `/nfs/scop4/data/trembl/xml/releases/2006-01-24': No space left on device
> 
> The filesystem is in a 2 TB LVM on an md RAID and according to df
> there's 662 GB space free:
> 
>   /dev/mapper/vg--storage-lv--data
>                       2.0T  1.4T  662G  68% /nfs/scop4/data
> 
> There are a quite a few directories in the filesystem. Some of the
> directories contain many millions of files and some directories consist
> entirely of symlinks, if any of that's relevant.
> 
> The filesystem is on a newish machine running openSUSE 11.2 (Linux scop4
> 2.6.31.12-0.2-desktop #1 SMP PREEMPT 2010-03-16 21:25:39 +0100 x86_64
> x86_64 x86_64 GNU/Linux) and the data is being mirrored from an older
> machine that uses a reiser filesystem and which stores the data without
> problem.
> 
> Some folks on the suse mailing list said it was probably an inode
> problem and suggested I run df -i:
> 
> # df -i /nfs/scop4/data
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/mapper/vg--storage-lv--data
>                      429496704 -18446744073280007488
> 18446744073709504192    - /nfs/scop4/data
> 
> I don't understand that output, especially the negative number! I then
> read about the inode64 mount option in the XFS FAQ and I believe I've
> now enabled that and remounted the filesystem. mtab shows
> 
> /dev/mapper/vg--storage-lv--data /nfs/scop4/data xfs rw,noatime,inode64 0 0
> 
> But I'm still seeing the same errors as before. Is there something else
> I need to do to enable inode64, or am I looking in the wrong direction?
> 
> Thanks, Dave
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
