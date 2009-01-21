Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0LIP6Xp002860
	for <linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 12:25:07 -0600
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F3F6183AA7F
	for <linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 10:25:05 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com
	with ESMTP id Ga6boBGSTuDSFBrT for <linux-xfs@oss.sgi.com>;
	Wed, 21 Jan 2009 10:25:05 -0800 (PST)
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LPhl8-0000Ha-Uk
	for linux-xfs@oss.sgi.com; Wed, 21 Jan 2009 18:25:02 +0000
Received: from p548a662f.dip.t-dialin.net ([84.138.102.47])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 18:25:02 +0000
Received: from kain by p548a662f.dip.t-dialin.net with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 21 Jan 2009 18:25:02 +0000
From: Bryon Roche <kain@kain.org>
Subject: Re: No space left on device on xfs filesystem with 1.6TB free
Date: Wed, 21 Jan 2009 17:49:26 +0000 (UTC)
Message-ID: <gl7n76$6et$1@ger.gmane.org>
References: <alpine.LSU.2.00.0901211007200.19898@hermes-2.csi.cam.ac.uk>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-xfs@oss.sgi.com

On Wed, 21 Jan 2009 10:33:10 +0000, Owen Dunn wrote:

> I'm running SuSE Linux Enterprise Server 10 SP2, on a 32-bit i386 Linux
> machine with kernel version 2.6.16.60-0.33-smp.  I appear to have
> version 2.9.4 of xfsprogs.
> 
> I have a 6TB xfs filesystem which has been grown twice from 2TB, and
> which appears to have 1.6TB and plenty of inodes free.  However,
> attempts to create a new file fail with ENOSPC:
You probably need to mount with inode64 then, to allow xfs to make inodes 
in the later space in the FS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
