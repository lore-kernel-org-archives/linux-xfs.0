Return-Path: <SRS0=vvgS=W4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17051C3A5A4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5BBE2190F
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:57:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PndYk1VB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfIAU5w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:57:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52750 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfIAU5w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 16:57:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81Ku9i0149782;
        Sun, 1 Sep 2019 20:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uMSi9wtTcp/Zadi15MEbCNxvpdW+2V0ci+XEWBoG04Y=;
 b=PndYk1VBb5mnPspYWCTsC4yk88kYqzSPBNQCSSFy8dJ6L8gOuELNyj5My8dAHhREcWfz
 wLgYU6a1zCGXYdAPZq9KaLhvYZUwxErmCSz75QXlfvQ5rbnz4teRKAHpppWbjRyx2pZo
 K+2u1vm8wd5Z4vyDFqvLMWJPDWD4w7AX8fM2h16adrxmHrN6IlLZZgitAb+xCvRZoFxA
 rxVa3vsM9XHsvQMvYk7VbtVAp5xKYuYEs0R+mOI0HCYxgDDBUcUCLRE9L6cxVS9mweaH
 CIG+ITvUi7mrRg9sQNdU8eSmFHr+HHC96Asqf2pTtDQ4vH4lP+c0Kg85wUdxlFJPuR87 RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2urne7r03y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:57:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81KrJ8N006843;
        Sun, 1 Sep 2019 20:55:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2uqe1betbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:55:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x81KtXdw012597;
        Sun, 1 Sep 2019 20:55:33 GMT
