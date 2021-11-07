Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32424C4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Nov 2021 13:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 060E6613AC
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Nov 2021 13:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhKGNDB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Nov 2021 08:03:01 -0500
Received: from out20-25.mail.aliyun.com ([115.124.20.25]:53900 "EHLO
        out20-25.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbhKGNDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Nov 2021 08:03:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=0.07436282|-1;BR=01201311R121ee;CH=green;DM=|CONTINUE|false|;DS=SPAM|spam_blackmail|0.983527-0.00130665-0.0151667;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047213;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.LosVVvp_1636290014;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.LosVVvp_1636290014)
          by smtp.aliyun-inc.com(10.147.41.121);
          Sun, 07 Nov 2021 21:00:14 +0800
Date:   Sun, 7 Nov 2021 21:00:14 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] fsstress: run more than 2^32 operations
Message-ID: <YYfN3v+Ph/LGDNCi@desktop>
References: <20211102190819.GV24282@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102190819.GV24282@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 02, 2021 at 12:08:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that storage has gotten really really fast, we have to crank up
> TIME_FACTOR to amusingly huge values to do things such as 10-day soak
> testing.  "Un"fortunately, fsstress uses 'int' to count operations,
> which means we get close to maxing out the 2^31 limit on operations in
> fsstress.  Widen it to a long long value to take us to the heat death of
> the universe, like we did for fsx a while back. ;)
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the fix!

I saw this new warning, and changed '%d' to '%lld' as suggested by gcc

fsstress.c: In function 'subvol_delete_f':
fsstress.c:4970:16: warning: format '%d' expects argument of type 'int', but argument 3 has type 'opnum_t' {aka 'long long int'} [-Wformat=]
 4970 |    printf("%d:%d: subvol_delete - no subvolume\n", procid,
      |               ~^
      |                |
      |                int
      |               %lld
 4971 |           opno);
      |           ~~~~
      |           |
      |           opnum_t {aka long long int}

Thanks,
Eryu

