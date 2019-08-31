Return-Path: <SRS0=0uIH=W3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F28C3A59B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 00:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1F1622CE9
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 00:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V3colrPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbfHaAh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 20:37:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfHaAh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 20:37:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V0YwDl003296;
        Sat, 31 Aug 2019 00:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=r3Eu7ls7gD3jskwT1tYIf3d+s80uDlPU4XbyD2kWZZg=;
 b=V3colrPP+OyrCUrEgJAHC9AI/hyLJ8o+1pM4ov6o5VsGoOnTMfP4QxWQnxPxHRzP43Dk
 /CKO1FuPk5gXzdKuh8FVFiEe4k21PaIllFmiZoqxNRW2UPNmGHfU9GhvXIkAGmCjAVTL
 pZgcMGXuJAtyKcoxybD06kxbm5nuByo3+cqDz19Oteu8JWz22o00iYA0OhYZxjp/AnSm
 5Eq5fTVIW6ONihQ4HZYuEPyHLjb0QXaIPIOykOB+t7MAwBtKbLXZTyvIl4RnrLB0OQwl
 4aDlhalwf82DivJfhzs0nsXJnk7AdxxjYCdqhOhp/DePSnEsG2XETPLK4lAEZl/mlRPc 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uqebjr0wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 00:37:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V0XaJf129567;
        Sat, 31 Aug 2019 00:37:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uphavvuj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 00:37:49 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7V0bmo9001432;
        Sat, 31 Aug 2019 00:37:49 GMT