Received: from [192.168.1.9] (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Sep 2019 13:55:31 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 9/9] libfrog: refactor open-coded INUMBERS calls
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713888219.386621.15662668758929652470.stgit@magnolia>
Message-ID: <07c35c39-c320-692c-ba1b-34eb9bc4c07b@oracle.com>
Date:   Sun, 1 Sep 2019 13:55:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156713888219.386621.15662668758929652470.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909010241
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9367 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909010241
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/29/19 9:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the INUMBERS ioctl callsites into helper functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
Looks good!  I think it looks a lot cleaner.  Thanks!

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   include/xfrog.h    |    4 ++++
>   io/imap.c          |   33 ++++++++++++++++-----------------
>   io/open.c          |   24 ++++++++++++------------
>   libfrog/bulkstat.c |   26 ++++++++++++++++++++++++++
>   scrub/fscounters.c |   20 ++++++++------------
>   scrub/inodes.c     |   17 ++++++-----------
>   6 files changed, 72 insertions(+), 52 deletions(-)
> 
> 
> diff --git a/include/xfrog.h b/include/xfrog.h
> index 3a49acc3..d16481ce 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -116,4 +116,8 @@ int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
>   int xfrog_bulkstat(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
>   		struct xfs_bstat *ubuffer, uint32_t *ocount);
>   
> +struct xfs_inogrp;
> +int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
> +		struct xfs_inogrp *ubuffer, uint32_t *ocount);
> +
>   #endif	/* __XFROG_H__ */
> diff --git a/io/imap.c b/io/imap.c
> index 9667289a..053ac28e 100644
> --- a/io/imap.c
> +++ b/io/imap.c
> @@ -8,18 +8,20 @@
>   #include "input.h"
>   #include "init.h"
>   #include "io.h"
> +#include "xfrog.h"
>   
>   static cmdinfo_t imap_cmd;
>   
>   static int
>   imap_f(int argc, char **argv)
>   {
> -	int		count;
> -	int		nent;
> -	int		i;
> -	__u64		last = 0;
> -	struct xfs_inogrp *t;
> -	struct xfs_fsop_bulkreq bulkreq;
> +	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> +	struct xfs_inogrp	*t;
> +	uint64_t		last = 0;
> +	uint32_t		count;
> +	uint32_t		nent;
> +	int			i;
> +	int			error;
>   
>   	if (argc != 2)
>   		nent = 1;
> @@ -30,14 +32,8 @@ imap_f(int argc, char **argv)
>   	if (!t)
>   		return 0;
>   
> -	bulkreq.lastip  = &last;
> -	bulkreq.icount  = nent;
> -	bulkreq.ubuffer = (void *)t;
> -	bulkreq.ocount  = &count;
> -
> -	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
> -		if (count == 0)
> -			goto out_free;
> +	while ((error = xfrog_inumbers(&xfd, &last, nent, t, &count)) == 0 &&
> +	       count > 0) {
>   		for (i = 0; i < count; i++) {
>   			printf(_("ino %10llu count %2d mask %016llx\n"),
>   				(unsigned long long)t[i].xi_startino,
> @@ -45,9 +41,12 @@ imap_f(int argc, char **argv)
>   				(unsigned long long)t[i].xi_allocmask);
>   		}
>   	}
> -	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> -	exitcode = 1;
> -out_free:
> +
> +	if (error) {
> +		errno = error;
> +		perror("xfsctl(XFS_IOC_FSINUMBERS)");
> +		exitcode = 1;
> +	}
>   	free(t);
>   	return 0;
>   }
> diff --git a/io/open.c b/io/open.c
> index 35e6131b..c0d0f1e9 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -675,24 +675,24 @@ inode_help(void)
>   "\n"));
>   }
>   
> +#define IGROUP_NR	(1024)
>   static __u64
>   get_last_inode(void)
>   {
> -	__u64			lastip = 0;
> -	__u64			lastgrp = 0;
> -	__s32			ocount = 0;
> +	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> +	uint64_t		lastip = 0;
> +	uint32_t		lastgrp = 0;
> +	uint32_t		ocount = 0;
>   	__u64			last_ino;
> -	struct xfs_inogrp	igroup[1024];
> -	struct xfs_fsop_bulkreq	bulkreq;
> -
> -	bulkreq.lastip = &lastip;
> -	bulkreq.ubuffer = &igroup;
> -	bulkreq.icount = sizeof(igroup) / sizeof(struct xfs_inogrp);
> -	bulkreq.ocount = &ocount;
> +	struct xfs_inogrp	igroup[IGROUP_NR];
>   
>   	for (;;) {
> -		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
> -				&bulkreq)) {
> +		int		ret;
> +
> +		ret = xfrog_inumbers(&xfd, &lastip, IGROUP_NR, igroup,
> +				&ocount);
> +		if (ret) {
> +			errno = ret;
>   			perror("XFS_IOC_FSINUMBERS");
>   			return 0;
>   		}
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 0e11ccea..18fffb20 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -50,3 +50,29 @@ xfrog_bulkstat(
>   		return errno;
>   	return 0;
>   }
> +
> +/*
> + * Query inode allocation bitmask information.  Returns zero or a positive
> + * error code.
> + */
> +int
> +xfrog_inumbers(
> +	struct xfs_fd		*xfd,
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
> +	int			ret;
> +
> +	ret = ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
> +	if (ret)
> +		return errno;
> +	return 0;
> +}
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index ea6af156..3915822e 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -15,6 +15,7 @@
>   #include "xfs_scrub.h"
>   #include "common.h"
>   #include "fscounters.h"
> +#include "xfrog.h"
>   
>   /*
>    * Filesystem counter collection routines.  We can count the number of
> @@ -41,30 +42,25 @@ xfs_count_inodes_range(
>   	uint64_t		last_ino,
>   	uint64_t		*count)
>   {
> -	struct xfs_fsop_bulkreq	igrpreq = {NULL};
>   	struct xfs_inogrp	inogrp;
> -	__u64			igrp_ino;
> +	uint64_t		igrp_ino;
>   	uint64_t		nr = 0;
> -	__s32			igrplen = 0;
> +	uint32_t		igrplen = 0;
>   	int			error;
>   
>   	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
>   	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
>   
> -	igrpreq.lastip  = &igrp_ino;
> -	igrpreq.icount  = 1;
> -	igrpreq.ubuffer = &inogrp;
> -	igrpreq.ocount  = &igrplen;
> -
>   	igrp_ino = first_ino;
> -	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
> -	while (!error && igrplen && inogrp.xi_startino < last_ino) {
> +	while (!(error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
> +			&igrplen))) {
> +		if (igrplen == 0 || inogrp.xi_startino >= last_ino)
> +			break;
>   		nr += inogrp.xi_alloccount;
> -		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
>   	}
>   
>   	if (error) {
> -		str_errno(ctx, descr);
> +		str_liberror(ctx, error, descr);
>   		return false;
>   	}
>   
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 413037d8..acad9b16 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -90,16 +90,15 @@ xfs_iterate_inodes_range(
>   	xfs_inode_iter_fn	fn,
>   	void			*arg)
>   {
> -	struct xfs_fsop_bulkreq	igrpreq = {NULL};
>   	struct xfs_handle	handle;
>   	struct xfs_inogrp	inogrp;
>   	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
>   	char			idescr[DESCR_BUFSZ];
>   	struct xfs_bstat	*bs;
> -	__u64			igrp_ino;
> +	uint64_t		igrp_ino;
>   	uint64_t		ino;
>   	uint32_t		bulklen = 0;
> -	__s32			igrplen = 0;
> +	uint32_t		igrplen = 0;
>   	bool			moveon = true;
>   	int			i;
>   	int			error;
> @@ -108,11 +107,6 @@ xfs_iterate_inodes_range(
>   
>   	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
>   
> -	igrpreq.lastip  = &igrp_ino;
> -	igrpreq.icount  = 1;
> -	igrpreq.ubuffer = &inogrp;
> -	igrpreq.ocount  = &igrplen;
> -
>   	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
>   	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
>   			sizeof(handle.ha_fid.fid_len);
> @@ -120,7 +114,7 @@ xfs_iterate_inodes_range(
>   
>   	/* Find the inode chunk & alloc mask */
>   	igrp_ino = first_ino;
> -	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
> +	error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp, &igrplen);
>   	while (!error && igrplen) {
>   		/* Load the inodes. */
>   		ino = inogrp.xi_startino - 1;
> @@ -176,12 +170,13 @@ _("Changed too many times during scan; giving up."));
>   
>   		stale_count = 0;
>   igrp_retry:
> -		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
> +		error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
> +				&igrplen);
>   	}
>   
>   err:
>   	if (error) {
> -		str_errno(ctx, descr);
> +		str_liberror(ctx, error, descr);
>   		moveon = false;
>   	}
>   out:
> 
