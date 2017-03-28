Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754641AbdC1JJG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 05:09:06 -0400
Date: Tue, 28 Mar 2017 17:08:53 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v9 1/2] fsstress: add mwrite/mread into test operation
 list
Message-ID: <20170328090853.GV21915@dhcp12-143.nay.redhat.com>
References: <1490690795-4527-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490690795-4527-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 28, 2017 at 04:46:34PM +0800, Zorro Lang wrote:
> mmap as a popular and basic operation, most of softwares use it to
> access files. More and more customers report bugs related with
> mmap/munmap and other stress conditions.
> 
> So add mmap read/write test into fsstress to increase mmap related
> stress to reproduce or find more bugs easily.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

Hi,

Sorry I forgot to write changelog.

Thanks Eryu found a problem by run g/270 and give me more suggestions.
When filesystem is filled, mwrite a hole of sparse file will hit
ENOSPC, and will trigger SIGBUS which will kill running process and
core dump.

So V9 add SIGBUS handler. Use sigsetjmp() before mwrite a mapped
memory, and siglongjmp() back to sigsetjmp() place from signal
handler. If siglongjmp() from a non-zero, print "Bus error".

To stop SIGBUS from other functions cause a endless loop (trigger
SIGBUS over and over ...), abort() the process if an unknown
SIGBUS is triggered.

generic/270 and xfs/068 test passed by merge this V9 patchset.

Thanks,
Zorro


