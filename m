Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25AEC7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 11:01:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E924F304043
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 09:01:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TMYlI44tOPbTXFTh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Sep 2016 09:01:23 -0700 (PDT)
Date: Wed, 14 Sep 2016 00:01:20 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs_repair: exit with status 2 if log dirtiness is unknown
Message-ID: <20160913160120.GH12847@dhcp12-143.nay.redhat.com>
References: <4c59d0b7-bf53-ca58-1bcf-b95d1c9c44dc@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4c59d0b7-bf53-ca58-1bcf-b95d1c9c44dc@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 12, 2016 at 07:46:05AM -0500, Eric Sandeen wrote:
> This new case is mostly like the known dirty log case; the log
> is corrupt, dirtiness cannot be determined, and a mount/umount
> cycle or an xfs_repair -L is required.
> 
> So exit with status 2 here as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index e21ffa6..5964244 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -79,10 +79,11 @@ zero_log(
>  		_("zero_log: cannot find log head/tail (xlog_find_tail=%d)\n"),
>  			error);
>  		if (!no_modify && !zap_log)
> -			do_error(_(
> +			do_warn(_(
>  "ERROR: The log head and/or tail cannot be discovered. Attempt to mount the\n"
>  "filesystem to replay the log or use the -L option to destroy the log and\n"
>  "attempt a repair.\n"));
> +			exit(2);

I think it makes sense for me. Exit 2 means log needs to be replayed or cleared.
If we meet xfs_repair return 2, we can do the same steps to deal with that:
 1. try to mount
 2. If mount fail, try xfs_repair -L

So I agree with this patch:
Reviewed-by: Zorro Lang <zlang@redhat.com>


>  	} else {
>  		if (verbose) {
>  			do_warn(
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
