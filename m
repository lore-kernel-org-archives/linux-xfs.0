Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0I4tItP106534 for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 22:55:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59E5F101A551
	for <xfs@oss.sgi.com>; Mon, 17 Jan 2011 20:57:33 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	MJGn7tUqFeG364fw for <xfs@oss.sgi.com>;
	Mon, 17 Jan 2011 20:57:33 -0800 (PST)
Date: Tue, 18 Jan 2011 15:57:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_iformat(realtime) even after xfs_repair.
Message-ID: <20110118045730.GU28803@dastard>
References: <AANLkTin=nqXCVJRgqBuTDx6nxMx1GLiG2DortJG+pz2L@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTin=nqXCVJRgqBuTDx6nxMx1GLiG2DortJG+pz2L@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 17, 2011 at 09:12:54PM +0900, Ajeet Yadav wrote:
> Kernel: 2.6.30.9, XFS backported from 2.6.34, xfsprogs-3.0.5
> 
> I used a script
> 1. create some file, directories, symlinks
> 2. unmount the file system
> 3. run xfs_bd with blocktrash
> 4. xfs_xfsrepair -L
> 5. list "ls -lR"
> 6. remove all file and directory "rm -rf *

OK, so you are effectively corrupting random blocks by introducing
random bit errors in the blocks. No surprise that some errors are
not being detected - what is the blocktrash command that you are
using?

> Often during testing I get the below backtrace from kernel during ls, rm
> even though I already run xfs_repair on it.
> Is it related to xfsrepair or xfs ?. I think xfs_repair must have detected
> this problem and corrected it.

xfs_repair is not checking the di_flags field in the inode for
sanity, hence having a wrong flag set is going unnoticed.

> There is similar problem already reported by
> http://oss.sgi.com/archives/xfs/2010-06/msg00349.html

Similar error message (xfs_iformt found an inode corruption), but
that one is a completely different problem.

Does the patch below (compile tested only) detect the bad inode?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs_repair: validate inode di_flags field

xfs_repair is not validating the di_flags field in the inode for
sanity. Block fuzzing indicates that we are not picking situations
like the RT bit being set on filesystems without realtime devices.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 2fa850d..e05d4e0 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2519,6 +2519,68 @@ process_dinode_int(xfs_mount_t *mp,
 		goto clear_bad_out;
 	}
 
+	/*
+	 * check that we only have valid flags set, and those that are set make
+	 * sense.
+	 */
+	if (dino->di_flags) {
+		uint16_t flags = be16_to_cpu(dino->di_flags);
+
+		if (flags & ~XFS_DIFLAG_ANY) {
+			do_warn(_("Bad flags set in inode %llu"), lino);
+			flags &= ~XFS_DIFLAG_ANY;
+		}
+
+		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
+			/* need an rt-dev! */
+			if (!rt_name) {
+				do_warn(_(
+	"inode %llu has RT flag set but there is no RT device"), lino);
+				flags &= ~(XFS_DIFLAG_REALTIME |
+						XFS_DIFLAG_RTINHERIT);
+			}
+		}
+		if (flags & XFS_DIFLAG_NEWRTBM_BIT) {
+			/* must be a rt bitmap inode */
+			if (lino != mp->m_sb.sb_rbmino) {
+				do_warn(_("inode %llu not rt bitmap"), lino);
+				flags &= ~XFS_DIFLAG_NEWRTBM_BIT;
+			}
+		}
+		if (flags & (XFS_DIFLAG_RTINHERIT |
+			     XFS_DIFLAG_EXTSZINHERIT |
+			     XFS_DIFLAG_PROJINHERIT |
+			     XFS_DIFLAG_NOSYMLINKS)) {
+			/* must be a directory */
+			if (di_mode && !S_ISDIR(di_mode)) {
+				do_warn(_(
+			"directory flags set on non-directory inode %llu"),
+					lino);
+				flags &= ~(XFS_DIFLAG_RTINHERIT |
+						XFS_DIFLAG_EXTSZINHERIT |
+						XFS_DIFLAG_PROJINHERIT |
+						XFS_DIFLAG_NOSYMLINKS);
+			}
+		}
+		if (flags & (XFS_DIFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) {
+			/* must be a file */
+			if (di_mode && !S_ISREG(di_mode)) {
+				do_warn(_(
+			"file flags set on non-file inode %llu"), lino);
+				flags &= ~(XFS_DIFLAG_REALTIME |
+						XFS_XFLAG_EXTSIZE);
+			}
+		}
+		if (!verify_mode && flags != be16_to_cpu(dino->di_flags)) {
+			if (!no_modify) {
+				do_warn(_(", fixing bad flags.\n"));
+				dino->di_flags = cpu_to_be16(flags);
+				*dirty = 1;
+			} else
+				do_warn(_(", would fix bad flags.\n"));
+		}
+	}
+
 	if (verify_mode)
 		return retval;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
