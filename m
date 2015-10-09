Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E1C97F55
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 08:24:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14831AC002
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 06:24:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8oC2ItGthUZzdsWa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2015 06:24:42 -0700 (PDT)
Date: Fri, 9 Oct 2015 09:24:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs_logprint: fix some unaligned accesses
Message-ID: <20151009132440.GD27982@bfoster.bfoster>
References: <56170906.5090301@redhat.com>
 <5617098E.9090102@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5617098E.9090102@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Oct 08, 2015 at 07:25:50PM -0500, Eric Sandeen wrote:
> This routine had a fair bit of gyration to avoid unaligned accesses,
> but didn't fix them all.  Fix some more spotted at runtime by libubsan.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  logprint/log_misc.c |   18 +++++++++++++++---
>  repair/btree.c      |    1 +
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index d76145c..6cd249a 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -325,7 +325,11 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>  		}
>  		super_block = 0;
>  	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
> -		agi = (xfs_agi_t *)(*ptr);
> +		struct xfs_agi agi_s;
> +
> +		/* memmove because *ptr may not be 8-byte aligned */
> +		memmove(&agi_s, *ptr, sizeof(struct xfs_agi));
> +		agi = &agi_s;

Nit: could we either define the new variables in the same scope as the
pointer (either here or at the top of the function), or just ditch the
pointers altogether?

>  		printf(_("AGI Buffer: XAGI  "));
>  		/*
>  		 * v4 filesystems only contain the fields before the uuid.
...
> diff --git a/repair/btree.c b/repair/btree.c
> index 66fb40b..e31e67a 100644
> --- a/repair/btree.c
> +++ b/repair/btree.c
> @@ -230,6 +230,7 @@ btree_get_next(
>  	}
>  	if (level == 0) {
>  		if (key) {
> +		/* XXXX what if index past MAX?  What if no next? */

Unintentional hunk?

Brian

>  			cur->index++;
>  			*key = btree_key_of_cursor(cur, root->height);
>  			cur->index--;
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
