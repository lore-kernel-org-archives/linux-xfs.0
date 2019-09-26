Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB92C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 21:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C50022459
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 21:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfIZVsj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 17:48:39 -0400
Received: from sandeen.net ([63.231.237.45]:41436 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfIZVsj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 17:48:39 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BAE8833FD;
        Thu, 26 Sep 2019 16:48:28 -0500 (CDT)
Subject: Re: [PATCH 4/4] misc: convert from XFS_IOC_FSINUMBERS to
 XFS_IOC_INUMBERS
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156944714720.297379.5532805895370082740.stgit@magnolia>
 <156944717162.297379.1042436133617221738.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <b76458e8-820c-1c0d-486e-53ef2b3a0680@sandeen.net>
Date:   Thu, 26 Sep 2019 16:48:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <156944717162.297379.1042436133617221738.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/25/19 4:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert all programs to use the v5 inumbers ioctl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/imap.c          |   26 +++++-----
>  io/open.c          |   34 ++++++++-----
>  libfrog/bulkstat.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++------
>  libfrog/bulkstat.h |   10 +++-
>  scrub/fscounters.c |   21 +++++---
>  scrub/inodes.c     |   46 ++++++++++--------
>  6 files changed, 198 insertions(+), 71 deletions(-)

...

> diff --git a/io/open.c b/io/open.c
> index e0e7fb3e..3c6113a1 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -681,39 +681,47 @@ static __u64
>  get_last_inode(void)
>  {
>  	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> -	uint64_t		lastip = 0;
> +	struct xfs_inumbers_req	*ireq;
>  	uint32_t		lastgrp = 0;
> -	uint32_t		ocount = 0;
> -	__u64			last_ino;
> -	struct xfs_inogrp	igroup[IGROUP_NR];
> +	__u64			last_ino = 0;
> +
> +	ireq = xfrog_inumbers_alloc_req(IGROUP_NR, 0);
> +	if (!ireq) {
> +		perror("alloc req");
> +		return 0;
> +	}
>  
>  	for (;;) {
>  		int		ret;
>  
> -		ret = xfrog_inumbers(&xfd, &lastip, IGROUP_NR, igroup,
> -				&ocount);
> +		ret = xfrog_inumbers(&xfd, ireq);
>  		if (ret) {
>  			errno = ret;
>  			perror("XFS_IOC_FSINUMBERS");
> -			return 0;
> +			free(ireq);

no need to free here

> +			goto out;
>  		}
>  
>  		/* Did we reach the last inode? */
> -		if (ocount == 0)
> +		if (ireq->hdr.ocount == 0)
>  			break;
>  
>  		/* last inode in igroup table */
> -		lastgrp = ocount;
> +		lastgrp = ireq->hdr.ocount;
>  	}
>  
> -	if (lastgrp == 0)
> -		return 0;
> +	if (lastgrp == 0) {
> +		free(ireq);

or here

> +		goto out;
> +	}
>  
>  	lastgrp--;
>  
>  	/* The last inode number in use */
> -	last_ino = igroup[lastgrp].xi_startino +
> -		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
> +	last_ino = ireq->inumbers[lastgrp].xi_startino +
> +		  libxfs_highbit64(ireq->inumbers[lastgrp].xi_allocmask);
> +out:
> +	free(ireq);

since you do it here

>  
>  	return last_ino;
>  }
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 300963f1..85594e5e 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -435,6 +435,86 @@ xfrog_bulkstat_alloc_req(
>  	return breq;
>  }
>  
> +/* Convert a inumbers data from v5 format to v1 format. */
> +void
> +xfrog_inumbers_v5_to_v1(
> +	struct xfs_inogrp		*ig1,
> +	const struct xfs_inumbers	*ig5)
> +{
> +	ig1->xi_startino = ig5->xi_startino;
> +	ig1->xi_alloccount = ig5->xi_alloccount;
> +	ig1->xi_allocmask = ig5->xi_allocmask;
> +}

nobody uses this?

...

> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 2112c9d1..964647ce 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -49,7 +49,7 @@
>  static void
>  xfs_iterate_inodes_range_check(
>  	struct scrub_ctx	*ctx,
> -	struct xfs_inogrp	*inogrp,
> +	struct xfs_inumbers	*inumbers,
>  	struct xfs_bulkstat	*bstat)
>  {
>  	struct xfs_bulkstat	*bs;
> @@ -57,19 +57,19 @@ xfs_iterate_inodes_range_check(
>  	int			error;
>  
>  	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
> -		if (!(inogrp->xi_allocmask & (1ULL << i)))
> +		if (!(inumbers->xi_allocmask & (1ULL << i)))
>  			continue;
> -		if (bs->bs_ino == inogrp->xi_startino + i) {
> +		if (bs->bs_ino == inumbers->xi_startino + i) {
>  			bs++;
>  			continue;
>  		}
>  
>  		/* Load the one inode. */
>  		error = xfrog_bulkstat_single(&ctx->mnt,
> -				inogrp->xi_startino + i, 0, bs);
> -		if (error || bs->bs_ino != inogrp->xi_startino + i) {
> +				inumbers->xi_startino + i, 0, bs);
> +		if (error || bs->bs_ino != inumbers->xi_startino + i) {
>  			memset(bs, 0, sizeof(struct xfs_bulkstat));
> -			bs->bs_ino = inogrp->xi_startino + i;
> +			bs->bs_ino = inumbers->xi_startino + i;
>  			bs->bs_blksize = ctx->mnt_sv.f_frsize;
>  		}
>  		bs++;
> @@ -92,12 +92,11 @@ xfs_iterate_inodes_range(
>  	void			*arg)
>  {
>  	struct xfs_handle	handle;
> -	struct xfs_inogrp	inogrp;
> +	struct xfs_inumbers_req	*ireq;
>  	struct xfs_bulkstat_req	*breq;
>  	char			idescr[DESCR_BUFSZ];
>  	struct xfs_bulkstat	*bs;
> -	uint64_t		igrp_ino;
> -	uint32_t		igrplen = 0;
> +	struct xfs_inumbers	*inumbers;
>  	bool			moveon = true;
>  	int			i;
>  	int			error;
> @@ -114,19 +113,26 @@ xfs_iterate_inodes_range(
>  		return false;
>  	}
>  
> +	ireq = xfrog_inumbers_alloc_req(1, first_ino);
> +	if (!ireq) {
> +		str_info(ctx, descr, _("Insufficient memory; giving up."));
> +		free(breq);
> +		return false;
> +	}
> +	inumbers = &ireq->inumbers[0];
> +
>  	/* Find the inode chunk & alloc mask */
> -	igrp_ino = first_ino;
> -	error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp, &igrplen);
> -	while (!error && igrplen) {
> +	error = xfrog_inumbers(&ctx->mnt, ireq);
> +	while (!error && ireq->hdr.ocount > 0) {
>  		/*
>  		 * We can have totally empty inode chunks on filesystems where
>  		 * there are more than 64 inodes per block.  Skip these.
>  		 */
> -		if (inogrp.xi_alloccount == 0)
> +		if (inumbers->xi_alloccount == 0)
>  			goto igrp_retry;
>  
> -		breq->hdr.ino = inogrp.xi_startino;
> -		breq->hdr.icount = inogrp.xi_alloccount;
> +		breq->hdr.ino = inumbers->xi_startino;
> +		breq->hdr.icount = inumbers->xi_alloccount;
>  		error = xfrog_bulkstat(&ctx->mnt, breq);
>  		if (error) {
>  			char	errbuf[DESCR_BUFSZ];
> @@ -135,11 +141,11 @@ xfs_iterate_inodes_range(
>  						errbuf, DESCR_BUFSZ));
>  		}
>  
> -		xfs_iterate_inodes_range_check(ctx, &inogrp, breq->bulkstat);
> +		xfs_iterate_inodes_range_check(ctx, inumbers, breq->bulkstat);
>  
>  		/* Iterate all the inodes. */
>  		for (i = 0, bs = breq->bulkstat;
> -		     i < inogrp.xi_alloccount;
> +		     i < inumbers->xi_alloccount;
>  		     i++, bs++) {
>  			if (bs->bs_ino > last_ino)
>  				goto out;

same deal w/ leaking here

> @@ -153,7 +159,7 @@ xfs_iterate_inodes_range(
>  			case ESTALE:
>  				stale_count++;
>  				if (stale_count < 30) {
> -					igrp_ino = inogrp.xi_startino;
> +					ireq->hdr.ino = inumbers->xi_startino;
>  					goto igrp_retry;
>  				}
>  				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
> @@ -177,8 +183,7 @@ _("Changed too many times during scan; giving up."));
>  
>  		stale_count = 0;
>  igrp_retry:
> -		error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
> -				&igrplen);
> +		error = xfrog_inumbers(&ctx->mnt, ireq);
>  	}
>  
>  err:
> @@ -186,6 +191,7 @@ _("Changed too many times during scan; giving up."));
>  		str_liberror(ctx, error, descr);
>  		moveon = false;
>  	}
> +	free(ireq);

since the free isn't under out:

>  	free(breq);
>  out:
>  	return moveon;
> 