Received: from [192.168.1.9] (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 17:37:48 -0700
Subject: Re: [PATCH 5/9] libfrog: store more inode and block geometry in
 struct xfs_fd
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713885704.386621.8085538826991730094.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <163a36c7-51f7-6597-f943-e7e5bf86ad83@oracle.com>
Date:   Fri, 30 Aug 2019 17:37:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156713885704.386621.8085538826991730094.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908310002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908310003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/29/19 9:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the extra AG geometry fields out of scrub and into the libfrog code
> so that we can consolidate the geoemtry code in one place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
Alrighty, looks good.  I'm seeing how the helpers are getting expanded 
:-)  You can add my review:

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   include/xfrog.h    |   12 ++++++++++++
>   libfrog/fsgeom.c   |   13 ++++++++++++-
>   scrub/fscounters.c |    4 ++--
>   scrub/inodes.c     |    4 ++--
>   scrub/phase1.c     |    5 -----
>   scrub/phase3.c     |    6 +++---
>   scrub/phase5.c     |    4 ++--
>   scrub/phase6.c     |    2 +-
>   scrub/phase7.c     |    6 +++---
>   scrub/xfs_scrub.h  |    4 ----
>   10 files changed, 37 insertions(+), 23 deletions(-)
> 
> 
> diff --git a/include/xfrog.h b/include/xfrog.h
> index 766ee5d5..008cc155 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -30,6 +30,18 @@ struct xfs_fd {
>   
>   	/* filesystem geometry */
>   	struct xfs_fsop_geom	fsgeom;
> +
> +	/* log2 of sb_agblocks (rounded up) */
> +	unsigned int		agblklog;
> +
> +	/* log2 of sb_blocksize */
> +	unsigned int		blocklog;
> +
> +	/* log2 of sb_inodesize */
> +	unsigned int		inodelog;
> +
> +	/* log2 of sb_inopblock */
> +	unsigned int		inopblog;
>   };
>   
>   /* Static initializers */
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 694ccbd0..b8873598 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -5,6 +5,7 @@
>   #include "libxfs.h"
>   #include "fsgeom.h"
>   #include "xfrog.h"
> +#include "libfrog.h"
>   
>   void
>   xfs_report_geom(
> @@ -102,7 +103,17 @@ int
>   xfd_prepare_geometry(
>   	struct xfs_fd		*xfd)
>   {
> -	return xfrog_geometry(xfd->fd, &xfd->fsgeom);
> +	int			ret;
> +
> +	ret = xfrog_geometry(xfd->fd, &xfd->fsgeom);
> +	if (ret)
> +		return ret;
> +
> +	xfd->agblklog = log2_roundup(xfd->fsgeom.agblocks);
> +	xfd->blocklog = highbit32(xfd->fsgeom.blocksize);
> +	xfd->inodelog = highbit32(xfd->fsgeom.inodesize);
> +	xfd->inopblog = xfd->blocklog - xfd->inodelog;
> +	return 0;
>   }
>   
>   /*
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index f18d0e19..ac898764 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -91,8 +91,8 @@ xfs_count_ag_inodes(
>   				minor(ctx->fsinfo.fs_datadev),
>   				agno);
>   
> -	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
> -	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
> +	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
> +	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
>   
>   	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
>   			&ci->counters[agno]);
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 08f3d847..873ad425 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -228,8 +228,8 @@ xfs_scan_ag_inodes(
>   				minor(ctx->fsinfo.fs_datadev),
>   				agno);
>   
> -	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
> -	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
> +	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
> +	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
>   
>   	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
>   			next_ag_ino - 1, si->fn, si->arg);
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 6d8293b2..cbdbd010 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -140,11 +140,6 @@ _("Does not appear to be an XFS filesystem!"));
>   		return false;
>   	}
>   
> -	ctx->agblklog = log2_roundup(ctx->mnt.fsgeom.agblocks);
> -	ctx->blocklog = highbit32(ctx->mnt.fsgeom.blocksize);
> -	ctx->inodelog = highbit32(ctx->mnt.fsgeom.inodesize);
> -	ctx->inopblog = ctx->blocklog - ctx->inodelog;
> -
>   	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
>   			&ctx->fshandle_len);
>   	if (error) {
> diff --git a/scrub/phase3.c b/scrub/phase3.c
> index a42d8213..579e08c3 100644
> --- a/scrub/phase3.c
> +++ b/scrub/phase3.c
> @@ -52,8 +52,8 @@ xfs_scrub_inode_vfs_error(
>   	xfs_agino_t		agino;
>   	int			old_errno = errno;
>   
> -	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
> -	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
> +	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
> +	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
>   	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
>   			(uint64_t)bstat->bs_ino, agno, agino);
>   	errno = old_errno;
> @@ -77,7 +77,7 @@ xfs_scrub_inode(
>   	int			error;
>   
>   	xfs_action_list_init(&alist);
> -	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
> +	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
>   	background_sleep();
>   
>   	/* Try to open the inode to pin it. */
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 748885d4..36ec27b3 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -239,8 +239,8 @@ xfs_scrub_connections(
>   	int			fd = -1;
>   	int			error;
>   
> -	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
> -	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
> +	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
> +	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
>   	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
>   			(uint64_t)bstat->bs_ino, agno, agino);
>   	background_sleep();
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index e5a0b3c1..48971270 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -547,7 +547,7 @@ xfs_estimate_verify_work(
>   	if (!moveon)
>   		return moveon;
>   
> -	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->blocklog;
> +	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->mnt.blocklog;
>   	*nr_threads = disk_heads(ctx->datadev);
>   	*rshift = 20;
>   	return moveon;
> diff --git a/scrub/phase7.c b/scrub/phase7.c
> index 13959ca8..41a77356 100644
> --- a/scrub/phase7.c
> +++ b/scrub/phase7.c
> @@ -148,11 +148,11 @@ xfs_scan_summary(
>   	 * filesystem treats them as "free", but since we scanned
>   	 * them, we'll consider them used.
>   	 */
> -	d_bfree -= totalcount.agbytes >> ctx->blocklog;
> +	d_bfree -= totalcount.agbytes >> ctx->mnt.blocklog;
>   
>   	/* Report on what we found. */
> -	used_data = (d_blocks - d_bfree) << ctx->blocklog;
> -	used_rt = (r_blocks - r_bfree) << ctx->blocklog;
> +	used_data = (d_blocks - d_bfree) << ctx->mnt.blocklog;
> +	used_rt = (r_blocks - r_bfree) << ctx->mnt.blocklog;
>   	used_files = f_files - f_free;
>   	stat_data = totalcount.dbytes;
>   	stat_rt = totalcount.rbytes;
> diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
> index 28eae6fe..fb34c587 100644
> --- a/scrub/xfs_scrub.h
> +++ b/scrub/xfs_scrub.h
> @@ -63,10 +63,6 @@ struct scrub_ctx {
>   
>   	/* XFS specific geometry */
>   	struct fs_path		fsinfo;
> -	unsigned int		agblklog;
> -	unsigned int		blocklog;
> -	unsigned int		inodelog;
> -	unsigned int		inopblog;
>   	void			*fshandle;
>   	size_t			fshandle_len;
>   
> 
