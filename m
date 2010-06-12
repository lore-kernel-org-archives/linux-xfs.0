Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5C1a7R8171808 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 20:36:07 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A0173C0DF1
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 18:38:40 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id FV9o5IyXa8mvrpgD for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 18:38:40 -0700 (PDT)
Message-ID: <4C12E520.6040008@sandeen.net>
Date: Fri, 11 Jun 2010 20:38:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair 3.1.2 crashing
References: <201006101306.07587@zmi.at> <4C11127C.3030907@sandeen.net>
	<201006120138.22265@zmi.at>
In-Reply-To: <201006120138.22265@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Donnerstag, 10. Juni 2010 Eric Sandeen wrote:
>> It'd be great to at least capture the issue by creating an
>>  xfs_metadump image for analysis...
> 
> I sent it to you in private.
> 
> But now I'm really puzzled: I bought 2 2TB drives, installed an lvm with 
> xfs on them to have 4TB, and copied the contents from the server to 
> these 4TB via rsync -aHAX. And now I have a broken XFS on that brand new 
> created drives, without any crash, not even a reboot!
> 
> I got this message after making a "du -s" on the new disks:
>  du: cannot access `samba/backup/uranus/WindowsImageBackup/uranus/Backup 
> 2010-06-05 010014/852c2690-cf1a-11de-b09b-806e6f6e6963.vhd': Structure 
> needs cleaning

dmesg would be the right thing to do here ...

> So I umounted and xfs_repaired (v3.1.2) it:
> # xfs_repair -V                                                                               
> xfs_repair version 3.1.2

which kernel, again?  The fork offset problems smell like something that's fixed.

-Eric
                                                                               
> # xfs_repair /dev/swraid0/backup 
> Phase 1 - find and verify superblock...   
> Phase 2 - using internal log              
>         - zero log...                     
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk                     
> Phase 3 - for each AG...                             
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
> local inode 2195133988 attr too small (size = 3, min size = 4)
> bad attribute fork in inode 2195133988, clearing attr fork
> clearing inode 2195133988 attributes
> cleared inode 2195133988
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 2
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 3
>         - agno = 1
>         - agno = 0
> data fork in inode 2195133988 claims metadata block 537122652
> xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' 
> failed.
> Aborted
> 
> What's this now? I copied the error from the source via rsync? ;-)
> 
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
