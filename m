Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 21:10:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m394AdrK011496
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 21:10:42 -0700
Date: Wed, 9 Apr 2008 14:11:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] Re: Does XFS prevent disk spindown?
Message-ID: <20080409041113.GC108924158@sgi.com>
References: <m2tzimbvif.fsf@getmail.no> <20080401003005.GJ103491721@sgi.com> <47F1CF6D.2040103@sandeen.net> <m2d4p9o2sc.fsf@getmail.no> <m2y77smmdj.fsf@getmail.no> <47F9735E.8020900@sgi.com> <m2wsn9qub4.fsf@getmail.no> <20080407215855.GE108924158@sgi.com> <m2skxwriye.fsf@getmail.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2skxwriye.fsf@getmail.no>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thor Kristoffersen <thorkr@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Tue, Apr 08, 2008 at 07:53:13AM +0200, Thor Kristoffersen wrote:
> David Chinner <dgc@sgi.com> writes:
> >> > What does 'xfs_logprint -t' show in these "idle" states
> >> > after these writes?
> >> 
> >> xfs_logprint produces output like the one shown below, so it does indeed
> >> look like it's writing to the journal.  But why should it need to keep
> >> writing to the journal when there have been no updates to any files on that
> >> partition recently?
> >
> > Are you using lazy-count=1? (i.e. output of 'xfs_info <mtpt>', please).
> 
> Looks like I am:
> 
> meta-data=/dev/sda3              isize=256    agcount=4, agsize=42676171 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=170704681, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Is that what's causing it?  I have never specified any lazy-count option
> when I created or mounted the filesystem.  I didn't even know it existed.

Introduced in 2.6.22, and recently was made the default mkfs config.

Try the patch below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Remove periodic logging of in-core superblock counters.

xfssyncd triggers the logging of superblock counters every
30s if the filesystem is made with lazy-count=1. This will
prevent disks from idling and spinning down as there will
be a log write every 30s. With the way counter recovery
works for lazy-count=1, this code is unnecessary and provides
no real benefit, so just remove it.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    3 +--
 fs/xfs/linux-2.6/xfs_vfs.h   |    1 -
 fs/xfs/xfs_vfsops.c          |   10 ----------
 3 files changed, 1 insertion(+), 13 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2008-04-02 09:25:11.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2008-04-02 10:02:25.391897032 +1000
@@ -1028,8 +1028,7 @@ xfs_sync_worker(
 	int		error;
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
-		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR |
-				     SYNC_REFCACHE | SYNC_SUPER);
+		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR);
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);
 }
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-24 22:25:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h	2008-04-02 10:02:52.596414152 +1000
@@ -49,7 +49,6 @@ typedef struct bhv_vfs_sync_work {
 #define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
 #define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
 #define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
-#define SYNC_SUPER		0x0200  /* flush superblock to disk */
 
 /*
  * When remounting a filesystem read-only or freezing the filesystem,
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2008-04-02 09:00:55.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2008-04-02 10:01:35.534280170 +1000
@@ -1334,18 +1334,8 @@ xfs_syncsub(
 	}
 
 	/*
-	 * If asked, update the disk superblock with incore counter values if we
-	 * are using non-persistent counters so that they don't get too far out
-	 * of sync if we crash or get a forced shutdown. We don't want to force
-	 * this to disk, just get a transaction into the iclogs....
-	 */
-	if (flags & SYNC_SUPER)
-		xfs_log_sbcount(mp, 0);
-
-	/*
 	 * Now check to see if the log needs a "dummy" transaction.
 	 */
-
 	if (!(flags & SYNC_REMOUNT) && xfs_log_need_covered(mp)) {
 		xfs_trans_t *tp;
 		xfs_inode_t *ip;
