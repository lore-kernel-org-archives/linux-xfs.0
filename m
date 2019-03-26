Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfCZRL2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Mar 2019 13:11:28 -0400
Subject: Re: [PATCH 21/36] xfs_db: use TYP_FINOBT for finobt metadump
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259755947.31886.6074285457193991395.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <67118439-6e6a-2870-5d74-f485375c8c58@sandeen.net>
Date: Tue, 26 Mar 2019 12:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <155259755947.31886.6074285457193991395.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the correct xfs_db type for dumping free inode btree blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

wow this looks familiar too but ... this one isn't in yet :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/metadump.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 6ecd5685..3cce3012 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2607,7 +2607,7 @@ copy_inodes(
>  		levels = be32_to_cpu(agi->agi_free_level);
>  
>  		finobt = 1;
> -		if (!scan_btree(agno, root, levels, TYP_INOBT, &finobt,
> +		if (!scan_btree(agno, root, levels, TYP_FINOBT, &finobt,
>  				scanfunc_ino))
>  			return 0;
>  	}
> 
