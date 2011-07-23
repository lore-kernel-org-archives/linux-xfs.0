Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6NJWSnf175147 for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 14:32:28 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89C8E180E7BD
	for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 12:32:26 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id bU3swmvsRzyc65B7 for
	<xfs@oss.sgi.com>; Sat, 23 Jul 2011 12:32:26 -0700 (PDT)
Date: Sat, 23 Jul 2011 21:32:25 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
	->fsync() handlers
Message-ID: <20110723193225.GA1652@x4.trippels.de>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
	<20110723180942.GA1616@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110723180942.GA1616@x4.trippels.de>
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
To: Josef Bacik <josef@redhat.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org

On 2011.07.23 at 20:09 +0200, Markus Trippelsdorf wrote:
> On 2011.06.29 at 14:05 -0400, Josef Bacik wrote:
> > Btrfs needs to be able to control how filemap_write_and_wait_range() is called
> > in fsync to make it less of a painful operation, so push down taking i_mutex and
> > the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
> > file systems can drop taking the i_mutex altogether it seems, like ext3 and
> > ocfs2.  For correctness sake I just pushed everything down in all cases to make
> > sure that we keep the current behavior the same for everybody, and then each
> > individual fs maintainer can make up their mind about what to do from there.
> 
> At least the xfs part of this patch is broken.
> Running the latest git-kernel bogofilter doesn't work anymore on my xfs
> partition. When I run "bogoutil -d wordlist.db" to dump the contents of
> the database, it produces no output at all. 
> 
> Reverting 02c24a82187d (or only the xfs part of that commit) "solves"
> the problem.

Looks like a locking problem (note the stale xfs_rw_ilock):

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 7f782af..fbbf657 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -127,6 +127,8 @@ xfs_iozero(
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
+	loff_t			start,
+	loff_t			end,
 	int			datasync)
 {
 	struct inode		*inode = file->f_mapping->host;
@@ -138,6 +140,10 @@ xfs_file_fsync(
 
 	trace_xfs_file_fsync(ip);
 
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
 
@@ -875,18 +881,11 @@ xfs_file_aio_write(
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
-		int error, error2;
 
 		xfs_rw_iunlock(ip, iolock);
-		error = filemap_write_and_wait_range(mapping, pos, end);
+		ret = -xfs_file_fsync(file, pos, end,
+				      (file->f_flags & __O_SYNC) ? 0 : 1);
 		xfs_rw_ilock(ip, iolock);
-
-		error2 = -xfs_file_fsync(file,
-					 (file->f_flags & __O_SYNC) ? 0 : 1);
-		if (error)
-			ret = error;
-		else if (error2)
-			ret = error2;
 	}
 
 out_unlock:

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
