Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34143 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdHRI7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 04:59:10 -0400
Received: by mail-wr0-f176.google.com with SMTP id y96so61875793wrc.1
        for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2017 01:59:10 -0700 (PDT)
Date: Fri, 18 Aug 2017 10:59:06 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_db: make write/fuzz -c and -d work on non-crc
 filesystems
Message-ID: <20170818085906.4ldnqxy2pilianjt@hades.localdomain>
References: <20170817165331.GF4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817165331.GF4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, eguan@redhat.com

On Thu, Aug 17, 2017 at 09:53:31AM -0700, Darrick J. Wong wrote:
> For a non-crc filesystem, make write/fuzz -c and -d work properly
> instead of bailing out.  Since there's no checksum to update, both
> cases collapse to setting the field value without calling the write
> verifier.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/fuzz.c  |    8 ++++++--
>  db/write.c |    7 +++++--
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/db/fuzz.c b/db/fuzz.c
> index 76dbf94..53cedbc 100644
> --- a/db/fuzz.c
> +++ b/db/fuzz.c
> @@ -125,7 +125,9 @@ fuzz_f(
>  		return 0;
>  	}
>  
> -	if (invalid_data && iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF) {
> +	if (invalid_data &&
> +	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
> +	    xfs_sb_version_hascrc(&mp->m_sb)) {
>  		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
>  		return 0;
>  	}
> @@ -149,7 +151,9 @@ fuzz_f(
>  	local_ops.verify_read = stashed_ops->verify_read;
>  	iocur_top->bp->b_ops = &local_ops;
>  
> -	if (corrupt) {
> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +		local_ops.verify_write = xfs_dummy_verify;
> +	} else if (corrupt) {
>  		local_ops.verify_write = xfs_dummy_verify;
>  		dbprintf(_("Allowing fuzz of corrupted data and bad CRC\n"));
>  	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
> diff --git a/db/write.c b/db/write.c
> index 9fc6d8e..5ef76bc 100644
> --- a/db/write.c
> +++ b/db/write.c
> @@ -138,7 +138,8 @@ write_f(
>  	}
>  
>  	if (invalid_data &&
> -	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF) {
> +	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
> +	    xfs_sb_version_hascrc(&mp->m_sb)) {
>  		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
>  		return 0;
>  	}
> @@ -162,7 +163,9 @@ write_f(
>  	local_ops.verify_read = stashed_ops->verify_read;
>  	iocur_top->bp->b_ops = &local_ops;
>  
> -	if (corrupt) {
> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +		local_ops.verify_write = xfs_dummy_verify;
> +	} else if (corrupt) {
>  		local_ops.verify_write = xfs_dummy_verify;
>  		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
>  	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
