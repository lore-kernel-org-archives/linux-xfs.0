Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RKsDD2220935 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 15:54:13 -0500
Received: from mx2.netapp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEBB818311A2
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 13:54:12 -0700 (PDT)
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37]) by cuda.sgi.com
	with ESMTP id F7TVyDXc4UUsx674 for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 13:54:12 -0700 (PDT)
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 27 Jul 2011 16:54:11 -0400
In-Reply-To: <1311799021.25645.41.camel@lade.trondhjem.org>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
	<alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
	<20110727193937.GA5354@infradead.org>
	<alpine.DEB.2.02.1107271540100.1451@p34.internal.lan>
	<20110727194722.GA9345@infradead.org>
	<1311799021.25645.41.camel@lade.trondhjem.org>
Message-ID: <1311800051.25645.43.camel@lade.trondhjem.org>
Mime-Version: 1.0
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
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Bryan Schumaker <bjschuma@netapp.com>

On Wed, 2011-07-27 at 16:37 -0400, Trond Myklebust wrote: 
> On Wed, 2011-07-27 at 15:47 -0400, Christoph Hellwig wrote: 
> > On Wed, Jul 27, 2011 at 03:44:20PM -0400, Justin Piszcz wrote:
> > > 
> > > 
> > > On Wed, 27 Jul 2011, Christoph Hellwig wrote:
> > > 
> > > >On Wed, Jul 27, 2011 at 03:35:01PM -0400, Justin Piszcz wrote:
> > > >>Currently I do not see any dupes, however I have a script that moves
> > > >>images out of the directory once an hour:
> > > >>0 * * * * /usr/local/bin/move_to_old2.sh > /dev/null 2>&1
> > > >
> > > >Do you keep adding files to the directory while you move files out?
> > > Yes, otherwise there are too many files in the directory and viewers, e.g.,
> > > each geeqie (picture viewer) will use > 4-6GB of memory, so I try to keep
> > > it around 5,000 pictures or less.
> > > 
> > > >What's the rate of additions/removals to the directory?
> > > Additions it depends, around 5,000 over a 12hr period, 416/hr, current:
> > > 
> > > atom:/d1/motion# find cam1|wc
> > >    5215    5215  166853
> > > atom:/d1/motion# find cam2|wc
> > >    5069    5069  162181
> > > atom:/d1/motion# find cam3|wc
> > >    5594    5594  178981
> > > atom:/d1/motion#
> > 
> > This sounds a lot like xfs simply filling up the directory index slots
> > of files that you just moved out with new files, and nfs falsely
> > claiming that this is a problem.
> 
> Yep. There is an existing bugzilla report for this bug at
> 
>    https://bugzilla.kernel.org/show_bug.cgi?id=38572
> 
> I have a preliminary patch there that attempts to turn off the loop
> detection when the directory is seen to change, however that patch still
> appears to have a bug in it, and I haven't had time to figure out what
> is wrong yet.
> 
> Can you perhaps take a look, Bryan?

Actually, Justin, can you test the following slight variant on the patch
in the bugzilla?

8<--------------------------------------------------------- 
>From 13cf7def9f2d802c3ea300833ba7f88705279cb1 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 27 Jul 2011 16:51:56 -0400
Subject: [PATCH] NFS: Fix spurious readdir cookie loop messages

If the directory contents change, then we have to accept that the
file->f_pos value may shrink if we do a 'search-by-cookie'. In that
case, we should turn off the loop detection and let the NFS client
try to recover.

