Return-Path: <SRS0=f4r+=4K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71888C35669
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Feb 2020 07:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442FC21741
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Feb 2020 07:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PP49WJJ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgBVHYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 02:24:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgBVHYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 02:24:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01M7NSUY127697;
        Sat, 22 Feb 2020 07:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=04qKMWy2DqUdrxJM7TqLxtERrXmm7E9wYT7sJ6cZUX8=;
 b=PP49WJJ+PzYpWzfAaRUqM9mRuWtutNmTRTylyRiHqVy74PS/4FoO6y3EPlgEjSNl8hCQ
 5DhJYZNiE7fsbsu8evI4kKfDHZSXXar4a+ScQQu4bwmd6KtmSX63NH+4nrdjuj3GDQIK
 zr8IYXOhMiL+t156Lx+gJA7gP2Uu7WZHtjgiRK5kMAo0UW64zWFdlffMo6WOlsiWVN0f
 lKY9vJWdo5I97vHOB2tDS+1lDWvm0ByXzeuj6ZBRevuCUOQL1TwAzsKS21Fjp5mDm0P0
 k4HYB5Kwr8zLopxghkBMMs07ePVNRq5Uz0RHKD2c2C4bZjLS09Dkr31jvqb5ktQRs7xU bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yav8q8b94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Feb 2020 07:24:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01M7MvTL003019;
        Sat, 22 Feb 2020 07:24:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yatbcyus3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Feb 2020 07:24:11 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01M7OAe1007547;
        Sat, 22 Feb 2020 07:24:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 23:24:10 -0800
Date:   Fri, 21 Feb 2020 23:24:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V3] libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
Message-ID: <20200222072410.GJ9506@magnolia>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
 <ea039b0a-408d-4859-447c-6d97e11c79c7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea039b0a-408d-4859-447c-6d97e11c79c7@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 suspectscore=9
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002220064
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 impostorscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002220064
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 09:22:12PM -0600, Eric Sandeen wrote:
> I had a request from someone who cared about mkfs speed(!)
> over a slower network block device to look into using faster
> zeroing methods, particularly for the log, during mkfs.
> 
> Using FALLOC_FL_ZERO_RANGE is faster in this case than writing
> a bunch of zeros across a wire.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Clean up all the nasty stuff I'd flung out there as a wild first
> cut, thanks Dave.
> 
> V3: make len_bytes a size_t; leave "end_offset" where it is for the loop
> use.  It's a bit odd but ... just don't mess with it for now, one patch
> one change.
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 4700b527..1dd27f76 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -144,6 +144,9 @@ endif
>  ifeq ($(HAVE_GETFSMAP),yes)
>  PCFLAGS+= -DHAVE_GETFSMAP
>  endif
> +ifeq ($(HAVE_FALLOCATE),yes)
> +PCFLAGS += -DHAVE_FALLOCATE
> +endif
>  
>  LIBICU_LIBS = @libicu_LIBS@
>  LIBICU_CFLAGS = @libicu_CFLAGS@
> diff --git a/include/linux.h b/include/linux.h
> index 8f3c32b0..8d5c4584 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -20,6 +20,10 @@
>  #include <stdio.h>
>  #include <asm/types.h>
>  #include <mntent.h>
> +#include <fcntl.h>
> +#if defined(HAVE_FALLOCATE)
> +#include <linux/falloc.h>
> +#endif
>  #ifdef OVERRIDE_SYSTEM_FSXATTR
>  # define fsxattr sys_fsxattr
>  #endif
> @@ -164,6 +168,24 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
>  	endmntent(cursor->mtabp);
>  }
>  
> +#if defined(FALLOC_FL_ZERO_RANGE)
> +static inline int
> +platform_zero_range(
> +	int		fd,
> +	xfs_off_t	start,
> +	size_t		len)

Seems fine to me, though it's unfortunate to cap this at u32.

> +{
> +	int ret;
> +
> +	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
> +	if (!ret)
> +		return 0;
> +	return -errno;
> +}
> +#else
> +#define platform_zero_range(fd, s, l)	(-EOPNOTSUP)

EOPNOTSUPP (two P's)

--D

> +#endif
> +
>  /*
>   * Check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves. These
>   * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 0d9d7202..e2d9d790 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -61,8 +61,18 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  {
>  	xfs_off_t	start_offset, end_offset, offset;
>  	ssize_t		zsize, bytes;
> +	size_t		len_bytes;
>  	char		*z;
> -	int		fd;
> +	int		error, fd;
> +
> +	fd = libxfs_device_to_fd(btp->dev);
> +	start_offset = LIBXFS_BBTOOFF64(start);
> +
> +	/* try to use special zeroing methods, fall back to writes if needed */
> +	len_bytes = LIBXFS_BBTOOFF64(len);
> +	error = platform_zero_range(fd, start_offset, len_bytes);
> +	if (!error)
> +		return 0;
>  
>  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
>  	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> @@ -73,9 +83,6 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  	}
>  	memset(z, 0, zsize);
>  
> -	fd = libxfs_device_to_fd(btp->dev);
> -	start_offset = LIBXFS_BBTOOFF64(start);
> -
>  	if ((lseek(fd, start_offset, SEEK_SET)) < 0) {
>  		fprintf(stderr, _("%s: %s seek to offset %llu failed: %s\n"),
>  			progname, __FUNCTION__,
> 
> 
