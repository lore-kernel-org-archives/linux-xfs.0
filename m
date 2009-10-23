Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9NI0bXe225261 for <xfs@oss.sgi.com>; Fri, 23 Oct 2009 13:00:40 -0500
Received: from borg.medozas.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 520F5C477C3
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2009 11:02:12 -0700 (PDT)
Received: from borg.medozas.de (borg.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id PrnY0fIufJroUTXW for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2009 11:02:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by borg.medozas.de (Postfix) with ESMTP id BDBB07362
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2009 20:02:08 +0200 (CEST)
Date: Fri, 23 Oct 2009 20:02:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: XFS in a XFS locks up in xfs_ilock
Message-ID: <alpine.LSU.2.00.0910231957570.5688@obet.zrqbmnf.qr>
MIME-Version: 1.0
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

Hi,


it seems that somewhere, locking is afoul in XFS so that having a 
loopback XFS on an XFS causes a deadlock, first on the subvolume, then 
on the real one. Sometimes that happens within writing a few MB to the 
subvolume (the loop one), sometimes nothing happens and it can be used 
for many months.

Suggested testcase:

Starting out with $HOME being on xfs (truncate is coreutils 7+):
$ >disk
$ truncate --size=$[3*1048576*1024] disk
So it's actually sparse(!)
$ mkfs.xfs disk
# mount disk mnt -oloop

Start filling it with data, preferably something like installing a bunch 
of rpm/debs into mnt, and hopefully soon enough, the thing will lock up.
xfs_ilock I got from `ps xaf -o wchan` while a box was shortly before 
dying - processes were stuck in D state. Not sure if this is related to 
the sparseness of the file, but I would bet it's part of the problem.

This has been observed on 2.6.29-2.6.31.4, probably even earlier.


thanks,
Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
