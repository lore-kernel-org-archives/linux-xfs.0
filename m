Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753176AbdDKSak (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 14:30:40 -0400
Date: Tue, 11 Apr 2017 14:30:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] metadump: warn about corruption if log is dirty
Message-ID: <20170411183036.GA3865@bfoster.bfoster>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-2-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411141237.9274-2-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Apr 11, 2017 at 04:12:36PM +0200, Jan Tulak wrote:
> Add a warning about possible corruption when exporting a dirty log, as
> the log content does not agree with obfuscated metadata.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---

Thanks for posting this...

>  db/metadump.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 66952f6..74e24b2 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2726,7 +2726,8 @@ copy_log(void)
>  		/* keep the dirty log */
>  		if (obfuscate)
>  			print_warning(
> -_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
> +_("Filesystem log is dirty; image will contain unobfuscated metadata in log "
> +  "and a log replay can cause a corruption."));

I think a slightly more verbose message might be a good idea. For
example, something like the following:

"Filesystem log is dirty; image will contain unobfuscated metadata in
the log. Log recovery of an obfuscated image can cause filesystem
corruption. Please mount the source image to clean the log or disable
metadump obfuscation."

That could also say "... or verify that log recovery of the resulting
image does not cause corruption," but that might be overkill. Thoughts?
Eric?

Brian

>  		break;
>  	case -1:
>  		/* log detection error */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
