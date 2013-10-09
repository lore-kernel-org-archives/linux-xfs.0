Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6BA17F4E
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 17:47:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5507DAC006
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:47:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BwXMivFDUtrqY5ED for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 15:47:03 -0700 (PDT)
Date: Thu, 10 Oct 2013 09:46:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 1/7] fs: add new flag(FALLOC_FL_COLLAPSE_RANGE)
	for fallocate
Message-ID: <20131009224658.GO4446@dastard>
References: <1381090366-2727-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381090366-2727-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Mon, Oct 07, 2013 at 05:12:46AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate.
> updated detailed semantics in comments.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/open.c                   |   24 +++++++++++++++++++++---
>  include/uapi/linux/falloc.h |   17 +++++++++++++++++
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 7931f76..85d243a 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -225,12 +225,14 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  {
>  	struct inode *inode = file_inode(file);
>  	long ret;
> +	unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
>  
>  	if (offset < 0 || len <= 0)
>  		return -EINVAL;
>  
>  	/* Return error if mode is not supported */
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> +		     FALLOC_FL_COLLAPSE_RANGE))
>  		return -EOPNOTSUPP;
>  
>  	/* Punch hole must have keep size set */
> @@ -241,8 +243,12 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (!(file->f_mode & FMODE_WRITE))
>  		return -EBADF;
>  
> -	/* It's not possible punch hole on append only file */
> -	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
> +	/*
> +	 * It's not possible to punch hole or perform collapse range
> +	 * on append only file
> +	 */
> +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
> +	    && IS_APPEND(inode))
>  		return -EPERM;
>  
>  	if (IS_IMMUTABLE(inode))
> @@ -270,6 +276,18 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
>  		return -EFBIG;
>  
> +	/*
> +	 * Collapse range works only on fs block size aligned offsets.
> +	 * Check if collapse range is contained within (aligned)i_size.
> +	 * Collapse range can only be used exclusively.
> +	 */
> +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> +	    (offset & blksize_mask || len & blksize_mask ||
> +	     mode & ~FALLOC_FL_COLLAPSE_RANGE ||
> +	     (offset + len >
> +	      round_up(i_size_read(inode), (blksize_mask + 1)))))
> +		return -EINVAL;

There's lots of individual checks here. Let's separate them out
logically. Firstly, "Collapse range can only be used exclusively" is
a mode parameter check, and so should be done directly after
validating the mode only contains known commands. i.e. in the first
hunk above.

Secondly, "Collapse range works only on fs block size aligned
offsets" is an implementation constraint, not an API constraint.
i.e. There is no reason why a filesystem can't implement byte range
granularity for this operation, it just may not be efficient for all
fielsystems and so they don't choose to implement byte range
granularity. Further, filesystems might have different allocation
constraints than the filesystem block size (think bigalloc on ext4,
per-file extent size hints for XFS), and these generally aren't
reflected in inode->i_blkbits. In these cases, the granularity of
the collapse operation can only be determined by the filesystem
itself, not this high level code.

Hence I think the granularity check should be put into a helper
function that the filesystem's ->fallocate() method calls if it can
only support fs block aligned operations. That allows each
filesystem to determine it's own constraints on a per-operation
basis.

All that remains here is the "within file size"
check, and that doesn't need to be rounded up to block size to check
if it is valid. If the range given overlaps the end of file in any
way, then it is a truncate operation....


> diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> index 990c4cc..9614b72 100644
> --- a/include/uapi/linux/falloc.h
> +++ b/include/uapi/linux/falloc.h
> @@ -4,6 +4,23 @@
>  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
>  #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
>  #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
> +/*
> + * FALLOC_FL_COLLAPSE_RANGE:
> + * This flag works in 2 steps.
> + * Firstly, it deallocates any data blocks present between [offset, offset+len)
> + * This step is same as punch hole and leaves a hole in the place from where
> + * the blocks are removed.
> + * Next, it eliminates the hole created by moving data blocks into it.
> + * For extent based file systems, we achieve this functionality simply by
> + * updating the starting logical offset of each extent which appears beyond
> + * the hole. As this flag works on blocks of filesystem, the offset and len
> + * provided to fallocate should be aligned with block size of filesystem.

Hmmm - you're describing an implementation, not the API. i.e. what
you need to describe is the functionality users are provided with by
the flag and it's usage constraints, not how filesystems need to
implement it. Something like:

"FALLOC_FL_COLLAPSE_RANGE is used to remove a range of a file
without leaving a hole in the file. The contents of the file beyond
the range being removed is appended to the start offset of the range
being removed (i.e. the hole that was punched is "collapsed"),
resulting in a file layout that looks like the range that was
removed never existed. As suchm collapsing a range of a file changes
the size of the file, reducing it by the same length of the range
that has been removed by the operation.

Different filesystems may implement different limitations on the
granularity of the operation. Most will limit operations to
filesystem block size boundaries, but this boundary may be larger or
smaller depending on the filesystem and/or the configuration of the
filesystem or file.

Attempting to collapse a range that crosses the end of the file is
considered an illegal operation - just use ftruncate(2) if you need
to collapse a range that crosses EOF."

> +#define FALLOC_FL_COLLAPSE_RANGE	0x08 /* it does not leave a hole */

With the large descriptive comment, there is no need for the
appended "/* it does not leave a hole */" comment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