>  configure.ac   |   1 +
>  ltp/fsstress.c | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  src/global.h   |   4 ++
>  3 files changed, 162 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index fa48d2f..246f92e 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -32,6 +32,7 @@ AC_HEADER_STDC
>  			xfs/platform_defs.h	\
>  			btrfs/ioctl.h		\
>  			cifs/ioctl.h		\
> +			sys/mman.h		\
>      ])
>  
>  AC_CHECK_HEADERS([xfs/xfs_log_format.h],,,[
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 7e7cf60..6d8f117 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <linux/fs.h>
> +#include <setjmp.h>
>  #include "global.h"
>  
>  #ifdef HAVE_ATTR_XATTR_H
> @@ -69,6 +70,8 @@ typedef enum {
>  	OP_LINK,
>  	OP_MKDIR,
>  	OP_MKNOD,
> +	OP_MREAD,
> +	OP_MWRITE,
>  	OP_PUNCH,
>  	OP_ZERO,
>  	OP_COLLAPSE,
> @@ -168,6 +171,8 @@ void	getdents_f(int, long);
>  void	link_f(int, long);
>  void	mkdir_f(int, long);
>  void	mknod_f(int, long);
> +void	mread_f(int, long);
> +void	mwrite_f(int, long);
>  void	punch_f(int, long);
>  void	zero_f(int, long);
>  void	collapse_f(int, long);
> @@ -208,6 +213,8 @@ opdesc_t	ops[] = {
>  	{ OP_LINK, "link", link_f, 1, 1 },
>  	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
>  	{ OP_MKNOD, "mknod", mknod_f, 2, 1 },
> +	{ OP_MREAD, "mread", mread_f, 2, 0 },
> +	{ OP_MWRITE, "mwrite", mwrite_f, 2, 1 },
>  	{ OP_PUNCH, "punch", punch_f, 1, 1 },
>  	{ OP_ZERO, "zero", zero_f, 1, 1 },
>  	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
> @@ -262,6 +269,7 @@ int		cleanup = 0;
>  int		verbose = 0;
>  int		verifiable_log = 0;
>  sig_atomic_t	should_stop = 0;
> +sigjmp_buf	*sigbus_jmp = NULL;
>  char		*execute_cmd = NULL;
>  int		execute_freq = 1;
>  struct print_string	flag_str = {0};
> @@ -311,7 +319,26 @@ void	zero_freq(void);
>  
>  void sg_handler(int signum)
>  {
> -	should_stop = 1;
> +	switch (signum) {
> +	case SIGTERM:
> +		should_stop = 1;
> +		break;
> +	case SIGBUS:
> +		/*
> +		 * Only handle SIGBUS when mmap write to a hole and no
> +		 * block can be allocated due to ENOSPC, abort otherwise.
> +		 */
> +		if (sigbus_jmp) {
> +			siglongjmp(*sigbus_jmp, -1);
> +		} else {
> +			printf("Unknown SIGBUS is caught, Abort!\n");
> +			abort();
> +		}
> +		/* should not reach here */
> +		break;
> +	default:
> +		break;
> +	}
>  }
>  
>  int main(int argc, char **argv)
> @@ -527,10 +554,13 @@ int main(int argc, char **argv)
>  
>  	for (i = 0; i < nproc; i++) {
>  		if (fork() == 0) {
> -			action.sa_handler = SIG_DFL;
>  			sigemptyset(&action.sa_mask);
> +			action.sa_handler = SIG_DFL;
>  			if (sigaction(SIGTERM, &action, 0))
>  				return 1;
> +			action.sa_handler = sg_handler;
> +			if (sigaction(SIGBUS, &action, 0))
> +				return 1;
>  #ifdef HAVE_SYS_PRCTL_H
>  			prctl(PR_SET_PDEATHSIG, SIGKILL);
>  			if (getppid() == 1) /* parent died already? */
> @@ -2655,6 +2685,131 @@ mknod_f(int opno, long r)
>  	free_pathname(&f);
>  }
>  
> +#ifdef HAVE_SYS_MMAN_H
> +struct print_flags mmap_flags[] = {
> +	{ MAP_SHARED, "SHARED"},
> +	{ MAP_PRIVATE, "PRIVATE"},
> +	{ -1, NULL}
> +};
> +
> +#define translate_mmap_flags(flags)	  \
> +	({translate_flags(flags, "|", mmap_flags);})
> +#endif
> +
> +void
> +do_mmap(int opno, long r, int prot)
> +{
> +#ifdef HAVE_SYS_MMAN_H
> +	char		*addr;
> +	int		e;
> +	pathname_t	f;
> +	int		fd;
> +	size_t		len;
> +	__int64_t	lr;
> +	off64_t		off;
> +	int		flags;
> +	struct stat64	stb;
> +	int		v;
> +	char		st[1024];
> +	sigjmp_buf	sigbus_jmpbuf;
> +
> +	init_pathname(&f);
> +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +		if (v)
> +			printf("%d/%d: do_mmap - no filename\n", procid, opno);
> +		free_pathname(&f);
> +		return;
> +	}
> +	fd = open_path(&f, O_RDWR);
> +	e = fd < 0 ? errno : 0;
> +	check_cwd();
> +	if (fd < 0) {
> +		if (v)
> +			printf("%d/%d: do_mmap - open %s failed %d\n",
> +			       procid, opno, f.path, e);
> +		free_pathname(&f);
> +		return;
> +	}
> +	if (fstat64(fd, &stb) < 0) {
> +		if (v)
> +			printf("%d/%d: do_mmap - fstat64 %s failed %d\n",
> +			       procid, opno, f.path, errno);
> +		free_pathname(&f);
> +		close(fd);
> +		return;
> +	}
> +	inode_info(st, sizeof(st), &stb, v);
> +	if (stb.st_size == 0) {
> +		if (v)
> +			printf("%d/%d: do_mmap - %s%s zero size\n", procid, opno,
> +			       f.path, st);
> +		free_pathname(&f);
> +		close(fd);
> +		return;
> +	}
> +
> +	lr = ((__int64_t)random() << 32) + random();
> +	off = (off64_t)(lr % stb.st_size);
> +	off &= (off64_t)(~(sysconf(_SC_PAGE_SIZE) - 1));
> +	len = (size_t)(random() % MIN(stb.st_size - off, FILELEN_MAX)) + 1;
> +
> +	flags = (random() % 2) ? MAP_SHARED : MAP_PRIVATE;
> +	addr = mmap(NULL, len, prot, flags, fd, off);
> +	e = (addr == MAP_FAILED) ? errno : 0;
> +	if (e) {
> +		if (v)
> +			printf("%d/%d: do_mmap - mmap failed %s%s [%lld,%d,%s] %d\n",
> +			       procid, opno, f.path, st, (long long)off,
> +			       (int)len, translate_mmap_flags(flags), e);
> +		free_pathname(&f);
> +		close(fd);
> +		return;
> +	}
> +
> +	if (prot & PROT_WRITE) {
> +		if ((e = sigsetjmp(sigbus_jmpbuf, 1)) == 0) {
> +			sigbus_jmp = &sigbus_jmpbuf;
> +			memset(addr, nameseq & 0xff, len);
> +		}
> +	} else {
> +		char *buf;
> +		if ((buf = malloc(len)) != NULL) {
> +			memcpy(buf, addr, len);
> +			free(buf);
> +		}
> +	}
> +	munmap(addr, len);
> +	/* set NULL to stop other functions from doing siglongjmp */
> +	sigbus_jmp = NULL;
> +
> +	if (v)
> +		printf("%d/%d: %s %s%s [%lld,%d,%s] %s\n",
> +		       procid, opno, (prot & PROT_WRITE) ? "mwrite" : "mread",
> +		       f.path, st, (long long)off, (int)len,
> +		       translate_mmap_flags(flags),
> +		       (e == 0) ? "0" : "Bus error");
> +
> +	free_pathname(&f);
> +	close(fd);
> +#endif
> +}
> +
> +void
> +mread_f(int opno, long r)
> +{
> +#ifdef HAVE_SYS_MMAN_H
> +	do_mmap(opno, r, PROT_READ);
> +#endif
> +}
> +
> +void
> +mwrite_f(int opno, long r)
> +{
> +#ifdef HAVE_SYS_MMAN_H
> +	do_mmap(opno, r, PROT_WRITE);
> +#endif
> +}
> +
>  void
>  punch_f(int opno, long r)
>  {
> diff --git a/src/global.h b/src/global.h
> index f63246b..3920c0d 100644
> --- a/src/global.h
> +++ b/src/global.h
> @@ -178,4 +178,8 @@
>  
>  #endif /* HAVE_LINUX_FALLOC_H */
>  
> +#ifdef HAVE_SYS_MMAN_H
> +#include <sys/mman.h>
> +#endif
> +
>  #endif /* GLOBAL_H */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
