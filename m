Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5QKHX6R223501 for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 15:17:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 936443278B2
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 13:18:00 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id UalAKkfAPmqMJ464 for
	<xfs@oss.sgi.com>; Fri, 26 Jun 2009 13:18:00 -0700 (PDT)
Message-ID: <4A452CF7.3040807@sandeen.net>
Date: Fri, 26 Jun 2009 15:17:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corrupt file system -- "Structure needs cleaning"
References: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
In-Reply-To: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
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
To: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Cc: xfs@oss.sgi.com

Hendrik Hoeth wrote:
> Hi,
> 
> I'm running linux-2.6.29.3 on a VIA Esther CPU. The harddisk is fully
> encrypted using dm-crypt, and inside the encryption I have LVM with my
> actual partitions. The file system is XFS, I have xfsprogs-2.9.4-1.
> 
> I was copying some large files when I got these errors (and yes, I own
> that music CD ;-)):
> 
> -------------------8<---------------------
> cp: cannot create regular file

...

> [14:36] hoeth@jetway:~/Musik/DONE $ ls
> ls: cannot open directory .: Input/output error
> [14:36] hoeth@jetway:~/Musik/DONE $ 
> -------------------8<---------------------
> 
> So at this point I realised that the filesystem was shut down.

Yep

> Here's what I see in the logfiles:
> 
> -------------------8<---------------------
> Jun 26 14:35:44 jetway kernel: Filesystem "dm-5": XFS internal error xfs_btree_check_sblock at line 124 of file fs/xfs/xfs_btree.c.  Caller 0xc02201ac

This is an internal consistency check failing

> -------------------8<---------------------
> 
> This is how I recovered (well, most of the data I had copied is
> corrupt at the target location):
> 
> -------------------8<---------------------
> [14:40] root@jetway:/var/log # umount /home 
> [14:43] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> [14:43] root@jetway:/var/log # mount /home/
> [14:43] root@jetway:/var/log # umount /home/
> [14:44] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home

xfs_check doesn't actually fix anything; I'd run xfs_repair.  Use -n
first if you want to see what it would do.

If it doesn't find anything, then I guess you had some in-memory corruption.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
