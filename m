Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7009C7FAA
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 12:46:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B7F0304053
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:46:58 -0800 (PST)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id bfvHDpmWouNIx1tx
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2015 10:46:57 -0800 (PST)
Received: by mail-pa0-f54.google.com with SMTP id fb1so31596287pad.13
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 10:46:56 -0800 (PST)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Tue, 6 Jan 2015 10:46:52 -0800
Subject: Re: [PATCH 02/18] fs: add FL_LAYOUT lease type
Message-ID: <20150106104652.49078615@synchrony.poochiereds.net>
In-Reply-To: <1420561721-9150-3-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Tue,  6 Jan 2015 17:28:25 +0100
Christoph Hellwig <hch@lst.de> wrote:

> This (ab-)uses the file locking code to allow filesystems to recall
> outstanding pNFS layouts on a file.  This new lease type is similar but
> not quite the same as FL_DELEG.  A FL_LAYOUT lease can always be granted,
> an a per-filesystem lock (XFS iolock for the initial implementation)
> ensures not FL_LAYOUT leases granted when we would need to recall them.
> 
> Also included are changes that allow multiple outstanding read
> leases of different types on the same file as long as they have a
> differnt owner.  This wasn't a problem until now as nfsd never set
> FL_LEASE leases, and no one else used FL_DELEG leases, but given that
> nfsd will also issues FL_LAYOUT leases we will have to handle it now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

So with the current code, layouts are always whole-file?

Tracking layouts as a lease-like object seems reasonable, but I'm not
100% thrilled with overloading all of the lease code with this. Perhaps
it should be its own sort of object with a separate API to manage them?
That would also make it easier to support layouts that are not for the
entire file.

To that end, it might be nice to hold off on taking this until we
deprecate the i_flock list as we can then give layouts their own
list_head in the file_lock_context. It would also make it easier to use
a new sort of object to represent layouts.

I just cleaned up that patchset last week, and will re-post it soon
once I give it a bit of testing this week.

