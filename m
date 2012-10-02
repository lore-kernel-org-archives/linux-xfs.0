Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92092ZP217763 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 19:09:02 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SbTlvMwPwPe6MXFZ for <xfs@oss.sgi.com>;
	Mon, 01 Oct 2012 17:10:24 -0700 (PDT)
Date: Tue, 2 Oct 2012 10:10:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
Message-ID: <20121002001021.GJ23520@dastard>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5069F9B0.50804@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Hi, Brian.

On Mon, Oct 01, 2012 at 04:14:40PM -0400, Brian Foster wrote:
> Warning: This message has had one or more attachments removed
> Warning: (273.out.bad).
> Warning: Please read the "boprocket-Attachment-Warning.txt" attachment(s) for more information.

Which says:

> At Mon Oct  1 20:14:58 2012 the virus scanner said:                
>    MailScanner: Attempt to hide real filename extension (273.out.bad)

Looks like your mailer did something wrong with the attachment....


> Heads up... I was doing some testing against my eofblocks set rebased
> against this patchset and I'm reproducing a new 273 failure. The failure
> bisects down to this patch.
> 
> With the bisection, I'm running xfs top of tree plus the following patch:
> 
> xfs: only update the last_sync_lsn when a transaction completes
> 
> ... and patches 1-6 of this set on top of that. i.e.:
> 
> xfs: xfs_sync_data is redundant.
> xfs: Bring some sanity to log unmounting
> xfs: sync work is now only periodic log work
> xfs: don't run the sync work if the filesystem is read-only
> xfs: rationalise xfs_mount_wq users
> xfs: xfs_syncd_stop must die
> xfs: only update the last_sync_lsn when a transaction completes
> xfs: Make inode32 a remountable option
> 
> This is on a 16p (according to /proc/cpuinfo) x86-64 system with 32GB
> RAM. The test and scratch volumes are both 500GB lvm volumes on top of a
> hardware raid.
> I haven't looked into this at all yet but I wanted to
> drop it on the list for now. The 273 output is attached.

I bet you had writes fail with ENOSPC - 201 * 426
= 85626 files of 8k each, that gives 685MB. When the test is
running, I see upwards of 1.5GB of space consumed, which then slowly
drops again as data files are closed and data is written.

Some of that space is specualtive preallocation (4k per file, I
think), but also a significant amount of it is metadata reservation
for delayed allocation (4 blocks per file, IIRC). If I've only got
2GB RAM on my machine, then writeback starts at 200MB written, and
so well before the fs runs out of space the metadata reservations
are being released.

I just upped the VM to 8GB RAM, and immediately I see the test
starting to fail. And this is in 273.full:

cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_141': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_142': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_1cp: cannot create regular filcp: cannot create regular file `/mnt/scratch/sub_198/origin/file_147': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_1cp: cannot create regular filcp: writing `/mnt/scratch/sub_198/origin/file_149': No space left cp: writing `/mnt/scratch/sub_156/origin/file_275': No space left on device
cp: failed to extencp: writing `/mnt/scratch/sub_198/origin/file_150': No space left cp: writing `/mnt/scratch/sub_156/origin/file_276': No space left on device
cp: failed to extencp: cannot create regular file `/mnt/scratch/sub_124/origin/file_3cp: cannot create regular filcp: writing `/mnt/scratch/sub_124/origin/file_378': No space left cp: writing `/mnt/scratch/sub_173/origin/file_250': No space left on device
cp: failed to extencp: writing `/mnt/scratch/sub_124/origin/file_379': No space left cp: cannot create regular file `/mnt/scratch/sub_173/origin/file_2cp: cannot create regular file `/mnt/scratch/sub_134/origin/file_337': No space left on device
cp: cannot create regular filcp: cannot create regular filcp: writing `/mnt/scratch/sub_159/origin/file_307': No space left on device
cp: failed to extend `/mnt/scratch/sub_159/origin/file_307': No space left on device
cp: writing `/mnt/scratch/sub_159/origin/file_308': No space left on device
cp: failed to extend `/mnt/scratch/sub_159/origin/file_308': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_309': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_310': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_311': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_312': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_313': No space left on device
cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_314': No space left on device
.....

So, turning off speculative preallocation via the allocsize mount
option doesn't fix the problem. IOWs, the problem is too much active
metadata reservation.  If we are caching 685MB, that's less than the
writeback thresholds of a large memory machine, so the metadata
reservations won't be trimmed at all until ENOSPC actually occurs
and writeback is then started.

The problem is that writeback_inodes_sb_if_idle() does not block if
there is already writeback in progress, so the callers just keep
hitting ENOSPC rather than being throttled waiting for delalloc
conversion.

The patch below should fix this - it changes xfs_flush_inodes() to
us sync_inodes_sb(), which will issue IO and block waiting for it to
complete, just like xfs_flush_inodes() used to. Indeed, it passes
again on my VM with 8GB RAM....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: make inode writeback at ENOSPC blocking.

From: Dave Chinner <dchinner@redhat.com>

writeback_inodes_sb_if_idle() is not sufficient to trigger delalloc
conversion fast enough to prevent spurious ENOSPC whent here are
hundreds of writers, thousands of small files and GBs of free RAM.
Change this to use sync_sb_inodes() to block callers while we wait
for writeback like the previous xfs_flush_inodes implementation did.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index da69c18..0ec7a46 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -294,7 +294,7 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
 static inline void
 xfs_flush_inodes(struct xfs_inode *ip)
 {
-	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
+	sync_inodes_sb(VFS_I(ip)->i_sb);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
