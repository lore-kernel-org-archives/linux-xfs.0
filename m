Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE1327F6F
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 12:13:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CF22AC005
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:13:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DYGop9yleNVXPicr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 10:13:18 -0800 (PST)
Date: Tue, 6 Jan 2015 13:13:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v7 10/11] xfstests: fsstress: Add fallocate insert range
	operation
Message-ID: <20150106181309.GH5874@bfoster.bfoster>
References: <004801d02670$79bd5bf0$6d3813d0$@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <004801d02670$79bd5bf0$6d3813d0$@samsung.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Jan 02, 2015 at 06:42:51PM +0900, Namjae Jeon wrote:
> This commit adds insert operation support for fsstress, which is
> meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---

It might be nice to avoid setting FALLOC_FL_KEEP_SIZE for insert and
collapse ops alike (see the only use of KEEP_SIZE in fsstress.c) to
increase the likelihood of valid fallocate() calls. We currently set it
randomly, but unconditionally across all fallocate ops.

That could be done in a separate patch, however, and this looks good to
me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  ltp/fsstress.c | 19 ++++++++++++++++---
>  src/global.h   |  4 ++++
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index b56fe5c..aa3e0c3 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -72,6 +72,7 @@ typedef enum {
>  	OP_PUNCH,
>  	OP_ZERO,
>  	OP_COLLAPSE,
> +	OP_INSERT,
>  	OP_READ,
>  	OP_READLINK,
>  	OP_RENAME,
> @@ -170,6 +171,7 @@ void	mknod_f(int, long);
>  void	punch_f(int, long);
>  void	zero_f(int, long);
>  void	collapse_f(int, long);
> +void	insert_f(int, long);
>  void	read_f(int, long);
>  void	readlink_f(int, long);
>  void	rename_f(int, long);
> @@ -209,6 +211,7 @@ opdesc_t	ops[] = {
>  	{ OP_PUNCH, "punch", punch_f, 1, 1 },
>  	{ OP_ZERO, "zero", zero_f, 1, 1 },
>  	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
> +	{ OP_INSERT, "insert", insert_f, 1, 1 },
>  	{ OP_READ, "read", read_f, 1, 0 },
>  	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
>  	{ OP_RENAME, "rename", rename_f, 2, 1 },
> @@ -2176,6 +2179,7 @@ struct print_flags falloc_flags [] = {
>  	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
>  	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
>  	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
> +	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
>  	{ -1, NULL}
>  };
>  
> @@ -2227,10 +2231,11 @@ do_fallocate(int opno, long r, int mode)
>  	off %= maxfsize;
>  	len = (off64_t)(random() % (1024 * 1024));
>  	/*
> -	 * Collapse range requires off and len to be block aligned, make it
> -	 * more likely to be the case.
> +	 * Collapse/insert range requires off and len to be block aligned,
> +	 * make it more likely to be the case.
>  	 */
> -	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {
> +	if ((mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) &&
> +		(opno % 2)) {
>  		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
>  		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
>  	}
> @@ -2656,6 +2661,14 @@ collapse_f(int opno, long r)
>  }
>  
>  void
> +insert_f(int opno, long r)
> +{
> +#ifdef HAVE_LINUX_FALLOC_H
> +	do_fallocate(opno, r, FALLOC_FL_INSERT_RANGE);
> +#endif
> +}
> +
> +void
>  read_f(int opno, long r)
>  {
>  	char		*buf;
> diff --git a/src/global.h b/src/global.h
> index 8180f66..f63246b 100644
> --- a/src/global.h
> +++ b/src/global.h
> @@ -172,6 +172,10 @@
>  #define FALLOC_FL_ZERO_RANGE		0x10
>  #endif
>  
> +#ifndef FALLOC_FL_INSERT_RANGE
> +#define FALLOC_FL_INSERT_RANGE		0x20
> +#endif
> +
>  #endif /* HAVE_LINUX_FALLOC_H */
>  
>  #endif /* GLOBAL_H */
> -- 
> 1.7.11-rc0
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
