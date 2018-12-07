Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbeLGNga (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Dec 2018 08:36:30 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03BF230821A4
        for <linux-xfs@vger.kernel.org>; Fri,  7 Dec 2018 13:36:30 +0000 (UTC)
Date: Fri, 7 Dec 2018 08:36:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/10] xfs: make checksum verifiers consistently return
 bools
Message-ID: <20181207133625.GB55482@bfoster>
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
 <fb3cd029-89d0-4e4a-0795-6c109254546b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb3cd029-89d0-4e4a-0795-6c109254546b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 05, 2018 at 03:03:05PM -0600, Eric Sandeen wrote:
> xfs_verify_cksum returns the result of a comparison, so make it
> a bool. xfs_buf_verify_cksum calls it, so make it a bool as well.
> Other callers up the callchain from here are already bools.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_cksum.h | 2 +-
>  fs/xfs/xfs_buf.h          | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
> index 999a290cfd72..1e3802a99867 100644
> --- a/fs/xfs/libxfs/xfs_cksum.h
> +++ b/fs/xfs/libxfs/xfs_cksum.h
> @@ -71,7 +71,7 @@ xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
>  /*
>   * Helper to verify the checksum for a buffer.
>   */
> -static inline int
> +static inline bool
>  xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
>  {
>  	uint32_t crc = xfs_start_cksum_safe(buffer, length, cksum_offset);
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index b9f5511ea998..5015255b5ede 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -359,7 +359,7 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
>  	xfs_buf_rele(bp);
>  }
>  
> -static inline int
> +static inline bool
>  xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  {
>  	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
> -- 
> 2.17.0
> 
> 
