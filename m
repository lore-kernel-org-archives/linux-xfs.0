Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84D587CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 03:35:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED506AC002
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 01:35:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w6alJ80sIXq2DcEI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 01:35:57 -0700 (PDT)
Date: Mon, 22 Aug 2016 04:35:54 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: disallow mounting of realtime + rmap filesystems
Message-ID: <20160822083554.GA8035@redhat.com>
References: <20160819203207.GE8268@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160819203207.GE8268@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 19, 2016 at 01:32:07PM -0700, Darrick J. Wong wrote:
> Since the kernel doesn't currently support the realtime rmapbt,
> don't allow such filesystems to be mounted.  Support will appear
> in a future release.
> 

Makes sense to me, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_super.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 24ef83e..fd6be45 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1574,9 +1574,16 @@ xfs_fs_fill_super(
>  		}
>  	}
>  
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +		if (mp->m_sb.sb_rblocks) {
> +			xfs_alert(mp,
> +	"EXPERIMENTAL reverse mapping btree not compatible with realtime device!");
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
> +		}
>  		xfs_alert(mp,
>  	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
> +	}
>  
>  	error = xfs_mountfs(mp);
>  	if (error)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
