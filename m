Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FDtSpc191143 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 08:55:29 -0500
Received: from ppsw-32.csi.cam.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88290DE6215
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:08:08 -0700 (PDT)
Received: from ppsw-32.csi.cam.ac.uk (ppsw-32.csi.cam.ac.uk [131.111.8.132])
	by cuda.sgi.com with ESMTP id EPlBeXfed3k8WQhV for
	<xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:08:08 -0700 (PDT)
Received: from mail.mrc-lmb.cam.ac.uk ([131.111.85.9]:33181
	helo=mail.lmb.internal)
	by ppsw-32.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.138]:25)
	with esmtp id 1OvsTA-0001XA-14 (Exim 4.72) for xfs@oss.sgi.com
	(return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Wed, 15 Sep 2010 14:56:16 +0100
Received: from cpepc210-3.lmb.internal ([10.14.0.2])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1OvsTA-0007y5-87
	for xfs@oss.sgi.com; Wed, 15 Sep 2010 14:56:16 +0100
Message-ID: <4C90D080.5090004@mrc-lmb.cam.ac.uk>
Date: Wed, 15 Sep 2010 14:56:16 +0100
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: no space left on device with 662G free
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
To: xfs@oss.sgi.com

Hello,

I recently started using XFS when I set up a new server and I'm having a
problem when copying data on to it from an old server. cp reports errors
like:

cp: cannot create symbolic link
`/nfs/scop4/data/trembl/xml/releases/2006-01-10/Q6RXU6.xml': No space
left on device

and later

cp: cannot create directory
`/nfs/scop4/data/trembl/xml/releases/2006-01-24': No space left on device

The filesystem is in a 2 TB LVM on an md RAID and according to df
there's 662 GB space free:

  /dev/mapper/vg--storage-lv--data
                      2.0T  1.4T  662G  68% /nfs/scop4/data

There are a quite a few directories in the filesystem. Some of the
directories contain many millions of files and some directories consist
entirely of symlinks, if any of that's relevant.

The filesystem is on a newish machine running openSUSE 11.2 (Linux scop4
2.6.31.12-0.2-desktop #1 SMP PREEMPT 2010-03-16 21:25:39 +0100 x86_64
x86_64 x86_64 GNU/Linux) and the data is being mirrored from an older
machine that uses a reiser filesystem and which stores the data without
problem.

Some folks on the suse mailing list said it was probably an inode
problem and suggested I run df -i:

# df -i /nfs/scop4/data
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/vg--storage-lv--data
                     429496704 -18446744073280007488
18446744073709504192    - /nfs/scop4/data

I don't understand that output, especially the negative number! I then
read about the inode64 mount option in the XFS FAQ and I believe I've
now enabled that and remounted the filesystem. mtab shows

/dev/mapper/vg--storage-lv--data /nfs/scop4/data xfs rw,noatime,inode64 0 0

But I'm still seeing the same errors as before. Is there something else
I need to do to enable inode64, or am I looking in the wrong direction?

Thanks, Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