Reported-by: Petr Vandrovec <petr@vandrovec.name>
Cc: stable@kernel.org [2.6.39]
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c           |   25 ++++++++++++++++---------
 include/linux/nfs_fs.h |    1 +
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 57f578e..73993b9 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -134,7 +134,7 @@ const struct inode_operations nfs4_dir_inode_operations = {
 
 #endif /* CONFIG_NFS_V4 */
 
-static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct rpc_cred *cred)
+static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir, struct rpc_cred *cred)
 {
 	struct nfs_open_dir_context *ctx;
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
@@ -143,9 +143,10 @@ static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct rpc_cred *
 		ctx->dir_cookie = 0;
 		ctx->dup_cookie = 0;
 		ctx->cred = get_rpccred(cred);
-	} else
-		ctx = ERR_PTR(-ENOMEM);
-	return ctx;
+		ctx->cache_change_attribute = nfs_save_change_attribute(dir);
+		return ctx;
+	}
+	return  ERR_PTR(-ENOMEM);
 }
 
 static void put_nfs_open_dir_context(struct nfs_open_dir_context *ctx)
@@ -173,7 +174,7 @@ nfs_opendir(struct inode *inode, struct file *filp)
 	cred = rpc_lookup_cred();
 	if (IS_ERR(cred))
 		return PTR_ERR(cred);
-	ctx = alloc_nfs_open_dir_context(cred);
+	ctx = alloc_nfs_open_dir_context(inode, cred);
 	if (IS_ERR(ctx)) {
 		res = PTR_ERR(ctx);
 		goto out;
@@ -323,7 +324,6 @@ int nfs_readdir_search_for_pos(struct nfs_cache_array *array, nfs_readdir_descri
 {
 	loff_t diff = desc->file->f_pos - desc->current_index;
 	unsigned int index;
-	struct nfs_open_dir_context *ctx = desc->file->private_data;
 
 	if (diff < 0)
 		goto out_eof;
@@ -336,7 +336,6 @@ int nfs_readdir_search_for_pos(struct nfs_cache_array *array, nfs_readdir_descri
 	index = (unsigned int)diff;
 	*desc->dir_cookie = array->array[index].cookie;
 	desc->cache_entry_index = index;
-	ctx->duped = 0;
 	return 0;
 out_eof:
 	desc->eof = 1;
@@ -349,12 +348,18 @@ int nfs_readdir_search_for_cookie(struct nfs_cache_array *array, nfs_readdir_des
 	int i;
 	loff_t new_pos;
 	int status = -EAGAIN;
-	struct nfs_open_dir_context *ctx = desc->file->private_data;
 
 	for (i = 0; i < array->size; i++) {
 		if (array->array[i].cookie == *desc->dir_cookie) {
+			struct inode *dir = desc->file->f_path.dentry->d_inode;
+			struct nfs_open_dir_context *ctx = desc->file->private_data;
+
 			new_pos = desc->current_index + i;
-			if (new_pos < desc->file->f_pos) {
+			if (!nfs_verify_change_attribute(dir, ctx->cache_change_attribute)
+			    || (NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATTR)) {
+				ctx->cache_change_attribute = nfs_save_change_attribute(dir);
+				ctx->duped = 0;
+			} else if (new_pos < desc->file->f_pos) {
 				ctx->dup_cookie = *desc->dir_cookie;
 				ctx->duped = 1;
 			}
@@ -805,6 +810,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, void *dirent,
 	struct page	*page = NULL;
 	int		status;
 	struct inode *inode = desc->file->f_path.dentry->d_inode;
+	struct nfs_open_dir_context *ctx = desc->file->private_data;
 
 	dfprintk(DIRCACHE, "NFS: uncached_readdir() searching for cookie %Lu\n",
 			(unsigned long long)*desc->dir_cookie);
@@ -818,6 +824,7 @@ int uncached_readdir(nfs_readdir_descriptor_t *desc, void *dirent,
 	desc->page_index = 0;
 	desc->last_cookie = *desc->dir_cookie;
 	desc->page = page;
+	ctx->duped = 0;
 
 	status = nfs_readdir_xdr_to_array(desc, page, inode);
 	if (status < 0)
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 8b579be..f45d712 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -99,6 +99,7 @@ struct nfs_open_context {
 
 struct nfs_open_dir_context {
 	struct rpc_cred *cred;
+	unsigned long cache_change_attribute;
 	__u64 dir_cookie;
 	__u64 dup_cookie;
 	int duped;
-- 
1.7.6



-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
