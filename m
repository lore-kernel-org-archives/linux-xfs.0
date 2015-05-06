Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F36F27F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 12:12:25 -0500 (CDT)
Date: Wed, 6 May 2015 12:12:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: SGI Version 1 XFS on Linux
Message-ID: <20150506171222.GA22744@sgi.com>
References: <2994A55DE0FBBE41B8FE47F9885D74221BC0569C@ARLEXCHMBX02.lst.link.l-3com.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2994A55DE0FBBE41B8FE47F9885D74221BC0569C@ARLEXCHMBX02.lst.link.l-3com.com>
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
To: "Scott, Edmund J @ SSG - Link" <edmund.scott@l-3com.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Edmund,

On Wed, May 06, 2015 at 03:12:59PM +0000, Scott, Edmund J @ SSG - Link
wrote:
> We have several older SGI hard drives we are trying to recover data
> from. However, since these drives came from an SGI Onyx running IRIX
> 6.2, it uses the older version 1 XFS file system. I can see the SCSI
> drive on my Linux box (CentOS 5.11) and I know data is on the drive, I
> can list out some of the info using dd, cpio or strings, but cannot
> copy the data off of it. I have tried using xfs_copy to a version 2
> XFS partition, but it just converts the target partition to version 1,
> which I cannot mount. I have also looked at xfs_dump/restore,
> but those require mounted filesystems.
> 
> Is there any script or program or option I can use to copy the data
> off of the un-mounted SGI XFS partition. I'm guessing some combination
> of the cpio and dd, but I have not figured out the right combination
> yet.

Apparently CentOS 5.11 should be a 2.6.18 kernel.  It looks like it
should still have support for version 1, so I'm surprised you're having
trouble.  Could you provide a little more information?  

1) dmesg output when you try to mount the filesystem
2) xfs_info output, e.g.
	xfs_info /dev/sda5
3) hexdump of the superblock, e.g. 
	dd if=/dev/sda5 count=1 | hexdump -C

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
