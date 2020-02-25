Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2434C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 794D12082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yUE68T82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgBYTQv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:16:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbgBYTQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:16:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJ3MB1010143;
        Tue, 25 Feb 2020 19:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=N7Y4rvo/6SK8FGbew7ka4QjSPWNZNEHx/5vsBXaC0go=;
 b=yUE68T82xTlqpb/Bdxah5xwcRyWR6QEi6LzYisOtxefS1BMXJ5jLByWHuibBy6znaGZB
 yrucJgFvXVhFNzxo8IdDIzDYBKf9cGn2Yr6tniGrwb1xzuCJ+GGb1697axsZf9c+6Mzf
 YjXXX0HZNgBiT29TIacOM3D0U20JFUi9gALYkC3XtsT7+rPmGhsXAYo59/F2grovRMLm
 4Da+lUeu62GQ+PhuVKWar1umA6h3VFRSWeh+13mkz0HiUTrL2IUi50K0EMbiYXzow9tn
 6i6SgWaEfC6Uf9sCksSrz3Kl6PvslT2Sq208OPjPHCd4Kyg/guxtUmtr3LZ876H70VLt LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yd0njkhse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:16:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJEAuL195091;
        Tue, 25 Feb 2020 19:16:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yd17qn45s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:16:48 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PJGlmJ011423;
        Tue, 25 Feb 2020 19:16:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 11:16:47 -0800
Date:   Tue, 25 Feb 2020 11:16:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V4] libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
Message-ID: <20200225191646.GQ6740@magnolia>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
 <1c7c39f7-91a7-be85-5906-e55180a91a5f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c7c39f7-91a7-be85-5906-e55180a91a5f@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=9 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=9 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 10:13:55AM -0800, Eric Sandeen wrote:
> I had a request from someone who cared about mkfs speed over
> a slower network block device to look into using faster zeroing
> methods, particularly for the log, during mkfs.
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
> V4: Use EOPNOTSUPP not EOPNOTSUP (same on linux anyway but meh)
> I ignored(tm) darrick's suggestion to make libxfs_device_zero accept
> a longer length, for now - no callers need anything bigger at this time.

But... 

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
> +{
> +	int ret;
> +
> +	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
> +	if (!ret)
> +		return 0;
> +	return -errno;
> +}
> +#else
> +#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
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

...but if the caller passes in (say) 2^23 daddrs on a 32-bit system,
this conversion will try to stuff 2^32 into a size_t (which is 32-bit),
causing an integer overflow.  I grok that no callers currently try this,
but this seems like leaving a logic bomb that could go off on what are
becoming difficult-to-test architectures.

Granted the added overflow checking and whatnot required to convert that
last parameter of libxfs_device_zero to unsigned long long could very
well justify a separate patch for fixing the 64-bitness of the whole
api.

--D 

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
