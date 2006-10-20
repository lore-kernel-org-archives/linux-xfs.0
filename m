Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Oct 2006 04:34:46 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9KBYYaG017845
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 04:34:34 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k9KBXpnx011192
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 06:33:51 -0500
Message-ID: <4538B477.1090907@sgi.com>
Date: Fri, 20 Oct 2006 12:35:19 +0100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: xfs_ncheck gives outdated and partial result
References: <200610200858.08718.daniele@interline.it>
In-Reply-To: <200610200858.08718.daniele@interline.it>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Daniele P." <daniele@interline.it>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Hi Daniele,

Daniele P. wrote:
> Hi All,
> I'm here to ask a couple of question regarding xfs_ncheck.
> I'm using xfs_db version 2.6.20
> 
> The first question is:
> Is it right that I have to unmount/mount the filesystem before
> using it (1), or to get the partial right (3) answer?
> And why it's print only the first file name for inodes pointed
> by multiple files (2)?
> 
> 
> (1)
> # mkfs.xfs /dev/hda5
> meta-data=/dev/hda5              isize=256    agcount=16, agsize=152617 blks
>          =                       sectsz=512
> data     =                       bsize=4096   blocks=2441872, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=2560, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> # mount /dev/hda5 /mnt/hda5/
> # touch /mnt/hda5/a
> # xfs_ncheck -i 131 /dev/hda5
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_ncheck.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> must run blockget -n first
While it is possible to run xfs_ncheck on a mounted filesystem the results
may be inaccurate and misleading.  I believe xfs_ncheck accesses the filesystem
directly without interpreting the log so if there are outstanding changes in
the log then the filesystem may appear inconsistent.  Unmounting the filesystem
ensures that no changes will occur while xfs_ncheck is running and is the only
way to be sure that it will provide an accurate report.  If the filesystem is
unmounted but there are still outstanding entries in the log then mount and
unmount the filesystem again to replay the log.

> 
> (2)
> # ln /mnt/hda5/a /mnt/hda5/b
> # ls -i /mnt/hda5/
> 131 a  131 b
> # umount /mnt/hda5
> # mount /dev/hda5 /mnt/hda5
> # xfs_ncheck -i 131 /dev/hda5
>         131 a
This could just be a convenience feature to provide the first known path to
the inode.  Does anyone have a better answer?

> 
> (3)                                           
> # ln /mnt/hda5/a /mnt/hda5/c
> # xfs_ncheck -i 131 /dev/hda5
>         131 a
> # rm /mnt/hda5/a
> # xfs_ncheck -i 131 /dev/hda5
>         131 a
The log entry for the delete has not been replayed into the filesystem yet
so xfs_ncheck still sees stale data.

> # umount /mnt/hda5
> # mount /dev/hda5 /mnt/hda5
> # xfs_ncheck -i 131 /dev/hda5
>         131 b
Remounting the filesystem forces the log to be replayed into the filesystem
and now xfs_ncheck has a consistent view.

> 
> Thanks in advance,
> Daniele P.
> 
> 
