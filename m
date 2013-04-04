Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A8DA67CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 23:35:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E7E2AC005
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 21:35:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	l2gWQ8AowlkP9EAs for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 21:35:22 -0700 (PDT)
Date: Thu, 4 Apr 2013 15:35:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 88TB filesystem going off-line without warning
Message-ID: <20130404043515.GC12011@dastard>
References: <CA+dre-c0K=AWRNRPgNVWANNkMW++FXEJvQzSe=68_JXyJMeNxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+dre-c0K=AWRNRPgNVWANNkMW++FXEJvQzSe=68_JXyJMeNxQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: L Ox <lox8096@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 02, 2013 at 11:44:15AM -0700, L Ox wrote:
> Hi,
> 
> We have a new Linux/XFS deployment (about a month old) and randomly without
> warning the XFS filesystem will go off-line. We are running Scientific
> Linux release 5.9 with the latest updates.
> 
> # uname -a
> Linux node24 2.6.18-348.3.1.el5 #1 SMP Mon Mar 11 15:43:13 EDT 2013 x86_64
> x86_64 x86_64 GNU/Linux
> 
> # cat /etc/redhat-release
> Scientific Linux release 5.9 (Boron)
> 
> Here are the errors we see in /var/log/messages after the initial off-line
> event:
> 
> -- snip --
> 
> Apr  2 07:50:28 node24 kernel: xfs_iunlink_remove: xfs_inotobp()  returned
> an error 22 on dm-6.  Returning error.
> Apr  2 07:50:28 node24 kernel: xfs_inactive:  xfs_ifree() returned an error
> = 22 on dm-6

#define EINVAL          22      /* Invalid argument */

That tends to imply a corrupt inode number in the unlinked list
chain.

> Here are the messages after I umount/xfs_repair/mount the filesystem:

What did xfs_repair detect/fix?

> # xfs_repair /dev/mapper/vol_d24-root
> Phase 1 - find and verify superblock...
.....
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected inode 202102936036, moving to lost+found
> disconnected inode 215350040250, moving to lost+found
> disconnected inode 215350208634, moving to lost+found
> disconnected inode 271016406074, moving to lost+found

Some inodes that had been unlinked from the directory structure
but not freed. They were probably on an unlinked inode list that
couldn't be walked.

> Any ideas?

If the problem is a one off, there isn't anything that can be done.
If you can reproduce it, try to narrow it down to the simplest case
you can...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
