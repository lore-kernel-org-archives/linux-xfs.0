Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 23:37:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4V6bgWt002729
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 23:37:43 -0700
Date: Thu, 31 May 2007 16:37:34 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode
Message-ID: <20070531063734.GJ85884050@sgi.com>
References: <20070530125954.706423971@suse.cz> <20070530143044.060544510@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530143044.060544510@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Marek <mmarek@suse.cz>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 02:59:57PM +0200, Michal Marek wrote:
> * 32bit struct xfs_fsop_bulkreq has different size and layout of
>   members, no matter the alignment. Move the code out of the #else
>   branch (why was it there in the first place?). Define _32 variants of
>   the ioctl constants.
> * 32bit struct xfs_bstat is different on 32bit (because of time_t and on
>   i386 becaus of different padding). Create a new function
>   xfs_ioctl32_bulkstat_wrap(), which allocates extra ->ubuffer and
>   converts the elements to the 32bit format after the original ioctl
>   returns. Same for i386 struct xfs_inogrp.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  fs/xfs/linux-2.6/xfs_ioctl32.c |  262 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 238 insertions(+), 24 deletions(-)
> 
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> @@ -109,35 +109,249 @@ STATIC unsigned long xfs_ioctl32_geom_v1
>  	return (unsigned long)p;
>  }
>  
> -#else
> +typedef struct xfs_inogrp32 {
> +	__u64		xi_startino;	/* starting inode number	*/
> +	__s32		xi_alloccount;	/* # bits set in allocmask	*/
> +	__u64		xi_allocmask;	/* mask of allocated inodes	*/
> +} __attribute__((packed)) xfs_inogrp32_t;

xfs_inogrp_32
xfs_inogrp_32_t

> +STATIC int xfs_inogrp_store_compat(
> +	xfs_inogrp32_t __user  *p32,
> +	xfs_inogrp_t __user *p)
> +{
> +#define copy(memb) copy_in_user(&p32->memb, &p->memb, sizeof(p32->memb))
> +	if (copy(xi_startino) ||
> +	    copy(xi_alloccount) ||
> +	    copy(xi_allocmask))

No need for the #define here....

> +		return -EFAULT;
> +	return 0;
> +#undef copy
> +}
> +
> +#endif
> +
> +/* XFS_IOC_FSBULKSTAT and friends */
> +
> +typedef struct xfs_bstime32 {
> +	__s32		tv_sec;		/* seconds		*/
> +	__s32		tv_nsec;	/* and nanoseconds	*/
> +} xfs_bstime32_t;

*_32

