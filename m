Return-Path: <SRS0=vvgS=W4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF92C3A5A4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93D9122CF7
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UoSuzORK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbfIAUzN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:55:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfIAUzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 16:55:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81KsZIK149256;
        Sun, 1 Sep 2019 20:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YjW9/jj/ooZhaC6ZxOHvyF1mexa0cyrQpUT6VIAUAkA=;
 b=UoSuzORKAz86DUVq80cAnUaoyjJlBqnUrt1W3JTgpcunQmqEG7MywK8B1EHo8UcH/Wh9
 iTXS8lb4t/OPMZz/AFweRATFQ70c5+FZ0bIsqqD8Fpk9OqNgJT/D6SQGicwueHG/Rwqr
 GB4yOLFvp60b1XWJ/HCADIMUuz0o+ynkctgRbyKeUpNLuCJmprqpmGf5l1n2Qu2g42gG
 M0F32gPGmnT4eJrvjBG3jF1zHXAAqt42aEby4t8pRNlHg+CD5GZZyKW6ooxtRdjA/Xpw
 sxYJ2sCbNKBaJUPcTwuqkSvnkXRRitIMji6F/+arZHPU+erzU0Ku3HD6lulta2YXk1NE iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2urne7r00n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:55:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x81Ks74P077741;
        Sun, 1 Sep 2019 20:55:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uqg827qcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Sep 2019 20:55:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x81Kt5Up017890;
        Sun, 1 Sep 2019 20:55:05 GMT
