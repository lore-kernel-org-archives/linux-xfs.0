Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F3FB7CA1
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 08:28:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 930F3AC001
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 06:28:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DaIJgVuoG6PQFwDh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 May 2016 06:28:36 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 6241465400
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 13:28:35 +0000 (UTC)
Received: from redhat.com (vpn-56-82.rdu2.redhat.com [10.10.56.82])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4IDSVqc009967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 18 May 2016 09:28:34 -0400
Date: Wed, 18 May 2016 15:28:31 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove spurious shutdown type check from
	xfs_bmap_finish()
Message-ID: <20160518132831.GA25154@redhat.com>
References: <1463573052-29336-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463573052-29336-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On Wed, May 18, 2016 at 08:04:12AM -0400, Brian Foster wrote:
> The static checker reports that after commit 8d99fe92fed0 ("xfs: fix
> efi/efd error handling to avoid fs shutdown hangs"), the code has been
> reworked such that error == -EFSCORRUPTED is not possible in this
> codepath.
> 
> Remove the spurious error check and just use SHUTDOWN_META_IO_ERROR
> unconditionally.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_bmap_util.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 3246ebc..918a25a 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -132,9 +132,7 @@ xfs_bmap_finish(
>  		if (committed) {
>  			xfs_efi_release(efi);
>  			xfs_force_shutdown((*tp)->t_mountp,
> -				(error == -EFSCORRUPTED) ?
> -					SHUTDOWN_CORRUPT_INCORE :
> -					SHUTDOWN_META_IO_ERROR);
> +					   SHUTDOWN_META_IO_ERROR);
>  		}
>  		return error;
>  	}
> -- 
> 2.4.11
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
