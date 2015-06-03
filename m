Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2DB417FCC
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 12:11:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C25B304062
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 10:11:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bD4eYVV3Am4LLGyL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 10:11:09 -0700 (PDT)
Date: Wed, 3 Jun 2015 13:11:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfsprogs: remove unused write-only var l_logsize
Message-ID: <20150603171106.GA45447@bfoster.bfoster>
References: <5568B7CE.9030709@redhat.com>
 <5568B809.1090302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5568B809.1090302@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Fri, May 29, 2015 at 02:03:37PM -0500, Eric Sandeen wrote:
> l_logsize is only ever set, and is never read.
> Remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/sb.c             |    1 -
>  include/libxlog.h   |    1 -
>  logprint/logprint.c |    1 -
>  repair/phase2.c     |    1 -
>  4 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/db/sb.c b/db/sb.c
> index cd12f83..991478d 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -251,7 +251,6 @@ sb_logcheck(void)
>  		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
>  
>  	log.l_dev = mp->m_logdev_targp;
> -	log.l_logsize = BBTOB(log.l_logBBsize);
>  	log.l_logBBsize = x.logBBsize;
>  	log.l_logBBstart = x.logBBstart;
>  	log.l_sectBBsize  = BTOBB(x.lbsize);
> diff --git a/include/libxlog.h b/include/libxlog.h
> index d6ba9a5..e6d915c 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -28,7 +28,6 @@ struct xlog {
>  	xfs_mount_t	*l_mp;	        /* mount point */
>  	struct xfs_buftarg *l_dev;	        /* dev_t of log */
>  	xfs_daddr_t	l_logBBstart;   /* start block of log */
> -	int		l_logsize;      /* size of log in bytes */
>  	int		l_logBBsize;    /* size of log in 512 byte chunks */
>  	int		l_curr_cycle;   /* Cycle number of log writes */
>  	int		l_prev_cycle;   /* Cycle # b4 last block increment */
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index 960a267..fdf106b 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -242,7 +242,6 @@ main(int argc, char **argv)
>  	ASSERT(x.logBBsize <= INT_MAX);
>  
>  	log.l_dev = mount.m_logdev_targp;
> -	log.l_logsize     = BBTOB(x.logBBsize);
>  	log.l_logBBstart  = x.logBBstart;
>  	log.l_logBBsize   = x.logBBsize;
>  	log.l_sectBBsize  = BTOBB(x.lbsize);
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 0192346..983aaa7 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -50,7 +50,6 @@ zero_log(xfs_mount_t *mp)
>  		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
>  
>  	log.l_dev = mp->m_logdev_targp;
> -	log.l_logsize = BBTOB(x.logBBsize);
>  	log.l_logBBsize = x.logBBsize;
>  	log.l_logBBstart = x.logBBstart;
>  	log.l_sectBBsize  = BTOBB(x.lbsize);
> -- 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
