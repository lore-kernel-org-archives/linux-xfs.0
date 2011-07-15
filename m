Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6FKXMhc218867 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 15:33:22 -0500
Date: Fri, 15 Jul 2011 16:33:17 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] xfs: failure mapping nfs fh to inode should return ESTALE
Message-ID: <20110715203317.GA25772@fieldses.org>
References: <20110714205036.GA19457@fieldses.org>
	<20110714223126.GA28694@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714223126.GA28694@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Thu, Jul 14, 2011 at 06:31:26PM -0400, Christoph Hellwig wrote:
> On Thu, Jul 14, 2011 at 04:50:36PM -0400, J. Bruce Fields wrote:
> > From: J. Bruce Fields <bfields@redhat.com>
> > 
> > On xfs exports, nfsd is incorrectly returning ENOENT instead of ESTALE
> > on attempts to use a filehandle of a deleted file (spotted with pynfs
> > test PUTFH3).  The ENOENT was coming from xfs_iget.
> 
> With that you mean the ip->i_d.di_mode checks?  Given that we should
> only be bale to get these from NFS or the handle ioctls I suspect just
> turning them into ESTALE should be fine.
> 

Like the following?  That passes my test.  I wouldn't have thought of
doing it that way because I wouldn't know how to check that

	- the change will only affect nfsd and the handle ioctls, and
	- those are the only two places under xfs_iget that will
	  generate an ENOENT (which will never be the right error return
	  on failure to find a filehandle).

If those are true, great.

--b.

commit 94578e7d1c3e00ad29608c70fae314f85a465840
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Thu Jul 14 15:39:49 2011 -0400

    xfs: failure mapping nfs fh to inode should return ESTALE
    
    On xfs exports, nfsd is incorrectly returning ENOENT instead of ESTALE
    on attempts to use a filehandle of a deleted file (spotted with pynfs
    test PUTFH3).  The ENOENT was coming from xfs_iget.
    
    While we're at it, the other return of ENOENT in xfs_nfs_get_inode()
    also looks wrong.
    
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index f4f878f..9e94d57 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -158,7 +158,7 @@ xfs_nfs_get_inode(
 
 	if (ip->i_d.di_gen != generation) {
 		IRELE(ip);
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-ESTALE);
 	}
 
 	return VFS_I(ip);
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 3631783..19752451 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -222,7 +222,7 @@ xfs_iget_cache_hit(
 	 * If lookup is racing with unlink return an error immediately.
 	 */
 	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
-		error = ENOENT;
+		error = ESTALE;
 		goto out_error;
 	}
 
@@ -333,7 +333,7 @@ xfs_iget_cache_miss(
 	trace_xfs_iget_miss(ip);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
-		error = ENOENT;
+		error = ESTALE;
 		goto out_destroy;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
