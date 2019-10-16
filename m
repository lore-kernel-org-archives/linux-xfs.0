Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B55ECE59D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 05:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABD6E217D6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 05:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kbHL8Pg/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732110AbfJPFAG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 01:00:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55268 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732018AbfJPFAG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 01:00:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9G4xAHm186191;
        Wed, 16 Oct 2019 05:00:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Uu/YFDaFen8f6qL+0UApS6QRwT+hszdY0zbEkXSTnhs=;
 b=kbHL8Pg/pDjrRZAjNdWP2w7SginmCWmhoO3RMW3u8g/RdyYy3IHb8+3RVsqGvHv706hW
 pZEAhU2ESASpjQ9ZlLSR+j+LcnhP3nkCVAwTFHkXweOA9U3HmzJzvbcu41V985P4GHWI
 sIfTsTkjqvJ9V2sJoW0WAjw53qeEKny0U4R+4IDQAc/81kf9U/RtNh6MntsA4NRqZv/G
 r8SFd5FBJYUsoW7pFjIIDcapZjjoGzp48odc8azPiAGvQ0WQ2laZsscW8pAi95JPADrq
 StO1d20Nk6zbs9CR2JAlCLlji0A1eR4vuK1exjoEieOh3wXsVhxLfYV2TT3DNUC2mLdB Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vk7frc0ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 05:00:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9G4wkjA020317;
        Wed, 16 Oct 2019 05:00:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vnf7smavs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 05:00:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9G501xN016430;
        Wed, 16 Oct 2019 05:00:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Oct 2019 05:00:00 +0000
Date:   Tue, 15 Oct 2019 21:59:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs_scrub: refactor inode prefix rendering code
Message-ID: <20191016045957.GV13108@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
 <156944733375.298887.14903136321208702854.stgit@magnolia>
 <0afea659-939d-d82b-67ea-b2742748921c@sandeen.net>
 <a4cd281d-8d05-debe-1af9-1192770c6cd1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4cd281d-8d05-debe-1af9-1192770c6cd1@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910160045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910160045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 15, 2019 at 06:25:10PM -0500, Eric Sandeen wrote:
> How about this:
> 
> Refactor all the places in the code where we try to render an inode
> number as a prefix for some sort of status message.  This will help make
> message prefixes more consistent, which should help users to locate
> broken metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [sandeen: swizzle stuff]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me. :)

--D

