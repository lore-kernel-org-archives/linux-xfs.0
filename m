Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5BD1C7F58
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 08:02:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 50E548F804B
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 06:02:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id k8XQaXM5jrvwxQuS for
	<xfs@oss.sgi.com>; Mon, 09 Jun 2014 06:02:51 -0700 (PDT)
Date: Mon, 9 Jun 2014 09:02:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs_fsr: test for more potential failures in
	packfile()
Message-ID: <20140609130249.GC31319@bfoster.bfoster>
References: <53922B49.1050005@redhat.com>
 <53922D67.2060906@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53922D67.2060906@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 06, 2014 at 04:06:47PM -0500, Eric Sandeen wrote:
> Test for lseek, ftruncate, and fsync failures in packfile()
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 8b191e6..48629fd 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1325,7 +1325,11 @@ packfile(char *fname, char *tname, int fd,
>  				fsrprintf(_("could not trunc tmp %s\n"),
>  					   tname);
>  			}
> -			lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR);
> +			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
> +				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
> +				   tname, strerror(errno));
> +				goto out;
> +			}
>  			continue;
>  		} else if (outmap[extent].bmv_length == 0) {
>  			/* to catch holes at the beginning of the file */
> @@ -1341,7 +1345,11 @@ packfile(char *fname, char *tname, int fd,
>  					" %s\n"), tname);
>  				goto out;
>  			}
> -			lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR);
> +			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
> +				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
> +				   tname, strerror(errno));
> +				goto out;
> +			}
>  		}
>  	} /* end of space allocation loop */
>  
> @@ -1365,8 +1373,16 @@ packfile(char *fname, char *tname, int fd,
>  	for (extent = 0; extent < nextents; extent++) {
>  		pos = outmap[extent].bmv_offset;
>  		if (outmap[extent].bmv_block == -1) {
> -			lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR);
> -			lseek64(fd, outmap[extent].bmv_length, SEEK_CUR);
> +			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
> +				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
> +				   tname, strerror(errno));
> +				goto out;
> +			}
> +			if (lseek64(fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
> +				fsrprintf(_("could not lseek in file: %s : %s\n"),
> +				   fname, strerror(errno));
> +				goto out;
> +			}
>  			continue;
>  		} else if (outmap[extent].bmv_length == 0) {
>  			/* to catch holes at the beginning of the file */
> @@ -1442,8 +1458,16 @@ packfile(char *fname, char *tname, int fd,
>  			}
>  		}
>  	}
> -	ftruncate64(tfd, statp->bs_size);
> -	fsync(tfd);
> +	if (ftruncate64(tfd, statp->bs_size) < 0) {
> +		fsrprintf(_("could not truncate tmpfile: %s : %s\n"),
> +				fname, strerror(errno));
> +		goto out;
> +	}
> +	if (fsync(tfd) < 0) {
> +		fsrprintf(_("could not fsync tmpfile: %s : %s\n"),
> +				fname, strerror(errno));
> +		goto out;
> +	}
>  
>  	sx.sx_stat     = *statp; /* struct copy */
>  	sx.sx_version  = XFS_SX_VERSION;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
