Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750840AbdAPOPg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 09:15:36 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 083218553F
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2017 14:15:37 +0000 (UTC)
Date: Mon, 16 Jan 2017 08:15:33 -0600
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH 18/22] mkfs: prevent sector/blocksize to be specified as
 a number of blocks
Message-ID: <20170116141533.GD13191@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-19-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481117249-21273-19-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 02:27:25PM +0100, Jan Tulak wrote:
> Documentation states that the options blocked in this patch accepts the
> size only in bytes. So prevent blocksize or sectorsize to be specified as
> a number of blocks or sectors.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d55eb9a..e8fd49b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2041,6 +2041,27 @@ getnum(
>  		}
>  	}
>  
> +	/* Prevent things like specifying blocksize as a number of blocks. */
> +	if (opts->index == OPT_B || opts->index == OPT_S ||
> +		(opts->index == OPT_L && (index == L_SECTLOG ||
> +			index == L_SECTSIZE)) ||
> +		(opts->index == OPT_N && (index == N_SIZE)) ||
> +		(opts->index == OPT_D && (index == D_SECTLOG ||
> +			index == D_SECTSIZE))
> +
> +		) {
> +		switch (str[strlen(str)-1]) {
> +		case 'b':
> +		case 's':
> +			fprintf(stderr,
> +				_("You can't set a sector or block size in "
> +				  "number of blocks or sectors (-%c %s).\n"),
> +				opts->name, opts->subopts[index]);
> +			exit(1);
> +		}
> +
> +	}
> +
>  	sp->seen = true;
>  
>  	if (test_uvalue_num(sp->type, sp->minval, 0) &&
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