> ---
> 
> this uses a single function, scrub_render_ino_descr() with a new comment,
> and automatic space-adding for any extra format.
> 
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 7db47044..7f971de8 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -354,3 +354,38 @@ within_range(
>  
>  	return true;
>  }
> +
> +/*
> + * Render an inode number into a buffer in a format suitable for use as a
> + * prefix for log messages. The buffer will be filled with:
> + * 	"inode <inode number> (<ag number>/<ag inode number>)"
> + * If the @format argument is non-NULL, it will be rendered into the buffer
> + * after the inode representation and a single space.
> + */
> +int
> +scrub_render_ino_descr(
> +	const struct scrub_ctx	*ctx,
> +	char			*buf,
> +	size_t			buflen,
> +	uint64_t		ino,
> +	uint32_t		gen,
> +	const char		*format,
> +	...)
> +{
> +	va_list			args;
> +	uint32_t		agno;
> +	uint32_t		agino;
> +	int			ret;
> +
> +	agno = cvt_ino_to_agno(&ctx->mnt, ino);
> +	agino = cvt_ino_to_agino(&ctx->mnt, ino);
> +	ret = snprintf(buf, buflen, _("inode %"PRIu64" (%"PRIu32"/%"PRIu32")%s"),
> +			ino, agno, agino, format ? " " : "");
> +	if (ret < 0 || ret >= buflen || format == NULL)
> +		return ret;
> +
> +	va_start(args, format);
> +	ret += vsnprintf(buf + ret, buflen - ret, format, args);
> +	va_end(args);
> +	return ret;
> +}
> diff --git a/scrub/common.h b/scrub/common.h
> index 33555891..9a37e9ed 100644
> --- a/scrub/common.h
> +++ b/scrub/common.h
> @@ -86,4 +86,8 @@ bool within_range(struct scrub_ctx *ctx, unsigned long long value,
>  		unsigned long long desired, unsigned long long abs_threshold,
>  		unsigned int n, unsigned int d, const char *descr);
>  
> +int scrub_render_ino_descr(const struct scrub_ctx *ctx, char *buf,
> +		size_t buflen, uint64_t ino, uint32_t gen,
> +		const char *format, ...);
> +
>  #endif /* XFS_SCRUB_COMMON_H_ */
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 91632b55..7aa61ebe 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -159,8 +159,8 @@ xfs_iterate_inodes_ag(
>  					ireq->hdr.ino = inumbers->xi_startino;
>  					goto igrp_retry;
>  				}
> -				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
> -						(uint64_t)bs->bs_ino);
> +				scrub_render_ino_descr(ctx, idescr, DESCR_BUFSZ,
> +						bs->bs_ino, bs->bs_gen, NULL);
>  				str_info(ctx, idescr,
>  _("Changed too many times during scan; giving up."));
>  				break;
> diff --git a/scrub/phase3.c b/scrub/phase3.c
> index 1e908c2c..0d2c9019 100644
> --- a/scrub/phase3.c
> +++ b/scrub/phase3.c
> @@ -48,14 +48,10 @@ xfs_scrub_inode_vfs_error(
>  	struct xfs_bulkstat	*bstat)
>  {
>  	char			descr[DESCR_BUFSZ];
> -	xfs_agnumber_t		agno;
> -	xfs_agino_t		agino;
>  	int			old_errno = errno;
>  
> -	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
> -	agino = cvt_ino_to_agino(&ctx->mnt, bstat->bs_ino);
> -	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
> -			(uint64_t)bstat->bs_ino, agno, agino);
> +	scrub_render_ino_descr(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
> +			bstat->bs_gen, NULL);
>  	errno = old_errno;
>  	str_errno(ctx, descr);
>  }
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 99cd51b2..27941907 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -234,15 +234,11 @@ xfs_scrub_connections(
>  	bool			*pmoveon = arg;
>  	char			descr[DESCR_BUFSZ];
>  	bool			moveon = true;
> -	xfs_agnumber_t		agno;
> -	xfs_agino_t		agino;
>  	int			fd = -1;
>  	int			error;
>  
> -	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
> -	agino = cvt_ino_to_agino(&ctx->mnt, bstat->bs_ino);
> -	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
> -			(uint64_t)bstat->bs_ino, agno, agino);
> +	scrub_render_ino_descr(ctx, descr, DESCR_BUFSZ, bstat->bs_ino,
> +			bstat->bs_gen, NULL);
>  	background_sleep();
>  
>  	/* Warn about naming problems in xattrs. */
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 8063d6ce..2ce2a19e 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -180,15 +180,15 @@ xfs_report_verify_inode(
>  	int				fd;
>  	int				error;
>  
> -	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (unlinked)"),
> -			(uint64_t)bstat->bs_ino);
> -
>  	/* Ignore linked files and things we can't open. */
>  	if (bstat->bs_nlink != 0)
>  		return 0;
>  	if (!S_ISREG(bstat->bs_mode) && !S_ISDIR(bstat->bs_mode))
>  		return 0;
>  
> +	scrub_render_ino_descr(ctx, descr, DESCR_BUFSZ,
> +			bstat->bs_ino, bstat->bs_gen, _("(unlinked)"));
> +
>  	/* Try to open the inode. */
>  	fd = xfs_open_handle(handle);
>  	if (fd < 0) {
> diff --git a/scrub/scrub.c b/scrub/scrub.c
> index d7a6b49b..0293ce30 100644
> --- a/scrub/scrub.c
> +++ b/scrub/scrub.c
> @@ -26,11 +26,13 @@
>  /* Format a scrub description. */
>  static void
>  format_scrub_descr(
> +	struct scrub_ctx		*ctx,
>  	char				*buf,
>  	size_t				buflen,
> -	struct xfs_scrub_metadata	*meta,
> -	const struct xfrog_scrub_descr	*sc)
> +	struct xfs_scrub_metadata	*meta)
>  {
> +	const struct xfrog_scrub_descr	*sc = &xfrog_scrubbers[meta->sm_type];
> +
>  	switch (sc->type) {
>  	case XFROG_SCRUB_TYPE_AGHEADER:
>  	case XFROG_SCRUB_TYPE_PERAG:
> @@ -38,8 +40,9 @@ format_scrub_descr(
>  				_(sc->descr));
>  		break;
>  	case XFROG_SCRUB_TYPE_INODE:
> -		snprintf(buf, buflen, _("Inode %"PRIu64" %s"),
> -				(uint64_t)meta->sm_ino, _(sc->descr));
> +		scrub_render_ino_descr(ctx, buf, buflen,
> +				meta->sm_ino, meta->sm_gen, "%s",
> +				_(sc->descr));
>  		break;
>  	case XFROG_SCRUB_TYPE_FS:
>  		snprintf(buf, buflen, _("%s"), _(sc->descr));
> @@ -123,8 +126,7 @@ xfs_check_metadata(
>  
>  	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
>  	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
> -	format_scrub_descr(buf, DESCR_BUFSZ, meta,
> -			&xfrog_scrubbers[meta->sm_type]);
> +	format_scrub_descr(ctx, buf, DESCR_BUFSZ, meta);
>  
>  	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
>  retry:
> @@ -681,8 +683,7 @@ xfs_repair_metadata(
>  		return CHECK_RETRY;
>  
>  	memcpy(&oldm, &meta, sizeof(oldm));
> -	format_scrub_descr(buf, DESCR_BUFSZ, &meta,
> -			&xfrog_scrubbers[meta.sm_type]);
> +	format_scrub_descr(ctx, buf, DESCR_BUFSZ, &meta);
>  
>  	if (needs_repair(&meta))
>  		str_info(ctx, buf, _("Attempting repair."));
> 