> ---
>  fs/locks.c          | 28 +++++++++++++++++++---------
>  fs/nfsd/nfs4state.c |  2 +-
>  include/linux/fs.h  | 16 ++++++++++++++++
>  3 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 735b8d3..6cf41f8 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -137,7 +137,7 @@
>  
>  #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
>  #define IS_FLOCK(fl)	(fl->fl_flags & FL_FLOCK)
> -#define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG))
> +#define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG|FL_LAYOUT))
>  #define IS_OFDLCK(fl)	(fl->fl_flags & FL_OFDLCK)
>  
>  static bool lease_breaking(struct file_lock *fl)
> @@ -1348,6 +1348,8 @@ static void time_out_leases(struct inode *inode, struct list_head *dispose)
>  
>  static bool leases_conflict(struct file_lock *lease, struct file_lock *breaker)
>  {
> +	if ((breaker->fl_flags & FL_LAYOUT) != (lease->fl_flags & FL_LAYOUT))
> +		return false;
>  	if ((breaker->fl_flags & FL_DELEG) && (lease->fl_flags & FL_LEASE))
>  		return false;
>  	return locks_conflict(breaker, lease);
> @@ -1560,11 +1562,14 @@ int fcntl_getlease(struct file *filp)
>   * conflict with the lease we're trying to set.
>   */
>  static int
> -check_conflicting_open(const struct dentry *dentry, const long arg)
> +check_conflicting_open(const struct dentry *dentry, const long arg, int flags)
>  {
>  	int ret = 0;
>  	struct inode *inode = dentry->d_inode;
>  
> +	if (flags & FL_LAYOUT)
> +		return 0;
> +
>  	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
>  		return -EAGAIN;
>  
> @@ -1608,7 +1613,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
>  
>  	spin_lock(&inode->i_lock);
>  	time_out_leases(inode, &dispose);
> -	error = check_conflicting_open(dentry, arg);
> +	error = check_conflicting_open(dentry, arg, lease->fl_flags);
>  	if (error)
>  		goto out;
>  
> @@ -1624,10 +1629,13 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
>  	for (before = &inode->i_flock;
>  			((fl = *before) != NULL) && IS_LEASE(fl);
>  			before = &fl->fl_next) {
> -		if (fl->fl_file == filp) {
> +
> +		if (fl->fl_file == filp &&
> +		    fl->fl_owner == lease->fl_owner) {
>  			my_before = before;
>  			continue;
>  		}
> +
>  		/*
>  		 * No exclusive leases if someone else has a lease on
>  		 * this file:
> @@ -1665,7 +1673,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
>  	 * precedes these checks.
>  	 */
>  	smp_mb();
> -	error = check_conflicting_open(dentry, arg);
> +	error = check_conflicting_open(dentry, arg, lease->fl_flags);
>  	if (error)
>  		goto out_unlink;
>  
> @@ -1685,7 +1693,7 @@ out_unlink:
>  	goto out;
>  }
>  
> -static int generic_delete_lease(struct file *filp)
> +static int generic_delete_lease(struct file *filp, void *priv)
>  {
>  	int error = -EAGAIN;
>  	struct file_lock *fl, **before;
> @@ -1698,7 +1706,8 @@ static int generic_delete_lease(struct file *filp)
>  	for (before = &inode->i_flock;
>  			((fl = *before) != NULL) && IS_LEASE(fl);
>  			before = &fl->fl_next) {
> -		if (fl->fl_file == filp)
> +		if (fl->fl_file == filp &&
> +		    priv == fl->fl_owner)
>  			break;
>  	}
>  	trace_generic_delete_lease(inode, fl);
> @@ -1737,13 +1746,14 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
>  
>  	switch (arg) {
>  	case F_UNLCK:
> -		return generic_delete_lease(filp);
> +		return generic_delete_lease(filp, *priv);
>  	case F_RDLCK:
>  	case F_WRLCK:
>  		if (!(*flp)->fl_lmops->lm_break) {
>  			WARN_ON_ONCE(1);
>  			return -ENOLCK;
>  		}
> +
>  		return generic_add_lease(filp, arg, flp, priv);
>  	default:
>  		return -EINVAL;
> @@ -1816,7 +1826,7 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
>  int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
>  {
>  	if (arg == F_UNLCK)
> -		return vfs_setlease(filp, F_UNLCK, NULL, NULL);
> +		return vfs_setlease(filp, F_UNLCK, NULL, (void **)&filp);
>  	return do_fcntl_add_lease(fd, filp, arg);
>  }
>  
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index 277f8b8..2505b68 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -693,7 +693,7 @@ static void nfs4_put_deleg_lease(struct nfs4_file *fp)
>  	spin_unlock(&fp->fi_lock);
>  
>  	if (filp) {
> -		vfs_setlease(filp, F_UNLCK, NULL, NULL);
> +		vfs_setlease(filp, F_UNLCK, NULL, (void **)&fp);
>  		fput(filp);
>  	}
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f90c028..204cf91 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -875,6 +875,7 @@ static inline struct file *get_file(struct file *f)
>  #define FL_DOWNGRADE_PENDING	256 /* Lease is being downgraded */
>  #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
>  #define FL_OFDLCK	1024	/* lock is "owned" by struct file */
> +#define FL_LAYOUT	2048	/* outstanding pNFS layout */
>  
>  /*
>   * Special return value from posix_lock_file() and vfs_lock_file() for
> @@ -2017,6 +2018,16 @@ static inline int break_deleg_wait(struct inode **delegated_inode)
>  	return ret;
>  }
>  
> +static inline int break_layout(struct inode *inode, bool wait)
> +{
> +	smp_mb();
> +	if (inode->i_flock)
> +		return __break_lease(inode,
> +				wait ? O_WRONLY : O_WRONLY | O_NONBLOCK,
> +				FL_LAYOUT);
> +	return 0;
> +}
> +
>  #else /* !CONFIG_FILE_LOCKING */
>  static inline int locks_mandatory_locked(struct file *file)
>  {
> @@ -2072,6 +2083,11 @@ static inline int break_deleg_wait(struct inode **delegated_inode)
>  	return 0;
>  }
>  
> +static inline int break_layout(struct inode *inode, bool wait)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_FILE_LOCKING */
>  
>  /* fs/open.c */


-- 
Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
