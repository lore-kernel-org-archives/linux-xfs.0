Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34977 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752899AbeFNItA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 04:49:00 -0400
Received: by mail-wm0-f68.google.com with SMTP id j15-v6so10446249wme.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jun 2018 01:48:59 -0700 (PDT)
Date: Thu, 14 Jun 2018 10:48:56 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] mkfs: initialize return value of parse_config_stream
 to success
Message-ID: <20180614084856.fxan3qpyziy55ott@odin.usersys.redhat.com>
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
> ---
> 
> diff --git a/mkfs/config.c b/mkfs/config.c
> index 835adc4..1a2cd35 100644
> --- a/mkfs/config.c
> +++ b/mkfs/config.c
> @@ -385,7 +385,7 @@ parse_config_stream(
>  	const char 			*config_file,

Any chance you could fix this trailing whitespace here while you are touching
it? :P


>  	FILE				*fp)
>  {
> -	int				ret = -1;


Sounds fine

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> +	int				ret = 0;
>  	char				*line = NULL;
>  	ssize_t				linelen;
>  	size_t				len = 0, lineno = 0;
> 

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