> +static int xfs_bstime_store_compat(
> +	xfs_bstime32_t __user *p32,
> +	xfs_bstime_t __user *p)
> +{
> +	time_t sec;
> +	__s32 sec32;
> +
> +	if (get_user(sec, &p->tv_sec))
> +		return -EFAULT;
> +	sec32 = sec;
> +	if (put_user(sec32, &p32->tv_sec) ||
> +	    copy_in_user(&p32->tv_nsec, &p->tv_nsec, sizeof(__s32)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +typedef struct xfs_bstat32 {
> +	__u64		bs_ino;		/* inode number			*/
> +	__u16		bs_mode;	/* type and mode		*/
> +	__u16		bs_nlink;	/* number of links		*/
> +	__u32		bs_uid;		/* user id			*/
> +	__u32		bs_gid;		/* group id			*/
> +	__u32		bs_rdev;	/* device value			*/
> +	__s32		bs_blksize;	/* block size			*/
> +	__s64		bs_size;	/* file size			*/
> +	xfs_bstime32_t	bs_atime;	/* access time			*/
> +	xfs_bstime32_t	bs_mtime;	/* modify time			*/
> +	xfs_bstime32_t	bs_ctime;	/* inode change time		*/
> +	int64_t		bs_blocks;	/* number of blocks		*/
> +	__u32		bs_xflags;	/* extended flags		*/
> +	__s32		bs_extsize;	/* extent size			*/
> +	__s32		bs_extents;	/* number of extents		*/
> +	__u32		bs_gen;		/* generation count		*/
> +	__u16		bs_projid;	/* project id			*/
> +	unsigned char	bs_pad[14];	/* pad space, unused		*/
> +	__u32		bs_dmevmask;	/* DMIG event mask		*/
> +	__u16		bs_dmstate;	/* DMIG state info		*/
> +	__u16		bs_aextents;	/* attribute number of extents	*/
> +}
> +#ifdef BROKEN_X86_ALIGNMENT
> +	__attribute__((packed))
> +#endif
> +	xfs_bstat32_t;

#ifdef BROKEN_X86_ALIGNMENT
#define _PACKED	__attribute__((packed))
#else
#define _PACKED
#endif

typedef struct xfs_bstat_32 {
	......
} _PACKED xfs_bstat32_t

> +
> +static int xfs_bstat_store_compat(
> +	xfs_bstat32_t __user *p32,
> +	xfs_bstat_t __user *p)
> +{
> +#define copy(memb) copy_in_user(&p32->memb, &p->memb, sizeof(p32->memb))

Hmmm - now I see why you used this.

These copies are used everywhere in this file, maybe it would be best
to define a copy_from_32() and a copy_to_32() macros and use them
everywhere in the file?

> +	if (copy(bs_ino) ||
> +	    copy(bs_mode) ||
> +	    copy(bs_nlink) ||
> +	    copy(bs_uid) ||
> +	    copy(bs_gid) ||
> +	    copy(bs_rdev) ||
> +	    copy(bs_blksize) ||
> +	    copy(bs_size) ||
> +	    xfs_bstime_store_compat(&p32->bs_atime, &p->bs_atime) ||
> +	    xfs_bstime_store_compat(&p32->bs_mtime, &p->bs_mtime) ||
> +	    xfs_bstime_store_compat(&p32->bs_ctime, &p->bs_ctime) ||
> +	    copy(bs_blocks) ||
> +	    copy(bs_xflags) ||
> +	    copy(bs_extsize) ||
> +	    copy(bs_extents) ||
> +	    copy(bs_gen) ||
> +	    copy(bs_projid) ||
> +	    copy(bs_pad[14]) ||
> +	    copy(bs_dmevmask) ||
> +	    copy(bs_dmstate) ||
> +	    copy(bs_aextents))
> +		return -EFAULT;
> +	return 0;
> +#undef copy
> +}
>  
>  typedef struct xfs_fsop_bulkreq32 {
>  	compat_uptr_t	lastip;		/* last inode # pointer		*/
>  	__s32		icount;		/* count of entries in buffer	*/
>  	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
> -	__s32		ocount;		/* output count pointer		*/
> +	compat_uptr_t	ocount;		/* output count pointer		*/
>  } xfs_fsop_bulkreq32_t;
> -
> -STATIC unsigned long
> -xfs_ioctl32_bulkstat(
> -	unsigned long		arg)
> +#define XFS_IOC_FSBULKSTAT_32	     _IOWR('X', 101, struct xfs_fsop_bulkreq32)
> +#define XFS_IOC_FSBULKSTAT_SINGLE_32 _IOWR('X', 102, struct xfs_fsop_bulkreq32)
> +#define XFS_IOC_FSINUMBERS_32	     _IOWR('X', 103, struct xfs_fsop_bulkreq32)
> +
> +#define MAX_BSTAT_LEN \
> +	((__s32)((64*1024 - sizeof(xfs_fsop_bulkreq_t)) / sizeof(xfs_bstat_t)))
> +#define MAX_INOGRP_LEN \
> +	((__s32)((64*1024 - sizeof(xfs_fsop_bulkreq_t)) / sizeof(xfs_inogrp_t)))

Oooo magic numbers. Why were these chosen?

> +
> +STATIC int
> +xfs_ioctl32_bulkstat_wrap(
> +	bhv_vnode_t	*vp,
> +	struct inode    *inode,
> +	struct file     *file,
> +	int             mode,
> +	unsigned        cmd,
> +	unsigned long   arg)
>  {
> -	xfs_fsop_bulkreq32_t	__user *p32 = (void __user *)arg;
> -	xfs_fsop_bulkreq_t	__user *p = compat_alloc_user_space(sizeof(*p));
> -	u32			addr;
> -
> -	if (get_user(addr, &p32->lastip) ||
> -	    put_user(compat_ptr(addr), &p->lastip) ||
> -	    copy_in_user(&p->icount, &p32->icount, sizeof(s32)) ||
> -	    get_user(addr, &p32->ubuffer) ||
> -	    put_user(compat_ptr(addr), &p->ubuffer) ||
> -	    get_user(addr, &p32->ocount) ||
> -	    put_user(compat_ptr(addr), &p->ocount))
> +	xfs_fsop_bulkreq32_t __user *p32 = (void __user *)arg;
> +	xfs_fsop_bulkreq_t tmp;
> +	u32 addr;
> +	void *buf32;
> +	int err;
> +
> +	if (get_user(addr, &p32->lastip))
> +		return 0;

return -EFAULT?

> +	tmp.lastip = compat_ptr(addr);
> +	if (get_user(tmp.icount, &p32->icount) ||
> +	    get_user(addr, &p32->ubuffer))
>  		return -EFAULT;
> +	buf32 = compat_ptr(addr);
> +	if (get_user(addr, &p32->ocount))
> +		return -EFAULT;
> +	tmp.ocount = compat_ptr(addr);
>  
> -	return (unsigned long)p;
> -}
> +	if (tmp.icount <= 0)
> +		return -EINVAL;
> +
> +	if (cmd == XFS_IOC_FSBULKSTAT_32)
> +		cmd = XFS_IOC_FSBULKSTAT;
> +	if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32)
> +		cmd = XFS_IOC_FSBULKSTAT_SINGLE;
> +	if (cmd == XFS_IOC_FSINUMBERS_32)
> +		cmd = XFS_IOC_FSINUMBERS;

	cmd = _NATIVE_IOC(cmd, struct xfs_fsop_bulkreq);
	switch (cmd) {
	case XFS_IOC_FSBULKSTAT:
	case XFS_IOC_FSBULKSTAT_SINGLE:
> +
> +	if (cmd == XFS_IOC_FSBULKSTAT || cmd == XFS_IOC_FSBULKSTAT_SINGLE) {

Oh, now it gets messy :(

So, we do a whole lot of repacking of the bulkstat structures
once we've got the data out of the bulkstat call.

I think this is really the wrong way of doing this - the bulkstat
functions themselves take a "formatter" argument that is used to pack
the buffer in a given format. I think that we need to be supplying
the bulkstat code with different formatters in this case, not
repacking the buffer into a different format at a later time.

The formatter used by default is xfs_bulkstat_one() which 
falls down to xfs_bulkstat_one_dinode() or xfs_bulkstat_one_iget()
depending on whether we are doing icache coherent or blockdev
cache coherent lookups. It is these functions that need to be
told what format they are packing, I think, and xfs_bulkstat_single()
needs to be taught about them....

> +	if (cmd == XFS_IOC_FSINUMBERS) {

And I'm wondering if we should be doing the same thing here
(i.e. customer formatters), because this is equally ugly...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
