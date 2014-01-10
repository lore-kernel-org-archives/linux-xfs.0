Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55B6C7F3F
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 07:22:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49949304066
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 05:22:48 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id IEizGx9HkyG67hJH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Jan 2014 05:22:46 -0800 (PST)
Message-ID: <52CFF402.5080409@oracle.com>
Date: Fri, 10 Jan 2014 21:22:10 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [xfs] c91c46c12: xfstests generic/313 regression
References: <20140110122700.GA12624@localhost>
In-Reply-To: <20140110122700.GA12624@localhost>
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
To: fengguang.wu@intel.com, Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Fengguang,

Thanks for help catching up this.  I think the below patch can fix it
up, but maybe there would have a neater solution once Christoph is back.

Thanks,
-Jeff

From: Jie Liu <jeff.liu@oracle.com>
Subject: xfs: fix ctime and mtime update for truncate(2)

There is a semantic difference between truncate(2) and ftruncate(2) as
per VFS implementation, that is the truncate(2) is called without both
ATTR_CTIME and ATTR_MTIME flags in inode attributes (iattr->ia_valid),
and this is a special case where we need to update the times despite
not having these flags set.  However, this was broken by:

    Commit: c91c46c12768daac8486dff0f74bc52c2ec974cd
    xfs: add xfs_setattr_time

Since those flags are not set in iattr->ia_valid, and this problem can
be reproduced via xfstests/generic/313.

This patch fix it by adding a mask argument to xfs_setattr_time() as it
includes those flags in xfs_setattr_size() specially.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_iops.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0ce1d75..defd47e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -477,23 +477,24 @@ xfs_setattr_mode(
 static void
 xfs_setattr_time(
 	struct xfs_inode	*ip,
-	struct iattr		*iattr)
+	struct iattr		*iattr,
+	int			mask)
 {
 	struct inode		*inode = VFS_I(ip);
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	if (iattr->ia_valid & ATTR_ATIME) {
+	if (mask & ATTR_ATIME) {
 		inode->i_atime = iattr->ia_atime;
 		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
 		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
 	}
-	if (iattr->ia_valid & ATTR_CTIME) {
+	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
 		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
 	}
-	if (iattr->ia_valid & ATTR_MTIME) {
+	if (mask & ATTR_MTIME) {
 		inode->i_mtime = iattr->ia_mtime;
 		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
 		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
@@ -657,7 +658,7 @@ xfs_setattr_nonsize(
 	if (mask & ATTR_MODE)
 		xfs_setattr_mode(ip, iattr);
 	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
+		xfs_setattr_time(ip, iattr, mask);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
@@ -875,7 +876,7 @@ xfs_setattr_size(
 	if (mask & ATTR_MODE)
 		xfs_setattr_mode(ip, iattr);
 	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
+		xfs_setattr_time(ip, iattr, mask);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-- 
1.8.3.2

On 01/10 2014 20:27 PM, fengguang.wu@intel.com wrote:
> Hi Christoph,
> 
> We find this commit failed xfstests generic/313.
> Attached is our kconfig.
> 
> c91c46c12768daac8486dff0f74bc52c2ec974cd is the first bad commit
> commit c91c46c12768daac8486dff0f74bc52c2ec974cd
> Author:     Christoph Hellwig <hch@infradead.org>
> AuthorDate: Mon Nov 18 05:10:52 2013 -0800
> Commit:     Ben Myers <bpm@sgi.com>
> CommitDate: Fri Dec 6 17:26:19 2013 -0600
> 
>     xfs: add xfs_setattr_time
>     
>     Split out a xfs_setattr_time helper to share code between truncate and
>     regular setattr similar to xfs_setattr_mode.  I might also have another
>     caller growing for this in the near future.
>     
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Reviewed-by: Brian Foster <bfoster@redhat.com>
>     Signed-off-by: Ben Myers <bpm@sgi.com>
> 
>  fs/xfs/xfs_iops.c | 66 +++++++++++++++++++++++++------------------------------
>  1 file changed, 30 insertions(+), 36 deletions(-)
> 
> Thanks,
> Fengguang
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
