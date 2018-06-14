Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59318 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755071AbeFNQlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 12:41:40 -0400
Date: Thu, 14 Jun 2018 09:41:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] mkfs: initialize return value of parse_config_stream
 to success
Message-ID: <20180614164136.GD6825@magnolia>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
 <8318bdfe-ff7b-02b9-414e-f63f9ccdbdbc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8318bdfe-ff7b-02b9-414e-f63f9ccdbdbc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jun 13, 2018 at 02:34:33PM -0500, Eric Sandeen wrote:
> Right now the return value is initialized to -1 (failure) and set to zero
> only if a valid token is found.  However, this means that i.e. a blank
> or template config file containing only comments will yield failure on
> parsing.
>     
> Initialize to success, and set to failure only if failure occurs.
>     
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/mkfs/config.c b/mkfs/config.c
> index 835adc4..1a2cd35 100644
> --- a/mkfs/config.c
> +++ b/mkfs/config.c
> @@ -385,7 +385,7 @@ parse_config_stream(
>  	const char 			*config_file,
>  	FILE				*fp)
>  {
> -	int				ret = -1;
> +	int				ret = 0;
>  	char				*line = NULL;
>  	ssize_t				linelen;
>  	size_t				len = 0, lineno = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
