Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5PDikOs144459 for <xfs@oss.sgi.com>; Thu, 25 Jun 2009 08:44:46 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 237B1321BC6
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2009 06:45:14 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Qq7rV60Yng2c8iqh for
	<xfs@oss.sgi.com>; Thu, 25 Jun 2009 06:45:14 -0700 (PDT)
Message-ID: <4A437F68.3050107@sandeen.net>
Date: Thu, 25 Jun 2009 08:45:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>	<4A4228DE.6040104@sandeen.net>
	<409bd82b0906250306o47b4bc54pb7a7d199e17af5e6@mail.gmail.com>
In-Reply-To: <409bd82b0906250306o47b4bc54pb7a7d199e17af5e6@mail.gmail.com>
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
To: Nitin Arora <nitin.arora.del@gmail.com>
Cc: xfs@oss.sgi.com

Nitin Arora wrote:
> Hi,
> 
> I have tried the patch provided in that link but unfortunately it
> doesn't solve that problem.
> I have run xfs_repair on the corrupted partition and got the following
> output.

Ah, well, if you had actual on-disk corruption, that's likely the reason
for the "internal error" - and finding out how it got corrupted after
the fact will be nigh impossible, I'm afraid.

-Eric

> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> data fork in regular inode 159 claims used block 667542
> bad data fork in inode 159
> cleared inode 159
> data fork in regular inode 6228245 claims used block 667569
> bad data fork in inode 6228245
> cleared inode 6228245
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
> entry "Masoom7.avi" at block 0 offset 1824 in directory inode 128
> references free inode 159
>         clearing inode number in entry at offset 1824...
> entry "Gandhi4.avi" at block 2 offset 664 in directory inode 128
> references free inode 6228245
>         clearing inode number in entry at offset 664...
> data fork in ino 133 claims dup extent, off - 0, start - 667542, cnt 333765
> bad data fork in inode 133
> cleared inode 133
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> entry "3.avi" in directory inode 128 points to free inode 133
> bad hash table for directory inode 128 (no data entry): rebuilding
> rebuilding directory inode 128
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
