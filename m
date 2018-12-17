Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33040 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387696AbeLQSYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 13:24:09 -0500
Date: Mon, 17 Dec 2018 10:23:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] xfs: change xfs_attr3_rmt_hdr_ok to return bool
Message-ID: <20181217182357.GD7823@magnolia>
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
 <1b1b2992-5304-e9e2-b20e-ac41235744f7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b1b2992-5304-e9e2-b20e-ac41235744f7@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 05, 2018 at 03:02:15PM -0600, Eric Sandeen wrote:
> xfs_attr3_rmt_hdr_ok is only checked for true/false and the caller
> does nothing with the returned failaddr, so make it a bool.
> (its usage and naming lend itself to a bool too, i.e. test (!ok))
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index d89363c6b523..f86680e08613 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -53,7 +53,7 @@ xfs_attr3_rmt_blocks(
>   * does CRC, location and bounds checking, the unpacking function checks the
>   * attribute parameters and owner.
>   */
> -static xfs_failaddr_t
> +static bool
>  xfs_attr3_rmt_hdr_ok(
>  	void			*ptr,
>  	xfs_ino_t		ino,
> @@ -64,16 +64,16 @@ xfs_attr3_rmt_hdr_ok(
>  	struct xfs_attr3_rmt_hdr *rmt = ptr;
>  
>  	if (bno != be64_to_cpu(rmt->rm_blkno))
> -		return __this_address;
> +		return false;
>  	if (offset != be32_to_cpu(rmt->rm_offset))
> -		return __this_address;
> +		return false;
>  	if (size != be32_to_cpu(rmt->rm_bytes))
> -		return __this_address;
> +		return false;
>  	if (ino != be64_to_cpu(rmt->rm_owner))
> -		return __this_address;
> +		return false;
>  
>  	/* ok */
> -	return NULL;
> +	return true;
>  }
>  
>  static xfs_failaddr_t
> @@ -287,7 +287,7 @@ xfs_attr_rmtval_copyout(
>  		byte_cnt = min(*valuelen, byte_cnt);
>  
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
> +			if (!xfs_attr3_rmt_hdr_ok(src, ino, *offset,

Why not pass a verifier context to attr3_rmt_hdr_ok and enable
rmtval_copyout to report the approximate instruction address of the
failed check?

(Or maybe I missed you doing this later...?)

--D

>  						  byte_cnt, bno)) {
>  				xfs_alert(mp,
>  "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
> -- 
> 2.17.0
> 
> 
