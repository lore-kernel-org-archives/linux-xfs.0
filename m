Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q33IdBjh241976 for <xfs@oss.sgi.com>; Tue, 3 Apr 2012 13:39:11 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 6bbQoFHpBZu4KYvk for <xfs@oss.sgi.com>;
	Tue, 03 Apr 2012 11:39:09 -0700 (PDT)
Message-ID: <4F7B43CB.9010709@sandeen.net>
Date: Tue, 03 Apr 2012 11:39:07 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corrupt xfs on USB HDD : sub-optimal xfs_repair
References: <4F79591C.6090508@daxxi.net>
In-Reply-To: <4F79591C.6090508@daxxi.net>
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
Cc: Dave B <xfs_bugs@daxxi.net>

On 4/2/12 12:45 AM, Dave B wrote:
> 
> Hi,
> 
> The two files in the root directory of a 500GB external USB HDD  became corrupt,
> probably due to a power failure.
> 
> dave@K-Matrix $ ls -l /media/Galaxy/
> ls: cannot access /media/Galaxy/ChnSchld_pre_4-14.tgz: No such file or directory
> ls: cannot access /media/Galaxy/dhr820xu.ext: No such file or directory
> total 24
> ??????????   ? ?    ?        ?                ? ChnSchld_pre_4-14.tgz
> ??????????   ? ?    ?        ?                ? dhr820xu.ext
> drwxr-xr-x   7 dave dave  4096 2012-02-13 12:45 DHR recordings
> drwxr-xr-x 212 dave dave 12288 2008-11-30 00:21 Miles Davis
> drwxr-xr-x   5 dave dave  4096 2012-02-16 06:06 PartImage
> 
> 
> xfs_repair didn't help much; it just removed the two filenames.
> At minimum, I expected two entries in L+F but the L+F directory was not created.
> 
> dave@K-Matrix $ sudo xfs_repair /dev/sdc1
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
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
> entry "ChnSchld_pre_4-14.tgz" in shortform directory 128 references free inode 48145461
> junking entry "ChnSchld_pre_4-14.tgz" in directory inode 128
> entry "dhr820xu.ext" in shortform directory 128 references free inode 48145451
> junking entry "dhr820xu.ext" in directory inode 128
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> 
> 
> See longer console session and before/after metadumps in ~7MB d/l at:
> http://daxxi.net/xfs/Galaxy_500GB_xfs.tar.gz
> user: xfs  ,  p/w: xfs
> (please only d/l if 2x240MB metadumps will be meaningful to you)
> 
> 
> Environment:
> Linux K-Matrix 3.0.0-16-generic #29-Ubuntu SMP Tue Feb 14 12:49:42 UTC 2012 i686 athlon i386 GNU/Linux

Thanks, I'll take a look at this, grabbing the images now.

-Eric
> 
> Dave
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
