Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PFtI2X239801 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 10:55:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B8F412E7C50
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:09:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZSA6hfChfK3diEpY for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:09:00 -0700 (PDT)
Date: Sat, 25 Sep 2010 11:56:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100925155611.GA21928@infradead.org>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<4C9C875D.9050308@open-e.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C9C875D.9050308@open-e.com>
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
To: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> So once again. We have created a RAID unit level 6. On the top of
> the unit there is an LVM architecture, I mean a volume group that
> contains logical volumes. The logical volume is formatted with XFS
> and it contains one big file that takes almost all of the space on
> the LV. There is some free space left in order to be able expand the
> LV and FS in the future. The LV is mounted and the file is served as
> iSCSI target. The iSCSI Initiator (MS Initiator from Windows 2k3)
> connects to iSCSI target. The iSCSI disk is formatted with the NTFS.

ok, so we have:

Linux Server

+----------------------+
|   hardware raid 6    |
+----------------------+
| lvm2 - linear volume |
+----------------------+
|          XFS         |
+----------------------+
|    iSCSI target      |
+----------------------+

Windows client:


+----------------------+
|    iSCSI initiator   |
+----------------------+
|        NTFS          |
+----------------------+

> But we believe the problem is with the XFS. With unknown reason we
> are not able to mount the LV and after running xfs_repair the file
> is missing from the LV. Do you have any ideas how we can try to fix
> the broken XFS?

This does not sound like a plain XFS issue to me, but an interaction
between components going completely wrong.  Normal I/O to a file
should never corrupt the filesystem around it to the point where
it's unusable, and so far I never heard reports about that.  The hint
that this doesn't happen with another purely userspace target is
interesting.  I wonder if SCST that you use does any sort of in-kernel
block I/O after using bmap or similar?  I've not seen that for iscsi
targets yet but for other kernel modules, and that kind of I/O
can cause massive corruption on a filesystem with delayed allocation
and unwritten extents.

Can any of the SCST experts on the list here track down how I/O for this
configuration will be issued?

What does happen if you try the same setup with say jfs or ext4 instead
of xfs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
