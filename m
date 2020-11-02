Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6A8C388F2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B54820786
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rR2cvg2e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgKBRDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:03:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgKBRDX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 12:03:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2GjPGl156878;
        Mon, 2 Nov 2020 17:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=j0eHUfd+s72HH13DTtQtHpB5X+ZhcL1ff3ENF0Ac9q0=;
 b=rR2cvg2eUmbJBbQTg84KIV/Pf3B/WchQybeliLdZhTzqn4b0LqPaCS3sZYdXBcHgOlpj
 IluR0avADvhhU4pIO+CVfxIT6C8Mu3ueVVmyIWU7TMmTfIFSt9KbPkBBVQ5iei8bJGur
 D/2Hj8bVUcyn0Yd5qTOpQyKAY2RJ4bPXRORMJRl8htPCvIKSFA8E1CWxP9X6R0+C3ElK
 GlvjlxONaayfknZykSCVluIegbm5Sp9w+raNT13z5iiBlgrPnT8uSlAL1dpZTssMgiEh
 0Wkwn49KxtW5phww9UUgQYTVyndxCaFw8KCae5Lma3Bfy4rOGMNBpZh3XSliIWRLeESh 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34hhvc52mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 02 Nov 2020 17:03:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2GkQ0t046485;
        Mon, 2 Nov 2020 17:03:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34hw0fbcdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Nov 2020 17:03:17 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A2H3G90013354;
        Mon, 2 Nov 2020 17:03:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 09:03:15 -0800
Date:   Mon, 2 Nov 2020 09:03:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] xfsdump: fix handling bind mount targets
Message-ID: <20201102170313.GB7123@magnolia>
References: <20201102100120.660443-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102100120.660443-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=1 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 02, 2020 at 06:01:20PM +0800, Gao Xiang wrote:
> Sometimes, it's not true that the root directory is always
> the first result from calling bulkstat with lastino == 0
> assumed by xfsdump.
> 
> Recently XFS_BULK_IREQ_SPECIAL_ROOT was introduced last year,
> yet that doesn't exist in old kernels.

Is this patch supposed to make xfsrestore start using that?

