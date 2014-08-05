Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5CE27F85
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 08:16:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71955AC005
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2014 06:16:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AJBe3UkXtmWJLdja (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Aug 2014 06:16:21 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s75DGKcM001449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 5 Aug 2014 09:16:20 -0400
Date: Tue, 5 Aug 2014 09:16:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs_fsr: fix leaks & catch error  in fsrfile()
Message-ID: <20140805131618.GC53538@bfoster.bfoster>
References: <1406905159-12415-1-git-send-email-sandeen@redhat.com>
	<1406905159-12415-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406905159-12415-3-git-send-email-sandeen@redhat.com>
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

On Fri, Aug 01, 2014 at 09:59:15AM -0500, Eric Sandeen wrote:
> The allocated fshandlep leaks on most error paths;
> restructure with an out: target that does all necessary
> freeing, and initialize filehandles to -1 so that we
> know whether they need to be closed on the error path.
> 
> While we're at it, if gettmpname() fails, we still
> return 0 for an error, because error is initialized
> to 0 and only set otherwise by fsrfile_common.
> So if gettmpname() fails, we return success from the
> function even though we did no work.  Fix that
> as well by initializing error to -1.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fsr/xfs_fsr.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 48629fd..752d2db 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -809,15 +809,15 @@ fsrfile(char *fname, xfs_ino_t ino)
>  {
>  	xfs_bstat_t	statbuf;
>  	jdm_fshandle_t	*fshandlep;
> -	int	fd, fsfd;
> -	int	error = 0;
> +	int	fd = -1, fsfd = -1;
> +	int	error = -1;
>  	char	*tname;
>  
>  	fshandlep = jdm_getfshandle(getparent (fname) );
> -	if (! fshandlep) {
> +	if (!fshandlep) {
>  		fsrprintf(_("unable to construct sys handle for %s: %s\n"),
>  			fname, strerror(errno));
> -		return -1;
> +		goto out;
>  	}
>  
>  	/*
> @@ -828,39 +828,39 @@ fsrfile(char *fname, xfs_ino_t ino)
>  	if (fsfd < 0) {
>  		fsrprintf(_("unable to open sys handle for %s: %s\n"),
>  			fname, strerror(errno));
> -		return -1;
> +		goto out;
>  	}
>  
>  	if ((xfs_bulkstat_single(fsfd, &ino, &statbuf)) < 0) {
>  		fsrprintf(_("unable to get bstat on %s: %s\n"),
>  			fname, strerror(errno));
> -		close(fsfd);
> -		return -1;
> +		goto out;
>  	}
>  
>  	fd = jdm_open(fshandlep, &statbuf, O_RDWR|O_DIRECT);
>  	if (fd < 0) {
>  		fsrprintf(_("unable to open handle %s: %s\n"),
>  			fname, strerror(errno));
> -		close(fsfd);
> -		return -1;
> +		goto out;
>  	}
>  
>  	/* Get the fs geometry */
>  	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
>  		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
> -		close(fsfd);
> -		return -1;
> +		goto out;
>  	}
>  
> -	close(fsfd);
> -
>  	tname = gettmpname(fname);
>  
>  	if (tname)
>  		error = fsrfile_common(fname, tname, NULL, fd, &statbuf);
>  

I was wondering whether this bit to not fail if the path is bad was
intentional (e.g., to avoid breaking through a higher-level loop or
something), but we don't check the return value of this function
anyways. :-|

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -	close(fd);
> +out:
> +	if (fsfd >= 0)
> +		close(fsfd);
> +	if (fd >= 0)
> +		close(fd);
> +	free(fshandlep);
>  
>  	return error;
>  }
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
