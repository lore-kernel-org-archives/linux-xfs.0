Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 149E67F47
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 10:47:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D90A8304053
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 08:47:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AYecKTFtZXERxCR4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2016 08:47:44 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id E5F2FA0792
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 16:47:43 +0000 (UTC)
Date: Thu, 14 Jan 2016 17:47:40 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] libxfs: don't pass negative errnos to strerror()
Message-ID: <20160114164740.GA20151@redhat.com>
References: <5697CE69.3050905@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5697CE69.3050905@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

This looks good to me, and simple enough.

consider it

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Thu, Jan 14, 2016 at 10:35:53AM -0600, Eric Sandeen wrote:
> The error negation work in 12b5319 tripped up a little bit
> when we're reporting errors via strerror().  By negating
> the error before passing it to strerror, we get i.e.
> 
>    mkfs.xfs: pwrite64 failed: Unknown error -22
> 
> Keep the error positive, but return -error, just as we
> do in the else clauses in these functions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 7a04985..7b23394 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -913,12 +913,12 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
>  
>  	sts = pread64(fd, buf, len, offset);
>  	if (sts < 0) {
> -		int error = -errno;
> +		int error = errno;
>  		fprintf(stderr, _("%s: read failed: %s\n"),
>  			progname, strerror(error));
>  		if (flags & LIBXFS_EXIT_ON_FAILURE)
>  			exit(1);
> -		return error;
> +		return -error;
>  	} else if (sts != len) {
>  		fprintf(stderr, _("%s: error - read only %d of %d bytes\n"),
>  			progname, sts, len);
> @@ -1081,12 +1081,12 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
>  
>  	sts = pwrite64(fd, buf, len, offset);
>  	if (sts < 0) {
> -		int error = -errno;
> +		int error = errno;
>  		fprintf(stderr, _("%s: pwrite64 failed: %s\n"),
>  			progname, strerror(error));
>  		if (flags & LIBXFS_B_EXIT)
>  			exit(1);
> -		return error;
> +		return -error;
>  	} else if (sts != len) {
>  		fprintf(stderr, _("%s: error - pwrite64 only %d of %d bytes\n"),
>  			progname, sts, len);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
