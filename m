Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o339LBu8033685 for <xfs@oss.sgi.com>; Sat, 3 Apr 2010 04:21:14 -0500
Date: Sat, 3 Apr 2010 05:22:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: exempt quota files from filesize checks
Message-ID: <20100403092258.GA20166@infradead.org>
References: <20100401203956.GA28295@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100401203956.GA28295@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 01, 2010 at 03:39:56PM -0500, Bill Kendall wrote:
> xfsdump backs up quota information by generating quota dump files
> ("xfs_quota -c dump") in the root of the filesystem being dumped.  If the
> user filters files from the dump based on max file size (-z option) the
> quota files may not be dumped. The following patch makes the quota files
> exempt from the max filesize checks.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> diff --git a/common/content.h b/common/content.h
> index e21f38e..03b72f0 100644
> --- a/common/content.h
> +++ b/common/content.h
> @@ -65,6 +65,8 @@ typedef struct content_hdr content_hdr_t;
>  #define CONTENT_PQUOTAFILE	"xfsdump_quotas_proj"
>  #define CONTENT_GQUOTAFILE	"xfsdump_quotas_group"
>  
> +#ifdef DUMP

How is this related to the rest of the patch?

>  /* save quota information in dump
>   */
>  static quota_info_t quotas[] = {
> -	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT },
> -	{ "project quota",	BOOL_TRUE,	CONTENT_PQUOTAFILE,	"", "-pf", XFS_QUOTA_PDQ_ACCT },
> -	{ "group quota",	BOOL_TRUE,	CONTENT_GQUOTAFILE,	"", "-gf", XFS_QUOTA_GDQ_ACCT }
> +	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT, 0 },
> +	{ "project quota",	BOOL_TRUE,	CONTENT_PQUOTAFILE,	"", "-pf", XFS_QUOTA_PDQ_ACCT, 0 },
> +	{ "group quota",	BOOL_TRUE,	CONTENT_GQUOTAFILE,	"", "-gf", XFS_QUOTA_GDQ_ACCT, 0 }
>  };

trailing fields in static structures are implicitly filled with zeroes.




Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
