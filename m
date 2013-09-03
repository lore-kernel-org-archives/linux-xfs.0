Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BD927F4E
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 17:17:15 -0500 (CDT)
Date: Tue, 3 Sep 2013 17:17:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: inode buffers may not be valid during recovery
	readahead
Message-ID: <20130903221712.GN1935@sgi.com>
References: <1377567577-24312-1-git-send-email-david@fromorbit.com>
	<20130830181520.GD1935@sgi.com> <20130831061420.GY12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130831061420.GY12779@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Sat, Aug 31, 2013 at 04:14:20PM +1000, Dave Chinner wrote:
> On Fri, Aug 30, 2013 at 01:15:20PM -0500, Ben Myers wrote:
> > Dave,
> > 
> > On Tue, Aug 27, 2013 at 11:39:37AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > CRC enabled filesystems fail log recovery with 100% reliability on
> > > xfstests xfs/085 with the following failure:
> > 
> > Unfortunately I have not been able to hit this one... not sure why.
> > 
> > > XFS (vdb): Mounting Filesystem
> > > XFS (vdb): Starting recovery (logdev: internal)
> > > XFS (vdb): Corruption detected. Unmount and run xfs_repair
> > > XFS (vdb): bad inode magic/vsn daddr 144 #0 (magic=0)
> > > XFS: Assertion failed: 0, file: fs/xfs/xfs_inode_buf.c, line: 95
> > > 
> > > The problem is that the inode buffer has not been recovered before
> > > the readahead on the inode buffer is issued. The checkpoint being
> > > recovered actually allocates the inode chunk we are doing readahead
> > > from, so what comes from disk during readahead is essentially
> > > random and the verifier barfs on it.
> > > 
> > > This inode buffer readahead problem affects non-crc filesystems,
> > > too, but xfstests does not trigger it at all on such
> > > configurations....
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > I've been mulling this one over for a bit, and I'm not quite sure this
> > is correct:
> > 
> > My feeling is that in light of commit 9222a9cf, if we do take part of a
> > buffer back in time, the write verifier should fail.
> 
> I don't see the connection between 9222a9cf ("xfs: don't shutdown
> log recovery on validation errors") and this issue. 9222a9cf works
> around are a longstanding architectural deficiency of log
> recovery, while this is a completely new problem introduced by the
> inode buffer readahead in log recovery.

Commit 9222a9cf left buffer operations for inodes clear in the v2 inode case:

@@ -1845,7 +1845,13 @@ xlog_recover_do_inode_buffer(
        xfs_agino_t             *buffer_nextp;

        trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
-       bp->b_ops = &xfs_inode_buf_ops;
+
+       /*
+        * Post recovery validation only works properly on CRC enabled
+        * filesystems.
+        */
+       if (xfs_sb_version_hascrc(&mp->m_sb))
+               bp->b_ops = &xfs_inode_buf_ops;

xlog_recover_commit_trans
  xlog_recover_items_pass2
    xlog_recover_buffer_pass2
      xlog_recover_do_inode_buffer
        if (xfs_sb_version_hascrc(&mp->m_sb))
		bp->b_ops = &xfs_inode_buf_ops;

My concern is that with the readahead we have:

xlog_recover_commit_trans
  . xlog_recover_ra_pass2
  .   xlog_recover_inode_ra_pass2
  .     xfs_buf_readahead
  .       xfs_buf_readahead_map
  .         xfs_buf_read_map
  .           if (!XFS_BUF_ISDONE(bp))
  .			bp->b_ops = ops;
  xlog_recover_items_pass2
    xlog_recover_buffer_pass2
      xlog_recover_do_inode_buffer
        if (xfs_sb_version_hascrc(&mp->m_sb))
		bp->b_ops = &xfs_inode_buf_ops;

Looks like we can set b_ops in xfs_buf_read_map in the v2 inode case and it
would remain set through recovery when we intend it to be clear.  If we needed
to b_ops to be clear in commit 9222a9cf, I think it should also be clear in the
readahead case.

Here's what I suggest:

---
 fs/xfs/xfs_log_recover.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c	2013-09-03 16:57:51.534388540 -0500
+++ b/fs/xfs/xfs_log_recover.c	2013-09-03 16:59:13.784398092 -0500
@@ -3309,7 +3309,9 @@ xlog_recover_inode_ra_pass2(
 		return;
 
 	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
-				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
+				ilfp->ilf_len,
+				xfs_sb_version_hascrc(&mp->m_sb) ?
+					&xfs_inode_buf_ra_ops : NULL);
 }
 
 STATIC void

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
