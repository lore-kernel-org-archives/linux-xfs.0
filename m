Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43020 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFYXxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 19:53:14 -0400
Date: Tue, 25 Jun 2019 16:53:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/12] libfrog: refactor open-coded INUMBERS calls
Message-ID: <20190625235305.GA2259292@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104942067.1172531.15834435379895326132.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156104942067.1172531.15834435379895326132.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 09:50:20AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the INUMBERS ioctl callsites into helper functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/xfrog.h    |    4 ++++
>  io/imap.c          |   32 +++++++++++++++-----------------
>  io/open.c          |   20 ++++++++------------
>  libfrog/bulkstat.c |   19 +++++++++++++++++++
>  scrub/fscounters.c |   18 +++++++-----------
>  scrub/inodes.c     |   23 +++++++++--------------
>  6 files changed, 62 insertions(+), 54 deletions(-)
> 
> 
> diff --git a/include/xfrog.h b/include/xfrog.h
> index 176a2e1d..dab1214d 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -107,4 +107,8 @@ int xfrog_bulkstat_single(struct xfrog *froggie, uint64_t ino,
>  int xfrog_bulkstat(struct xfrog *froggie, uint64_t *lastino, uint32_t icount,
>  		struct xfs_bstat *ubuffer, uint32_t *ocount);
>  
> +struct xfs_inogrp;
> +int xfrog_inumbers(struct xfrog *froggie, uint64_t *lastino, uint32_t icount,
> +		struct xfs_inogrp *ubuffer, uint32_t *ocount);
> +
>  #endif	/* __XFROG_H__ */
> diff --git a/io/imap.c b/io/imap.c
> index fbc8e9e1..05a4985d 100644
> --- a/io/imap.c
> +++ b/io/imap.c
> @@ -8,18 +8,20 @@
>  #include "input.h"
>  #include "init.h"
>  #include "io.h"
> +#include "xfrog.h"
>  
>  static cmdinfo_t imap_cmd;
>  
>  static int
>  imap_f(int argc, char **argv)
>  {
> -	int		count;
> -	int		nent;
> -	int		i;
> -	__u64		last = 0;
> -	xfs_inogrp_t	*t;
> -	xfs_fsop_bulkreq_t bulkreq;
> +	struct xfrog		frog = XFROG_INIT(file->fd);
> +	struct xfs_inogrp	*t;
> +	uint64_t		last = 0;
> +	uint32_t		count;
> +	uint32_t		nent;
> +	int			i;
> +	int			error;
>  
>  	if (argc != 2)
>  		nent = 1;
> @@ -30,14 +32,8 @@ imap_f(int argc, char **argv)
>  	if (!t)
>  		return 0;
>  
> -	bulkreq.lastip  = &last;
> -	bulkreq.icount  = nent;
> -	bulkreq.ubuffer = (void *)t;
> -	bulkreq.ocount  = &count;
> -
> -	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
> -		if (count == 0)
> -			goto out_free;
> +	while ((error = xfrog_inumbers(&frog, &last, nent, t, &count)) == 0 &&
> +	       count > 0) {
>  		for (i = 0; i < count; i++) {
>  			printf(_("ino %10llu count %2d mask %016llx\n"),
>  				(unsigned long long)t[i].xi_startino,
> @@ -45,9 +41,11 @@ imap_f(int argc, char **argv)
>  				(unsigned long long)t[i].xi_allocmask);
>  		}
>  	}
> -	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> -	exitcode = 1;
> -out_free:
> +
> +	if (error) {
> +		perror("xfsctl(XFS_IOC_FSINUMBERS)");
> +		exitcode = 1;
> +	}
>  	free(t);
>  	return 0;
>  }
> diff --git a/io/open.c b/io/open.c
> index 36e07dc3..35bcd23a 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -669,24 +669,20 @@ inode_help(void)
>  "\n"));
>  }
>  
> +#define IGROUP_NR	(1024)
>  static __u64
>  get_last_inode(void)
>  {
> -	__u64			lastip = 0;
> -	__u64			lastgrp = 0;
> -	__s32			ocount = 0;
> +	struct xfrog		frog = XFROG_INIT(file->fd);
> +	uint64_t		lastip = 0;
> +	uint32_t		lastgrp = 0;
> +	uint32_t		ocount = 0;
>  	__u64			last_ino;
> -	struct xfs_inogrp	igroup[1024];
> -	struct xfs_fsop_bulkreq	bulkreq;
> -
> -	bulkreq.lastip = &lastip;
> -	bulkreq.ubuffer = &igroup;
> -	bulkreq.icount = sizeof(igroup) / sizeof(struct xfs_inogrp);
> -	bulkreq.ocount = &ocount;
> +	struct xfs_inogrp	igroup[IGROUP_NR];
>  
>  	for (;;) {
> -		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
> -				&bulkreq)) {
> +		if (xfrog_inumbers(&frog, &lastip, IGROUP_NR, igroup,
> +					&ocount)) {
>  			perror("XFS_IOC_FSINUMBERS");
>  			return 0;
>  		}
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 30a9e6bc..9ce238b8 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -42,3 +42,22 @@ xfrog_bulkstat(
>  
>  	return ioctl(froggie->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
>  }
> +
> +/* Query inode allocation bitmask information. */
> +int
> +xfrog_inumbers(
> +	struct xfrog		*froggie,
> +	uint64_t		*lastino,
> +	uint32_t		icount,
> +	struct xfs_inogrp	*ubuffer,
> +	uint32_t		*ocount)
> +{
> +	struct xfs_fsop_bulkreq	bulkreq = {
> +		.lastip		= (__u64 *)lastino,
> +		.icount		= icount,
> +		.ubuffer	= ubuffer,
> +		.ocount		= (__s32 *)ocount,
> +	};
> +
> +	return ioctl(froggie->fd, XFS_IOC_FSINUMBERS, &bulkreq);
> +}
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index adb79b50..cd216b30 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -15,6 +15,7 @@
>  #include "xfs_scrub.h"
>  #include "common.h"
>  #include "fscounters.h"
> +#include "xfrog.h"
>  
>  /*
>   * Filesystem counter collection routines.  We can count the number of
> @@ -41,26 +42,21 @@ xfs_count_inodes_range(
>  	uint64_t		last_ino,
>  	uint64_t		*count)
>  {
> -	struct xfs_fsop_bulkreq	igrpreq = {NULL};
>  	struct xfs_inogrp	inogrp;
> -	__u64			igrp_ino;
> +	uint64_t		igrp_ino;
>  	uint64_t		nr = 0;
> -	__s32			igrplen = 0;
> +	uint32_t		igrplen = 0;
>  	int			error;
>  
>  	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
>  	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
>  
> -	igrpreq.lastip  = &igrp_ino;
> -	igrpreq.icount  = 1;
> -	igrpreq.ubuffer = &inogrp;
> -	igrpreq.ocount  = &igrplen;
> -
>  	igrp_ino = first_ino;
> -	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
> -	while (!error && igrplen && inogrp.xi_startino < last_ino) {
> +	while (!(error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
> +			&igrplen))) {
> +		if (igrplen == 0 || inogrp.xi_startino >= last_ino)
> +			break;
>  		nr += inogrp.xi_alloccount;
> -		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
>  	}
>  
>  	if (error) {
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 09dd0055..dea925be 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -90,17 +90,16 @@ xfs_iterate_inodes_range(
>  	xfs_inode_iter_fn	fn,
>  	void			*arg)
>  {
> -	struct xfs_fsop_bulkreq	igrpreq = {NULL};
>  	struct xfs_handle	handle;
>  	struct xfs_inogrp	inogrp;
>  	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
>  	char			idescr[DESCR_BUFSZ];
>  	char			buf[DESCR_BUFSZ];
>  	struct xfs_bstat	*bs;
> -	__u64			igrp_ino;
> +	uint64_t		igrp_ino;
>  	uint64_t		ino;
>  	uint32_t		bulklen = 0;
> -	__s32			igrplen = 0;
> +	uint32_t		igrplen = 0;
>  	bool			moveon = true;
>  	int			i;
>  	int			error;
> @@ -109,11 +108,6 @@ xfs_iterate_inodes_range(
>  
>  	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
>  
> -	igrpreq.lastip  = &igrp_ino;
> -	igrpreq.icount  = 1;
> -	igrpreq.ubuffer = &inogrp;
> -	igrpreq.ocount  = &igrplen;
> -
>  	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
>  	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
>  			sizeof(handle.ha_fid.fid_len);
> @@ -121,8 +115,11 @@ xfs_iterate_inodes_range(
>  
>  	/* Find the inode chunk & alloc mask */
>  	igrp_ino = first_ino;
> -	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
> -	while (!error && igrplen) {
> +	while (!(error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
> +			&igrplen))) {
> +		if (igrplen == 0)
> +			break;
> +
>  		/* Load the inodes. */
>  		ino = inogrp.xi_startino - 1;
>  
> @@ -131,7 +128,7 @@ xfs_iterate_inodes_range(
>  		 * there are more than 64 inodes per block.  Skip these.
>  		 */
>  		if (inogrp.xi_alloccount == 0)
> -			goto igrp_retry;
> +			continue;
>  		error = xfrog_bulkstat(&ctx->mnt, &ino, inogrp.xi_alloccount,
>  				bstat, &bulklen);
>  		if (error)
> @@ -155,7 +152,7 @@ xfs_iterate_inodes_range(
>  				stale_count++;
>  				if (stale_count < 30) {
>  					igrp_ino = inogrp.xi_startino;
> -					goto igrp_retry;
> +					continue;

NAK.

This doesn't continue the outer loop like the old code did.

--D

>  				}
>  				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
>  						(uint64_t)bs->bs_ino);
> @@ -177,8 +174,6 @@ _("Changed too many times during scan; giving up."));
>  		}
>  
>  		stale_count = 0;
> -igrp_retry:
> -		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
>  	}
>  
>  err:
> 
