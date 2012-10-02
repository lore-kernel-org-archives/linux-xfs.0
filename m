Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92Ko3wO085348 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 15:50:03 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Gg2hkcLBbWTdXuRM for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 13:51:26 -0700 (PDT)
Date: Wed, 3 Oct 2012 06:51:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
Message-ID: <20121002205124.GS23520@dastard>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com> <20121002001021.GJ23520@dastard>
	<506A38D1.6090204@redhat.com> <506AE5AD.60509@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506AE5AD.60509@redhat.com>
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

On Tue, Oct 02, 2012 at 09:01:33AM -0400, Brian Foster wrote:
> On 10/01/2012 08:44 PM, Brian Foster wrote:
> > On 10/01/2012 08:10 PM, Dave Chinner wrote:
> ...
> > 
> > I gave this a quick couple runs against 273 and it passes (on top of
> > the entire die-xfssyncd-die patchset). I'll kick off another full run
> > on this box overnight. Thanks!
> > 
> 
> And I spoke a bit too soon... I hit the following warning with this change:
> 
> WARNING: at fs/fs-writeback.c:1401 sync_inodes_sb+0xc0/0xd0()
> 
> The inline patch addresses it. I also see the following message during
> 273 but it doesn't appear related to this set:
> 
> kernel: XFS (dm-4): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> 
> Brian
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index da69c18..f11133b 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -294,7 +294,9 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
>  static inline void
>  xfs_flush_inodes(struct xfs_inode *ip)
>  {
> -	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
> +	down_read(&VFS_I(ip)->i_sb->s_umount);
> +	sync_inodes_sb(VFS_I(ip)->i_sb);
> +	up_read(&VFS_I(ip)->i_sb->s_umount);
>  }

I don't think we can do an unconditional down_read() there, as the
caller from xfs_create() already holds an i_mutex (the VFS holds the
directory inode lock) and I'm pretty sure that s_umount is supposed
to be outside per-inode locks.

Given that where we are called we are inside a transaction for the
create case, and inside mnt_want_write() protection for the buffered
write case, the likelyhood of s_umount being held for write at
ENOSPC is going to be non-existent at these call sites. Hence a
down_read_trylock() will avoid lock ordering issues, but will almost
always succeed and so be equivalent to down_read()....

/me modifies and runs 273 and the enospc xfstests group...

Seems to work just fine, and no warnings. Patch below.

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

We have to hold the s_umount lock here, but because this call can
nest inside i_mutex (the parent directory in the create case, held
by the VFS), we have to use down_read_trylock() to avoid potential
deadlocks. In practice, this trylock will succeed on almost every
attempt as unmount/remount type operations are exceedingly rare.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index da69c18..b3dabe9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -294,7 +294,12 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
 static inline void
 xfs_flush_inodes(struct xfs_inode *ip)
 {
-	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
+	struct super_block *sb = VFS_I(ip)->i_sb;
+
+	if (down_read_trylock(&sb->s_umount)) {
+		sync_inodes_sb(sb);
+		up_read(&sb->s_umount);
+	}
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
