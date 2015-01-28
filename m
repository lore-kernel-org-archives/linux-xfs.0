Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F32607F8A
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 19:28:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2DE38F804B
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 17:28:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Q4aDGIOfmTHf7dN1 for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2015 17:28:01 -0800 (PST)
Date: Wed, 28 Jan 2015 12:27:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs_spaceman: XFS_IOC_FIEMAPFS ioctl replacing
	previous FS_IOC_FIEMAPFS
Message-ID: <20150128012758.GS16552@dastard>
References: <54c1c11e.678c420a.37a1.13c6@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54c1c11e.678c420a.37a1.13c6@mx.google.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 23, 2015 at 09:03:44AM +0530, Dhruvesh Rathore wrote:
> The original kernel patch that Dave wrote for xfs_spaceman implemented
> FS_IOC_FIEMAPFS ioctl, here is the original fiemap extension patch:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00363.html
> 
> These patches were not posted and were just forward ported to a current 
> 3.18-rc7+ for-next XFS tree and were pushed to the fiemapfs branch in Dave's
> kernel tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> The original xfs_spaceman tool that Dave wrote to call the fiemap
> interface and make use of it is here:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00366.html
> 
> Dave just updated it to the 3.2.2 code base and pushed it to the
> spaceman branch in this tree:
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> This patch is concerned with turning FS_IOC_FIEMAPFS, present in the earlier
> version of xfs_spaceman into an XFS specific ioctl called XFS_IOC_FIEMAPFS
> that uses the fiemap plumbing. Please do comment. 

So this commentary belongs in a patch series description, usually
titled "[PATCH 0/X] <patch series title>".

Then the patch itself will have a title/ description along the lines
of:

[PATCH 1/X] xfs: add XFS_IOC_FIEMAPFS

The FS_IOC_FIEMAPFS ioctl is not going to be merged, so convert the
existing code to use an XFS specific ioctl named XFS_IOC_FIEMAPFS
and plumb the code to use this ioctl.

> Signed-off-by: 
> Dhruvesh Rathore <dhruvesh_r@outlook.com>
> Amey Ruikar <ameyruikar@yahoo.com>
> Somdeep Dey <somdeepdey10@gmail.com>

One name per s-o-b. i.e.

Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>

> ---
> linux-xfs/fs/xfs/xfs_fs.h		| 1 +
> linux-xfs/fs/xfs/xfs_ioctl.c		| 71 ++++-
> xfsprogs-3.2.2/include/xfs_fs.h		| 1 +
> xfsprogs-3.2.2/spaceman/freesp.c	| 10 ++++++---
> 4 files changed, 79 insertions(+), 4 deletions(-) 

This needs to be separated into two patches - one for the kernel
changes, and one for the userspace changes. What I'd suggest that
you do is get the changes into a git tree with the correct commit
message that you want, then use git-send-email to send the commit.
That way you'll be sending patches that correctly formatted and
separated by tree.

> --- a/linux-xfs/fs/xfs/xfs_ioctl.c	2015-01-04 15:45:26.518359725 +0530
> +++ b/linux-xfs/fs/xfs/xfs_ioctl.c	2015-01-04 15:24:06.030407817 +0530
> @@ -49,6 +49,8 @@
>  #include <linux/exportfs.h>
>  
>  
> +/* So that the fiemap access checks can't overflow on 32 bit machines. */   		 
> +#define FIEMAP_MAX_EXTENTS	(UINT_MAX / sizeof(struct fiemap_extent))		 

Just move to include/linux/fs.h where the FS_IOC_FIEMAP definitions
are.

Also, there is trailing whitespace on the lines. I'd suggest that
you might like to use scripts/checkpatch.pl to find these simple
whitespace issues. if you use vim, then add this to your local
.vimrc file and it will highlight trailing whitespace in red:

" highlight whitespace damage
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/

> +static int fiemap_check_ranges(struct super_block *sb,
> +			       u64 start, u64 len, u64 *new_len)
> +{
> +	u64 maxbytes = (u64) sb->s_maxbytes;
> +
> +	*new_len = len;
> +
> +	if (len == 0)
> +		return -EINVAL;
> +
> +	if (start > maxbytes)
> +		return -EFBIG;
> +
> +	/*
> +	 * Shrink request scope to what the fs can actually handle.
> +	 */
> +	if (len > maxbytes || (maxbytes - len) < start)
> +		*new_len = maxbytes - start;
>  
> +	return 0;
> +}

Rather than copying this code, I'd suggest that you remove the "static"
declaration, export the symbol and add a prototype to
include/linux/fs.h similar to fiemap_check_flags().

> +static int xfsctl_fiemapfs(struct super_block *sb, unsigned long arg)				

- more trailing whitespace.
- xfs_ioctl_fiemapfs() follows the naming convention used in the
  rest of the file
- this is an XFS specific function now, so should pass the xfs_mount
  rather than the VFS super_block.
- need a comment saying it was mostly copied from fs/ioctl.c::ioctl_fiemap().
- arg has already marked as __user converted in the calling
  function, so we need to retain the __user annotations here.
