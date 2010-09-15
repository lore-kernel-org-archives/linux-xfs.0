Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FEkRSF193399 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 09:46:27 -0500
Received: from pavilion.ashurst.eu.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2300014F2E83
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:59:01 -0700 (PDT)
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[212.13.194.45]) by cuda.sgi.com with ESMTP id aWq3uGZrDvzwHSRs
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:59:01 -0700 (PDT)
Message-ID: <4C90DC1E.6090002@ashurst.eu.org>
Date: Wed, 15 Sep 2010 15:45:50 +0100
From: Andy Bennett <andyjpb@ashurst.eu.org>
MIME-Version: 1.0
References: <4C90D080.5090004@mrc-lmb.cam.ac.uk>
In-Reply-To: <4C90D080.5090004@mrc-lmb.cam.ac.uk>
Subject: Re: no space left on device with 662G free
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
Cc: xfs@oss.sgi.com

Hi,

> I recently started using XFS when I set up a new server and I'm having a
> problem when copying data on to it from an old server. cp reports errors
> like:
> 
> cp: cannot create symbolic link
> `/nfs/scop4/data/trembl/xml/releases/2006-01-10/Q6RXU6.xml': No space
> left on device
> 
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

Seems like you have a cross between

http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F

and

http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_receive_No_space_left_on_device_after_xfs_growfs.3F

Perhaps not using inode64 from the beginning looks similar to a xfs_growfs?




Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