> Alternatively, we can also use bulkstat to walk through
> all dirs and find the exact dir whose ino # of ".." is
> itself by getdents, and that should be considered as the
> root dir.
> 
> Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> preliminary test with the original testcase is done...
> 
>  dump/content.c | 168 ++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 140 insertions(+), 28 deletions(-)
> 
> diff --git a/dump/content.c b/dump/content.c
> index 30232d4..653d4eb 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -511,6 +511,132 @@ static bool_t create_inv_session(
>  		ix_t subtreecnt,
>  		size_t strmix);
>  
> +struct fixrootino_context {
> +	xfs_ino_t	rootino;
> +	struct dirent	*gdp;
> +	size_t		gdsz;
> +};
> +
> +static bool_t
> +scan_rootinode(int fd,
> +	       xfs_ino_t ino,
> +	       struct dirent *gdp,
> +	       size_t gdsz)
> +{
> +	while (1) {
> +		struct dirent *p;
> +		int nread;
> +
> +		nread = getdents_wrap(fd, (char *)gdp, gdsz);
> +		/*
> +		 * negative count indicates something very bad happened;
> +		 * try to gracefully end this dir.
> +		 */
> +		if (nread < 0) {
> +			mlog(MLOG_NORMAL | MLOG_WARNING,
> +_("unable to read dirents for directory ino %llu: %s\n"),
> +			      ino, strerror(errno));
> +			/* !!! curtis looked at this, and pointed out that
> +			 * we could take some recovery action here. if the
> +			 * errno is appropriate, lseek64 to the value of
> +			 * doff field of the last dirent successfully
> +			 * obtained, and contiue the loop.
> +			 */
> +			nread = 0; /* pretend we are done */
> +		}
> +
> +		/* no more directory entries: break; */
> +		if (!nread)
> +			break;
> +
> +		for (p = gdp; nread > 0;
> +		     nread -= (int)p->d_reclen,
> +		     assert(nread >= 0),
> +		     p = (struct dirent *)((char *)p + p->d_reclen)) {
> +			if (!strcmp(p->d_name, "..") && p->d_ino == ino) {

Doesn't this fail on bind mounted directories?  The VFS remaps '..' on a
bind mount to the directory on the parent mount, which means...

# ls -di /
128 drwxr-xr-x 20 root root 317 May 30 10:05 //
# ls -ila /home/
total 16
      128 drwxr-xr-x  9 root   root     90 Apr 28  2018 ./
      128 drwxr-xr-x 20 root   root    317 May 30 10:05 ../

that reading '..' won't get you to the root of /home, it'll get you to
the root of the root filesystem.

--D

> +				mlog(MLOG_NITTY, "FOUND: name %s d_ino %llu\n",
> +				     p->d_name, ino);
> +				return BOOL_TRUE;
> +			}
> +		}
> +	}
> +	return BOOL_FALSE;
> +}
> +
> +/* ARGSUSED */
> +static int
> +cb_find_root_inode(void *arg1,
> +	jdm_fshandle_t *fshandlep,
> +	int fsfd,
> +	struct xfs_bstat *statp)
> +{
> +	int fd;
> +	struct fixrootino_context *ctx = arg1;
> +
> +	/* open the directory named by statp*/
> +	fd = jdm_open(fshandlep, statp, O_RDONLY);
> +	if (fd < 0) {
> +		mlog(MLOG_NORMAL | MLOG_WARNING, _(
> +		      "unable to open directory: ino %llu: %s\n"),
> +		      statp->bs_ino, strerror(errno));
> +		return RV_OK; /* continue anyway */
> +	}
> +
> +	if (scan_rootinode(fd, statp->bs_ino, ctx->gdp, ctx->gdsz)) {
> +		ctx->rootino = statp->bs_ino;
> +		return RV_NOMORE;
> +	}
> +	return RV_OK;
> +}
> +
> +static bool_t
> +fix_root_inode(
> +	stat64_t *rootstat,
> +	struct xfs_bstat *sc_rootxfsstatp)
> +{
> +	struct xfs_bstat *bstatbufp;
> +	int rval;
> +	struct fixrootino_context ctx;
> +	rv_t rv = RV_OK;
> +
> +	ctx.gdsz = sizeof(struct dirent) + NAME_MAX + 1;
> +	if (ctx.gdsz < GETDENTSBUF_SZ_MIN)
> +		ctx.gdsz = GETDENTSBUF_SZ_MIN;
> +
> +	ctx.gdp = (struct dirent *)calloc(1, ctx.gdsz);
> +	assert(ctx.gdp);
> +
> +	/* already a root dir */
> +	if (scan_rootinode(sc_fsfd, rootstat->st_ino, ctx.gdp, ctx.gdsz))
> +		goto out;
> +
> +	/* allocate a buffer for use by bigstat_iter */
> +	bstatbufp = (struct xfs_bstat *)calloc(BSTATBUFLEN,
> +					       sizeof(struct xfs_bstat));
> +	assert(bstatbufp);
> +
> +	rval = bigstat_iter(sc_fshandlep, sc_fsfd, BIGSTAT_ITER_DIR,
> +			    (xfs_ino_t)0, cb_find_root_inode,
> +			    &ctx, NULL, NULL, (int *)&rv, preemptchk,
> +			    bstatbufp, BSTATBUFLEN);
> +	if (rval)
> +		return BOOL_FALSE;
> +
> +	if (rv != RV_NOMORE && rv != RV_OK)
> +		return BOOL_FALSE;
> +
> +	mlog(MLOG_NORMAL | MLOG_NOTE,
> +	     "fix up rootino %lld, bind mount?\n", ctx.rootino);
> +	rootstat->st_ino = ctx.rootino;
> +out:
> +	if (bigstat_one(sc_fsfd, rootstat->st_ino, sc_rootxfsstatp) < 0) {
> +		mlog( MLOG_ERROR,
> +		      _("failed to get bulkstat information for root inode\n"));
> +		return BOOL_FALSE;
> +	}
> +	return BOOL_TRUE;
> +}
> +
>  bool_t
>  content_init(int argc,
>  	      char *argv[],
> @@ -1381,6 +1507,18 @@ baseuuidbypass:
>  		return BOOL_FALSE;
>  	}
>  
> +	/* alloc a file system handle, to be used with the jdm_open()
> +	 * functions.
> +	 */
> +	sc_fshandlep = jdm_getfshandle(mntpnt);
> +	if (!sc_fshandlep) {
> +		mlog(MLOG_NORMAL, _(
> +		      "unable to construct a file system handle for %s: %s\n"),
> +		      mntpnt,
> +		      strerror(errno));
> +		return BOOL_FALSE;
> +	}
> +
>  	/* figure out the ino for the root directory of the fs
>  	 * and get its struct xfs_bstat for inomap_build().  This could
>  	 * be a bind mount; don't ask for the mount point inode,
> @@ -1388,9 +1526,6 @@ baseuuidbypass:
>  	 */
>  	{
>  		stat64_t rootstat;
> -		xfs_ino_t lastino = 0;
> -		int ocount = 0;
> -		struct xfs_fsop_bulkreq bulkreq;
>  
>  		/* Get the inode of the mount point */
>  		rval = fstat64(sc_fsfd, &rootstat);
> @@ -1404,33 +1539,10 @@ baseuuidbypass:
>  			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
>  		assert(sc_rootxfsstatp);
>  
> -		/* Get the first valid (i.e. root) inode in this fs */
> -		bulkreq.lastip = (__u64 *)&lastino;
> -		bulkreq.icount = 1;
> -		bulkreq.ubuffer = sc_rootxfsstatp;
> -		bulkreq.ocount = &ocount;
> -		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
> -			mlog(MLOG_ERROR,
> -			      _("failed to get bulkstat information for root inode\n"));
> +		if (!fix_root_inode(&rootstat, sc_rootxfsstatp)) {
> +			mlog(MLOG_ERROR, _("failed to fix root inode\n"));
>  			return BOOL_FALSE;
>  		}
> -
> -		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
> -			mlog (MLOG_NORMAL | MLOG_NOTE,
> -			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
> -			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
> -	}
> -
> -	/* alloc a file system handle, to be used with the jdm_open()
> -	 * functions.
> -	 */
> -	sc_fshandlep = jdm_getfshandle(mntpnt);
> -	if (!sc_fshandlep) {
> -		mlog(MLOG_NORMAL, _(
> -		      "unable to construct a file system handle for %s: %s\n"),
> -		      mntpnt,
> -		      strerror(errno));
> -		return BOOL_FALSE;
>  	}
>  
>  	if (preemptchk(PREEMPT_FULL)) {
> -- 
> 2.18.1
> 