> ---
>  ltp/fsstress.c |  673 ++++++++++++++++++++++++++++----------------------------
>  1 file changed, 340 insertions(+), 333 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 90ae432e..3d53e25f 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -147,7 +147,9 @@ typedef enum {
>  	OP_LAST
>  } opty_t;
>  
> -typedef void (*opfnc_t)(int, long);
> +typedef long long opnum_t;
> +
> +typedef void (*opfnc_t)(opnum_t, long);
>  
>  typedef struct opdesc {
>  	opty_t	op;
> @@ -213,67 +215,67 @@ struct print_string {
>  
>  #define XATTR_NAME_BUF_SIZE 18
>  
> -void	afsync_f(int, long);
> -void	allocsp_f(int, long);
> -void	aread_f(int, long);
> -void	attr_remove_f(int, long);
> -void	attr_set_f(int, long);
> -void	awrite_f(int, long);
> -void	bulkstat_f(int, long);
> -void	bulkstat1_f(int, long);
> -void	chown_f(int, long);
> -void	clonerange_f(int, long);
> -void	copyrange_f(int, long);
> -void	creat_f(int, long);
> -void	deduperange_f(int, long);
> -void	dread_f(int, long);
> -void	dwrite_f(int, long);
> -void	fallocate_f(int, long);
> -void	fdatasync_f(int, long);
> -void	fiemap_f(int, long);
> -void	freesp_f(int, long);
> -void	fsync_f(int, long);
> +void	afsync_f(opnum_t, long);
> +void	allocsp_f(opnum_t, long);
> +void	aread_f(opnum_t, long);
> +void	attr_remove_f(opnum_t, long);
> +void	attr_set_f(opnum_t, long);
> +void	awrite_f(opnum_t, long);
> +void	bulkstat_f(opnum_t, long);
> +void	bulkstat1_f(opnum_t, long);
> +void	chown_f(opnum_t, long);
> +void	clonerange_f(opnum_t, long);
> +void	copyrange_f(opnum_t, long);
> +void	creat_f(opnum_t, long);
> +void	deduperange_f(opnum_t, long);
> +void	dread_f(opnum_t, long);
> +void	dwrite_f(opnum_t, long);
> +void	fallocate_f(opnum_t, long);
> +void	fdatasync_f(opnum_t, long);
> +void	fiemap_f(opnum_t, long);
> +void	freesp_f(opnum_t, long);
> +void	fsync_f(opnum_t, long);
>  char	*gen_random_string(int);
> -void	getattr_f(int, long);
> -void	getdents_f(int, long);
> -void	getfattr_f(int, long);
> -void	link_f(int, long);
> -void	listfattr_f(int, long);
> -void	mkdir_f(int, long);
> -void	mknod_f(int, long);
> -void	mread_f(int, long);
> -void	mwrite_f(int, long);
> -void	punch_f(int, long);
> -void	zero_f(int, long);
> -void	collapse_f(int, long);
> -void	insert_f(int, long);
> -void	read_f(int, long);
> -void	readlink_f(int, long);
> -void	readv_f(int, long);
> -void	removefattr_f(int, long);
> -void	rename_f(int, long);
> -void	rnoreplace_f(int, long);
> -void	rexchange_f(int, long);
> -void	rwhiteout_f(int, long);
> -void	resvsp_f(int, long);
> -void	rmdir_f(int, long);
> -void	setattr_f(int, long);
> -void	setfattr_f(int, long);
> -void	setxattr_f(int, long);
> -void	snapshot_f(int, long);
> -void	splice_f(int, long);
> -void	stat_f(int, long);
> -void	subvol_create_f(int, long);
> -void	subvol_delete_f(int, long);
> -void	symlink_f(int, long);
> -void	sync_f(int, long);
> -void	truncate_f(int, long);
> -void	unlink_f(int, long);
> -void	unresvsp_f(int, long);
> -void	uring_read_f(int, long);
> -void	uring_write_f(int, long);
> -void	write_f(int, long);
> -void	writev_f(int, long);
> +void	getattr_f(opnum_t, long);
> +void	getdents_f(opnum_t, long);
> +void	getfattr_f(opnum_t, long);
> +void	link_f(opnum_t, long);
> +void	listfattr_f(opnum_t, long);
> +void	mkdir_f(opnum_t, long);
> +void	mknod_f(opnum_t, long);
> +void	mread_f(opnum_t, long);
> +void	mwrite_f(opnum_t, long);
> +void	punch_f(opnum_t, long);
> +void	zero_f(opnum_t, long);
> +void	collapse_f(opnum_t, long);
> +void	insert_f(opnum_t, long);
> +void	read_f(opnum_t, long);
> +void	readlink_f(opnum_t, long);
> +void	readv_f(opnum_t, long);
> +void	removefattr_f(opnum_t, long);
> +void	rename_f(opnum_t, long);
> +void	rnoreplace_f(opnum_t, long);
> +void	rexchange_f(opnum_t, long);
> +void	rwhiteout_f(opnum_t, long);
> +void	resvsp_f(opnum_t, long);
> +void	rmdir_f(opnum_t, long);
> +void	setattr_f(opnum_t, long);
> +void	setfattr_f(opnum_t, long);
> +void	setxattr_f(opnum_t, long);
> +void	snapshot_f(opnum_t, long);
> +void	splice_f(opnum_t, long);
> +void	stat_f(opnum_t, long);
> +void	subvol_create_f(opnum_t, long);
> +void	subvol_delete_f(opnum_t, long);
> +void	symlink_f(opnum_t, long);
> +void	sync_f(opnum_t, long);
> +void	truncate_f(opnum_t, long);
> +void	unlink_f(opnum_t, long);
> +void	unresvsp_f(opnum_t, long);
> +void	uring_read_f(opnum_t, long);
> +void	uring_write_f(opnum_t, long);
> +void	write_f(opnum_t, long);
> +void	writev_f(opnum_t, long);
>  char	*xattr_flag_to_string(int);
>  
>  opdesc_t	ops[] = {
> @@ -370,7 +372,7 @@ int		namerand;
>  int		nameseq;
>  int		nops;
>  int		nproc = 1;
> -int		operations = 1;
> +opnum_t		operations = 1;
>  unsigned int	idmodulo = XFS_IDMODULO_MAX;
>  unsigned int	attr_mask = ~0;
>  int		procid;
> @@ -525,7 +527,12 @@ int main(int argc, char **argv)
>  			loops = atoi(optarg);
>  			break;
>  		case 'n':
> -			operations = atoi(optarg);
> +			errno = 0;
> +			operations = strtoll(optarg, NULL, 0);
> +			if (errno) {
> +				perror(optarg);
> +				exit(1);
> +			}
>  			break;
>  		case 'o':
>  			logname = optarg;
> @@ -1105,10 +1112,10 @@ doproc(void)
>  	struct stat64	statbuf;
>  	char		buf[10];
>  	char		cmd[64];
> -	int		opno;
> +	opnum_t		opno;
>  	int		rval;
>  	opdesc_t	*p;
> -	int		dividend;
> +	long long	dividend;
>  
>  	dividend = (operations + execute_freq) / (execute_freq + 1);
>  	sprintf(buf, "p%x", procid);
> @@ -1130,7 +1137,7 @@ doproc(void)
>  	for (opno = 0; opno < operations; opno++) {
>  		if (execute_cmd && opno && opno % dividend == 0) {
>  			if (verbose)
> -				printf("%d: execute command %s\n", opno,
> +				printf("%lld: execute command %s\n", opno,
>  					execute_cmd);
>  			rval = system(execute_cmd);
>  			if (rval)
> @@ -1792,7 +1799,7 @@ show_ops(int flag, char *lead_str)
>  		/* Command line style */
>  		if (lead_str != NULL)
>  			printf("%s", lead_str);
> -		printf ("-z -s %ld -m %d -n %d -p %d \\\n", seed, idmodulo,
> +		printf ("-z -s %ld -m %d -n %lld -p %d \\\n", seed, idmodulo,
>  			operations, nproc);
>  	        for (p = ops; p < ops_end; p++)
>  		        if (p->freq > 0)
> @@ -1974,7 +1981,7 @@ void inode_info(char *str, size_t sz, struct stat64 *s, int verbose)
>  }
>  
>  void
> -afsync_f(int opno, long r)
> +afsync_f(opnum_t opno, long r)
>  {
>  #ifdef AIO
>  	int		e;
> @@ -1988,7 +1995,7 @@ afsync_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: afsync - no filename\n", procid, opno);
> +			printf("%d/%lld: afsync - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -1997,7 +2004,7 @@ afsync_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: afsync - open %s failed %d\n",
> +			printf("%d/%lld: afsync - open %s failed %d\n",
>  			       procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
> @@ -2006,7 +2013,7 @@ afsync_f(int opno, long r)
>  	io_prep_fsync(&iocb, fd);
>  	if ((e = io_submit(io_ctx, 1, iocbs)) != 1) {
>  		if (v)
> -			printf("%d/%d: afsync - io_submit %s %d\n",
> +			printf("%d/%lld: afsync - io_submit %s %d\n",
>  			       procid, opno, f.path, e);
>  		free_pathname(&f);
>  		close(fd);
> @@ -2014,7 +2021,7 @@ afsync_f(int opno, long r)
>  	}
>  	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
>  		if (v)
> -			printf("%d/%d: afsync - io_getevents failed %d\n",
> +			printf("%d/%lld: afsync - io_getevents failed %d\n",
>  			       procid, opno, e);
>  		free_pathname(&f);
>  		close(fd);
> @@ -2023,14 +2030,14 @@ afsync_f(int opno, long r)
>  
>  	e = event.res2;
>  	if (v)
> -		printf("%d/%d: afsync %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: afsync %s %d\n", procid, opno, f.path, e);
>  	free_pathname(&f);
>  	close(fd);
>  #endif
>  }
>  
>  void
> -allocsp_f(int opno, long r)
> +allocsp_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -2045,7 +2052,7 @@ allocsp_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: allocsp - no filename\n", procid, opno);
> +			printf("%d/%lld: allocsp - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -2054,14 +2061,14 @@ allocsp_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: allocsp - open %s failed %d\n",
> +			printf("%d/%lld: allocsp - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: allocsp - fstat64 %s failed %d\n",
> +			printf("%d/%lld: allocsp - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -2076,7 +2083,7 @@ allocsp_f(int opno, long r)
>  	fl.l_len = 0;
>  	e = xfsctl(f.path, fd, XFS_IOC_ALLOCSP64, &fl) < 0 ? errno : 0;
>  	if (v) {
> -		printf("%d/%d: xfsctl(XFS_IOC_ALLOCSP64) %s%s %lld 0 %d\n",
> +		printf("%d/%lld: xfsctl(XFS_IOC_ALLOCSP64) %s%s %lld 0 %d\n",
>  		       procid, opno, f.path, st, (long long)off, e);
>  	}
>  	free_pathname(&f);
> @@ -2085,7 +2092,7 @@ allocsp_f(int opno, long r)
>  
>  #ifdef AIO
>  void
> -do_aio_rw(int opno, long r, int flags)
> +do_aio_rw(opnum_t opno, long r, int flags)
>  {
>  	int64_t		align;
>  	char		*buf = NULL;
> @@ -2108,7 +2115,7 @@ do_aio_rw(int opno, long r, int flags)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: do_aio_rw - no filename\n", procid, opno);
> +			printf("%d/%lld: do_aio_rw - no filename\n", procid, opno);
>  		goto aio_out;
>  	}
>  	fd = open_path(&f, flags|O_DIRECT);
> @@ -2116,27 +2123,27 @@ do_aio_rw(int opno, long r, int flags)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: do_aio_rw - open %s failed %d\n",
> +			printf("%d/%lld: do_aio_rw - open %s failed %d\n",
>  			       procid, opno, f.path, e);
>  		goto aio_out;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: do_aio_rw - fstat64 %s failed %d\n",
> +			printf("%d/%lld: do_aio_rw - fstat64 %s failed %d\n",
>  			       procid, opno, f.path, errno);
>  		goto aio_out;
>  	}
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (!iswrite && stb.st_size == 0) {
>  		if (v)
> -			printf("%d/%d: do_aio_rw - %s%s zero size\n", procid, opno,
> +			printf("%d/%lld: do_aio_rw - %s%s zero size\n", procid, opno,
>  			       f.path, st);
>  		goto aio_out;
>  	}
>  	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
>  		if (v)
>  			printf(
> -			"%d/%d: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) %s%s return %d,"
> +			"%d/%lld: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) %s%s return %d,"
>  			" fallback to stat()\n",
>  				procid, opno, f.path, st, errno);
>  		diob.d_mem = diob.d_miniosz = stb.st_blksize;
> @@ -2156,7 +2163,7 @@ do_aio_rw(int opno, long r, int flags)
>  	buf = memalign(diob.d_mem, len);
>  	if (!buf) {
>  		if (v)
> -			printf("%d/%d: do_aio_rw - memalign failed\n",
> +			printf("%d/%lld: do_aio_rw - memalign failed\n",
>  			       procid, opno);
>  		goto aio_out;
>  	}
> @@ -2174,20 +2181,20 @@ do_aio_rw(int opno, long r, int flags)
>  	}
>  	if ((e = io_submit(io_ctx, 1, iocbs)) != 1) {
>  		if (v)
> -			printf("%d/%d: %s - io_submit failed %d\n",
> +			printf("%d/%lld: %s - io_submit failed %d\n",
>  			       procid, opno, iswrite ? "awrite" : "aread", e);
>  		goto aio_out;
>  	}
>  	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
>  		if (v)
> -			printf("%d/%d: %s - io_getevents failed %d\n",
> +			printf("%d/%lld: %s - io_getevents failed %d\n",
>  			       procid, opno, iswrite ? "awrite" : "aread", e);
>  		goto aio_out;
>  	}
>  
>  	e = event.res != len ? event.res2 : 0;
>  	if (v)
> -		printf("%d/%d: %s %s%s [%lld,%d] %d\n",
> +		printf("%d/%lld: %s %s%s [%lld,%d] %d\n",
>  		       procid, opno, iswrite ? "awrite" : "aread",
>  		       f.path, st, (long long)off, (int)len, e);
>   aio_out:
> @@ -2201,7 +2208,7 @@ do_aio_rw(int opno, long r, int flags)
>  
>  #ifdef URING
>  void
> -do_uring_rw(int opno, long r, int flags)
> +do_uring_rw(opnum_t opno, long r, int flags)
>  {
>  	char		*buf = NULL;
>  	int		e;
> @@ -2224,7 +2231,7 @@ do_uring_rw(int opno, long r, int flags)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: do_uring_rw - no filename\n", procid, opno);
> +			printf("%d/%lld: do_uring_rw - no filename\n", procid, opno);
>  		goto uring_out;
>  	}
>  	fd = open_path(&f, flags);
> @@ -2232,27 +2239,27 @@ do_uring_rw(int opno, long r, int flags)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: do_uring_rw - open %s failed %d\n",
> +			printf("%d/%lld: do_uring_rw - open %s failed %d\n",
>  			       procid, opno, f.path, e);
>  		goto uring_out;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: do_uring_rw - fstat64 %s failed %d\n",
> +			printf("%d/%lld: do_uring_rw - fstat64 %s failed %d\n",
>  			       procid, opno, f.path, errno);
>  		goto uring_out;
>  	}
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (!iswrite && stb.st_size == 0) {
>  		if (v)
> -			printf("%d/%d: do_uring_rw - %s%s zero size\n", procid, opno,
> +			printf("%d/%lld: do_uring_rw - %s%s zero size\n", procid, opno,
>  			       f.path, st);
>  		goto uring_out;
>  	}
>  	sqe = io_uring_get_sqe(&ring);
>  	if (!sqe) {
>  		if (v)
> -			printf("%d/%d: do_uring_rw - io_uring_get_sqe failed\n",
> +			printf("%d/%lld: do_uring_rw - io_uring_get_sqe failed\n",
>  			       procid, opno);
>  		goto uring_out;
>  	}
> @@ -2261,7 +2268,7 @@ do_uring_rw(int opno, long r, int flags)
>  	buf = malloc(len);
>  	if (!buf) {
>  		if (v)
> -			printf("%d/%d: do_uring_rw - malloc failed\n",
> +			printf("%d/%lld: do_uring_rw - malloc failed\n",
>  			       procid, opno);
>  		goto uring_out;
>  	}
> @@ -2279,18 +2286,18 @@ do_uring_rw(int opno, long r, int flags)
>  
>  	if ((e = io_uring_submit_and_wait(&ring, 1)) != 1) {
>  		if (v)
> -			printf("%d/%d: %s - io_uring_submit failed %d\n", procid, opno,
> +			printf("%d/%lld: %s - io_uring_submit failed %d\n", procid, opno,
>  			       iswrite ? "uring_write" : "uring_read", e);
>  		goto uring_out;
>  	}
>  	if ((e = io_uring_wait_cqe(&ring, &cqe)) < 0) {
>  		if (v)
> -			printf("%d/%d: %s - io_uring_wait_cqe failed %d\n", procid, opno,
> +			printf("%d/%lld: %s - io_uring_wait_cqe failed %d\n", procid, opno,
>  			       iswrite ? "uring_write" : "uring_read", e);
>  		goto uring_out;
>  	}
>  	if (v)
> -		printf("%d/%d: %s %s%s [%lld, %d(res=%d)] %d\n",
> +		printf("%d/%lld: %s %s%s [%lld, %d(res=%d)] %d\n",
>  		       procid, opno, iswrite ? "uring_write" : "uring_read",
>  		       f.path, st, (long long)off, (int)len, cqe->res, e);
>  	io_uring_cqe_seen(&ring, cqe);
> @@ -2305,7 +2312,7 @@ do_uring_rw(int opno, long r, int flags)
>  #endif
>  
>  void
> -aread_f(int opno, long r)
> +aread_f(opnum_t opno, long r)
>  {
>  #ifdef AIO
>  	do_aio_rw(opno, r, O_RDONLY);
> @@ -2313,7 +2320,7 @@ aread_f(int opno, long r)
>  }
>  
>  void
> -attr_remove_f(int opno, long r)
> +attr_remove_f(opnum_t opno, long r)
>  {
>  	char			*bufname;
>  	char			*bufend;
> @@ -2335,7 +2342,7 @@ attr_remove_f(int opno, long r)
>  		total = attr_list_count(buf, e);
>  	if (total == 0) {
>  		if (v)
> -			printf("%d/%d: attr_remove - no attrs for %s\n",
> +			printf("%d/%lld: attr_remove - no attrs for %s\n",
>  				procid, opno, f.path);
>  		free_pathname(&f);
>  		return;
> @@ -2356,7 +2363,7 @@ attr_remove_f(int opno, long r)
>  	if (aname == NULL) {
>  		if (v)
>  			printf(
> -			"%d/%d: attr_remove - name %d not found at %s\n",
> +			"%d/%lld: attr_remove - name %d not found at %s\n",
>  				procid, opno, which, f.path);
>  		free_pathname(&f);
>  		return;
> @@ -2367,13 +2374,13 @@ attr_remove_f(int opno, long r)
>  		e = 0;
>  	check_cwd();
>  	if (v)
> -		printf("%d/%d: attr_remove %s %s %d\n",
> +		printf("%d/%lld: attr_remove %s %s %d\n",
>  			procid, opno, f.path, aname, e);
>  	free_pathname(&f);
>  }
>  
>  void
> -attr_set_f(int opno, long r)
> +attr_set_f(opnum_t opno, long r)
>  {
>  	char		aname[10];
>  	char		*aval;
> @@ -2401,13 +2408,13 @@ attr_set_f(int opno, long r)
>  	check_cwd();
>  	free(aval);
>  	if (v)
> -		printf("%d/%d: attr_set %s %s %d\n", procid, opno, f.path,
> +		printf("%d/%lld: attr_set %s %s %d\n", procid, opno, f.path,
>  			aname, e);
>  	free_pathname(&f);
>  }
>  
>  void
> -awrite_f(int opno, long r)
> +awrite_f(opnum_t opno, long r)
>  {
>  #ifdef AIO
>  	do_aio_rw(opno, r, O_WRONLY);
> @@ -2415,7 +2422,7 @@ awrite_f(int opno, long r)
>  }
>  
>  void
> -bulkstat_f(int opno, long r)
> +bulkstat_f(opnum_t opno, long r)
>  {
>  	int		count;
>  	int		fd;
> @@ -2440,13 +2447,13 @@ bulkstat_f(int opno, long r)
>  		total += count;
>  	free(t);
>  	if (verbose)
> -		printf("%d/%d: bulkstat nent %d total %lld\n",
> +		printf("%d/%lld: bulkstat nent %d total %lld\n",
>  			procid, opno, nent, (long long)total);
>  	close(fd);
>  }
>  
>  void
> -bulkstat1_f(int opno, long r)
> +bulkstat1_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -2494,14 +2501,14 @@ bulkstat1_f(int opno, long r)
>          bsr.ocount=NULL;
>  	e = xfsctl(".", fd, XFS_IOC_FSBULKSTAT_SINGLE, &bsr) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: bulkstat1 %s ino %lld %d\n", 
> +		printf("%d/%lld: bulkstat1 %s ino %lld %d\n", 
>  		       procid, opno, good?"real":"random",
>  		       verifiable_log ? -1LL : (long long)ino, e);
>  	close(fd);
>  }
>  
>  void
> -chown_f(int opno, long r)
> +chown_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -2521,14 +2528,14 @@ chown_f(int opno, long r)
>  	e = lchown_path(&f, u, g) < 0 ? errno : 0;
>  	check_cwd();
>  	if (v)
> -		printf("%d/%d: chown %s %d/%d %d\n", procid, opno, f.path, (int)u, (int)g, e);
> +		printf("%d/%lld: chown %s %d/%d %d\n", procid, opno, f.path, (int)u, (int)g, e);
>  	free_pathname(&f);
>  }
>  
>  /* reflink some arbitrary range of f1 to f2. */
>  void
>  clonerange_f(
> -	int			opno,
> +	opnum_t			opno,
>  	long			r)
>  {
>  #ifdef FICLONERANGE
> @@ -2555,7 +2562,7 @@ clonerange_f(
>  	init_pathname(&fpath1);
>  	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
>  		if (v1)
> -			printf("%d/%d: clonerange read - no filename\n",
> +			printf("%d/%lld: clonerange read - no filename\n",
>  				procid, opno);
>  		goto out_fpath1;
>  	}
> @@ -2563,7 +2570,7 @@ clonerange_f(
>  	init_pathname(&fpath2);
>  	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
>  		if (v2)
> -			printf("%d/%d: clonerange write - no filename\n",
> +			printf("%d/%lld: clonerange write - no filename\n",
>  				procid, opno);
>  		goto out_fpath2;
>  	}
> @@ -2574,7 +2581,7 @@ clonerange_f(
>  	check_cwd();
>  	if (fd1 < 0) {
>  		if (v1)
> -			printf("%d/%d: clonerange read - open %s failed %d\n",
> +			printf("%d/%lld: clonerange read - open %s failed %d\n",
>  				procid, opno, fpath1.path, e);
>  		goto out_fpath2;
>  	}
> @@ -2584,7 +2591,7 @@ clonerange_f(
>  	check_cwd();
>  	if (fd2 < 0) {
>  		if (v2)
> -			printf("%d/%d: clonerange write - open %s failed %d\n",
> +			printf("%d/%lld: clonerange write - open %s failed %d\n",
>  				procid, opno, fpath2.path, e);
>  		goto out_fd1;
>  	}
> @@ -2592,7 +2599,7 @@ clonerange_f(
>  	/* Get file stats */
>  	if (fstat64(fd1, &stat1) < 0) {
>  		if (v1)
> -			printf("%d/%d: clonerange read - fstat64 %s failed %d\n",
> +			printf("%d/%lld: clonerange read - fstat64 %s failed %d\n",
>  				procid, opno, fpath1.path, errno);
>  		goto out_fd2;
>  	}
> @@ -2600,7 +2607,7 @@ clonerange_f(
>  
>  	if (fstat64(fd2, &stat2) < 0) {
>  		if (v2)
> -			printf("%d/%d: clonerange write - fstat64 %s failed %d\n",
> +			printf("%d/%lld: clonerange write - fstat64 %s failed %d\n",
>  				procid, opno, fpath2.path, errno);
>  		goto out_fd2;
>  	}
> @@ -2643,7 +2650,7 @@ clonerange_f(
>  	ret = ioctl(fd2, FICLONERANGE, &fcr);
>  	e = ret < 0 ? errno : 0;
>  	if (v1 || v2) {
> -		printf("%d/%d: clonerange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
> +		printf("%d/%lld: clonerange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
>  			procid, opno,
>  			fpath1.path, inoinfo1, (long long)off1, (long long)len,
>  			fpath2.path, inoinfo2, (long long)off2, (long long)len);
> @@ -2667,7 +2674,7 @@ clonerange_f(
>  /* copy some arbitrary range of f1 to f2. */
>  void
>  copyrange_f(
> -	int			opno,
> +	opnum_t			opno,
>  	long			r)
>  {
>  #ifdef HAVE_COPY_FILE_RANGE
> @@ -2697,7 +2704,7 @@ copyrange_f(
>  	init_pathname(&fpath1);
>  	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
>  		if (v1)
> -			printf("%d/%d: copyrange read - no filename\n",
> +			printf("%d/%lld: copyrange read - no filename\n",
>  				procid, opno);
>  		goto out_fpath1;
>  	}
> @@ -2705,7 +2712,7 @@ copyrange_f(
>  	init_pathname(&fpath2);
>  	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
>  		if (v2)
> -			printf("%d/%d: copyrange write - no filename\n",
> +			printf("%d/%lld: copyrange write - no filename\n",
>  				procid, opno);
>  		goto out_fpath2;
>  	}
> @@ -2716,7 +2723,7 @@ copyrange_f(
>  	check_cwd();
>  	if (fd1 < 0) {
>  		if (v1)
> -			printf("%d/%d: copyrange read - open %s failed %d\n",
> +			printf("%d/%lld: copyrange read - open %s failed %d\n",
>  				procid, opno, fpath1.path, e);
>  		goto out_fpath2;
>  	}
> @@ -2726,7 +2733,7 @@ copyrange_f(
>  	check_cwd();
>  	if (fd2 < 0) {
>  		if (v2)
> -			printf("%d/%d: copyrange write - open %s failed %d\n",
> +			printf("%d/%lld: copyrange write - open %s failed %d\n",
>  				procid, opno, fpath2.path, e);
>  		goto out_fd1;
>  	}
> @@ -2734,7 +2741,7 @@ copyrange_f(
>  	/* Get file stats */
>  	if (fstat64(fd1, &stat1) < 0) {
>  		if (v1)
> -			printf("%d/%d: copyrange read - fstat64 %s failed %d\n",
> +			printf("%d/%lld: copyrange read - fstat64 %s failed %d\n",
>  				procid, opno, fpath1.path, errno);
>  		goto out_fd2;
>  	}
> @@ -2742,7 +2749,7 @@ copyrange_f(
>  
>  	if (fstat64(fd2, &stat2) < 0) {
>  		if (v2)
> -			printf("%d/%d: copyrange write - fstat64 %s failed %d\n",
> +			printf("%d/%lld: copyrange write - fstat64 %s failed %d\n",
>  				procid, opno, fpath2.path, errno);
>  		goto out_fd2;
>  	}
> @@ -2794,7 +2801,7 @@ copyrange_f(
>  	}
>  	e = ret < 0 ? errno : 0;
>  	if (v1 || v2) {
> -		printf("%d/%d: copyrange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
> +		printf("%d/%lld: copyrange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
>  			procid, opno,
>  			fpath1.path, inoinfo1,
>  			(long long)offset1, (long long)length,
> @@ -2823,7 +2830,7 @@ copyrange_f(
>  /* dedupe some arbitrary range of f1 to f2...fn. */
>  void
>  deduperange_f(
> -	int			opno,
> +	opnum_t			opno,
>  	long			r)
>  {
>  #ifdef FIDEDUPERANGE
> @@ -2854,7 +2861,7 @@ deduperange_f(
>  	fdr = malloc(nr * sizeof(struct file_dedupe_range_info) +
>  		     sizeof(struct file_dedupe_range));
>  	if (!fdr) {
> -		printf("%d/%d: line %d error %d\n",
> +		printf("%d/%lld: line %d error %d\n",
>  			procid, opno, __LINE__, errno);
>  		return;
>  	}
> @@ -2863,41 +2870,41 @@ deduperange_f(
>  
>  	fpath = calloc(nr, sizeof(struct pathname));
>  	if (!fpath) {
> -		printf("%d/%d: line %d error %d\n",
> +		printf("%d/%lld: line %d error %d\n",
>  			procid, opno, __LINE__, errno);
>  		goto out_fdr;
>  	}
>  
>  	stat = calloc(nr, sizeof(struct stat64));
>  	if (!stat) {
> -		printf("%d/%d: line %d error %d\n",
> +		printf("%d/%lld: line %d error %d\n",
>  			procid, opno, __LINE__, errno);
>  		goto out_paths;
>  	}
>  
>  	info = calloc(nr, INFO_SZ);
>  	if (!info) {
> -		printf("%d/%d: line %d error %d\n",
> +		printf("%d/%lld: line %d error %d\n",
>  			procid, opno, __LINE__, errno);
>  		goto out_stats;
>  	}
>  
>  	off = calloc(nr, sizeof(off64_t));
>  	if (!off) {
> -		printf("%d/%d: line %d error %d\n",
> +		printf("%d/%lld: line %d error %d\n",
>  			procid, opno, __LINE__, errno);
>  		goto out_info;
>  	}
>  
>  	v = calloc(nr, sizeof(int));
>  	if (!v) {
> -		printf("%d/%d: line %d error %d\n",
> +		printf("%d/%lld: line %d error %d\n",
>  			procid, opno, __LINE__, errno);
>  		goto out_offsets;
>  	}
>  	fd = calloc(nr, sizeof(int));
>  	if (!fd) {
> -		printf("%d/%d: line %d error %d\n",
> +		printf("%d/%lld: line %d error %d\n",
>  			procid, opno, __LINE__, errno);
>  		goto out_v;
>  	}
> @@ -2909,7 +2916,7 @@ deduperange_f(
>  
>  	if (!get_fname(FT_REGm, r, &fpath[0], NULL, NULL, &v[0])) {
>  		if (v[0])
> -			printf("%d/%d: deduperange read - no filename\n",
> +			printf("%d/%lld: deduperange read - no filename\n",
>  				procid, opno);
>  		goto out_pathnames;
>  	}
> @@ -2917,7 +2924,7 @@ deduperange_f(
>  	for (i = 1; i < nr; i++) {
>  		if (!get_fname(FT_REGm, random(), &fpath[i], NULL, NULL, &v[i])) {
>  			if (v[i])
> -				printf("%d/%d: deduperange write - no filename\n",
> +				printf("%d/%lld: deduperange write - no filename\n",
>  					procid, opno);
>  			goto out_pathnames;
>  		}
> @@ -2929,7 +2936,7 @@ deduperange_f(
>  	check_cwd();
>  	if (fd[0] < 0) {
>  		if (v[0])
> -			printf("%d/%d: deduperange read - open %s failed %d\n",
> +			printf("%d/%lld: deduperange read - open %s failed %d\n",
>  				procid, opno, fpath[0].path, e);
>  		goto out_pathnames;
>  	}
> @@ -2940,7 +2947,7 @@ deduperange_f(
>  		check_cwd();
>  		if (fd[i] < 0) {
>  			if (v[i])
> -				printf("%d/%d: deduperange write - open %s failed %d\n",
> +				printf("%d/%lld: deduperange write - open %s failed %d\n",
>  					procid, opno, fpath[i].path, e);
>  			goto out_fds;
>  		}
> @@ -2949,7 +2956,7 @@ deduperange_f(
>  	/* Get file stats */
>  	if (fstat64(fd[0], &stat[0]) < 0) {
>  		if (v[0])
> -			printf("%d/%d: deduperange read - fstat64 %s failed %d\n",
> +			printf("%d/%lld: deduperange read - fstat64 %s failed %d\n",
>  				procid, opno, fpath[0].path, errno);
>  		goto out_fds;
>  	}
> @@ -2959,7 +2966,7 @@ deduperange_f(
>  	for (i = 1; i < nr; i++) {
>  		if (fstat64(fd[i], &stat[i]) < 0) {
>  			if (v[i])
> -				printf("%d/%d: deduperange write - fstat64 %s failed %d\n",
> +				printf("%d/%lld: deduperange write - fstat64 %s failed %d\n",
>  					procid, opno, fpath[i].path, errno);
>  			goto out_fds;
>  		}
> @@ -3015,7 +3022,7 @@ deduperange_f(
>  	ret = ioctl(fd[0], FIDEDUPERANGE, fdr);
>  	e = ret < 0 ? errno : 0;
>  	if (v[0]) {
> -		printf("%d/%d: deduperange from %s%s [%lld,%lld]",
> +		printf("%d/%lld: deduperange from %s%s [%lld,%lld]",
>  			procid, opno,
>  			fpath[0].path, &info[0], (long long)off[0],
>  			(long long)len);
> @@ -3029,7 +3036,7 @@ deduperange_f(
>  	for (i = 1; i < nr; i++) {
>  		e = fdr->info[i - 1].status < 0 ? fdr->info[i - 1].status : 0;
>  		if (v[i]) {
> -			printf("%d/%d: ...to %s%s [%lld,%lld]",
> +			printf("%d/%lld: ...to %s%s [%lld,%lld]",
>  				procid, opno,
>  				fpath[i].path, &info[i * INFO_SZ],
>  				(long long)off[i], (long long)len);
> @@ -3069,7 +3076,7 @@ deduperange_f(
>  }
>  
>  void
> -setxattr_f(int opno, long r)
> +setxattr_f(opnum_t opno, long r)
>  {
>  #ifdef XFS_XFLAG_EXTSIZE
>  	struct fsxattr	fsx;
> @@ -3098,14 +3105,14 @@ setxattr_f(int opno, long r)
>  		e = xfsctl(f.path, fd, XFS_IOC_FSSETXATTR, &fsx);
>  	}
>  	if (v)
> -		printf("%d/%d: setxattr %s %u %d\n", procid, opno, f.path, p, e);
> +		printf("%d/%lld: setxattr %s %u %d\n", procid, opno, f.path, p, e);
>  	free_pathname(&f);
>  	close(fd);
>  #endif
>  }
>  
>  void
> -splice_f(int opno, long r)
> +splice_f(opnum_t opno, long r)
>  {
>  	struct pathname		fpath1;
>  	struct pathname		fpath2;
> @@ -3132,7 +3139,7 @@ splice_f(int opno, long r)
>  	init_pathname(&fpath1);
>  	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
>  		if (v1)
> -			printf("%d/%d: splice read - no filename\n",
> +			printf("%d/%lld: splice read - no filename\n",
>  				procid, opno);
>  		goto out_fpath1;
>  	}
> @@ -3140,7 +3147,7 @@ splice_f(int opno, long r)
>  	init_pathname(&fpath2);
>  	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
>  		if (v2)
> -			printf("%d/%d: splice write - no filename\n",
> +			printf("%d/%lld: splice write - no filename\n",
>  				procid, opno);
>  		goto out_fpath2;
>  	}
> @@ -3151,7 +3158,7 @@ splice_f(int opno, long r)
>  	check_cwd();
>  	if (fd1 < 0) {
>  		if (v1)
> -			printf("%d/%d: splice read - open %s failed %d\n",
> +			printf("%d/%lld: splice read - open %s failed %d\n",
>  				procid, opno, fpath1.path, e);
>  		goto out_fpath2;
>  	}
> @@ -3161,7 +3168,7 @@ splice_f(int opno, long r)
>  	check_cwd();
>  	if (fd2 < 0) {
>  		if (v2)
> -			printf("%d/%d: splice write - open %s failed %d\n",
> +			printf("%d/%lld: splice write - open %s failed %d\n",
>  				procid, opno, fpath2.path, e);
>  		goto out_fd1;
>  	}
> @@ -3169,7 +3176,7 @@ splice_f(int opno, long r)
>  	/* Get file stats */
>  	if (fstat64(fd1, &stat1) < 0) {
>  		if (v1)
> -			printf("%d/%d: splice read - fstat64 %s failed %d\n",
> +			printf("%d/%lld: splice read - fstat64 %s failed %d\n",
>  				procid, opno, fpath1.path, errno);
>  		goto out_fd2;
>  	}
> @@ -3177,7 +3184,7 @@ splice_f(int opno, long r)
>  
>  	if (fstat64(fd2, &stat2) < 0) {
>  		if (v2)
> -			printf("%d/%d: splice write - fstat64 %s failed %d\n",
> +			printf("%d/%lld: splice write - fstat64 %s failed %d\n",
>  				procid, opno, fpath2.path, errno);
>  		goto out_fd2;
>  	}
> @@ -3216,7 +3223,7 @@ splice_f(int opno, long r)
>  	/* Pipe initialize */
>  	if (pipe(filedes) < 0) {
>  		if (v1 || v2) {
> -			printf("%d/%d: splice - pipe failed %d\n",
> +			printf("%d/%lld: splice - pipe failed %d\n",
>  				procid, opno, errno);
>  			goto out_fd2;
>  		}
> @@ -3252,7 +3259,7 @@ splice_f(int opno, long r)
>  	else
>  		e = 0;
>  	if (v1 || v2) {
> -		printf("%d/%d: splice %s%s [%lld,%lld] -> %s%s [%lld,%lld] %d",
> +		printf("%d/%lld: splice %s%s [%lld,%lld] -> %s%s [%lld,%lld] %d",
>  			procid, opno,
>  			fpath1.path, inoinfo1, (long long)offset1, (long long)length,
>  			fpath2.path, inoinfo2, (long long)offset2, (long long)length, e);
> @@ -3276,7 +3283,7 @@ splice_f(int opno, long r)
>  }
>  
>  void
> -creat_f(int opno, long r)
> +creat_f(opnum_t opno, long r)
>  {
>  	struct fsxattr	a;
>  	int		e;
> @@ -3311,7 +3318,7 @@ creat_f(int opno, long r)
>  	if (!e) {
>  		if (v) {
>  			(void)fent_to_name(&f, fep);
> -			printf("%d/%d: creat - no filename from %s\n",
> +			printf("%d/%lld: creat - no filename from %s\n",
>  				procid, opno, f.path);
>  		}
>  		free_pathname(&f);
> @@ -3341,15 +3348,15 @@ creat_f(int opno, long r)
>  		close(fd);
>  	}
>  	if (v) {
> -		printf("%d/%d: creat %s x:%d %d %d\n", procid, opno, f.path,
> +		printf("%d/%lld: creat %s x:%d %d %d\n", procid, opno, f.path,
>  			extsize ? a.fsx_extsize : 0, e, e1);
> -		printf("%d/%d: creat add id=%d,parent=%d\n", procid, opno, id, parid);
> +		printf("%d/%lld: creat add id=%d,parent=%d\n", procid, opno, id, parid);
>  	}
>  	free_pathname(&f);
>  }
>  
>  void
> -dread_f(int opno, long r)
> +dread_f(opnum_t opno, long r)
>  {
>  	int64_t		align;
>  	char		*buf;
> @@ -3368,7 +3375,7 @@ dread_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: dread - no filename\n", procid, opno);
> +			printf("%d/%lld: dread - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -3377,14 +3384,14 @@ dread_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: dread - open %s failed %d\n",
> +			printf("%d/%lld: dread - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: dread - fstat64 %s failed %d\n",
> +			printf("%d/%lld: dread - fstat64 %s failed %d\n",
>  			       procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -3393,7 +3400,7 @@ dread_f(int opno, long r)
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (stb.st_size == 0) {
>  		if (v)
> -			printf("%d/%d: dread - %s%s zero size\n", procid, opno,
> +			printf("%d/%lld: dread - %s%s zero size\n", procid, opno,
>  			       f.path, st);
>  		free_pathname(&f);
>  		close(fd);
> @@ -3402,7 +3409,7 @@ dread_f(int opno, long r)
>  	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
>  		if (v)
>  			printf(
> -			"%d/%d: dread - xfsctl(XFS_IOC_DIOINFO) %s%s return %d,"
> +			"%d/%lld: dread - xfsctl(XFS_IOC_DIOINFO) %s%s return %d,"
>  			" fallback to stat()\n",
>  				procid, opno, f.path, st, errno);
>  		diob.d_mem = diob.d_miniosz = stb.st_blksize;
> @@ -3428,14 +3435,14 @@ dread_f(int opno, long r)
>  	e = read(fd, buf, len) < 0 ? errno : 0;
>  	free(buf);
>  	if (v)
> -		printf("%d/%d: dread %s%s [%lld,%d] %d\n",
> +		printf("%d/%lld: dread %s%s [%lld,%d] %d\n",
>  		       procid, opno, f.path, st, (long long)off, (int)len, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
>  
>  void
> -dwrite_f(int opno, long r)
> +dwrite_f(opnum_t opno, long r)
>  {
>  	int64_t		align;
>  	char		*buf;
> @@ -3454,7 +3461,7 @@ dwrite_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: dwrite - no filename\n", procid, opno);
> +			printf("%d/%lld: dwrite - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -3463,14 +3470,14 @@ dwrite_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: dwrite - open %s failed %d\n",
> +			printf("%d/%lld: dwrite - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: dwrite - fstat64 %s failed %d\n",
> +			printf("%d/%lld: dwrite - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -3479,7 +3486,7 @@ dwrite_f(int opno, long r)
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
>  		if (v)
> -			printf("%d/%d: dwrite - xfsctl(XFS_IOC_DIOINFO)"
> +			printf("%d/%lld: dwrite - xfsctl(XFS_IOC_DIOINFO)"
>  				" %s%s return %d, fallback to stat()\n",
>  			       procid, opno, f.path, st, errno);
>  		diob.d_mem = diob.d_miniosz = stb.st_blksize;
> @@ -3508,7 +3515,7 @@ dwrite_f(int opno, long r)
>  	e = write(fd, buf, len) < 0 ? errno : 0;
>  	free(buf);
>  	if (v)
> -		printf("%d/%d: dwrite %s%s [%lld,%d] %d\n",
> +		printf("%d/%lld: dwrite %s%s [%lld,%d] %d\n",
>  		       procid, opno, f.path, st, (long long)off, (int)len, e);
>  	free_pathname(&f);
>  	close(fd);
> @@ -3531,7 +3538,7 @@ struct print_flags falloc_flags [] = {
>  #endif
>  
>  void
> -do_fallocate(int opno, long r, int mode)
> +do_fallocate(opnum_t opno, long r, int mode)
>  {
>  #ifdef HAVE_LINUX_FALLOC_H
>  	int		e;
> @@ -3547,14 +3554,14 @@ do_fallocate(int opno, long r, int mode)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: do_fallocate - no filename\n", procid, opno);
> +			printf("%d/%lld: do_fallocate - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
>  	fd = open_path(&f, O_RDWR);
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: do_fallocate - open %s failed %d\n",
> +			printf("%d/%lld: do_fallocate - open %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		return;
> @@ -3562,7 +3569,7 @@ do_fallocate(int opno, long r, int mode)
>  	check_cwd();
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: do_fallocate - fstat64 %s failed %d\n",
> +			printf("%d/%lld: do_fallocate - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -3585,7 +3592,7 @@ do_fallocate(int opno, long r, int mode)
>  	mode |= FALLOC_FL_KEEP_SIZE & random();
>  	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: fallocate(%s) %s %st %lld %lld %d\n",
> +		printf("%d/%lld: fallocate(%s) %s %st %lld %lld %d\n",
>  		       procid, opno, translate_falloc_flags(mode),
>  		       f.path, st, (long long)off, (long long)len, e);
>  	free_pathname(&f);
> @@ -3594,7 +3601,7 @@ do_fallocate(int opno, long r, int mode)
>  }
>  
>  void
> -fallocate_f(int opno, long r)
> +fallocate_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_LINUX_FALLOC_H
>  	do_fallocate(opno, r, 0);
> @@ -3602,7 +3609,7 @@ fallocate_f(int opno, long r)
>  }
>  
>  void
> -fdatasync_f(int opno, long r)
> +fdatasync_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -3612,7 +3619,7 @@ fdatasync_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: fdatasync - no filename\n",
> +			printf("%d/%lld: fdatasync - no filename\n",
>  				procid, opno);
>  		free_pathname(&f);
>  		return;
> @@ -3622,14 +3629,14 @@ fdatasync_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: fdatasync - open %s failed %d\n",
> +			printf("%d/%lld: fdatasync - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	e = fdatasync(fd) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: fdatasync %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: fdatasync %s %d\n", procid, opno, f.path, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
> @@ -3646,7 +3653,7 @@ struct print_flags fiemap_flags[] = {
>  #endif
>  
>  void
> -fiemap_f(int opno, long r)
> +fiemap_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_LINUX_FIEMAP_H
>  	int		e;
> @@ -3663,7 +3670,7 @@ fiemap_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: fiemap - no filename\n", procid, opno);
> +			printf("%d/%lld: fiemap - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -3672,14 +3679,14 @@ fiemap_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: fiemap - open %s failed %d\n",
> +			printf("%d/%lld: fiemap - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: fiemap - fstat64 %s failed %d\n",
> +			printf("%d/%lld: fiemap - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -3691,7 +3698,7 @@ fiemap_f(int opno, long r)
>  			(blocks_to_map * sizeof(struct fiemap_extent)));
>  	if (!fiemap) {
>  		if (v)
> -			printf("%d/%d: malloc failed \n", procid, opno);
> +			printf("%d/%lld: malloc failed \n", procid, opno);
>  		free_pathname(&f);
>  		close(fd);
>  		return;
> @@ -3707,7 +3714,7 @@ fiemap_f(int opno, long r)
>  
>  	e = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
>  	if (v)
> -		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld (%s) %d\n",
> +		printf("%d/%lld: ioctl(FIEMAP) %s%s %lld %lld (%s) %d\n",
>  		       procid, opno, f.path, st, (long long)fiemap->fm_start,
>  		       (long long) fiemap->fm_length,
>  		       translate_fiemap_flags(fiemap->fm_flags), e);
> @@ -3718,7 +3725,7 @@ fiemap_f(int opno, long r)
>  }
>  
>  void
> -freesp_f(int opno, long r)
> +freesp_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -3733,7 +3740,7 @@ freesp_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: freesp - no filename\n", procid, opno);
> +			printf("%d/%lld: freesp - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -3742,14 +3749,14 @@ freesp_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: freesp - open %s failed %d\n",
> +			printf("%d/%lld: freesp - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: freesp - fstat64 %s failed %d\n",
> +			printf("%d/%lld: freesp - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -3764,14 +3771,14 @@ freesp_f(int opno, long r)
>  	fl.l_len = 0;
>  	e = xfsctl(f.path, fd, XFS_IOC_FREESP64, &fl) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: xfsctl(XFS_IOC_FREESP64) %s%s %lld 0 %d\n",
> +		printf("%d/%lld: xfsctl(XFS_IOC_FREESP64) %s%s %lld 0 %d\n",
>  		       procid, opno, f.path, st, (long long)off, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
>  
>  void
> -fsync_f(int opno, long r)
> +fsync_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -3781,7 +3788,7 @@ fsync_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE | FT_DIRm, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: fsync - no filename\n", procid, opno);
> +			printf("%d/%lld: fsync - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -3790,14 +3797,14 @@ fsync_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: fsync - open %s failed %d\n",
> +			printf("%d/%lld: fsync - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	e = fsync(fd) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: fsync %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: fsync %s %d\n", procid, opno, f.path, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
> @@ -3825,7 +3832,7 @@ gen_random_string(int len)
>  }
>  
>  void
> -getattr_f(int opno, long r)
> +getattr_f(opnum_t opno, long r)
>  {
>  	int		fd;
>  	int		e;
> @@ -3842,13 +3849,13 @@ getattr_f(int opno, long r)
>  
>  	e = ioctl(fd, FS_IOC_GETFLAGS, &fl);
>  	if (v)
> -		printf("%d/%d: getattr %s %u %d\n", procid, opno, f.path, fl, e);
> +		printf("%d/%lld: getattr %s %u %d\n", procid, opno, f.path, fl, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
>  
>  void
> -getdents_f(int opno, long r)
> +getdents_f(opnum_t opno, long r)
>  {
>  	DIR		*dir;
>  	pathname_t	f;
> @@ -3861,7 +3868,7 @@ getdents_f(int opno, long r)
>  	check_cwd();
>  	if (dir == NULL) {
>  		if (v)
> -			printf("%d/%d: getdents - can't open %s\n",
> +			printf("%d/%lld: getdents - can't open %s\n",
>  				procid, opno, f.path);
>  		free_pathname(&f);
>  		return;
> @@ -3869,13 +3876,13 @@ getdents_f(int opno, long r)
>  	while (readdir64(dir) != NULL)
>  		continue;
>  	if (v)
> -		printf("%d/%d: getdents %s 0\n", procid, opno, f.path);
> +		printf("%d/%lld: getdents %s 0\n", procid, opno, f.path);
>  	free_pathname(&f);
>  	closedir(dir);
>  }
>  
>  void
> -getfattr_f(int opno, long r)
> +getfattr_f(opnum_t opno, long r)
>  {
>  	fent_t	        *fep;
>  	int		e;
> @@ -3889,7 +3896,7 @@ getfattr_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE | FT_ANYDIR, r, &f, NULL, &fep, &v)) {
>  		if (v)
> -			printf("%d/%d: getfattr - no filename\n", procid, opno);
> +			printf("%d/%lld: getfattr - no filename\n", procid, opno);
>  		goto out;
>  	}
>  	check_cwd();
> @@ -3906,7 +3913,7 @@ getfattr_f(int opno, long r)
>  
>  	e = generate_xattr_name(xattr_num, name, sizeof(name));
>  	if (e < 0) {
> -		printf("%d/%d: getfattr - file %s failed to generate xattr name: %d\n",
> +		printf("%d/%lld: getfattr - file %s failed to generate xattr name: %d\n",
>  		       procid, opno, f.path, e);
>  		goto out;
>  	}
> @@ -3914,7 +3921,7 @@ getfattr_f(int opno, long r)
>  	value_len = getxattr(f.path, name, NULL, 0);
>  	if (value_len < 0) {
>  		if (v)
> -			printf("%d/%d: getfattr file %s name %s failed %d\n",
> +			printf("%d/%lld: getfattr file %s name %s failed %d\n",
>  			       procid, opno, f.path, name, errno);
>  		goto out;
>  	}
> @@ -3928,7 +3935,7 @@ getfattr_f(int opno, long r)
>  	value = malloc(value_len);
>  	if (!value) {
>  		if (v)
> -			printf("%d/%d: getfattr file %s failed to allocate buffer with %d bytes\n",
> +			printf("%d/%lld: getfattr file %s failed to allocate buffer with %d bytes\n",
>  			       procid, opno, f.path, value_len);
>  		goto out;
>  	}
> @@ -3936,7 +3943,7 @@ getfattr_f(int opno, long r)
>  	e = getxattr(f.path, name, value, value_len) < 0 ? errno : 0;
>  out_log:
>  	if (v)
> -		printf("%d/%d: getfattr file %s name %s value length %d %d\n",
> +		printf("%d/%lld: getfattr file %s name %s value length %d %d\n",
>  		       procid, opno, f.path, name, value_len, e);
>  out:
>  	free(value);
> @@ -3944,7 +3951,7 @@ getfattr_f(int opno, long r)
>  }
>  
>  void
> -link_f(int opno, long r)
> +link_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -3960,7 +3967,7 @@ link_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_NOTDIR, r, &f, &flp, &fep_src, &v1)) {
>  		if (v1)
> -			printf("%d/%d: link - no file\n", procid, opno);
> +			printf("%d/%lld: link - no file\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -3975,7 +3982,7 @@ link_f(int opno, long r)
>  	if (!e) {
>  		if (v) {
>  			(void)fent_to_name(&l, fep);
> -			printf("%d/%d: link - no filename from %s\n",
> +			printf("%d/%lld: link - no filename from %s\n",
>  				procid, opno, l.path);
>  		}
>  		free_pathname(&l);
> @@ -3987,16 +3994,16 @@ link_f(int opno, long r)
>  	if (e == 0)
>  		add_to_flist(flp - flist, id, parid, fep_src->xattr_counter);
>  	if (v) {
> -		printf("%d/%d: link %s %s %d\n", procid, opno, f.path, l.path,
> +		printf("%d/%lld: link %s %s %d\n", procid, opno, f.path, l.path,
>  			e);
> -		printf("%d/%d: link add id=%d,parent=%d\n", procid, opno, id, parid);
> +		printf("%d/%lld: link add id=%d,parent=%d\n", procid, opno, id, parid);
>  	}
>  	free_pathname(&l);
>  	free_pathname(&f);
>  }
>  
>  void
> -listfattr_f(int opno, long r)
> +listfattr_f(opnum_t opno, long r)
>  {
>  	fent_t	        *fep;
>  	int		e;
> @@ -4008,7 +4015,7 @@ listfattr_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE | FT_ANYDIR, r, &f, NULL, &fep, &v)) {
>  		if (v)
> -			printf("%d/%d: listfattr - no filename\n", procid, opno);
> +			printf("%d/%lld: listfattr - no filename\n", procid, opno);
>  		goto out;
>  	}
>  	check_cwd();
> @@ -4016,14 +4023,14 @@ listfattr_f(int opno, long r)
>  	e = listxattr(f.path, NULL, 0);
>  	if (e < 0) {
>  		if (v)
> -			printf("%d/%d: listfattr %s failed %d\n",
> +			printf("%d/%lld: listfattr %s failed %d\n",
>  			       procid, opno, f.path, errno);
>  		goto out;
>  	}
>  	buffer_len = e;
>  	if (buffer_len == 0) {
>  		if (v)
> -			printf("%d/%d: listfattr %s - has no extended attributes\n",
> +			printf("%d/%lld: listfattr %s - has no extended attributes\n",
>  			       procid, opno, f.path);
>  		goto out;
>  	}
> @@ -4031,14 +4038,14 @@ listfattr_f(int opno, long r)
>  	buffer = malloc(buffer_len);
>  	if (!buffer) {
>  		if (v)
> -			printf("%d/%d: listfattr %s failed to allocate buffer with %d bytes\n",
> +			printf("%d/%lld: listfattr %s failed to allocate buffer with %d bytes\n",
>  			       procid, opno, f.path, buffer_len);
>  		goto out;
>  	}
>  
>  	e = listxattr(f.path, buffer, buffer_len) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: listfattr %s buffer length %d %d\n",
> +		printf("%d/%lld: listfattr %s buffer length %d %d\n",
>  		       procid, opno, f.path, buffer_len, e);
>  out:
>  	free(buffer);
> @@ -4046,7 +4053,7 @@ listfattr_f(int opno, long r)
>  }
>  
>  void
> -mkdir_f(int opno, long r)
> +mkdir_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -4066,7 +4073,7 @@ mkdir_f(int opno, long r)
>  	if (!e) {
>  		if (v) {
>  			(void)fent_to_name(&f, fep);
> -			printf("%d/%d: mkdir - no filename from %s\n",
> +			printf("%d/%lld: mkdir - no filename from %s\n",
>  				procid, opno, f.path);
>  		}
>  		free_pathname(&f);
> @@ -4077,14 +4084,14 @@ mkdir_f(int opno, long r)
>  	if (e == 0)
>  		add_to_flist(FT_DIR, id, parid, 0);
>  	if (v) {
> -		printf("%d/%d: mkdir %s %d\n", procid, opno, f.path, e);
> -		printf("%d/%d: mkdir add id=%d,parent=%d\n", procid, opno, id, parid);
> +		printf("%d/%lld: mkdir %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: mkdir add id=%d,parent=%d\n", procid, opno, id, parid);
>  	}
>  	free_pathname(&f);
>  }
>  
>  void
> -mknod_f(int opno, long r)
> +mknod_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -4104,7 +4111,7 @@ mknod_f(int opno, long r)
>  	if (!e) {
>  		if (v) {
>  			(void)fent_to_name(&f, fep);
> -			printf("%d/%d: mknod - no filename from %s\n",
> +			printf("%d/%lld: mknod - no filename from %s\n",
>  				procid, opno, f.path);
>  		}
>  		free_pathname(&f);
> @@ -4115,8 +4122,8 @@ mknod_f(int opno, long r)
>  	if (e == 0)
>  		add_to_flist(FT_DEV, id, parid, 0);
>  	if (v) {
> -		printf("%d/%d: mknod %s %d\n", procid, opno, f.path, e);
> -		printf("%d/%d: mknod add id=%d,parent=%d\n", procid, opno, id, parid);
> +		printf("%d/%lld: mknod %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: mknod add id=%d,parent=%d\n", procid, opno, id, parid);
>  	}
>  	free_pathname(&f);
>  }
> @@ -4133,7 +4140,7 @@ struct print_flags mmap_flags[] = {
>  #endif
>  
>  void
> -do_mmap(int opno, long r, int prot)
> +do_mmap(opnum_t opno, long r, int prot)
>  {
>  #ifdef HAVE_SYS_MMAN_H
>  	char		*addr;
> @@ -4152,7 +4159,7 @@ do_mmap(int opno, long r, int prot)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: do_mmap - no filename\n", procid, opno);
> +			printf("%d/%lld: do_mmap - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -4161,14 +4168,14 @@ do_mmap(int opno, long r, int prot)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: do_mmap - open %s failed %d\n",
> +			printf("%d/%lld: do_mmap - open %s failed %d\n",
>  			       procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: do_mmap - fstat64 %s failed %d\n",
> +			printf("%d/%lld: do_mmap - fstat64 %s failed %d\n",
>  			       procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -4177,7 +4184,7 @@ do_mmap(int opno, long r, int prot)
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (stb.st_size == 0) {
>  		if (v)
> -			printf("%d/%d: do_mmap - %s%s zero size\n", procid, opno,
> +			printf("%d/%lld: do_mmap - %s%s zero size\n", procid, opno,
>  			       f.path, st);
>  		free_pathname(&f);
>  		close(fd);
> @@ -4194,7 +4201,7 @@ do_mmap(int opno, long r, int prot)
>  	e = (addr == MAP_FAILED) ? errno : 0;
>  	if (e) {
>  		if (v)
> -			printf("%d/%d: do_mmap - mmap failed %s%s [%lld,%d,%s] %d\n",
> +			printf("%d/%lld: do_mmap - mmap failed %s%s [%lld,%d,%s] %d\n",
>  			       procid, opno, f.path, st, (long long)off,
>  			       (int)len, translate_mmap_flags(flags), e);
>  		free_pathname(&f);
> @@ -4219,7 +4226,7 @@ do_mmap(int opno, long r, int prot)
>  	sigbus_jmp = NULL;
>  
>  	if (v)
> -		printf("%d/%d: %s %s%s [%lld,%d,%s] %s\n",
> +		printf("%d/%lld: %s %s%s [%lld,%d,%s] %s\n",
>  		       procid, opno, (prot & PROT_WRITE) ? "mwrite" : "mread",
>  		       f.path, st, (long long)off, (int)len,
>  		       translate_mmap_flags(flags),
> @@ -4231,7 +4238,7 @@ do_mmap(int opno, long r, int prot)
>  }
>  
>  void
> -mread_f(int opno, long r)
> +mread_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_SYS_MMAN_H
>  	do_mmap(opno, r, PROT_READ);
> @@ -4239,7 +4246,7 @@ mread_f(int opno, long r)
>  }
>  
>  void
> -mwrite_f(int opno, long r)
> +mwrite_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_SYS_MMAN_H
>  	do_mmap(opno, r, PROT_WRITE);
> @@ -4247,7 +4254,7 @@ mwrite_f(int opno, long r)
>  }
>  
>  void
> -punch_f(int opno, long r)
> +punch_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_LINUX_FALLOC_H
>  	do_fallocate(opno, r, FALLOC_FL_PUNCH_HOLE);
> @@ -4255,7 +4262,7 @@ punch_f(int opno, long r)
>  }
>  
>  void
> -zero_f(int opno, long r)
> +zero_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_LINUX_FALLOC_H
>  	do_fallocate(opno, r, FALLOC_FL_ZERO_RANGE);
> @@ -4263,7 +4270,7 @@ zero_f(int opno, long r)
>  }
>  
>  void
> -collapse_f(int opno, long r)
> +collapse_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_LINUX_FALLOC_H
>  	do_fallocate(opno, r, FALLOC_FL_COLLAPSE_RANGE);
> @@ -4271,7 +4278,7 @@ collapse_f(int opno, long r)
>  }
>  
>  void
> -insert_f(int opno, long r)
> +insert_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_LINUX_FALLOC_H
>  	do_fallocate(opno, r, FALLOC_FL_INSERT_RANGE);
> @@ -4279,7 +4286,7 @@ insert_f(int opno, long r)
>  }
>  
>  void
> -read_f(int opno, long r)
> +read_f(opnum_t opno, long r)
>  {
>  	char		*buf;
>  	int		e;
> @@ -4295,7 +4302,7 @@ read_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: read - no filename\n", procid, opno);
> +			printf("%d/%lld: read - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -4304,14 +4311,14 @@ read_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: read - open %s failed %d\n",
> +			printf("%d/%lld: read - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: read - fstat64 %s failed %d\n",
> +			printf("%d/%lld: read - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -4320,7 +4327,7 @@ read_f(int opno, long r)
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (stb.st_size == 0) {
>  		if (v)
> -			printf("%d/%d: read - %s%s zero size\n", procid, opno,
> +			printf("%d/%lld: read - %s%s zero size\n", procid, opno,
>  			       f.path, st);
>  		free_pathname(&f);
>  		close(fd);
> @@ -4334,14 +4341,14 @@ read_f(int opno, long r)
>  	e = read(fd, buf, len) < 0 ? errno : 0;
>  	free(buf);
>  	if (v)
> -		printf("%d/%d: read %s%s [%lld,%d] %d\n",
> +		printf("%d/%lld: read %s%s [%lld,%d] %d\n",
>  		       procid, opno, f.path, st, (long long)off, (int)len, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
>  
>  void
> -readlink_f(int opno, long r)
> +readlink_f(opnum_t opno, long r)
>  {
>  	char		buf[PATH_MAX];
>  	int		e;
> @@ -4351,19 +4358,19 @@ readlink_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_SYMm, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: readlink - no filename\n", procid, opno);
> +			printf("%d/%lld: readlink - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
>  	e = readlink_path(&f, buf, PATH_MAX) < 0 ? errno : 0;
>  	check_cwd();
>  	if (v)
> -		printf("%d/%d: readlink %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: readlink %s %d\n", procid, opno, f.path, e);
>  	free_pathname(&f);
>  }
>  
>  void
> -readv_f(int opno, long r)
> +readv_f(opnum_t opno, long r)
>  {
>  	char		*buf;
>  	int		e;
> @@ -4384,7 +4391,7 @@ readv_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: readv - no filename\n", procid, opno);
> +			printf("%d/%lld: readv - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -4393,14 +4400,14 @@ readv_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: readv - open %s failed %d\n",
> +			printf("%d/%lld: readv - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: readv - fstat64 %s failed %d\n",
> +			printf("%d/%lld: readv - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -4409,7 +4416,7 @@ readv_f(int opno, long r)
>  	inode_info(st, sizeof(st), &stb, v);
>  	if (stb.st_size == 0) {
>  		if (v)
> -			printf("%d/%d: readv - %s%s zero size\n", procid, opno,
> +			printf("%d/%lld: readv - %s%s zero size\n", procid, opno,
>  			       f.path, st);
>  		free_pathname(&f);
>  		close(fd);
> @@ -4434,7 +4441,7 @@ readv_f(int opno, long r)
>  	e = readv(fd, iov, iovcnt) < 0 ? errno : 0;
>  	free(buf);
>  	if (v)
> -		printf("%d/%d: readv %s%s [%lld,%d,%d] %d\n",
> +		printf("%d/%lld: readv %s%s [%lld,%d,%d] %d\n",
>  		       procid, opno, f.path, st, (long long)off, (int)iovl,
>  		       iovcnt, e);
>  	free_pathname(&f);
> @@ -4442,7 +4449,7 @@ readv_f(int opno, long r)
>  }
>  
>  void
> -removefattr_f(int opno, long r)
> +removefattr_f(opnum_t opno, long r)
>  {
>  	fent_t	        *fep;
>  	int		e;
> @@ -4454,7 +4461,7 @@ removefattr_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE | FT_ANYDIR, r, &f, NULL, &fep, &v)) {
>  		if (v)
> -			printf("%d/%d: removefattr - no filename\n", procid, opno);
> +			printf("%d/%lld: removefattr - no filename\n", procid, opno);
>  		goto out;
>  	}
>  	check_cwd();
> @@ -4471,14 +4478,14 @@ removefattr_f(int opno, long r)
>  
>  	e = generate_xattr_name(xattr_num, name, sizeof(name));
>  	if (e < 0) {
> -		printf("%d/%d: removefattr - file %s failed to generate xattr name: %d\n",
> +		printf("%d/%lld: removefattr - file %s failed to generate xattr name: %d\n",
>  		       procid, opno, f.path, e);
>  		goto out;
>  	}
>  
>  	e = removexattr(f.path, name) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: removefattr file %s name %s %d\n",
> +		printf("%d/%lld: removefattr file %s name %s %d\n",
>  		       procid, opno, f.path, name, e);
>  out:
>  	free_pathname(&f);
> @@ -4495,7 +4502,7 @@ struct print_flags renameat2_flags [] = {
>  	({translate_flags(mode, "|", renameat2_flags);})
>  
>  void
> -do_renameat2(int opno, long r, int mode)
> +do_renameat2(opnum_t opno, long r, int mode)
>  {
>  	fent_t		*dfep;
>  	int		e;
> @@ -4516,7 +4523,7 @@ do_renameat2(int opno, long r, int mode)
>  	which = (mode == RENAME_WHITEOUT) ? FT_DEVm : FT_ANYm;
>  	if (!get_fname(which, r, &f, &flp, &fep, &v1)) {
>  		if (v1)
> -			printf("%d/%d: rename - no source filename\n",
> +			printf("%d/%lld: rename - no source filename\n",
>  				procid, opno);
>  		free_pathname(&f);
>  		return;
> @@ -4532,7 +4539,7 @@ do_renameat2(int opno, long r, int mode)
>  		init_pathname(&newf);
>  		if (!get_fname(which, random(), &newf, NULL, &dfep, &v)) {
>  			if (v)
> -				printf("%d/%d: rename - no target filename\n",
> +				printf("%d/%lld: rename - no target filename\n",
>  					procid, opno);
>  			free_pathname(&newf);
>  			free_pathname(&f);
> @@ -4541,7 +4548,7 @@ do_renameat2(int opno, long r, int mode)
>  		if (which == FT_DIRm && (fents_ancestor_check(fep, dfep) ||
>  		    fents_ancestor_check(dfep, fep))) {
>  			if (v)
> -				printf("%d/%d: rename(REXCHANGE) %s and %s "
> +				printf("%d/%lld: rename(REXCHANGE) %s and %s "
>  					"have ancestor-descendant relationship\n",
>  					procid, opno, f.path, newf.path);
>  			free_pathname(&newf);
> @@ -4572,7 +4579,7 @@ do_renameat2(int opno, long r, int mode)
>  		if (!e) {
>  			if (v) {
>  				(void)fent_to_name(&f, dfep);
> -				printf("%d/%d: rename - no filename from %s\n",
> +				printf("%d/%lld: rename - no filename from %s\n",
>  					procid, opno, f.path);
>  			}
>  			free_pathname(&newf);
> @@ -4609,13 +4616,13 @@ do_renameat2(int opno, long r, int mode)
>  		}
>  	}
>  	if (v) {
> -		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
> +		printf("%d/%lld: rename(%s) %s to %s %d\n", procid,
>  			opno, translate_renameat2_flags(mode), f.path,
>  			newf.path, e);
>  		if (e == 0) {
> -			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
> +			printf("%d/%lld: rename source entry: id=%d,parent=%d\n",
>  				procid, opno, oldid, oldparid);
> -			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
> +			printf("%d/%lld: rename target entry: id=%d,parent=%d\n",
>  				procid, opno, id, parid);
>  		}
>  	}
> @@ -4624,31 +4631,31 @@ do_renameat2(int opno, long r, int mode)
>  }
>  
>  void
> -rename_f(int opno, long r)
> +rename_f(opnum_t opno, long r)
>  {
>  	do_renameat2(opno, r, 0);
>  }
>  
>  void
> -rnoreplace_f(int opno, long r)
> +rnoreplace_f(opnum_t opno, long r)
>  {
>  	do_renameat2(opno, r, RENAME_NOREPLACE);
>  }
>  
>  void
> -rexchange_f(int opno, long r)
> +rexchange_f(opnum_t opno, long r)
>  {
>  	do_renameat2(opno, r, RENAME_EXCHANGE);
>  }
>  
>  void
> -rwhiteout_f(int opno, long r)
> +rwhiteout_f(opnum_t opno, long r)
>  {
>  	do_renameat2(opno, r, RENAME_WHITEOUT);
>  }
>  
>  void
> -resvsp_f(int opno, long r)
> +resvsp_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -4663,7 +4670,7 @@ resvsp_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: resvsp - no filename\n", procid, opno);
> +			printf("%d/%lld: resvsp - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -4672,14 +4679,14 @@ resvsp_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: resvsp - open %s failed %d\n",
> +			printf("%d/%lld: resvsp - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: resvsp - fstat64 %s failed %d\n",
> +			printf("%d/%lld: resvsp - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -4694,7 +4701,7 @@ resvsp_f(int opno, long r)
>  	fl.l_len = (off64_t)(random() % (1024 * 1024));
>  	e = xfsctl(f.path, fd, XFS_IOC_RESVSP64, &fl) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: xfsctl(XFS_IOC_RESVSP64) %s%s %lld %lld %d\n",
> +		printf("%d/%lld: xfsctl(XFS_IOC_RESVSP64) %s%s %lld %lld %d\n",
>  		       procid, opno, f.path, st,
>  			(long long)off, (long long)fl.l_len, e);
>  	free_pathname(&f);
> @@ -4702,7 +4709,7 @@ resvsp_f(int opno, long r)
>  }
>  
>  void
> -rmdir_f(int opno, long r)
> +rmdir_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -4714,7 +4721,7 @@ rmdir_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_DIRm, r, &f, NULL, &fep, &v)) {
>  		if (v)
> -			printf("%d/%d: rmdir - no directory\n", procid, opno);
> +			printf("%d/%lld: rmdir - no directory\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -4726,16 +4733,16 @@ rmdir_f(int opno, long r)
>  		del_from_flist(FT_DIR, fep - flist[FT_DIR].fents);
>  	}
>  	if (v) {
> -		printf("%d/%d: rmdir %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: rmdir %s %d\n", procid, opno, f.path, e);
>  		if (e == 0)
> -			printf("%d/%d: rmdir del entry: id=%d,parent=%d\n",
> +			printf("%d/%lld: rmdir del entry: id=%d,parent=%d\n",
>  				procid, opno, oldid, oldparid);
>  	}
>  	free_pathname(&f);
>  }
>  
>  void
> -setattr_f(int opno, long r)
> +setattr_f(opnum_t opno, long r)
>  {
>  	int		fd;
>  	int		e;
> @@ -4753,13 +4760,13 @@ setattr_f(int opno, long r)
>  	fl = attr_mask & (uint)random();
>  	e = ioctl(fd, FS_IOC_SETFLAGS, &fl);
>  	if (v)
> -		printf("%d/%d: setattr %s %x %d\n", procid, opno, f.path, fl, e);
> +		printf("%d/%lld: setattr %s %x %d\n", procid, opno, f.path, fl, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
>  
>  void
> -setfattr_f(int opno, long r)
> +setfattr_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -4774,7 +4781,7 @@ setfattr_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE | FT_ANYDIR, r, &f, NULL, &fep, &v)) {
>  		if (v)
> -			printf("%d/%d: setfattr - no filename\n", procid, opno);
> +			printf("%d/%lld: setfattr - no filename\n", procid, opno);
>  		goto out;
>  	}
>  	check_cwd();
> @@ -4810,13 +4817,13 @@ setfattr_f(int opno, long r)
>  	value = gen_random_string(value_len);
>  	if (!value && value_len > 0) {
>  		if (v)
> -			printf("%d/%d: setfattr - file %s failed to allocate value with %d bytes\n",
> +			printf("%d/%lld: setfattr - file %s failed to allocate value with %d bytes\n",
>  			       procid, opno, f.path, value_len);
>  		goto out;
>  	}
>  	e = generate_xattr_name(xattr_num, name, sizeof(name));
>  	if (e < 0) {
> -		printf("%d/%d: setfattr - file %s failed to generate xattr name: %d\n",
> +		printf("%d/%lld: setfattr - file %s failed to generate xattr name: %d\n",
>  		       procid, opno, f.path, e);
>  		goto out;
>  	}
> @@ -4825,7 +4832,7 @@ setfattr_f(int opno, long r)
>  	if (e == 0)
>  		fep->xattr_counter++;
>  	if (v)
> -		printf("%d/%d: setfattr file %s name %s flag %s value length %d: %d\n",
> +		printf("%d/%lld: setfattr file %s name %s flag %s value length %d: %d\n",
>  		       procid, opno, f.path, name, xattr_flag_to_string(flag),
>  		       value_len, e);
>  out:
> @@ -4834,7 +4841,7 @@ setfattr_f(int opno, long r)
>  }
>  
>  void
> -snapshot_f(int opno, long r)
> +snapshot_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_BTRFSUTIL_H
>  	enum btrfs_util_error	e;
> @@ -4850,7 +4857,7 @@ snapshot_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_SUBVOLm, r, &f, NULL, &fep, &v)) {
>  		if (v)
> -			printf("%d/%d: snapshot - no subvolume\n", procid,
> +			printf("%d/%lld: snapshot - no subvolume\n", procid,
>  			       opno);
>  		free_pathname(&f);
>  		return;
> @@ -4862,7 +4869,7 @@ snapshot_f(int opno, long r)
>  	if (!err) {
>  		if (v) {
>  			(void)fent_to_name(&f, fep);
> -			printf("%d/%d: snapshot - no filename from %s\n",
> +			printf("%d/%lld: snapshot - no filename from %s\n",
>  			       procid, opno, f.path);
>  		}
>  		free_pathname(&f);
> @@ -4872,9 +4879,9 @@ snapshot_f(int opno, long r)
>  	if (e == BTRFS_UTIL_OK)
>  		add_to_flist(FT_SUBVOL, id, parid, 0);
>  	if (v) {
> -		printf("%d/%d: snapshot %s->%s %d(%s)\n", procid, opno,
> +		printf("%d/%lld: snapshot %s->%s %d(%s)\n", procid, opno,
>  		       f.path, newf.path, e, btrfs_util_strerror(e));
> -		printf("%d/%d: snapshot add id=%d,parent=%d\n", procid, opno,
> +		printf("%d/%lld: snapshot add id=%d,parent=%d\n", procid, opno,
>  		       id, parid);
>  	}
>  	free_pathname(&newf);
> @@ -4883,7 +4890,7 @@ snapshot_f(int opno, long r)
>  }
>  
>  void
> -stat_f(int opno, long r)
> +stat_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -4893,19 +4900,19 @@ stat_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: stat - no entries\n", procid, opno);
> +			printf("%d/%lld: stat - no entries\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
>  	e = lstat64_path(&f, &stb) < 0 ? errno : 0;
>  	check_cwd();
>  	if (v)
> -		printf("%d/%d: stat %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: stat %s %d\n", procid, opno, f.path, e);
>  	free_pathname(&f);
>  }
>  
>  void
> -subvol_create_f(int opno, long r)
> +subvol_create_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_BTRFSUTIL_H
>  	enum btrfs_util_error	e;
> @@ -4927,7 +4934,7 @@ subvol_create_f(int opno, long r)
>  	if (!err) {
>  		if (v) {
>  			(void)fent_to_name(&f, fep);
> -			printf("%d/%d: subvol_create - no filename from %s\n",
> +			printf("%d/%lld: subvol_create - no filename from %s\n",
>  			       procid, opno, f.path);
>  		}
>  		free_pathname(&f);
> @@ -4937,9 +4944,9 @@ subvol_create_f(int opno, long r)
>  	if (e == BTRFS_UTIL_OK)
>  		add_to_flist(FT_SUBVOL, id, parid, 0);
>  	if (v) {
> -		printf("%d/%d: subvol_create %s %d(%s)\n", procid, opno,
> +		printf("%d/%lld: subvol_create %s %d(%s)\n", procid, opno,
>  		       f.path, e, btrfs_util_strerror(e));
> -		printf("%d/%d: subvol_create add id=%d,parent=%d\n", procid,
> +		printf("%d/%lld: subvol_create add id=%d,parent=%d\n", procid,
>  		       opno, id, parid);
>  	}
>  	free_pathname(&f);
> @@ -4947,7 +4954,7 @@ subvol_create_f(int opno, long r)
>  }
>  
>  void
> -subvol_delete_f(int opno, long r)
> +subvol_delete_f(opnum_t opno, long r)
>  {
>  #ifdef HAVE_BTRFSUTIL_H
>  	enum btrfs_util_error	e;
> @@ -4974,10 +4981,10 @@ subvol_delete_f(int opno, long r)
>  		del_from_flist(FT_SUBVOL, fep - flist[FT_SUBVOL].fents);
>  	}
>  	if (v) {
> -		printf("%d/%d: subvol_delete %s %d(%s)\n", procid, opno, f.path,
> +		printf("%d/%lld: subvol_delete %s %d(%s)\n", procid, opno, f.path,
>  		       e, btrfs_util_strerror(e));
>  		if (e == BTRFS_UTIL_OK)
> -			printf("%d/%d: subvol_delete del entry: id=%d,parent=%d\n",
> +			printf("%d/%lld: subvol_delete del entry: id=%d,parent=%d\n",
>  			       procid, opno, oldid, oldparid);
>  	}
>  	free_pathname(&f);
> @@ -4985,7 +4992,7 @@ subvol_delete_f(int opno, long r)
>  }
>  
>  void
> -symlink_f(int opno, long r)
> +symlink_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -5008,7 +5015,7 @@ symlink_f(int opno, long r)
>  	if (!e) {
>  		if (v) {
>  			(void)fent_to_name(&f, fep);
> -			printf("%d/%d: symlink - no filename from %s\n",
> +			printf("%d/%lld: symlink - no filename from %s\n",
>  				procid, opno, f.path);
>  		}
>  		free_pathname(&f);
> @@ -5027,23 +5034,23 @@ symlink_f(int opno, long r)
>  		add_to_flist(FT_SYM, id, parid, 0);
>  	free(val);
>  	if (v) {
> -		printf("%d/%d: symlink %s %d\n", procid, opno, f.path, e);
> -		printf("%d/%d: symlink add id=%d,parent=%d\n", procid, opno, id, parid);
> +		printf("%d/%lld: symlink %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: symlink add id=%d,parent=%d\n", procid, opno, id, parid);
>  	}
>  	free_pathname(&f);
>  }
>  
>  /* ARGSUSED */
>  void
> -sync_f(int opno, long r)
> +sync_f(opnum_t opno, long r)
>  {
>  	sync();
>  	if (verbose)
> -		printf("%d/%d: sync\n", procid, opno);
> +		printf("%d/%lld: sync\n", procid, opno);
>  }
>  
>  void
> -truncate_f(int opno, long r)
> +truncate_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -5056,7 +5063,7 @@ truncate_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: truncate - no filename\n", procid, opno);
> +			printf("%d/%lld: truncate - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -5064,7 +5071,7 @@ truncate_f(int opno, long r)
>  	check_cwd();
>  	if (e > 0) {
>  		if (v)
> -			printf("%d/%d: truncate - stat64 %s failed %d\n",
> +			printf("%d/%lld: truncate - stat64 %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
> @@ -5076,13 +5083,13 @@ truncate_f(int opno, long r)
>  	e = truncate64_path(&f, off) < 0 ? errno : 0;
>  	check_cwd();
>  	if (v)
> -		printf("%d/%d: truncate %s%s %lld %d\n", procid, opno, f.path,
> +		printf("%d/%lld: truncate %s%s %lld %d\n", procid, opno, f.path,
>  		       st, (long long)off, e);
>  	free_pathname(&f);
>  }
>  
>  void
> -unlink_f(int opno, long r)
> +unlink_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -5095,7 +5102,7 @@ unlink_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_NOTDIR, r, &f, &flp, &fep, &v)) {
>  		if (v)
> -			printf("%d/%d: unlink - no file\n", procid, opno);
> +			printf("%d/%lld: unlink - no file\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -5107,16 +5114,16 @@ unlink_f(int opno, long r)
>  		del_from_flist(flp - flist, fep - flp->fents);
>  	}
>  	if (v) {
> -		printf("%d/%d: unlink %s %d\n", procid, opno, f.path, e);
> +		printf("%d/%lld: unlink %s %d\n", procid, opno, f.path, e);
>  		if (e == 0)
> -			printf("%d/%d: unlink del entry: id=%d,parent=%d\n",
> +			printf("%d/%lld: unlink del entry: id=%d,parent=%d\n",
>  				procid, opno, oldid, oldparid);
>  	}
>  	free_pathname(&f);
>  }
>  
>  void
> -unresvsp_f(int opno, long r)
> +unresvsp_f(opnum_t opno, long r)
>  {
>  	int		e;
>  	pathname_t	f;
> @@ -5131,7 +5138,7 @@ unresvsp_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: unresvsp - no filename\n", procid, opno);
> +			printf("%d/%lld: unresvsp - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -5140,14 +5147,14 @@ unresvsp_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: unresvsp - open %s failed %d\n",
> +			printf("%d/%lld: unresvsp - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: unresvsp - fstat64 %s failed %d\n",
> +			printf("%d/%lld: unresvsp - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -5162,7 +5169,7 @@ unresvsp_f(int opno, long r)
>  	fl.l_len = (off64_t)(random() % (1 << 20));
>  	e = xfsctl(f.path, fd, XFS_IOC_UNRESVSP64, &fl) < 0 ? errno : 0;
>  	if (v)
> -		printf("%d/%d: xfsctl(XFS_IOC_UNRESVSP64) %s%s %lld %lld %d\n",
> +		printf("%d/%lld: xfsctl(XFS_IOC_UNRESVSP64) %s%s %lld %lld %d\n",
>  		       procid, opno, f.path, st,
>  			(long long)off, (long long)fl.l_len, e);
>  	free_pathname(&f);
> @@ -5170,7 +5177,7 @@ unresvsp_f(int opno, long r)
>  }
>  
>  void
> -uring_read_f(int opno, long r)
> +uring_read_f(opnum_t opno, long r)
>  {
>  #ifdef URING
>  	do_uring_rw(opno, r, O_RDONLY);
> @@ -5178,7 +5185,7 @@ uring_read_f(int opno, long r)
>  }
>  
>  void
> -uring_write_f(int opno, long r)
> +uring_write_f(opnum_t opno, long r)
>  {
>  #ifdef URING
>  	do_uring_rw(opno, r, O_WRONLY);
> @@ -5186,7 +5193,7 @@ uring_write_f(int opno, long r)
>  }
>  
>  void
> -write_f(int opno, long r)
> +write_f(opnum_t opno, long r)
>  {
>  	char		*buf;
>  	int		e;
> @@ -5202,7 +5209,7 @@ write_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGm, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: write - no filename\n", procid, opno);
> +			printf("%d/%lld: write - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -5211,14 +5218,14 @@ write_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: write - open %s failed %d\n",
> +			printf("%d/%lld: write - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: write - fstat64 %s failed %d\n",
> +			printf("%d/%lld: write - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -5235,14 +5242,14 @@ write_f(int opno, long r)
>  	e = write(fd, buf, len) < 0 ? errno : 0;
>  	free(buf);
>  	if (v)
> -		printf("%d/%d: write %s%s [%lld,%d] %d\n",
> +		printf("%d/%lld: write %s%s [%lld,%d] %d\n",
>  		       procid, opno, f.path, st, (long long)off, (int)len, e);
>  	free_pathname(&f);
>  	close(fd);
>  }
>  
>  void
> -writev_f(int opno, long r)
> +writev_f(opnum_t opno, long r)
>  {
>  	char		*buf;
>  	int		e;
> @@ -5263,7 +5270,7 @@ writev_f(int opno, long r)
>  	init_pathname(&f);
>  	if (!get_fname(FT_REGm, r, &f, NULL, NULL, &v)) {
>  		if (v)
> -			printf("%d/%d: writev - no filename\n", procid, opno);
> +			printf("%d/%lld: writev - no filename\n", procid, opno);
>  		free_pathname(&f);
>  		return;
>  	}
> @@ -5272,14 +5279,14 @@ writev_f(int opno, long r)
>  	check_cwd();
>  	if (fd < 0) {
>  		if (v)
> -			printf("%d/%d: writev - open %s failed %d\n",
> +			printf("%d/%lld: writev - open %s failed %d\n",
>  				procid, opno, f.path, e);
>  		free_pathname(&f);
>  		return;
>  	}
>  	if (fstat64(fd, &stb) < 0) {
>  		if (v)
> -			printf("%d/%d: writev - fstat64 %s failed %d\n",
> +			printf("%d/%lld: writev - fstat64 %s failed %d\n",
>  				procid, opno, f.path, errno);
>  		free_pathname(&f);
>  		close(fd);
> @@ -5308,7 +5315,7 @@ writev_f(int opno, long r)
>  	free(buf);
>  	free(iov);
>  	if (v)
> -		printf("%d/%d: writev %s%s [%lld,%d,%d] %d\n",
> +		printf("%d/%lld: writev %s%s [%lld,%d,%d] %d\n",
>  		       procid, opno, f.path, st, (long long)off, (int)iovl,
>  		       iovcnt, e);
>  	free_pathname(&f);
