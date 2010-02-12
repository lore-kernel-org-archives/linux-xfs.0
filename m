Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CEMTVd257211 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 08:22:30 -0600
Subject: Re: [PATCH 1/2] commit_metadata export operation replacing
	nfsd_sync_dir
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100211220500.26466.24169.stgit@case>
References: <20100211220454.26466.37578.stgit@case>
	<20100211220500.26466.24169.stgit@case>
Date: Fri, 12 Feb 2010 08:23:40 -0600
Message-ID: <1265984620.3201.73.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Ben Myers <bpm@sgi.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

Generally this looks like a good change, but I do have
some questions embedded below.

					-Alex

On Thu, 2010-02-11 at 16:05 -0600, Ben Myers wrote:
> - Add commit_metadata export_operation to allow the underlying filesystem to
> decide how to sync parent and child inodes most efficiently.
> 
> - Usage of nfsd_sync_dir and write_inode_now has been replaced with the
> commit_metadata function that takes a svc_fh and optional dentry for the child.

In the cases you pass the child dentry, you will now be syncing
things to disk in a slightly different way/order from before.
I think this way is actually much better, but I thought I'd ask
anyway:  are you sure that it's OK to sync them at the same time,
rather than directory first, then child (or the other way around,
depending on the case)?

> - The commit_metadata function calls the commit_metadata export_op if it's
> there, or else falls back to sync_inode instead of fsync and write_inode_now
> because only metadata need be synched here.
> 
> - nfsd4_sync_rec_dir now uses vfs_fsync so that commit_metadata can be static
> 
> - Add a 'delay_commit' arg to nfsd_setattr so that callers of
> nfsd_create_setattr can commit parent and child together avoiding an extra
> sync.

I think this is a distinct enough change to warrant a separate patch
from the commit_metadata feature.

> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

. . .

> index 5a754f7..98fb98e 100644
> --- a/fs/nfsd/nfs4recover.c
> +++ b/fs/nfsd/nfs4recover.c
> @@ -119,9 +119,7 @@ out_no_tfm:
>  static void
>  nfsd4_sync_rec_dir(void)
>  {
> -	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
> -	nfsd_sync_dir(rec_dir.dentry);
> -	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
> +	vfs_fsync(NULL, rec_dir.dentry, 0);

Why do you no longer need to acquire the mutex here?
I see it gets acquired during the ->fsync() call
inside vfs_fsync_range(), but is there a reason
that it needed to be held during the filemap_write_and_wait()
(as is done in the nfsd_sync_dir() code) also?

. . .

> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index ed024d3..97474fb 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c

. . .

> @@ -415,9 +449,8 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
>  	}
>  	if (size_change)
>  		put_write_access(inode);
> -	if (!err)
> -		if (EX_ISSYNC(fhp->fh_export))
> -			write_inode_now(inode, 1);
> +	if (!err && !delay_commit)
> +		err = nfserrno(commit_metadata(fhp, NULL));

Is this sufficient even if the size has changed?

>  out:
>  	return err;
>  

. . .

> @@ -1766,10 +1763,10 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
>  		goto out_dput_new;
>  
>  	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
> -	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
> -		host_err = nfsd_sync_dir(tdentry);
> +	if (!host_err) {
> +		host_err = commit_metadata(tfhp, NULL);
>  		if (!host_err)
> -			host_err = nfsd_sync_dir(fdentry);
> +			host_err = commit_metadata(ffhp, NULL);

It violates the spirit of the "parent" and "child"
nature of its arguments, but it might be nice to
commit both directories' metadata with the same
call here.

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
