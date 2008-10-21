Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 23:47:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L6lXxm011741
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 23:47:34 -0700
Message-ID: <48FD7B69.3090600@wm.jp.nec.com>
Date: Tue, 21 Oct 2008 15:49:13 +0900
From: Utako Kusaka <u-kusaka@wm.jp.nec.com>
MIME-Version: 1.0
Subject: Re: atime not written to disk
References: <48FD74CC.907@sgi.com>
In-Reply-To: <48FD74CC.907@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs <xfs@oss.sgi.com>

Hi,

Your problem seems the same as mine.
http://oss.sgi.com/archives/xfs/2007-10/msg00168.html

Utako.

Timothy Shimmin wrote:
> Hi,
> 
> Before I investigate further ;-),
> it appears that in XFS (seen in recent xfs-dev tree and on older issp release
> on default mkfs/mount options),
> that the atime is not being written out to disk in xfs,
> at least, in the simple scenario below.
> 
> emu:/home/tes # echo bill >/mnt/test/bill
> emu:/home/tes # ls -l /mnt/test/bill
> -rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill
> emu:/home/tes # ls -lu /mnt/test/bill
> -rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill
> 
> ... wait a bit to change the atime...
> 
> emu:/home/tes # cat /mnt/test/bill
> bill
> emu:/home/tes # ls -lu /mnt/test/bill
> -rw-r--r-- 1 root root 5 2008-10-21 16:11 /mnt/test/bill
> 
> emu:/home/tes # cd /
> emu:/ # umount /mnt/test
> emu:/ # mount /mnt/test
> emu:/mnt/test # ls -lu /mnt/test/bill
> -rw-r--r-- 1 root root 5 2008-10-21 16:03 /mnt/test/bill
> 
> I believe that the atime is handled by the vfs and in xfs_iflush_int
> we sync up with the linux inode.
> Perhaps i_update_core needs to be set so that xfs_iflush_int
> will proceed and call xfs_synchronize_atime() and
> somehow that is not happening??
> 
> I haven't looked further yet, but I thought I'd ask on the list
> in case others, such as Christoph and Dave have thoughts on this.
> 
> Thanks,
> Tim.
