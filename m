Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Sep 2006 03:46:17 -0700 (PDT)
Received: from tac.ki.iif.hu (tac.ki.iif.hu [193.6.222.43])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8DAk6Vw007496
	for <xfs@oss.sgi.com>; Wed, 13 Sep 2006 03:46:06 -0700
Subject: Re: Bug#387057: xfsprogs: repeated xfs_repair does not fix the
 filesystem
References: <20060911223008.5160.98142.reportbug@szonett.ki.iif.hu>
	<20060912085025.A3552962@wobbly.melbourne.sgi.com>
From: Ferenc Wagner <wferi@niif.hu>
Date: Wed, 13 Sep 2006 11:46:08 +0200
In-Reply-To: <20060912085025.A3552962@wobbly.melbourne.sgi.com> (Nathan
 Scott's message of "Tue, 12 Sep 2006 08:50:25 +1000")
Message-ID: <87zmd4jdzz.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@debian.org>
Cc: 387057@bugs.debian.org, xfs@oss.sgi.com

Nathan Scott <nathans@debian.org> writes:

> On Tue, Sep 12, 2006 at 12:30:08AM +0200, Ferenc Wagner wrote:
>> Package: xfsprogs
>> Version: 2.8.11-1
>> Severity: normal
>> 
>> I guess my problem is rooted in the 'well known' 2.6.17 error, or maybe
>> not.  Anyway, my experience under a current Sid system is that
>> xfs_repair does not fix my filesystem.  It does something, as the first
>> two runs produced slightly different outputs, but the further runs did
>> not.  I've got similar problems on two filesystems:
>
> Try moving aside the contents of lost+found after the first run,
> and see if the problems persist.

After renaming lost+found to l+f, xfs_repair didn't report any
errors:
=> Phase 1 - find and verify superblock...
=> Phase 2 - using internal log
=>         - zero log...
=>         - scan filesystem freespace and inode maps...
=>         - found root inode chunk
=> Phase 3 - for each AG...
=>         - scan and clear agi unlinked lists...
=>         - process known inodes and perform inode discovery...
=>         - agno = 0
=>         - agno = 1
=>         - agno = 2
=>         - agno = 3
=>         - agno = 4
=>         - agno = 5
=>         - agno = 6
=>         - agno = 7
=>         - process newly discovered inodes...
=> Phase 4 - check for duplicate blocks...
=>         - setting up duplicate extent list...
=>         - clear lost+found (if it exists) ...
=>         - check for inodes claiming duplicate blocks...
=>         - agno = 0
=>         - agno = 1
=>         - agno = 2
=>         - agno = 3
=>         - agno = 4
=>         - agno = 5
=>         - agno = 6
=>         - agno = 7
=> Phase 5 - rebuild AG headers and trees...
=>         - reset superblock...
=> Phase 6 - check inode connectivity...
=>         - resetting contents of realtime bitmap and summary inodes
=>         - ensuring existence of lost+found directory
=>         - traversing filesystem starting at / ... 
=>         - traversal finished ... 
=>         - traversing all unattached subtrees ... 
=>         - traversals finished ... 
=>         - moving disconnected inodes to lost+found ... 
=> Phase 7 - verify and correct link counts...
=> done

Still, xfs_check reported:
=> link count mismatch for inode 400254 (name ?), nlink 0, counted 2
=> link count mismatch for inode 4239409 (name ?), nlink 0, counted 2
=> link count mismatch for inode 8388736 (name ?), nlink 39, counted 38

Further runs of xfs_repair didn't bring any change.  On the root
filesystem the results are much the same, but xfs_check reports:
=> sb_ifree 3042, counted 3041

I read that xfs_check is being obsoleted in the future, but not sure
which program to trust.  Are my filesystems healthy or not?
-- 
Thanks,
Feri.
(Please Cc: me, I'm not subscribed to the xfs mailing list.)
