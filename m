Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC2967F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 12:07:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 707D630404E
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 10:07:02 -0700 (PDT)
Received: from mail-pd0-f176.google.com (mail-pd0-f176.google.com
	[209.85.192.176]) by cuda.sgi.com with ESMTP id
	g4tVfDfMSBMDiXB7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 May 2013 10:06:58 -0700 (PDT)
Received: by mail-pd0-f176.google.com with SMTP id r11so2502250pdi.7
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 10:06:57 -0700 (PDT)
Date: Sat, 1 Jun 2013 01:24:56 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
Message-ID: <20130531172456.GB6915@gmail.com>
References: <51A8C59B.3030308@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A8C59B.3030308@redhat.com>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 31, 2013 at 10:45:31AM -0500, Eric Sandeen wrote:
> currently the seek_sanity_test (generic/285) fails on ext3
> or ext2 due to fallocate() failures.  Just ignore that test
> if the fs doesn't support fallocate.

Hi Eric,

I remember that my patch had been applied [1].  But stranger I couldn't
find it in xfstests tree.  However, I think that your patch is better.

1. http://oss.sgi.com/archives/xfs/2013-05/msg00534.html

                                                - Zheng

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index cd3b1ee..fbf5a8c 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -96,9 +96,13 @@ static int do_fallocate(int fd, off_t offset, off_t length, int mode)
>  	int ret;
>  
>  	ret = fallocate(fd, mode, offset, length);
> -	if (ret)
> +	if (ret) {
> +		/* Don't warn about a filesystem w/o fallocate support */
> +		if (errno == EOPNOTSUPP)
> +			return ret;
>  		fprintf(stderr, "  ERROR %d: Failed to preallocate "
>  			"space to %ld bytes\n", errno, (long) length);
> +	}
>  
>  	return ret;
>  }
> @@ -290,8 +294,14 @@ static int test09(int fd, int testnum)
>  
>  	/* preallocate 8M space to file */
>  	ret = do_fallocate(fd, 0, filsz, 0);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		/* Report success if fs doesn't support fallocate */
> +		if (errno == EOPNOTSUPP) {
> +			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
> +			ret = 0;
> +		}
>  		goto out;
> +	}
>  
>  	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
>  	if (!ret) {
> @@ -336,8 +346,14 @@ static int test08(int fd, int testnum)
>  
>  	/* preallocate 4M space to file */
>  	ret = do_fallocate(fd, 0, filsz, 0);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		/* Report success if fs doesn't support fallocate */
> +		if (errno == EOPNOTSUPP) {
> +			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
> +			ret = 0;
> +		}
>  		goto out;
> +	}
>  
>  	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
>  	if (ret)
> @@ -379,8 +395,14 @@ static int test07(int fd, int testnum)
>  
>  	/* preallocate 4M space to file */
>  	ret = do_fallocate(fd, 0, filsz, 0);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		/* Report success if fs doesn't support fallocate */
> +		if (errno == EOPNOTSUPP) {
> +			fprintf(stdout, "Test skipped as fs doesn't support fallocate.\n");
> +			ret = 0;
> +		}
>  		goto out;
> +	}
>  
>  	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
>  	if (ret)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
