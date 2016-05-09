Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C04D47CA4
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 05:26:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D177AC003
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 03:26:46 -0700 (PDT)
Received: from co02.mbox.net (co02.mbox.net [165.212.64.32]) by cuda.sgi.com
	with ESMTP id 17nKaRkLApedE9ri (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 03:26:42 -0700 (PDT)
Received: from co02.mbox.net (localhost [127.0.0.1])
	by co02.mbox.net (Postfix) with ESMTP id 3r3JTG0YV0zKTlw
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 10:26:42 +0000 (UTC)
Date: Mon, 09 May 2016 12:26:37 +0200
From: issa-gorissen@usa.net
Subject: Re: Unable to mount a XFS filesystem
Mime-Version: 1.0
Message-ID: <057ueikZl3984S04.1462789597@web04.cms.usa.net>
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
To: xfs@oss.sgi.com

------ Original Message ------
Received: 10:51 PM CEST, 05/08/2016
From: Dave Chinner <david@fromorbit.com>

> Yup, the kernel also emits the same error on the same check - most
> likely during your upgrade the MD RAID device has changed size and
> is now 112 sectors smaller than before, hence the filesystem will
> refuse to mount.
> 

> 
> Unlikely to be an XFS problem, more likely a MD device/upgrade issue.


Thanks Dave for your pointer.

As I don't have much experiences in debugging XFS or MD RAID; I just took a
shortcut.

Your input helped a little.

I tried to resize the MD partition (for the missing sectors XFS was
complaining about) but as the MD superblock is at the end on my partition,
after the resize, mdadm could not find back the superblock and I did not want
to spend time trying to move the superblock along with the partition resize
(don't know if this is feasable).

So of one of the two disks; I could mount the resized MD partition as a XFS
filesystem after a xfs_repair on it. The folders structure is lost as
everything is in random folders in lost+found; but it seems the files are
there.

So I will create a new MD RAID from the disk I could mount.

It seems the setup of openSuse Tumbleweed messed up with my md raid
partitions! :-(

Thx,
--
Issa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
