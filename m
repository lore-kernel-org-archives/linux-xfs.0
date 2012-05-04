Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44GhabO056567 for <xfs@oss.sgi.com>; Fri, 4 May 2012 11:43:36 -0500
Date: Fri, 4 May 2012 11:47:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/4] xfsprogs: Add support to mkfs to add pquotino by
	adding a new option.
Message-ID: <20120504164701.GT16881@sgi.com>
References: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173310.31735.28918.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173310.31735.28918.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:33:10AM -0600, Chandra Seetharaman wrote:
> >From 77152735d6bc893b3a724d7a6ff4bb747fb23aec Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Tue, 13 Dec 2011 16:10:07 -0600
> Subject: [PATCH 4/4] Add support to mkfs to have a separate inode field for project quota.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  mkfs/xfs_mkfs.c |   22 +++++++++++++++++-----
>  mkfs/xfs_mkfs.h |    3 ++-
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f527f3d..872a304 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -90,6 +90,8 @@ char	*dopts[] = {
>  	"projinherit",
>  #define D_EXTSZINHERIT	14
>  	"extszinherit",
> +#define D_NO_OQUOTA	15
> +	"seppquota",
>  	NULL
>  };
>  
> @@ -922,6 +924,7 @@ main(
>  	libxfs_init_t		xi;
>  	struct fs_topology	ft;
>  	int			lazy_sb_counters;
> +	int			seppquota;
>  
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -930,6 +933,7 @@ main(
>  
>  	attrversion = 2;
>  	projid32bit = 0;
> +	seppquota = 1;
>  	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
>  	blocklog = blocksize = 0;
>  	sectorlog = lsectorlog = XFS_MIN_SECTORSIZE_LOG;
> @@ -1178,6 +1182,14 @@ main(
>  					fsx.fsx_xflags |= \
>  						XFS_DIFLAG_EXTSZINHERIT;
>  					break;
> +				case D_NO_OQUOTA:
> +					if (!value)
> +						value = "0";

I recommend that in if seppquota is passed without a value it should default to
1.  A value of 0 is more apropriate if it had been named 'noseppquota'.

Other than that this looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