Received: from [192.168.1.9] (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Sep 2019 13:55:05 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 7/9] libfrog: refactor open-coded bulkstat calls
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713886958.386621.13098819870887683837.stgit@magnolia>
Message-ID: <a36f906a-e49c-bfde-394c-940beacca9ac@oracle.com>
Date:   Sun, 1 Sep 2019 13:55:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156713886958.386621.13098819870887683837.stgit@magnolia>
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
> Refactor the BULKSTAT_SINGLE and BULKSTAT ioctl callsites into helper
> functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fsr/xfs_fsr.c      |  110 ++++++++++++++++++++++------------------------------
>   include/xfrog.h    |    7 +++
>   io/open.c          |   72 +++++++++++++++++-----------------
>   io/swapext.c       |   20 ++-------
>   libfrog/Makefile   |    1
>   libfrog/bulkstat.c |   52 +++++++++++++++++++++++++
>   quota/quot.c       |   33 ++++++++--------
>   scrub/inodes.c     |   32 ++++-----------
>   8 files changed, 172 insertions(+), 155 deletions(-)
>   create mode 100644 libfrog/bulkstat.c
> 
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 4b239a30..36402252 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -102,31 +102,6 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
>   				 * of extents */
>   static int	openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
>   
> -static int
> -xfs_bulkstat_single(int fd, xfs_ino_t *lastip, struct xfs_bstat *ubuffer)
> -{
> -    struct xfs_fsop_bulkreq  bulkreq;
> -
> -    bulkreq.lastip = (__u64 *)lastip;
> -    bulkreq.icount = 1;
> -    bulkreq.ubuffer = ubuffer;
> -    bulkreq.ocount = NULL;
> -    return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
> -}
> -
> -static int
> -xfs_bulkstat(int fd, xfs_ino_t *lastip, int icount,
> -                    struct xfs_bstat *ubuffer, __s32 *ocount)
> -{
> -    struct xfs_fsop_bulkreq  bulkreq;
> -
> -    bulkreq.lastip = (__u64 *)lastip;
> -    bulkreq.icount = icount;
> -    bulkreq.ubuffer = ubuffer;
> -    bulkreq.ocount = ocount;
> -    return ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
> -}
> -
>   static int
>   xfs_swapext(int fd, xfs_swapext_t *sx)
>   {
> @@ -596,11 +571,11 @@ fsrall_cleanup(int timeout)
>   static int
>   fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>   {
> -
> -	int	fsfd, fd;
> +	struct xfs_fd	fsxfd = XFS_FD_INIT_EMPTY;
> +	int	fd;
>   	int	count = 0;
>   	int	ret;
> -	__s32	buflenout;
> +	uint32_t buflenout;
>   	struct xfs_bstat buf[GRABSZ];
>   	char	fname[64];
>   	char	*tname;
> @@ -617,26 +592,27 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>   		return -1;
>   	}
>   
> -	if ((fsfd = open(mntdir, O_RDONLY)) < 0) {
> +	if ((fsxfd.fd = open(mntdir, O_RDONLY)) < 0) {
>   		fsrprintf(_("unable to open: %s: %s\n"),
>   		          mntdir, strerror( errno ));
>   		free(fshandlep);
>   		return -1;
>   	}
>   
> -	ret = xfrog_geometry(fsfd, &fsgeom);
> +	ret = xfd_prepare_geometry(&fsxfd);
>   	if (ret) {
>   		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
>   			  mntdir);
> -		close(fsfd);
> +		xfd_close(&fsxfd);
>   		free(fshandlep);
>   		return -1;
>   	}
> +	memcpy(&fsgeom, &fsxfd.fsgeom, sizeof(fsgeom));
>   
>   	tmp_init(mntdir);
>   
> -	while ((ret = xfs_bulkstat(fsfd,
> -				&lastino, GRABSZ, &buf[0], &buflenout)) == 0) {
> +	while ((ret = xfrog_bulkstat(&fsxfd, &lastino, GRABSZ, &buf[0],
> +				&buflenout)) == 0) {
>   		struct xfs_bstat *p;
>   		struct xfs_bstat *endp;
>   
> @@ -685,16 +661,16 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>   		}
>   		if (endtime && endtime < time(NULL)) {
>   			tmp_close(mntdir);
> -			close(fsfd);
> +			xfd_close(&fsxfd);
>   			fsrall_cleanup(1);
>   			exit(1);
>   		}
>   	}
> -	if (ret < 0)
> -		fsrprintf(_("%s: xfs_bulkstat: %s\n"), progname, strerror(errno));
> +	if (ret)
> +		fsrprintf(_("%s: bulkstat: %s\n"), progname, strerror(ret));
>   out0:
>   	tmp_close(mntdir);
> -	close(fsfd);
> +	xfd_close(&fsxfd);
>   	free(fshandlep);
>   	return 0;
>   }
> @@ -727,13 +703,16 @@ fsrdir(char *dirname)
>    * an open on the file and passes this all to fsrfile_common.
>    */
>   static int
> -fsrfile(char *fname, xfs_ino_t ino)
> +fsrfile(
> +	char			*fname,
> +	xfs_ino_t		ino)
>   {
> -	struct xfs_bstat statbuf;
> -	jdm_fshandle_t	*fshandlep;
> -	int	fd = -1, fsfd = -1;
> -	int	error = -1;
> -	char	*tname;
> +	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
> +	struct xfs_bstat	statbuf;
> +	jdm_fshandle_t		*fshandlep;
> +	int			fd = -1;
> +	int			error = -1;
> +	char			*tname;
>   
>   	fshandlep = jdm_getfshandle(getparent (fname) );
>   	if (!fshandlep) {
> @@ -746,16 +725,23 @@ fsrfile(char *fname, xfs_ino_t ino)
>   	 * Need to open something on the same filesystem as the
>   	 * file.  Open the parent.
>   	 */
> -	fsfd = open(getparent(fname), O_RDONLY);
> -	if (fsfd < 0) {
> +	fsxfd.fd = open(getparent(fname), O_RDONLY);
> +	if (fsxfd.fd < 0) {
>   		fsrprintf(_("unable to open sys handle for %s: %s\n"),
>   			fname, strerror(errno));
>   		goto out;
>   	}
>   
> -	if ((xfs_bulkstat_single(fsfd, &ino, &statbuf)) < 0) {
> +	error = xfd_prepare_geometry(&fsxfd);
> +	if (error) {
> +		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
> +		goto out;
> +	}
> +
> +	error = xfrog_bulkstat_single(&fsxfd, ino, &statbuf);
> +	if (error) {
>   		fsrprintf(_("unable to get bstat on %s: %s\n"),
> -			fname, strerror(errno));
> +			fname, strerror(error));
>   		goto out;
>   	}
>   
> @@ -766,12 +752,8 @@ fsrfile(char *fname, xfs_ino_t ino)
>   		goto out;
>   	}
>   
> -	/* Get the fs geometry */
> -	error = xfrog_geometry(fsfd, &fsgeom);
> -	if (error) {
> -		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
> -		goto out;
> -	}
> +	/* Stash the fs geometry for general use. */
> +	memcpy(&fsgeom, &fsxfd.fsgeom, sizeof(fsgeom));

Just a nit: Why the memcpy here instead of making a general use pointer?

Otherwise looks like a lot of good clean up
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

>   
>   	tname = gettmpname(fname);
>   
> @@ -779,8 +761,7 @@ fsrfile(char *fname, xfs_ino_t ino)
>   		error = fsrfile_common(fname, tname, NULL, fd, &statbuf);
>   
>   out:
> -	if (fsfd >= 0)
> -		close(fsfd);
> +	xfd_close(&fsxfd);
>   	if (fd >= 0)
>   		close(fd);
>   	free(fshandlep);
> @@ -947,6 +928,7 @@ fsr_setup_attr_fork(
>   	struct xfs_bstat *bstatp)
>   {
>   #ifdef HAVE_FSETXATTR
> +	struct xfs_fd	txfd = XFS_FD_INIT(tfd);
>   	struct stat	tstatbuf;
>   	int		i;
>   	int		diff = 0;
> @@ -964,7 +946,7 @@ fsr_setup_attr_fork(
>   	if (!(fsgeom.flags & XFS_FSOP_GEOM_FLAGS_ATTR2) ||
>   	    bstatp->bs_forkoff == 0) {
>   		/* attr1 */
> -		ret = fsetxattr(tfd, "user.X", "X", 1, XATTR_CREATE);
> +		ret = fsetxattr(txfd.fd, "user.X", "X", 1, XATTR_CREATE);
>   		if (ret) {
>   			fsrprintf(_("could not set ATTR\n"));
>   			return -1;
> @@ -974,7 +956,7 @@ fsr_setup_attr_fork(
>   
>   	/* attr2 w/ fork offsets */
>   
> -	if (fstat(tfd, &tstatbuf) < 0) {
> +	if (fstat(txfd.fd, &tstatbuf) < 0) {
>   		fsrprintf(_("unable to stat temp file: %s\n"),
>   					strerror(errno));
>   		return -1;
> @@ -983,18 +965,18 @@ fsr_setup_attr_fork(
>   	i = 0;
>   	do {
>   		struct xfs_bstat tbstat;
> -		xfs_ino_t	ino;
>   		char		name[64];
> +		int		ret;
>   
>   		/*
>   		 * bulkstat the temp inode to see what the forkoff is.  Use
>   		 * this to compare against the target and determine what we
>   		 * need to do.
>   		 */
> -		ino = tstatbuf.st_ino;
> -		if ((xfs_bulkstat_single(tfd, &ino, &tbstat)) < 0) {
> +		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, &tbstat);
> +		if (ret) {
>   			fsrprintf(_("unable to get bstat on temp file: %s\n"),
> -						strerror(errno));
> +						strerror(ret));
>   			return -1;
>   		}
>   		if (dflag)
> @@ -1014,7 +996,7 @@ fsr_setup_attr_fork(
>   		 */
>   		if (!tbstat.bs_forkoff) {
>   			ASSERT(i == 0);
> -			ret = fsetxattr(tfd, name, "XX", 2, XATTR_CREATE);
> +			ret = fsetxattr(txfd.fd, name, "XX", 2, XATTR_CREATE);
>   			if (ret) {
>   				fsrprintf(_("could not set ATTR\n"));
>   				return -1;
> @@ -1050,7 +1032,7 @@ fsr_setup_attr_fork(
>   			if (diff < 0) {
>   				char val[2048];
>   				memset(val, 'X', 2048);
> -				if (fsetxattr(tfd, name, val, 2048, 0)) {
> +				if (fsetxattr(txfd.fd, name, val, 2048, 0)) {
>   					fsrprintf(_("big ATTR set failed\n"));
>   					return -1;
>   				}
> @@ -1094,7 +1076,7 @@ fsr_setup_attr_fork(
>   		}
>   
>   		/* we need to grow the attr fork, so create another attr */
> -		ret = fsetxattr(tfd, name, "XX", 2, XATTR_CREATE);
> +		ret = fsetxattr(txfd.fd, name, "XX", 2, XATTR_CREATE);
>   		if (ret) {
>   			fsrprintf(_("could not set ATTR\n"));
>   			return -1;
> diff --git a/include/xfrog.h b/include/xfrog.h
> index a08f6464..7bda9810 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -108,4 +108,11 @@ cvt_b_to_off_fsbt(
>   	return bytes >> xfd->blocklog;
>   }
>   
> +/* Bulkstat wrappers */
> +struct xfs_bstat;
> +int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
> +		struct xfs_bstat *ubuffer);
> +int xfrog_bulkstat(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
> +		struct xfs_bstat *ubuffer, uint32_t *ocount);
> +
>   #endif	/* __XFROG_H__ */
> diff --git a/io/open.c b/io/open.c
> index 8b24a4f9..35e6131b 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -719,19 +719,18 @@ get_last_inode(void)
>   
>   static int
>   inode_f(
> -	  int			argc,
> -	  char			**argv)
> +	int			argc,
> +	char			**argv)
>   {
> -	__s32			count = 0;
> -	__u64			result_ino = 0;
> -	__u64			userino = NULLFSINO;
> +	struct xfs_bstat	bstat;
> +	uint32_t		count = 0;
> +	uint64_t		result_ino = 0;
> +	uint64_t		userino = NULLFSINO;
>   	char			*p;
>   	int			c;
>   	int			verbose = 0;
>   	int			ret_next = 0;
> -	int			cmd = 0;
> -	struct xfs_fsop_bulkreq	bulkreq;
> -	struct xfs_bstat	bstat;
> +	int			ret;
>   
>   	while ((c = getopt(argc, argv, "nv")) != EOF) {
>   		switch (c) {
> @@ -773,35 +772,38 @@ inode_f(
>   			exitcode = 1;
>   			return 0;
>   		}
> +	} else if (ret_next) {
> +		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
> +
> +		/* get next inode */
> +		ret = xfrog_bulkstat(&xfd, &userino, 1, &bstat, &count);
> +		if (ret) {
> +			errno = ret;
> +			perror("bulkstat");
> +			exitcode = 1;
> +			return 0;
> +		}
> +
> +		/* The next inode in use, or 0 if none */
> +		if (count)
> +			result_ino = bstat.bs_ino;
> +		else
> +			result_ino = 0;
>   	} else {
> -		if (ret_next)	/* get next inode */
> -			cmd = XFS_IOC_FSBULKSTAT;
> -		else		/* get this inode */
> -			cmd = XFS_IOC_FSBULKSTAT_SINGLE;
> -
> -		bulkreq.lastip = &userino;
> -		bulkreq.icount = 1;
> -		bulkreq.ubuffer = &bstat;
> -		bulkreq.ocount = &count;
> -
> -		if (xfsctl(file->name, file->fd, cmd, &bulkreq)) {
> -			if (!ret_next && errno == EINVAL) {
> -				/* Not in use */
> -				result_ino = 0;
> -			} else {
> -				perror("xfsctl");
> -				exitcode = 1;
> -				return 0;
> -			}
> -		} else if (ret_next) {
> -			/* The next inode in use, or 0 if none */
> -			if (*bulkreq.ocount)
> -				result_ino = bstat.bs_ino;
> -			else
> -				result_ino = 0;
> +		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
> +
> +		/* get this inode */
> +		ret = xfrog_bulkstat_single(&xfd, userino, &bstat);
> +		if (ret == EINVAL) {
> +			/* Not in use */
> +			result_ino = 0;
> +		} else if (ret) {
> +			errno = ret;
> +			perror("bulkstat_single");
> +			exitcode = 1;
> +			return 0;
>   		} else {
> -			/* The inode we asked about */
> -			result_ino = userino;
> +			result_ino = bstat.bs_ino;
>   		}
>   	}
>   
> diff --git a/io/swapext.c b/io/swapext.c
> index d360c221..fbf4fff5 100644
> --- a/io/swapext.c
> +++ b/io/swapext.c
> @@ -8,6 +8,7 @@
>   #include "input.h"
>   #include "init.h"
>   #include "io.h"
> +#include "xfrog.h"
>   
>   static cmdinfo_t swapext_cmd;
>   
> @@ -20,26 +21,12 @@ swapext_help(void)
>   "\n"));
>   }
>   
> -static int
> -xfs_bulkstat_single(
> -	int			fd,
> -	xfs_ino_t		*lastip,
> -	struct xfs_bstat	*ubuffer)
> -{
> -	struct xfs_fsop_bulkreq	bulkreq;
> -
> -	bulkreq.lastip = (__u64 *)lastip;
> -	bulkreq.icount = 1;
> -	bulkreq.ubuffer = ubuffer;
> -	bulkreq.ocount = NULL;
> -	return ioctl(fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
> -}
> -
>   static int
>   swapext_f(
>   	int			argc,
>   	char			**argv)
>   {
> +	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
>   	int			fd;
>   	int			error;
>   	struct xfs_swapext	sx;
> @@ -60,8 +47,9 @@ swapext_f(
>   		goto out;
>   	}
>   
> -	error = xfs_bulkstat_single(file->fd, &stat.st_ino, &sx.sx_stat);
> +	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, &sx.sx_stat);
>   	if (error) {
> +		errno = error;
>   		perror("bulkstat");
>   		goto out;
>   	}
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index f5a0539b..05c6f701 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -13,6 +13,7 @@ LT_AGE = 0
>   CFILES = \
>   avl64.c \
>   bitmap.c \
> +bulkstat.c \
>   convert.c \
>   crc32.c \
>   fsgeom.c \
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> new file mode 100644
> index 00000000..0e11ccea
> --- /dev/null
> +++ b/libfrog/bulkstat.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include "xfs.h"
> +#include "xfrog.h"
> +
> +/* Bulkstat a single inode.  Returns zero or a positive error code. */
> +int
> +xfrog_bulkstat_single(
> +	struct xfs_fd		*xfd,
> +	uint64_t		ino,
> +	struct xfs_bstat	*ubuffer)
> +{
> +	__u64			i = ino;
> +	struct xfs_fsop_bulkreq	bulkreq = {
> +		.lastip		= &i,
> +		.icount		= 1,
> +		.ubuffer	= ubuffer,
> +		.ocount		= NULL,
> +	};
> +	int			ret;
> +
> +	ret = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
> +	if (ret)
> +		return errno;
> +	return 0;
> +}
> +
> +/* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
> +int
> +xfrog_bulkstat(
> +	struct xfs_fd		*xfd,
> +	uint64_t		*lastino,
> +	uint32_t		icount,
> +	struct xfs_bstat	*ubuffer,
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
> +	ret = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
> +	if (ret)
> +		return errno;
> +	return 0;
> +}
> diff --git a/quota/quot.c b/quota/quot.c
> index 6bc91171..1e970819 100644
> --- a/quota/quot.c
> +++ b/quota/quot.c
> @@ -11,6 +11,7 @@
>   #include <grp.h>
>   #include "init.h"
>   #include "quota.h"
> +#include "xfrog.h"
>   
>   typedef struct du {
>   	struct du	*next;
> @@ -124,13 +125,13 @@ quot_bulkstat_add(
>   static void
>   quot_bulkstat_mount(
>   	char			*fsdir,
> -	uint			flags)
> +	unsigned int		flags)
>   {
> -	struct xfs_fsop_bulkreq	bulkreq;
> +	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
>   	struct xfs_bstat	*buf;
> -	__u64			last = 0;
> -	__s32			count;
> -	int			i, sts, fsfd;
> +	uint64_t		last = 0;
> +	uint32_t		count;
> +	int			i, sts;
>   	du_t			**dp;
>   
>   	/*
> @@ -145,8 +146,8 @@ quot_bulkstat_mount(
>   			*dp = NULL;
>   	ndu[0] = ndu[1] = ndu[2] = 0;
>   
> -	fsfd = open(fsdir, O_RDONLY);
> -	if (fsfd < 0) {
> +	fsxfd.fd = open(fsdir, O_RDONLY);
> +	if (fsxfd.fd < 0) {
>   		perror(fsdir);
>   		return;
>   	}
> @@ -154,25 +155,23 @@ quot_bulkstat_mount(
>   	buf = (struct xfs_bstat *)calloc(NBSTAT, sizeof(struct xfs_bstat));
>   	if (!buf) {
>   		perror("calloc");
> -		close(fsfd);
> +		xfd_close(&fsxfd);
>   		return;
>   	}
>   
> -	bulkreq.lastip = &last;
> -	bulkreq.icount = NBSTAT;
> -	bulkreq.ubuffer = buf;
> -	bulkreq.ocount = &count;
> -
> -	while ((sts = xfsctl(fsdir, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
> +	while ((sts = xfrog_bulkstat(&fsxfd, &last, NBSTAT, buf,
> +				&count)) == 0) {
>   		if (count == 0)
>   			break;
>   		for (i = 0; i < count; i++)
>   			quot_bulkstat_add(&buf[i], flags);
>   	}
> -	if (sts < 0)
> -		perror("XFS_IOC_FSBULKSTAT"),
> +	if (sts < 0) {
> +		errno = sts;
> +		perror("XFS_IOC_FSBULKSTAT");
> +	}
>   	free(buf);
> -	close(fsfd);
> +	xfd_close(&fsxfd);
>   }
>   
>   static int
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 700e5200..413037d8 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -17,6 +17,7 @@
>   #include "xfs_scrub.h"
>   #include "common.h"
>   #include "inodes.h"
> +#include "xfrog.h"
>   
>   /*
>    * Iterate a range of inodes.
> @@ -50,17 +51,10 @@ xfs_iterate_inodes_range_check(
>   	struct xfs_inogrp	*inogrp,
>   	struct xfs_bstat	*bstat)
>   {
> -	struct xfs_fsop_bulkreq	onereq = {NULL};
>   	struct xfs_bstat	*bs;
> -	__u64			oneino;
> -	__s32			onelen = 0;
>   	int			i;
>   	int			error;
>   
> -	onereq.lastip  = &oneino;
> -	onereq.icount  = 1;
> -	onereq.ocount  = &onelen;
> -
>   	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
>   		if (!(inogrp->xi_allocmask & (1ULL << i)))
>   			continue;
> @@ -70,10 +64,8 @@ xfs_iterate_inodes_range_check(
>   		}
>   
>   		/* Load the one inode. */
> -		oneino = inogrp->xi_startino + i;
> -		onereq.ubuffer = bs;
> -		error = ioctl(ctx->mnt.fd, XFS_IOC_FSBULKSTAT_SINGLE,
> -				&onereq);
> +		error = xfrog_bulkstat_single(&ctx->mnt,
> +				inogrp->xi_startino + i, bs);
>   		if (error || bs->bs_ino != inogrp->xi_startino + i) {
>   			memset(bs, 0, sizeof(struct xfs_bstat));
>   			bs->bs_ino = inogrp->xi_startino + i;
> @@ -99,16 +91,14 @@ xfs_iterate_inodes_range(
>   	void			*arg)
>   {
>   	struct xfs_fsop_bulkreq	igrpreq = {NULL};
> -	struct xfs_fsop_bulkreq	bulkreq = {NULL};
>   	struct xfs_handle	handle;
>   	struct xfs_inogrp	inogrp;
>   	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
>   	char			idescr[DESCR_BUFSZ];
> -	char			buf[DESCR_BUFSZ];
>   	struct xfs_bstat	*bs;
>   	__u64			igrp_ino;
> -	__u64			ino;
> -	__s32			bulklen = 0;
> +	uint64_t		ino;
> +	uint32_t		bulklen = 0;
>   	__s32			igrplen = 0;
>   	bool			moveon = true;
>   	int			i;
> @@ -117,10 +107,6 @@ xfs_iterate_inodes_range(
>   
>   
>   	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
> -	bulkreq.lastip  = &ino;
> -	bulkreq.icount  = XFS_INODES_PER_CHUNK;
> -	bulkreq.ubuffer = &bstat;
> -	bulkreq.ocount  = &bulklen;
>   
>   	igrpreq.lastip  = &igrp_ino;
>   	igrpreq.icount  = 1;
> @@ -138,17 +124,17 @@ xfs_iterate_inodes_range(
>   	while (!error && igrplen) {
>   		/* Load the inodes. */
>   		ino = inogrp.xi_startino - 1;
> -		bulkreq.icount = inogrp.xi_alloccount;
> +
>   		/*
>   		 * We can have totally empty inode chunks on filesystems where
>   		 * there are more than 64 inodes per block.  Skip these.
>   		 */
>   		if (inogrp.xi_alloccount == 0)
>   			goto igrp_retry;
> -		error = ioctl(ctx->mnt.fd, XFS_IOC_FSBULKSTAT, &bulkreq);
> +		error = xfrog_bulkstat(&ctx->mnt, &ino, inogrp.xi_alloccount,
> +				bstat, &bulklen);
>   		if (error)
> -			str_info(ctx, descr, "%s", strerror_r(errno,
> -						buf, DESCR_BUFSZ));
> +			str_liberror(ctx, error, descr);
>   
>   		xfs_iterate_inodes_range_check(ctx, &inogrp, bstat);
>   
> 
