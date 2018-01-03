Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750748AbeACIsE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jan 2018 03:48:04 -0500
Date: Wed, 3 Jan 2018 16:48:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 6/8] fsstress: implement the clonerange/deduperange
 ioctls
Message-ID: <20180103084801.GX5123@eguan.usersys.redhat.com>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314503583.18893.15475795025536691678.stgit@magnolia>
 <20171215020731.GM6896@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215020731.GM6896@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Dec 14, 2017 at 06:07:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Mix it up a bit by reflinking and deduping data blocks when possible.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This looks fine overall, but I noticed a soft lockup bug in generic/083
and generic/269 (both test exercise ENOSPC behavior), test config is
reflink+rmapbt XFS with 4k block size. Not sure if the soft lockup is
related to the clonerange/deduperange ops in fsstress yet, will confirm
without clone/dedupe ops.

[12968.100008] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [fsstress:6903]
[12968.100038] Modules linked in: loop dm_flakey xfs ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables sunrpc 8139too 8139cp i2c_piix4 joydev mii pcspkr virtio_balloon virtio_pci serio_raw virtio_ring virtio floppy ata_generic pata_acpi
[12968.104043] irq event stamp: 23222196
[12968.104043] hardirqs last  enabled at (23222195): [<000000007d0c2e75>] restore_regs_and_return_to_kernel+0x0/0x2e
[12968.105111] hardirqs last disabled at (23222196): [<000000008f80dc57>] apic_timer_interrupt+0xa7/0xc0
[12968.105111] softirqs last  enabled at (877594): [<0000000034c53d5e>] __do_softirq+0x392/0x502
[12968.105111] softirqs last disabled at (877585): [<000000003f4d9e0b>] irq_exit+0x102/0x110
[12968.105111] CPU: 2 PID: 6903 Comm: fsstress Tainted: G        W    L   4.15.0-rc5 #10
[12968.105111] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[12968.108043] RIP: 0010:xfs_bmapi_update_map+0xc/0xc0 [xfs]
[12968.108043] RSP: 0018:ffffb8cbc2b8ba88 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff11
[12968.109028] RAX: ffffb8cbc2b8bc50 RBX: 0000000000000a40 RCX: 000000000000012b
[12968.109111] RDX: ffffb8cbc2b8bb00 RSI: ffffb8cbc2b8bb08 RDI: ffffb8cbc2b8baf8
[12968.109111] RBP: ffffb8cbc2b8bc10 R08: 000000000000012c R09: ffffb8cbc2b8bb14
[12968.109111] R10: 0000000000000000 R11: 0000000000000000 R12: ffffb8cbc2b8bb28
[12968.109111] R13: ffffb8cbc2b8bb68 R14: 000000000000012c R15: 0000000000000001
[12968.109111] FS:  00007fed71507b80(0000) GS:ffff98f457200000(0000) knlGS:0000000000000000
[12968.112047] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12968.112047] CR2: 00007fed71503000 CR3: 000000020f50d000 CR4: 00000000000006e0
[12968.113049] Call Trace:
[12968.113049]  xfs_bmapi_write+0x33e/0xcc0 [xfs]
[12968.113049]  xfs_reflink_convert_cow+0x8c/0xc0 [xfs]
[12968.113049]  ? xfs_vm_writepages+0x54/0xd0 [xfs]
[12968.113049]  xfs_submit_ioend+0x18f/0x1f0 [xfs]
[12968.113049]  xfs_vm_writepages+0xc5/0xd0 [xfs]
[12968.113049]  do_writepages+0x48/0xf0
[12968.113049]  ? __filemap_fdatawrite_range+0xb4/0x100
[12968.116073]  ? __filemap_fdatawrite_range+0xc1/0x100
[12968.116073]  __filemap_fdatawrite_range+0xc1/0x100
[12968.116073]  xfs_release+0x11c/0x160 [xfs]
[12968.117049]  __fput+0xe6/0x1f0
[12968.117049]  task_work_run+0x82/0xb0
[12968.117049]  exit_to_usermode_loop+0xa8/0xb0
[12968.117049]  syscall_return_slowpath+0x153/0x160
[12968.117049]  entry_SYSCALL_64_fastpath+0x94/0x96
[12968.117049] RIP: 0033:0x7fed70cddcb1
[12968.117049] RSP: 002b:00007ffd8d566118 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
[12968.117049] RAX: 0000000000000000 RBX: 00000000000002da RCX: 00007fed70cddcb1
[12968.117049] RDX: 0000000000c1f440 RSI: 0000000000c1e010 RDI: 0000000000000003
[12968.120048] RBP: 0000000000000003 R08: 0000000000000006 R09: 00007ffd8d56612c
[12968.120048] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000012bd3b
[12968.121048] R13: 00000000004073c0 R14: 0000000000000000 R15: 0000000000000000

