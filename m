Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C03B7F59
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 06:26:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDE7E304053
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 04:26:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XHO8781lfmE5ARms (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 04:26:12 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9RBQBrK017786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 07:26:11 -0400
Date: Mon, 27 Oct 2014 07:26:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsprogs: two more completely harmless sparse nits
Message-ID: <20141027112609.GC39598@bfoster.bfoster>
References: <5449964F.1040504@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5449964F.1040504@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2014 at 06:59:11PM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 65f8456..7ea0d36 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -171,7 +171,7 @@ pf_read_bmbt_reclist(
>  	struct xfs_buf_map	map_array[MAP_ARRAY_SZ];
>  	struct xfs_buf_map	*map = map_array;
>  	int			max_extents = MAP_ARRAY_SZ;
> -	int			nmaps = 0;;
> +	int			nmaps = 0;
>  	unsigned int		len = 0;
>  	int			ret = 0;
>  
> diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
> index b81b1e1..5f26a62 100644
> --- a/rtcp/xfs_rtcp.c
> +++ b/rtcp/xfs_rtcp.c
> @@ -25,7 +25,7 @@ int pflag;
>  char *progname;
>  
>  void
> -usage()
> +usage(void)
>  {
>  	fprintf(stderr, _("%s [-e extsize] [-p] [-V] source target\n"), progname);
>  	exit(2);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
