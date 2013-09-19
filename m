Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB43A7F37
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 17:54:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9791304043
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:54:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vqHF85EGRpx4acSQ for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 15:54:37 -0700 (PDT)
Date: Fri, 20 Sep 2013 08:54:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfsprog: add dirent filetype information for xfs_info
Message-ID: <20130919225435.GL9901@dastard>
References: <20130919211523.407741285@sgi.com>
	<20130919211539.130206963@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130919211539.130206963@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 19, 2013 at 04:05:25PM -0500, Mark Tinguely wrote:
> Make xfs_info aware of the directory inode type.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  growfs/xfs_growfs.c |   14 +++++++++-----
>  include/xfs_fs.h    |   31 ++++++++++++++++---------------
>  2 files changed, 25 insertions(+), 20 deletions(-)
> 
> Index: b/growfs/xfs_growfs.c
> ===================================================================
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -55,7 +55,8 @@ report_info(
>  	int		attrversion,
>  	int		projid32bit,
>  	int		crcs_enabled,
> -	int		cimode)
> +	int		cimode,
> +	int		ftype_enabled)
>  {
>  	printf(_(
>  	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
> @@ -63,7 +64,7 @@ report_info(
>  	    "         =%-22s crc=%u\n"
>  	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
>  	    "         =%-22s sunit=%-6u swidth=%u blks\n"
> -	    "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
> +	    "naming   =version %-14u bsize=%-6u ascii-ci=%d field=%d\n"

What does "field" mean? It doesn't describe the feature at all.
"dtype" or "ftype" would be a better description of what is
different in the directory structure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