> ---
> v2: don't disable broken commands, just ignore them
> ---
>  ltp/fsstress.c |  391 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 391 insertions(+)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 96f48b1..b02cb0c 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -68,7 +68,9 @@ typedef enum {
>  	OP_BULKSTAT,
>  	OP_BULKSTAT1,
>  	OP_CHOWN,
> +	OP_CLONERANGE,
>  	OP_CREAT,
> +	OP_DEDUPERANGE,
>  	OP_DREAD,
>  	OP_DWRITE,
>  	OP_FALLOCATE,
> @@ -174,7 +176,9 @@ void	awrite_f(int, long);
>  void	bulkstat_f(int, long);
>  void	bulkstat1_f(int, long);
>  void	chown_f(int, long);
> +void	clonerange_f(int, long);
>  void	creat_f(int, long);
> +void	deduperange_f(int, long);
>  void	dread_f(int, long);
>  void	dwrite_f(int, long);
>  void	fallocate_f(int, long);
> @@ -221,7 +225,9 @@ opdesc_t	ops[] = {
>  	{ OP_BULKSTAT, "bulkstat", bulkstat_f, 1, 0 },
>  	{ OP_BULKSTAT1, "bulkstat1", bulkstat1_f, 1, 0 },
>  	{ OP_CHOWN, "chown", chown_f, 3, 1 },
> +	{ OP_CLONERANGE, "clonerange", clonerange_f, 4, 1 },
>  	{ OP_CREAT, "creat", creat_f, 4, 1 },
> +	{ OP_DEDUPERANGE, "deduperange", deduperange_f, 4, 1},
>  	{ OP_DREAD, "dread", dread_f, 4, 0 },
>  	{ OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
>  	{ OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
> @@ -2189,6 +2195,391 @@ chown_f(int opno, long r)
>  	free_pathname(&f);
>  }
>  
> +/* reflink some arbitrary range of f1 to f2. */
> +void
> +clonerange_f(
> +	int			opno,
> +	long			r)
> +{
> +#ifdef FICLONERANGE
> +	struct file_clone_range	fcr;
> +	struct pathname		fpath1;
> +	struct pathname		fpath2;
> +	struct stat64		stat1;
> +	struct stat64		stat2;
> +	char			inoinfo1[1024];
> +	char			inoinfo2[1024];
> +	off64_t			lr;
> +	off64_t			off1;
> +	off64_t			off2;
> +	size_t			len;
> +	int			v1;
> +	int			v2;
> +	int			fd1;
> +	int			fd2;
> +	int			ret;
> +	int			e;
> +
> +	/* Load paths */
> +	init_pathname(&fpath1);
> +	if (!get_fname(FT_REGm, r, &fpath1, NULL, NULL, &v1)) {
> +		if (v1)
> +			printf("%d/%d: clonerange read - no filename\n",
> +				procid, opno);
> +		goto out_fpath1;
> +	}
> +
> +	init_pathname(&fpath2);
> +	if (!get_fname(FT_REGm, random(), &fpath2, NULL, NULL, &v2)) {
> +		if (v2)
> +			printf("%d/%d: clonerange write - no filename\n",
> +				procid, opno);
> +		goto out_fpath2;
> +	}
> +
> +	/* Open files */
> +	fd1 = open_path(&fpath1, O_RDONLY);
> +	e = fd1 < 0 ? errno : 0;
> +	check_cwd();
> +	if (fd1 < 0) {
> +		if (v1)
> +			printf("%d/%d: clonerange read - open %s failed %d\n",
> +				procid, opno, fpath1.path, e);
> +		goto out_fpath2;
> +	}
> +
> +	fd2 = open_path(&fpath2, O_WRONLY);
> +	e = fd2 < 0 ? errno : 0;
> +	check_cwd();
> +	if (fd2 < 0) {
> +		if (v2)
> +			printf("%d/%d: clonerange write - open %s failed %d\n",
> +				procid, opno, fpath2.path, e);
> +		goto out_fd1;
> +	}
> +
> +	/* Get file stats */
> +	if (fstat64(fd1, &stat1) < 0) {
> +		if (v1)
> +			printf("%d/%d: clonerange read - fstat64 %s failed %d\n",
> +				procid, opno, fpath1.path, errno);
> +		goto out_fd2;
> +	}
> +	inode_info(inoinfo1, sizeof(inoinfo1), &stat1, v1);
> +
> +	if (fstat64(fd2, &stat2) < 0) {
> +		if (v2)
> +			printf("%d/%d: clonerange write - fstat64 %s failed %d\n",
> +				procid, opno, fpath2.path, errno);
> +		goto out_fd2;
> +	}
> +	inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v1);
                                                      ^^^^ should be v2?
> +
> +	/* Calculate offsets */
> +	len = (random() % FILELEN_MAX) + 1;
> +	len &= ~(stat1.st_blksize - 1);
> +	if (len == 0)
> +		len = stat1.st_blksize;
> +	if (len > stat1.st_size)
> +		len = stat1.st_size;
> +
> +	lr = ((__int64_t)random() << 32) + random();
> +	if (stat1.st_size == len)
> +		off1 = 0;
> +	else
> +		off1 = (off64_t)(lr % MIN(stat1.st_size - len, MAXFSIZE));
> +	off1 %= maxfsize;
> +	off1 &= ~(stat1.st_blksize - 1);

Seems that the offset and len are not required to be block size aligned,
mind adding some comments on the consideration on offset and len, in
both clonerange and deduperange cases?

Thanks,
Eryu

> +
> +	/*
> +	 * If srcfile == destfile, randomly generate destination ranges
> +	 * until we find one that doesn't overlap the source range.
> +	 */
> +	do {
> +		lr = ((__int64_t)random() << 32) + random();
> +		off2 = (off64_t)(lr % MIN(stat2.st_size + (1024 * 1024), MAXFSIZE));
> +		off2 %= maxfsize;
> +		off2 &= ~(stat2.st_blksize - 1);
> +	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
> +
> +	/* Clone data blocks */
> +	fcr.src_fd = fd1;
> +	fcr.src_offset = off1;
> +	fcr.src_length = len;
> +	fcr.dest_offset = off2;
> +
> +	ret = ioctl(fd2, FICLONERANGE, &fcr);
> +	e = ret < 0 ? errno : 0;
> +	if (v1 || v2) {
> +		printf("%d/%d: clonerange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
> +			procid, opno,
> +			fpath1.path, inoinfo1, (long long)off1, (long long)len,
> +			fpath2.path, inoinfo2, (long long)off2, (long long)len);
> +
> +		if (ret < 0)
> +			printf(" error %d", e);
> +		printf("\n");
> +	}
> +
> +out_fd2:
> +	close(fd2);
> +out_fd1:
> +	close(fd1);
> +out_fpath2:
> +	free_pathname(&fpath2);
> +out_fpath1:
> +	free_pathname(&fpath1);
> +#endif
> +}
> +
> +/* dedupe some arbitrary range of f1 to f2...fn. */
> +void
> +deduperange_f(
> +	int			opno,
> +	long			r)
> +{
> +#ifdef FIDEDUPERANGE
> +#define INFO_SZ			1024
> +	struct file_dedupe_range *fdr;
> +	struct pathname		*fpath;
> +	struct stat64		*stat;
> +	char			*info;
> +	off64_t			*off;
> +	int			*v;
> +	int			*fd;
> +	int			nr;
> +	off64_t			lr;
> +	size_t			len;
> +	int			ret;
> +	int			i;
> +	int			e;
> +
> +	if (flist[FT_REG].nfiles < 2)
> +		return;
> +
> +	/* Pick somewhere between 2 and 128 files. */
> +	do {
> +		nr = random() % (flist[FT_REG].nfiles + 1);
> +	} while (nr < 2 || nr > 128);
> +
> +	/* Alloc memory */
> +	fdr = malloc(nr * sizeof(struct file_dedupe_range_info) +
> +		     sizeof(struct file_dedupe_range));
> +	if (!fdr) {
> +		printf("%d/%d: line %d error %d\n",
> +			procid, opno, __LINE__, errno);
> +		return;
> +	}
> +	memset(fdr, 0, (nr * sizeof(struct file_dedupe_range_info) +
> +			sizeof(struct file_dedupe_range)));
> +
> +	fpath = calloc(nr, sizeof(struct pathname));
> +	if (!fpath) {
> +		printf("%d/%d: line %d error %d\n",
> +			procid, opno, __LINE__, errno);
> +		goto out_fdr;
> +	}
> +
> +	stat = calloc(nr, sizeof(struct stat64));
> +	if (!stat) {
> +		printf("%d/%d: line %d error %d\n",
> +			procid, opno, __LINE__, errno);
> +		goto out_paths;
> +	}
> +
> +	info = calloc(nr, INFO_SZ);
> +	if (!info) {
> +		printf("%d/%d: line %d error %d\n",
> +			procid, opno, __LINE__, errno);
> +		goto out_stats;
> +	}
> +
> +	off = calloc(nr, sizeof(off64_t));
> +	if (!off) {
> +		printf("%d/%d: line %d error %d\n",
> +			procid, opno, __LINE__, errno);
> +		goto out_info;
> +	}
> +
> +	v = calloc(nr, sizeof(int));
> +	if (!v) {
> +		printf("%d/%d: line %d error %d\n",
> +			procid, opno, __LINE__, errno);
> +		goto out_offsets;
> +	}
> +	fd = calloc(nr, sizeof(int));
> +	if (!fd) {
> +		printf("%d/%d: line %d error %d\n",
> +			procid, opno, __LINE__, errno);
> +		goto out_v;
> +	}
> +	memset(fd, 0xFF, nr * sizeof(int));
> +
> +	/* Get paths for all files */
> +	for (i = 0; i < nr; i++)
> +		init_pathname(&fpath[i]);
> +
> +	if (!get_fname(FT_REGm, r, &fpath[0], NULL, NULL, &v[0])) {
> +		if (v[0])
> +			printf("%d/%d: deduperange read - no filename\n",
> +				procid, opno);
> +		goto out_pathnames;
> +	}
> +
> +	for (i = 1; i < nr; i++) {
> +		if (!get_fname(FT_REGm, random(), &fpath[i], NULL, NULL, &v[i])) {
> +			if (v[i])
> +				printf("%d/%d: deduperange write - no filename\n",
> +					procid, opno);
> +			goto out_pathnames;
> +		}
> +	}
> +
> +	/* Open files */
> +	fd[0] = open_path(&fpath[0], O_RDONLY);
> +	e = fd[0] < 0 ? errno : 0;
> +	check_cwd();
> +	if (fd[0] < 0) {
> +		if (v[0])
> +			printf("%d/%d: deduperange read - open %s failed %d\n",
> +				procid, opno, fpath[0].path, e);
> +		goto out_pathnames;
> +	}
> +
> +	for (i = 1; i < nr; i++) {
> +		fd[i] = open_path(&fpath[i], O_WRONLY);
> +		e = fd[i] < 0 ? errno : 0;
> +		check_cwd();
> +		if (fd[i] < 0) {
> +			if (v[i])
> +				printf("%d/%d: deduperange write - open %s failed %d\n",
> +					procid, opno, fpath[i].path, e);
> +			goto out_fds;
> +		}
> +	}
> +
> +	/* Get file stats */
> +	if (fstat64(fd[0], &stat[0]) < 0) {
> +		if (v[0])
> +			printf("%d/%d: deduperange read - fstat64 %s failed %d\n",
> +				procid, opno, fpath[0].path, errno);
> +		goto out_fds;
> +	}
> +
> +	inode_info(&info[0], INFO_SZ, &stat[0], v[0]);
> +
> +	for (i = 1; i < nr; i++) {
> +		if (fstat64(fd[i], &stat[i]) < 0) {
> +			if (v[i])
> +				printf("%d/%d: deduperange write - fstat64 %s failed %d\n",
> +					procid, opno, fpath[i].path, errno);
> +			goto out_fds;
> +		}
> +		inode_info(&info[i * INFO_SZ], INFO_SZ, &stat[i], v[i]);
> +	}
> +
> +	/* Never try to dedupe more than half of the src file. */
> +	len = (random() % FILELEN_MAX) + 1;
> +	len &= ~(stat[0].st_blksize - 1);
> +	if (len == 0)
> +		len = stat[0].st_blksize / 2;
> +	if (len > stat[0].st_size / 2)
> +		len = stat[0].st_size / 2;
> +
> +	/* Calculate offsets */
> +	lr = ((__int64_t)random() << 32) + random();
> +	if (stat[0].st_size == len)
> +		off[0] = 0;
> +	else
> +		off[0] = (off64_t)(lr % MIN(stat[0].st_size - len, MAXFSIZE));
> +	off[0] %= maxfsize;
> +	off[0] &= ~(stat[0].st_blksize - 1);
> +
> +	/*
> +	 * If srcfile == destfile[i], randomly generate destination ranges
> +	 * until we find one that doesn't overlap the source range.
> +	 */
> +	for (i = 1; i < nr; i++) {
> +		int	tries = 0;
> +
> +		do {
> +			lr = ((__int64_t)random() << 32) + random();
> +			if (stat[i].st_size <= len)
> +				off[i] = 0;
> +			else
> +				off[i] = (off64_t)(lr % MIN(stat[i].st_size - len, MAXFSIZE));
> +			off[i] %= maxfsize;
> +			off[i] &= ~(stat[i].st_blksize - 1);
> +		} while (stat[0].st_ino == stat[i].st_ino &&
> +			 llabs(off[i] - off[0]) < len &&
> +			 tries++ < 10);
> +	}
> +
> +	/* Clone data blocks */
> +	fdr->src_offset = off[0];
> +	fdr->src_length = len;
> +	fdr->dest_count = nr - 1;
> +	for (i = 1; i < nr; i++) {
> +		fdr->info[i - 1].dest_fd = fd[i];
> +		fdr->info[i - 1].dest_offset = off[i];
> +	}
> +
> +	ret = ioctl(fd[0], FIDEDUPERANGE, fdr);
> +	e = ret < 0 ? errno : 0;
> +	if (v[0]) {
> +		printf("%d/%d: deduperange from %s%s [%lld,%lld]",
> +			procid, opno,
> +			fpath[0].path, &info[0], (long long)off[0],
> +			(long long)len);
> +		if (ret < 0)
> +			printf(" error %d", e);
> +		printf("\n");
> +	}
> +	if (ret < 0)
> +		goto out_fds;
> +
> +	for (i = 1; i < nr; i++) {
> +		e = fdr->info[i - 1].status < 0 ? fdr->info[i - 1].status : 0;
> +		if (v[i]) {
> +			printf("%d/%d: ...to %s%s [%lld,%lld]",
> +				procid, opno,
> +				fpath[i].path, &info[i * INFO_SZ],
> +				(long long)off[i], (long long)len);
> +			if (fdr->info[i - 1].status < 0)
> +				printf(" error %d", e);
> +			if (fdr->info[i - 1].status == FILE_DEDUPE_RANGE_SAME)
> +				printf(" %llu bytes deduplicated",
> +					fdr->info[i - 1].bytes_deduped);
> +			if (fdr->info[i - 1].status == FILE_DEDUPE_RANGE_DIFFERS)
> +				printf(" differed");
> +			printf("\n");
> +		}
> +	}
> +
> +out_fds:
> +	for (i = 0; i < nr; i++)
> +		if (fd[i] >= 0)
> +			close(fd[i]);
> +out_pathnames:
> +	for (i = 0; i < nr; i++)
> +		free_pathname(&fpath[i]);
> +
> +	free(fd);
> +out_v:
> +	free(v);
> +out_offsets:
> +	free(off);
> +out_info:
> +	free(info);
> +out_stats:
> +	free(stat);
> +out_paths:
> +	free(fpath);
> +out_fdr:
> +	free(fdr);
> +#endif
> +}
> +
>  void
>  setxattr_f(int opno, long r)
>  {
