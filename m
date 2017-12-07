Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48184 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdLGGJA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 01:09:00 -0500
Date: Wed, 6 Dec 2017 22:08:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] libhandle: zap fdhash_head in fshandle_destroy
Message-ID: <20171207060854.GT19219@magnolia>
References: <20171206175401.GK19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206175401.GK19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 06, 2017 at 09:54:01AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Set fdhash_head to zero once we've destroyed the handle list to avoid
> dangling pointer problems.

Ping?

(The xfsprogs update announcement said to resend, but meh.)

--D

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libhandle/handle.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index e6971dd..878d14d 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -73,6 +73,7 @@ fshandle_destroy(void)
>  		free(h);
>  		h = nexth;
>  	}
> +	fdhash_head = NULL;
>  }
>  
>  int
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
