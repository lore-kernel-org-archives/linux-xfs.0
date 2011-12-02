Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2NSHbd109604 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 17:28:18 -0600
Date: Fri, 2 Dec 2011 15:28:16 -0800
From: Phil White <pwhite@sgi.com>
Subject: Re: [4/8] xfstests: add fallocate support to fsstress
Message-ID: <20111202232816.GC28903@caliban.corp.sgi.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com

On Sat, Oct 29, 2011 at 12:48:13AM -0000, Dmitry Monakhov wrote:
> Add tests for fallocate(2) syscall
> - fallocate: reserve the disk space
> - punch: de-allocates the disk space
> Since FALLOC_FL_PUNCH_HOLE is relatively new it's value defined
> explicitly if not yet defined. Later we may clear that define.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> ---
> ltp/fsstress.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 126 insertions(+), 1 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 133a247..547bf30 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -24,7 +24,13 @@
>  #ifdef HAVE_ATTR_ATTRIBUTES_H
>  #include <attr/attributes.h>
>  #endif
> -
> +#ifdef FALLOCATE
> +#include <linux/falloc.h>
> +#ifndef FALLOC_FL_PUNCH_HOLE
> +/* Copy-paste from linux/falloc.h */
> +#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> +#endif
> +#endif
>  #ifndef HAVE_ATTR_LIST
>  #define attr_list(path, buf, size, flags, cursor) (errno = -ENOSYS, -1)
>  #endif
> @@ -48,6 +54,7 @@ typedef enum {
>  	OP_CREAT,
>  	OP_DREAD,
>  	OP_DWRITE,
> +	OP_FALLOCATE,
>  	OP_FDATASYNC,
>  	OP_FREESP,
>  	OP_FSYNC,
> @@ -55,6 +62,7 @@ typedef enum {
>  	OP_LINK,
>  	OP_MKDIR,
>  	OP_MKNOD,
> +	OP_PUNCH,
>  	OP_READ,
>  	OP_READLINK,
>  	OP_RENAME,
> @@ -128,6 +136,7 @@ void	chown_f(int, long);
>  void	creat_f(int, long);
>  void	dread_f(int, long);
>  void	dwrite_f(int, long);
> +void	fallocate_f(int, long);
>  void	fdatasync_f(int, long);
>  void	freesp_f(int, long);
>  void	fsync_f(int, long);
> @@ -135,6 +144,7 @@ void	getdents_f(int, long);
>  void	link_f(int, long);
>  void	mkdir_f(int, long);
>  void	mknod_f(int, long);
> +void	punch_f(int, long);
>  void	read_f(int, long);
>  void	readlink_f(int, long);
>  void	rename_f(int, long);
> @@ -159,6 +169,7 @@ opdesc_t	ops[] = {
>  	{ OP_CREAT, "creat", creat_f, 4, 1 },
>  	{ OP_DREAD, "dread", dread_f, 4, 0 },
>  	{ OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
> +	{ OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
>  	{ OP_FDATASYNC, "fdatasync", fdatasync_f, 1, 1 },
>  	{ OP_FREESP, "freesp", freesp_f, 1, 1 },
>  	{ OP_FSYNC, "fsync", fsync_f, 1, 1 },
> @@ -166,6 +177,7 @@ opdesc_t	ops[] = {
>  	{ OP_LINK, "link", link_f, 1, 1 },
>  	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
>  	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
> +	{ OP_PUNCH, "punch", punch_f, 1, 1 },
>  	{ OP_READ, "read", read_f, 1, 0 },
>  	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
>  	{ OP_RENAME, "rename", rename_f, 2, 1 },
> @@ -1998,6 +2010,63 @@ dwrite_f(int opno, long r)
>  }
>  
>  void
> +fallocate_f(int opno, long r)
> +{
> +#ifdef FALLOCATE
> +	int		e;
> +	pathname_t	f;
> +	int		fd;
> +	__int64_t	lr;
> +	off64_t		off;
> +	off64_t		len;
> +	struct stat64	stb;
> +	int		v;
> +	char		st[1024];
> +	int mode = 0;
> +
> +	init_pathname(&f);
> +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +		if (v)
> +			printf("%d/%d: fallocate - no filename\n", procid, opno);
> +		free_pathname(&f);
> +		return;
> +	}
> +	fd = open_path(&f, O_RDWR);
> +	e = fd < 0 ? errno : 0;
> +	check_cwd();
> +	if (fd < 0) {
> +		if (v)
> +			printf("%d/%d: fallocate - open %s failed %d\n",
> +				procid, opno, f.path, e);
> +		free_pathname(&f);
> +		return;
> +	}
> +	if (fstat64(fd, &stb) < 0) {
> +		if (v)
> +			printf("%d/%d: fallocate - fstat64 %s failed %d\n",
> +				procid, opno, f.path, errno);
> +		free_pathname(&f);
> +		close(fd);
> +		return;
> +	}
> +	inode_info(st, sizeof(st), &stb, v);
> +	lr = ((__int64_t)random() << 32) + random();
> +	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
> +	off %= maxfsize;
> +	len = (off64_t)(random() % (1024 * 1024));
> +	mode |= FALLOC_FL_KEEP_SIZE & random();
> +	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
> +	if (v)
> +		printf("%d/%d: fallocate(%d) %s %st %lld %lld %d\n",
> +		       procid, opno, mode,
> +		       f.path, st, (long long)off, (long long)len, e);
> +	free_pathname(&f);
> +	close(fd);
> +#endif
> +}
> +
> +
> +void
>  fdatasync_f(int opno, long r)
>  {
>  	int		e;
> @@ -2270,6 +2339,62 @@ mknod_f(int opno, long r)
>  }
>  
>  void
> +punch_f(int opno, long r)
> +{
> +#ifdef FALLOCATE
> +	int		e;
> +	pathname_t	f;
> +	int		fd;
> +	__int64_t	lr;
> +	off64_t		off;
> +	off64_t		len;
> +	struct stat64	stb;
> +	int		v;
> +	char		st[1024];
> +	int mode = FALLOC_FL_PUNCH_HOLE;
> +
> +	init_pathname(&f);
> +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +		if (v)
> +			printf("%d/%d: punch hole - no filename\n", procid, opno);
> +		free_pathname(&f);
> +		return;
> +	}
> +	fd = open_path(&f, O_RDWR);
> +	e = fd < 0 ? errno : 0;
> +	check_cwd();
> +	if (fd < 0) {
> +		if (v)
> +			printf("%d/%d: punch hole - open %s failed %d\n",
> +				procid, opno, f.path, e);
> +		free_pathname(&f);
> +		return;
> +	}
> +	if (fstat64(fd, &stb) < 0) {
> +		if (v)
> +			printf("%d/%d: punch hole - fstat64 %s failed %d\n",
> +				procid, opno, f.path, errno);
> +		free_pathname(&f);
> +		close(fd);
> +		return;
> +	}
> +	inode_info(st, sizeof(st), &stb, v);
> +	lr = ((__int64_t)random() << 32) + random();
> +	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
> +	off %= maxfsize;
> +	len = (off64_t)(random() % (1024 * 1024));
> +	mode |= FALLOC_FL_KEEP_SIZE & random();
> +	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
> +	if (v)
> +		printf("%d/%d: punch hole(%d) %s %s %lld %lld %d\n",
> +		       procid, opno, mode,
> +		       f.path, st, (long long)off, (long long)len, e);
> +	free_pathname(&f);
> +	close(fd);
> +#endif
> +}
> +
> +void
>  read_f(int opno, long r)
>  {
>  	char		*buf;

Looks good to me.

Reviewed-By: Phil White <pwhite@sgi.com>
Tested-By: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
