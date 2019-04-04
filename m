Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56902 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfDDWRD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 18:17:03 -0400
Subject: Re: [PATCH 42/36] xfs_db: refactor metadump handling of multi-fsb
 objects
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193658.GF1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <37438b82-0775-b461-0e4f-5711c260b70f@sandeen.net>
Date: Thu, 4 Apr 2019 17:17:01 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193658.GF1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 2:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Separate the multi-fsb object dispatch from actual dir block processing
> so that we can implement symlink handling correctly as a multi-fsb file.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/metadump.c |   27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 3cce3012..83a257d0 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1911,7 +1911,7 @@ static struct bbmap mfsb_map;
>  static int mfsb_length;
>  
>  static int
> -process_multi_fsb_objects(
> +process_multi_fsb_dir(
>  	xfs_fileoff_t	o,
>  	xfs_fsblock_t	s,
>  	xfs_filblks_t	c,
> @@ -1921,14 +1921,6 @@ process_multi_fsb_objects(
>  	char		*dp;
>  	int		ret = 0;
>  
> -	switch (btype) {
> -	case TYP_DIR2:
> -		break;
> -	default:
> -		print_warning("bad type for multi-fsb object %d", btype);
> -		return -EINVAL;
> -	}
> -
>  	while (c > 0) {
>  		unsigned int	bm_len;
>  
> @@ -1987,6 +1979,23 @@ process_multi_fsb_objects(
>  	return ret;
>  }
>  
> +static int
> +process_multi_fsb_objects(
> +	xfs_fileoff_t	o,
> +	xfs_fsblock_t	s,
> +	xfs_filblks_t	c,
> +	typnm_t		btype,
> +	xfs_fileoff_t	last)
> +{
> +	switch (btype) {
> +	case TYP_DIR2:
> +		return process_multi_fsb_dir(o, s, c, btype, last);
> +	default:
> +		print_warning("bad type for multi-fsb object %d", btype);
> +		return -EINVAL;
> +	}
> +}
> +
>  /* inode copy routines */
>  static int
>  process_bmbt_reclist(
> 
