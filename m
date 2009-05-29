Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TJPFEo084866 for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:25:16 -0500
Date: Fri, 29 May 2009 15:25:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: prevent deadlock in xfs_qm_shake()
Message-ID: <20090529192529.GA1599@infradead.org>
References: <1243620631-10749-1-git-send-email-felixb@sgi.com>
	<1243620631-10749-2-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1243620631-10749-2-git-send-email-felixb@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: Hedi Berriche <hedi@sgi.com>, xfs@oss.sgi.com

On Fri, May 29, 2009 at 01:10:31PM -0500, Felix Blyakher wrote:
> It's possible to recurse into filesystem from the memory
> allocation, which deadlocks in xfs_qm_shake(). Add check
> for __GFP_FS, and bailout if it is not set.
> 
> Signed-off-by: Felix Blyakher <felixb@sgi.com>
> Signed-off-by: Hedi Berriche <hedi@sgi.com>
> ---
>  fs/xfs/linux-2.6/kmem.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
> index af6843c..d8d2321 100644
> --- a/fs/xfs/linux-2.6/kmem.h
> +++ b/fs/xfs/linux-2.6/kmem.h
> @@ -103,7 +103,7 @@ extern void *kmem_zone_zalloc(kmem_zone_t *, unsigned int __nocast);
>  static inline int
>  kmem_shake_allow(gfp_t gfp_mask)
>  {
> -	return (gfp_mask & __GFP_WAIT) != 0;
> +	return ((gfp_mask & __GFP_WAIT && gfp_mask & __GFP_FS) != 0;

Looks good to me.  But this could be written simpler as:

	return ((gfp_mask & (__GFP_WAIT|__GFP_FS)) != 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
