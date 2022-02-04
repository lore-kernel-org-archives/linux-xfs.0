Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5E3C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Feb 2022 22:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbiBDWFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Feb 2022 17:05:19 -0500
Received: from sandeen.net ([63.231.237.45]:53386 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239701AbiBDWFP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Feb 2022 17:05:15 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3D77F7BCB;
        Fri,  4 Feb 2022 16:04:51 -0600 (CST)
Message-ID: <9d975f71-a08a-a303-eb97-b354a8452960@sandeen.net>
Date:   Fri, 4 Feb 2022 16:05:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH 03/17] libxfs: don't leave dangling perag references from
 xfs_buf
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811129.863810.509345961407054307.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <164263811129.863810.509345961407054307.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're preparing to move a list of xfs_buf(fers) to the freelist, be
> sure to detach the perag reference so that we don't leak the reference
> or leave dangling pointers.  Currently this has no negative effects
> since we only call libxfs_bulkrelse while exiting programs, but let's
> not be sloppy.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Seems fine

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/rdwr.c |   23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 2a9e8c98..b43527e4 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -887,11 +887,19 @@ libxfs_buf_mark_dirty(
>  	bp->b_flags |= LIBXFS_B_DIRTY;
>  }
>  
> -/* Complain about (and remember) dropping dirty buffers. */
> -static void
> -libxfs_whine_dirty_buf(
> +/* Prepare a buffer to be sent to the MRU list. */
> +static inline void
> +libxfs_buf_prepare_mru(
>  	struct xfs_buf		*bp)
>  {
> +	if (bp->b_pag)
> +		xfs_perag_put(bp->b_pag);
> +	bp->b_pag = NULL;
> +
> +	if (!(bp->b_flags & LIBXFS_B_DIRTY))
> +		return;
> +
> +	/* Complain about (and remember) dropping dirty buffers. */
>  	fprintf(stderr, _("%s: Releasing dirty buffer to free list!\n"),
>  			progname);
>  
> @@ -909,11 +917,7 @@ libxfs_brelse(
>  
>  	if (!bp)
>  		return;
> -	if (bp->b_flags & LIBXFS_B_DIRTY)
> -		libxfs_whine_dirty_buf(bp);
> -	if (bp->b_pag)
> -		xfs_perag_put(bp->b_pag);
> -	bp->b_pag = NULL;
> +	libxfs_buf_prepare_mru(bp);
>  
>  	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
>  	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> @@ -932,8 +936,7 @@ libxfs_bulkrelse(
>  		return 0 ;
>  
>  	list_for_each_entry(bp, list, b_node.cn_mru) {
> -		if (bp->b_flags & LIBXFS_B_DIRTY)
> -			libxfs_whine_dirty_buf(bp);
> +		libxfs_buf_prepare_mru(bp);
>  		count++;
>  	}
>  
> 
