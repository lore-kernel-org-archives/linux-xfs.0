Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 23:19:22 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L6JJlw007336
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 23:19:19 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id EFA6C908A5
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 23:21:01 -0700 (PDT)
Received: from boing.melbourne.sgi.com (boing.melbourne.sgi.com [134.14.55.141]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA18225 for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 17:21:00 +1100
Message-ID: <48FD74CC.907@sgi.com>
Date: Tue, 21 Oct 2008 17:21:00 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: atime not written to disk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Hi,

Before I investigate further ;-),
it appears that in XFS (seen in recent xfs-dev tree and on older issp release
on default mkfs/mount options),
that the atime is not being written out to disk in xfs,
at least, in the simple scenario below.

emu:/home/tes # echo bill >/mnt/test/bill
emu:/home/tes # ls -l /mnt/test/bill
-rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill
emu:/home/tes # ls -lu /mnt/test/bill
-rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill

... wait a bit to change the atime...

emu:/home/tes # cat /mnt/test/bill
bill
emu:/home/tes # ls -lu /mnt/test/bill
-rw-r--r-- 1 root root 5 2008-10-21 16:11 /mnt/test/bill

emu:/home/tes # cd /
emu:/ # umount /mnt/test
emu:/ # mount /mnt/test
emu:/mnt/test # ls -lu /mnt/test/bill
-rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill

I believe that the atime is handled by the vfs and in xfs_iflush_int
we sync up with the linux inode.
Perhaps i_update_core needs to be set so that xfs_iflush_int
will proceed and call xfs_synchronize_atime() and
somehow that is not happening??

I haven't looked further yet, but I thought I'd ask on the list
in case others, such as Christoph and Dave have thoughts on this.

Thanks,
Tim.