- format for XFS functions is this:

/*
 * Mostly copied from ioctl_fiemap()
 */
static int
xfs_ioctl_fiemapfs(
	struct xfs_mount	*mp,
	void __user		*arg)


> +{
> +	struct fiemap fiemap;									
> +	struct fiemap __user *ufiemap = (struct fiemap __user *) arg;
> +	struct fiemap_extent_info fieinfo = { 0, };
> +	u64 len;
> +	int error;

formatting of declarations is usually aligned to that of the
function declaration. i.e:

	struct fiemap		fiemap;
	struct fiemap __user	*ufiemap = (struct fiemap __user *) arg;
	struct fiemap_extent_info fieinfo = { 0, };
	u64			len;
	int			error;

> +	if (!sb->s_op->fiemapfs)
> +		return -EOPNOTSUPP;

No need to check this - we can call the XFS function directly.

>  
> +	if (copy_from_user(&fiemap, ufiemap, sizeof(fiemap)))
> +		return -EFAULT;
> +
> +	if (fiemap.fm_extent_count > FIEMAP_MAX_EXTENTS)
> +		return -EINVAL;
> +
> +	error = fiemap_check_ranges(sb, fiemap.fm_start, fiemap.fm_length,
> +				    &len);
> +	if (error)
> +		return error;
> +
> +	fieinfo.fi_flags = fiemap.fm_flags;
> +	fieinfo.fi_extents_max = fiemap.fm_extent_count;
> +	fieinfo.fi_extents_start = ufiemap->fm_extents;
> +
> +	if (fiemap.fm_extent_count != 0 &&
> +	    !access_ok(VERIFY_WRITE, fieinfo.fi_extents_start,
> +		       fieinfo.fi_extents_max * sizeof(struct fiemap_extent)))
> +		return -EFAULT;
> +
> +	if (fiemap.fm_extent_count != 0 &&
> +	    (fiemap.fm_flags & FIEMAPFS_FLAG_FREESP_SIZE_HINT) &&
> +	    !access_ok(VERIFY_READ, fieinfo.fi_extents_start,
> +		       sizeof(struct fiemap_extent)))
> +		return -EFAULT;
> +
> +	error = sb->s_op->fiemapfs(sb, &fieinfo, fiemap.fm_start, len);

Call the xfs function directly.

And, in doing so, this will mean you can remove the ->fiemapfs
definitions from include/linux/fs.h

> +	fiemap.fm_flags = fieinfo.fi_flags;
> +	fiemap.fm_mapped_extents = fieinfo.fi_extents_mapped;
> +	if (copy_to_user(ufiemap, &fiemap, sizeof(fiemap)))
> +		error = -EFAULT;
> +
> +	return error;
> +}
>  
>  /*
>   * Note: some of the ioctl's return positive numbers as a
> @@ -1570,7 +1637,9 @@
>  		return 0;
>  	}
>  
> -	
> +	case XFS_IOC_FIEMAPFS:						
> +	   return xfsctl_fiemapfs(inode->i_sb, p);			

8 space tabs and lots of trailing whitespace.

		return xfs_ioctl_fiemapfs(mp, arg);

> --- a/xfsprogs-3.2.2/spaceman/freesp.c	2015-01-04 15:39:58.446372047 +0530
> +++ b/xfsprogs-3.2.2/spaceman/freesp.c	2015-01-04 15:38:30.294375357 +0530
> @@ -31,7 +31,7 @@
>  #define FIEMAPFS_FLAG_FREESP_SIZE_HINT	0x20000000
>  #define	FIEMAPFS_FLAG_FREESP_CONTINUE   0x10000000
>  
> -#define FS_IOC_FIEMAPFS			_IOWR('f', 12, struct fiemap)
> +#define XFS_IOC_FIEMAPFS			_IOWR('X', 33, struct fiemap)
>  #endif
>  
>  typedef struct histent
> @@ -201,9 +201,9 @@
>  		fiemap->fm_length = length;
>  		fiemap->fm_extent_count = NR_EXTENTS;
>  
> -		ret = ioctl(file->fd, XFS_IOC_FIEMAPFS, (unsigned long)fiemap);
> +		ret = xfsctl(file->name,file->fd, XFS_IOC_FIEMAPFS, (unsigned long)fiemap);
>  		if (ret < 0) {	
> -			fprintf(stderr, "%s: ioctl(FS_IOC_FIEMAPFS) [\"%s\"]: "	
> +			fprintf(stderr, "%s: xfsctl(XFS_IOC_FIEMAPFS) [\"%s\"]: "	
>  				"%s\n", progname, file->name, strerror(errno));

Also, whitespace damage. There's already some in that patch hunk, so
you may as well fix it while you are changing that code.

>  			free(fiemap);
>  			exitcode = 1;
> @@ -338,6 +338,10 @@
>  
>  	if (!init(argc, argv))
>  		return 0;
> +
> +	if (dumpflag)
> +		printf("%8s %8s %8s\n", "agno", "agbno", "len");	

Added functionality? That should be in a separate patch ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
