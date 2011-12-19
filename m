Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBJMwTN0102416 for <xfs@oss.sgi.com>; Mon, 19 Dec 2011 16:58:29 -0600
Message-ID: <4EEFC18F.4020705@sgi.com>
Date: Mon, 19 Dec 2011 16:58:23 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: xfsprogs patches pw 2883, 2986-2997
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: xfs@oss.sgi.com

Just a FYI to let you know that I testing your xfsprog patches that you 
submitted on Dec 2. I looked at the comments and the patches. The 
xfstests running now.

Dave Chinner had feedback requests on a couple items.

Below is my summary of the patches:

repair-avoid-ABBA-deadlocks-on-prefetched-buffers.patch
         patchworks 2883
          I believe this is required for patchworks 2997.
          feedback says that there are still deadlock, but I believe
          that it is addressed in patchworks 2986 and 2989.

01-12-repair-do-not-walk-the-unlinked-inode-list.patch
         patchworks 2987
          removed the walk_unlink_list code.

02-12-repair-allocate-and-free-inode-records-individually.patch
         patchworks 2988
          use malloc to allocate inodes rather than managing chucks.

03-12-repair-allocate-and-free-extent-records-individually.patch
         patchworks 2994
          use malloc to allocate extents rather than managing chucks.

04-12-xfsprogs-allow-linking-against-libtcmalloc.patch
         patchworks 2994
          use malloc to allocate extents rather than managing chucks.

05-12-repair-update-extent-count-after-zapping-duplicate-blocks.patch
         patchworks 2991
          configuration file changes to use Google performance tools.
          Dave had comments on the location of the change.
	 I had problems with installing the x64 Google tools with libunwind.
          This could be addressed separately.

06-12-repair-use-recursive-buffer-locking.patch
         patchworks 2989
          Use a recursion counter to avoid deadlock.
           Dave want a block number printed and add a return after the
           recursion count.(also ABBA pw 2925).
	  We could mark pw 2925 as superseded.

07-12-repair-fix-another-ABBA-deadlock-in-inode-prefetching.patch
         patchworks 2986
          additional patch for the ABBA deadlock.

08-12-repair-handle-filesystems-with-the-log-in-allocation-group-0.patch
         patchworks 2990
          Log allocation fix

09-12-repair-kill-check_inode_block.patch
         patchworks 2995
          Code clean up

10-12-repair-mark-local-functions-static.patch
         patchworks 2992
          Code clean up

11-12-repair-move-extern-declarations-to-headers.patch
         patchworks 2996
          Code clean up

12-12-repair-cleanup-inode-record-macros.patch
         patchworks 2993
          Code clean up

--Mark Tinguely
   tinguely@sgi.com
   SGI XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
