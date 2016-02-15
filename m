Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B7877CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:57:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F29F88F8049
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:57:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rtAC1PlaAwBhxGLY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:57:25 -0800 (PST)
Date: Mon, 15 Feb 2016 13:57:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs:  fix format specifier , should be %llx and not %llu
Message-ID: <20160215185723.GE33291@bfoster.bfoster>
References: <1455395182-4771-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455395182-4771-1-git-send-email-colin.king@canonical.com>
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
To: Colin King <colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Feb 13, 2016 at 08:26:22PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> busyp->bno is printed with a %llu format specifier when the
> intention is to print a hexadecimal value. Trivial fix to
> use %llx instead.  Found with smatch static analysis:
> 
> fs/xfs/xfs_discard.c:229 xfs_discard_extents() warn: '0x'
>   prefix is confusing together with '%llu' specifier
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_discard.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index e85a951..272c3f8 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -227,7 +227,7 @@ xfs_discard_extents(
>  				GFP_NOFS, 0);
>  		if (error && error != -EOPNOTSUPP) {
>  			xfs_info(mp,
> -	 "discard failed for extent [0x%llu,%u], error %d",
> +	 "discard failed for extent [0x%llx,%u], error %d",
>  				 (unsigned long long)busyp->bno,
>  				 busyp->length,
>  				 error);
> -- 
> 2.7.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
