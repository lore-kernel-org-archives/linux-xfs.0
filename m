Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Sep 2006 04:42:38 -0700 (PDT)
Received: from tac.ki.iif.hu (tac.ki.iif.hu [193.6.222.43])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8FBgEZd030284
	for <xfs@oss.sgi.com>; Fri, 15 Sep 2006 04:42:19 -0700
Subject: Re: Bug#387057: xfsprogs: repeated xfs_repair does not fix the
 filesystem
References: <200609140157.LAA22186@larry.melbourne.sgi.com>
From: Ferenc Wagner <wferi@niif.hu>
Date: Fri, 15 Sep 2006 13:41:23 +0200
In-Reply-To: <200609140157.LAA22186@larry.melbourne.sgi.com> (Barry Naujok's
 message of "Thu, 14 Sep 2006 12:03:28 +1000")
Message-ID: <87mz91mk64.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com

"Barry Naujok" <bnaujok@melbourne.sgi.com> writes:

>> -----Original Message-----
>> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
>> On Behalf Of Ferenc Wagner
>> Sent: Wednesday, 13 September 2006 7:46 PM
>> To: Nathan Scott
>> Cc: 387057@bugs.debian.org; xfs@oss.sgi.com
>> Subject: Re: Bug#387057: xfsprogs: repeated xfs_repair does 
>> not fix the filesystem
>> 
>> 
>> Still, xfs_check reported:
>> => link count mismatch for inode 400254 (name ?), nlink 0, counted 2
>> => link count mismatch for inode 4239409 (name ?), nlink 0, counted 2
>> => link count mismatch for inode 8388736 (name ?), nlink 39, 
>> counted 38
>> 
>> Further runs of xfs_repair didn't bring any change.  On the root
>> filesystem the results are much the same, but xfs_check reports:
>> => sb_ifree 3042, counted 3041
>
> This has been reported before, can you try running an older xfsprogs before
> 2.8.10 and see how that goes? I think with the dir2 fixes, the nlink stuff
> might be a tad broken. I'll also look into it from my end.

Thanks.  I tried xfsprogs 2.8.4 with the following result:

# xfs_repair /dev/main/usr
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - marking entry "lost+found" to be deleted
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
rebuilding directory inode 128
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
resetting inode 400254 nlinks from 0 to 2
resetting inode 4239409 nlinks from 0 to 2
resetting inode 8388736 nlinks from 39 to 38
done
# xfs_check /dev/main/usr
#

That is, my /usr partition looks fixed.  On the other hand:

# xfs_repair -d /dev/main/root
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - clearing existing "lost+found" inode
        - marking entry "lost+found" to be deleted
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ... 
rebuilding directory inode 128
        - traversal finished ... 
        - traversing all unattached subtrees ... 
        - traversals finished ... 
        - moving disconnected inodes to lost+found ... 
Phase 7 - verify and correct link counts...
done
# xfs_check /dev/main/root
sb_ifree 3044, counted 3043
#

That is, almost like before, but with incremented numbers (there was
filesystem activity since then).

So, there is some progress, but part of the problem remained.
-- 
Thanks,
Feri.
