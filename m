Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47924 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755085AbeFNQeS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 12:34:18 -0400
Subject: Re: [PATCH 4/2] mkfs: add -c option to the --help screen
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <20180614162029.GB6825@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6f251f1a-f1d8-ddb4-92c3-faad877e466b@sandeen.net>
Date: Thu, 14 Jun 2018 11:34:17 -0500
MIME-Version: 1.0
In-Reply-To: <20180614162029.GB6825@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 6/14/18 11:20 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Mention the -c option when the user runs mkfs.xfs --help.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

oops!

Reviewed-by: Eric Sandeen <sandeeN@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1a5636fe..f106517f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -823,6 +823,7 @@ usage( void )
>  {
>  	fprintf(stderr, _("Usage: %s\n\
>  /* blocksize */		[-b size=num]\n\
> +/* config file */	[-c configfile]\n\
>  /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
>  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
