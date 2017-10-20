Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752649AbdJTLXt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:23:49 -0400
Date: Fri, 20 Oct 2017 07:23:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfsprogs: explicitly cast troublesome types to match
 printf format specifiers
Message-ID: <20171020112345.GB13669@bfoster.bfoster>
References: <150837629129.31583.8002405051612025341.stgit@magnolia>
 <150837630007.31583.276276066789692232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150837630007.31583.276276066789692232.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Oct 18, 2017 at 06:25:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Certain system-defined types (__u64, __s64, __nlink_t, __ino64_t,
> __off64_t, __blkcnt64_t) don't have a consistent definition across
> different architectures, so wherever we use a printf format specifier on
> such a variable, we have to typecast the variable or else the compiler
> will complain.
> 
> IOWs this fixes build warnings on ppc64le.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  io/fiemap.c          |   37 +++++++++++++++++++++----------------
>  io/open.c            |    4 ++--
>  io/stat.c            |   26 +++++++++++++-------------
>  repair/attr_repair.c |    6 ++++--
>  repair/dinode.c      |    3 ++-
>  repair/phase6.c      |    4 ++--
>  repair/scan.c        |    9 ++++++---
>  7 files changed, 50 insertions(+), 39 deletions(-)
> 
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index e6fd66d..bdcfacd 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -67,16 +67,18 @@ print_hole(
>  
>  	   if (plain) {
>  		printf("\t%d: [%llu..%llu]: hole", cur_extent,
> -		       llast, lstart - 1ULL);
> +		       (unsigned long long)llast, lstart - 1ULL);
>  		if (lflag)
> -			printf(_(" %llu blocks\n"), lstart - llast);
> +			printf(_(" %llu blocks\n"),
> +			       (unsigned long long)lstart - llast);
>  		else
>  			printf("\n");
>  	   } else {
> -		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", llast,
> -			 lstart - 1ULL);
> +		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
> +			 (unsigned long long)llast, lstart - 1ULL);
>  		printf("%4d: %-*s %-*s %*llu\n", cur_extent, foff_w, lbuf,
> -		       boff_w, _("hole"), tot_w, lstart - llast);
> +		       boff_w, _("hole"), tot_w,
> +		       (unsigned long long)lstart - llast);
>  	   }
>  
>  
> @@ -125,12 +127,13 @@ print_verbose(
>  	if (cur_extent == max_extents)
>  		return 1;
>  
> -	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
> -		 lstart + len - 1ULL);
> -	snprintf(bbuf, sizeof(bbuf), "%llu..%llu", block, block + len - 1ULL);
> +	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:",
> +		 (unsigned long long)lstart, lstart + len - 1ULL);
> +	snprintf(bbuf, sizeof(bbuf), "%llu..%llu",
> +		 (unsigned long long)block, block + len - 1ULL);
>  	snprintf(flgbuf, sizeof(flgbuf), "0x%x", extent->fe_flags);
>  	printf("%4d: %-*s %-*s %*llu %*s\n", cur_extent, foff_w, lbuf,
> -	       boff_w, bbuf, tot_w, len, flg_w, flgbuf);
> +	       boff_w, bbuf, tot_w, (unsigned long long)len, flg_w, flgbuf);
>  
>  	return 2;
>  }
> @@ -161,11 +164,11 @@ print_plain(
>  		return 1;
>  
>  	printf("\t%d: [%llu..%llu]: %llu..%llu", cur_extent,
> -	       lstart, lstart + len - 1ULL, block,
> -	       block + len - 1ULL);
> +	       (unsigned long long)lstart, lstart + len - 1ULL,
> +	       (unsigned long long)block, block + len - 1ULL);
>  
>  	if (lflag)
> -		printf(_(" %llu blocks\n"), len);
> +		printf(_(" %llu blocks\n"), (unsigned long long)len);
>  	else
>  		printf("\n");
>  	return 2;
> @@ -198,10 +201,12 @@ calc_print_format(
>  		len = BTOBBT(extent->fe_length);
>  		block = BTOBBT(extent->fe_physical);
>  
> -		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]", logical,
> -			 logical + len - 1);
> -		snprintf(bbuf, sizeof(bbuf), "%llu..%llu", block,
> -			 block + len - 1);
> +		snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]",
> +			 (unsigned long long)logical,
> +			 (unsigned long long)logical + len - 1);
> +		snprintf(bbuf, sizeof(bbuf), "%llu..%llu",
> +			 (unsigned long long)block,
> +			 (unsigned long long)block + len - 1);
>  		*foff_w = max(*foff_w, strlen(lbuf));
>  		*boff_w = max(*boff_w, strlen(bbuf));
>  		*tot_w = max(*tot_w, numlen(len, 10));
> diff --git a/io/open.c b/io/open.c
> index f2ea7c3..2cce045 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -762,14 +762,14 @@ inode_f(
>  
>  	if (verbose && result_ino) {
>  		/* Requested verbose and we have an answer */
> -		printf("%llu:%d\n", result_ino,
> +		printf("%llu:%d\n", (unsigned long long)result_ino,
>  			result_ino > XFS_MAXINUMBER_32 ? 64 : 32);
>  	} else if (userino == NULLFSINO) {
>  		/* Just checking 32 or 64 bit presence, non-verbose */
>  		printf("%d\n", result_ino > XFS_MAXINUMBER_32 ? 1 : 0);
>  	} else {
>  		/* We asked about a specific inode, non-verbose */
> -		printf("%llu\n", result_ino);
> +		printf("%llu\n", (unsigned long long)result_ino);
>  	}
>  
>  	return 0;
> diff --git a/io/stat.c b/io/stat.c
> index 060ff83..b97cced 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -69,14 +69,14 @@ filetype(mode_t mode)
>  static int
>  dump_raw_stat(struct stat *st)
>  {
> -	printf("stat.blksize = %lu\n", st->st_blksize);
> -	printf("stat.nlink = %lu\n", st->st_nlink);
> +	printf("stat.blksize = %lu\n", (unsigned long)st->st_blksize);
> +	printf("stat.nlink = %lu\n", (unsigned long)st->st_nlink);
>  	printf("stat.uid = %u\n", st->st_uid);
>  	printf("stat.gid = %u\n", st->st_gid);
>  	printf("stat.mode: 0%o\n", st->st_mode);
> -	printf("stat.ino = %lu\n", st->st_ino);
> -	printf("stat.size = %lu\n", st->st_size);
> -	printf("stat.blocks = %lu\n", st->st_blocks);
> +	printf("stat.ino = %llu\n", (unsigned long long)st->st_ino);
> +	printf("stat.size = %lld\n", (long long)st->st_size);
> +	printf("stat.blocks = %lld\n", (long long)st->st_blocks);
>  	printf("stat.atime.tv_sec = %ld\n", st->st_atim.tv_sec);
>  	printf("stat.atime.tv_nsec = %ld\n", st->st_atim.tv_nsec);
>  	printf("stat.ctime.tv_sec = %ld\n", st->st_ctim.tv_sec);
> @@ -273,21 +273,21 @@ dump_raw_statx(struct statx *stx)
>  {
>  	printf("stat.mask = 0x%x\n", stx->stx_mask);
>  	printf("stat.blksize = %u\n", stx->stx_blksize);
> -	printf("stat.attributes = 0x%llx\n", stx->stx_attributes);
> +	printf("stat.attributes = 0x%llx\n", (unsigned long long)stx->stx_attributes);
>  	printf("stat.nlink = %u\n", stx->stx_nlink);
>  	printf("stat.uid = %u\n", stx->stx_uid);
>  	printf("stat.gid = %u\n", stx->stx_gid);
>  	printf("stat.mode: 0%o\n", stx->stx_mode);
> -	printf("stat.ino = %llu\n", stx->stx_ino);
> -	printf("stat.size = %llu\n", stx->stx_size);
> -	printf("stat.blocks = %llu\n", stx->stx_blocks);
> -	printf("stat.atime.tv_sec = %lld\n", stx->stx_atime.tv_sec);
> +	printf("stat.ino = %llu\n", (unsigned long long)stx->stx_ino);
> +	printf("stat.size = %llu\n", (unsigned long long)stx->stx_size);
> +	printf("stat.blocks = %llu\n", (unsigned long long)stx->stx_blocks);
> +	printf("stat.atime.tv_sec = %lld\n", (long long)stx->stx_atime.tv_sec);
>  	printf("stat.atime.tv_nsec = %d\n", stx->stx_atime.tv_nsec);
> -	printf("stat.btime.tv_sec = %lld\n", stx->stx_btime.tv_sec);
> +	printf("stat.btime.tv_sec = %lld\n", (long long)stx->stx_btime.tv_sec);
>  	printf("stat.btime.tv_nsec = %d\n", stx->stx_btime.tv_nsec);
> -	printf("stat.ctime.tv_sec = %lld\n", stx->stx_ctime.tv_sec);
> +	printf("stat.ctime.tv_sec = %lld\n", (long long)stx->stx_ctime.tv_sec);
>  	printf("stat.ctime.tv_nsec = %d\n", stx->stx_ctime.tv_nsec);
> -	printf("stat.mtime.tv_sec = %lld\n", stx->stx_mtime.tv_sec);
> +	printf("stat.mtime.tv_sec = %lld\n", (long long)stx->stx_mtime.tv_sec);
>  	printf("stat.mtime.tv_nsec = %d\n", stx->stx_mtime.tv_nsec);
>  	printf("stat.rdev_major = %u\n", stx->stx_rdev_major);
>  	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 9ec2231..8b1b8a7 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -943,14 +943,16 @@ __check_attr_header(
>  	if (be64_to_cpu(info->owner) != ino) {
>  		do_warn(
>  _("expected owner inode %" PRIu64 ", got %llu, attr block %" PRIu64 "\n"),
> -			ino, be64_to_cpu(info->owner), bp->b_bn);
> +			ino, (unsigned long long)be64_to_cpu(info->owner),
> +			bp->b_bn);
>  		return 1;
>  	}
>  	/* verify block number */
>  	if (be64_to_cpu(info->blkno) != bp->b_bn) {
>  		do_warn(
>  _("expected block %" PRIu64 ", got %llu, inode %" PRIu64 "attr block\n"),
> -			bp->b_bn, be64_to_cpu(info->blkno), ino);
> +			bp->b_bn, (unsigned long long)be64_to_cpu(info->blkno),
> +			ino);
>  		return 1;
>  	}
>  	/* verify uuid */
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 15ba8cc..e7de6d4 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2330,7 +2330,8 @@ process_dinode_int(xfs_mount_t *mp,
>  			if (!uncertain)
>  				do_warn(
>  _("inode identifier %llu mismatch on inode %" PRIu64 "\n"),
> -					be64_to_cpu(dino->di_ino), lino);
> +					(unsigned long long)be64_to_cpu(dino->di_ino),
> +					lino);
>  			if (verify_mode)
>  				return 1;
>  			goto clear_bad_out;
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 4279d2a..37505a8 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1917,14 +1917,14 @@ __check_dir3_header(
>  	if (be64_to_cpu(owner) != ino) {
>  		do_warn(
>  _("expected owner inode %" PRIu64 ", got %llu, directory block %" PRIu64 "\n"),
> -			ino, be64_to_cpu(owner), bp->b_bn);
> +			ino, (unsigned long long)be64_to_cpu(owner), bp->b_bn);
>  		return 1;
>  	}
>  	/* verify block number */
>  	if (be64_to_cpu(blkno) != bp->b_bn) {
>  		do_warn(
>  _("expected block %" PRIu64 ", got %llu, directory inode %" PRIu64 "\n"),
> -			bp->b_bn, be64_to_cpu(blkno), ino);
> +			bp->b_bn, (unsigned long long)be64_to_cpu(blkno), ino);
>  		return 1;
>  	}
>  	/* verify uuid */
> diff --git a/repair/scan.c b/repair/scan.c
> index 9c0f2d6..22c7331 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -227,7 +227,9 @@ _("expected level %d got %d in inode %" PRIu64 ", (%s fork) bmbt block %" PRIu64
>  		if (be64_to_cpu(block->bb_u.l.bb_owner) != ino) {
>  			do_warn(
>  _("expected owner inode %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
> -				ino, be64_to_cpu(block->bb_u.l.bb_owner), bno);
> +				ino,
> +				(unsigned long long)be64_to_cpu(block->bb_u.l.bb_owner),
> +				bno);
>  			return 1;
>  		}
>  		/* verify block number */
> @@ -236,7 +238,8 @@ _("expected owner inode %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
>  			do_warn(
>  _("expected block %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
>  				XFS_FSB_TO_DADDR(mp, bno),
> -				be64_to_cpu(block->bb_u.l.bb_blkno), bno);
> +				(unsigned long long)be64_to_cpu(block->bb_u.l.bb_blkno),
> +				bno);
>  			return 1;
>  		}
>  		/* verify uuid */
> @@ -1587,7 +1590,7 @@ import_single_ino_chunk(
>  _("ir_holemask/ir_free mismatch, %s chunk %d/%u, holemask 0x%x free 0x%llx\n"),
>  					inobt_name, agno, ino,
>  					be16_to_cpu(rp->ir_u.sp.ir_holemask),
> -					be64_to_cpu(rp->ir_free));
> +					(unsigned long long)be64_to_cpu(rp->ir_free));
>  				suspect++;
>  			}
>  			if (!suspect && ino_rec)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
