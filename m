Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750831AbdAPOR3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 09:17:29 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD00D7F77E
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2017 14:17:30 +0000 (UTC)
Date: Mon, 16 Jan 2017 08:17:27 -0600
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 21/22] mkfs: remove duplicit checks
Message-ID: <20170116141727.GG13191@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-22-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481117249-21273-22-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 02:27:28PM +0100, Jan Tulak wrote:
> Remove old checks that are now done by the conflicts table.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9c1ad11..cd0eb20 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2760,26 +2760,6 @@ main(
>  		*blocklog = XFS_DFL_BLOCKSIZE_LOG;
>  		*blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG;
>  	}
> -	if (*blocksize < XFS_MIN_BLOCKSIZE || *blocksize > XFS_MAX_BLOCKSIZE) {
> -		fprintf(stderr, _("illegal block size %d\n"), *blocksize);
> -		usage();
> -	}
> -	if (sb_feat.crcs_enabled && *blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> -		fprintf(stderr,
> -_("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
> -			XFS_MIN_CRC_BLOCKSIZE);
> -		usage();
> -	}
> -
> -	/*
> -	 * If user explicitly stated -m crc=1 -n ftype=0, an error was already
> -	 * issued. But if -n ftype=0 was stated alone, then it is a conflict
> -	 * with a default value for crc enabled and has to be detected here.
> -	 */
> -	if (sb_feat.crcs_enabled && !sb_feat.dirftype) {
> -		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
> -		usage();
> -	}
>  	if (!slflag && !ssflag) {
>  		sectorlog = XFS_MIN_SECTORSIZE_LOG;
>  		sectorsize = XFS_MIN_SECTORSIZE;
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
