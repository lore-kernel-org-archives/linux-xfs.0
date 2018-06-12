Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43806 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934563AbeFLWXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 18:23:25 -0400
Date: Tue, 12 Jun 2018 15:23:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] mkfs: remove gotos in parse_defaults_file
Message-ID: <20180612222322.GS22045@magnolia>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
 <1528831883-21879-8-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528831883-21879-8-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 12, 2018 at 02:31:23PM -0500, Eric Sandeen wrote:
> There's no point to the gotos in parse_defaults_file; no cleanup
> etc that is normally facilitated by a goto, so just remove them.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  mkfs/config.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/config.c b/mkfs/config.c
> index 173ab9a..f9ca78a 100644
> --- a/mkfs/config.c
> +++ b/mkfs/config.c
> @@ -636,17 +636,15 @@ parse_defaults_file(
>  
>  	fp = fdopen(fd, "r");
>  	if (!fp)
> -		goto out;
> +		return -1;
>  
>  	ret = parse_config_stream(dft, config_file, fp);
>  	if (ret) {
>  		fclose(fp);
> -		goto out;
> +		return -1;
>  	}

Separate patch, but don't we leak fp here?

Everything else seems ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  	printf(_("config-file=%s\n"), config_file);
>  
>  	return 0;
> -out:
> -	return -1;
>  }
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
