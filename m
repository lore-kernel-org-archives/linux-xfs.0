Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 486BD7F59
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:41:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6EAFAC005
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:41:19 -0800 (PST)
Received: from mail.emea.novell.com (mail.emea.novell.com [130.57.118.101]) by
	cuda.sgi.com with ESMTP id 1vAOll21VmBOUXdH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:41:18 -0800 (PST)
Message-Id: <5457BE390200007800044838@mail.emea.novell.com>
Date: Mon, 03 Nov 2014 16:41:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
Subject: your patch "mm: Remove false WARN_ON from pagecache_isize_extended()"
Mime-Version: 1.0
Content-Disposition: inline
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
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Jan,

having run into that warning too, I looked into it a little, and now
having found that patch am pretty uncertain: Both truncate_setsize()
and pagecache_isize_extended() document that they want to be
called with i_mutex held, so removing the WARN_ON() alone seems
either incomplete or wrong. What I found to work without violating
this documented requirement is the patch below.

Jan

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -797,7 +797,7 @@ xfs_file_fallocate(
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -877,7 +877,7 @@ xfs_file_fallocate(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
