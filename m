Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92IvFxt076489 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 13:57:15 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9SLBtFpWdGutXwOW for
	<xfs@oss.sgi.com>; Tue, 02 Oct 2012 11:58:39 -0700 (PDT)
Message-ID: <506AE5AD.60509@redhat.com>
Date: Tue, 02 Oct 2012 09:01:33 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com> <20121002001021.GJ23520@dastard>
	<506A38D1.6090204@redhat.com>
In-Reply-To: <506A38D1.6090204@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/01/2012 08:44 PM, Brian Foster wrote:
> On 10/01/2012 08:10 PM, Dave Chinner wrote:
...
> 
> I gave this a quick couple runs against 273 and it passes (on top of
> the entire die-xfssyncd-die patchset). I'll kick off another full run
> on this box overnight. Thanks!
> 

And I spoke a bit too soon... I hit the following warning with this change:

WARNING: at fs/fs-writeback.c:1401 sync_inodes_sb+0xc0/0xd0()

The inline patch addresses it. I also see the following message during
273 but it doesn't appear related to this set:

kernel: XFS (dm-4): xlog_verify_grant_tail: space > BBTOB(tail_blocks)

Brian

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index da69c18..f11133b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -294,7 +294,9 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
 static inline void
 xfs_flush_inodes(struct xfs_inode *ip)
 {
-	writeback_inodes_sb_if_idle(VFS_I(ip)->i_sb, WB_REASON_FS_FREE_SPACE);
+	down_read(&VFS_I(ip)->i_sb->s_umount);
+	sync_inodes_sb(VFS_I(ip)->i_sb);
+	up_read(&VFS_I(ip)->i_sb->s_umount);
 }

 /*

> Brian
> 
>> Cheers,
>> 
>> Dave.
>> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
