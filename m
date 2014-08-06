Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 469417F98
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 07:24:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16674304043
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 05:24:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3qMtOfmWNCXlZU0l (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 05:24:49 -0700 (PDT)
Date: Wed, 6 Aug 2014 08:24:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/15] xfs: fix decimal printf format specifiers prefixed
	with 0x
Message-ID: <20140806122442.GC14820@bfoster.bfoster>
References: <1407300256-495-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1407300256-495-1-git-send-email-hans@hanshq.net>
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
To: Hans Wennborg <hans@hanshq.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 05, 2014 at 09:44:16PM -0700, Hans Wennborg wrote:
> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  fs/xfs/xfs_discard.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 13d08a1..b4a2415 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -228,7 +228,7 @@ xfs_discard_extents(
>  				GFP_NOFS, 0);
>  		if (error && error != -EOPNOTSUPP) {
>  			xfs_info(mp,
> -	 "discard failed for extent [0x%llu,%u], error %d",
> +	 "discard failed for extent [0x%llx,%u], error %d",
>  				 (unsigned long long)busyp->bno,
>  				 busyp->length,
>  				 error);

It's kind of annoying seeing values of multiple bases being used to
describe a single extent, imo. But using 0x before a decimal value
certainly isn't nice... ;)

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -- 
> 2.0.0.526.g5318336
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
