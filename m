Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753271AbdHQVby (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 17:31:54 -0400
Subject: Re: [PATCH] xfs_db: make write/fuzz -c and -d work on non-crc
 filesystems
References: <20170817165331.GF4796@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <259d4bca-0c72-acdf-d7c2-7840740e6c60@redhat.com>
Date: Thu, 17 Aug 2017 16:31:53 -0500
MIME-Version: 1.0
In-Reply-To: <20170817165331.GF4796@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, eguan@redhat.com

On 8/17/17 11:53 AM, Darrick J. Wong wrote:
> For a non-crc filesystem, make write/fuzz -c and -d work properly
> instead of bailing out.  Since there's no checksum to update, both
> cases collapse to setting the field value without calling the write
> verifier.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
> 

