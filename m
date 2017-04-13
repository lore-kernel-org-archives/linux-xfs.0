Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752148AbdDMLyK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 07:54:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67DD319CB90
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 11:54:10 +0000 (UTC)
Date: Thu, 13 Apr 2017 07:54:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] metadump: warn about corruption if log is dirty
Message-ID: <20170413115408.GA24893@bfoster.bfoster>
References: <20170413081354.22170-1-jtulak@redhat.com>
 <20170413081354.22170-2-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413081354.22170-2-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:13:53AM +0200, Jan Tulak wrote:
> Add a warning about possible corruption when exporting a dirty log, as
> the log content does not agree with obfuscated metadata.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
> Change: More elaborate warning message.
> ---
>  db/metadump.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 66952f6..2dd8593 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2726,7 +2726,9 @@ copy_log(void)
>  		/* keep the dirty log */
>  		if (obfuscate)
>  			print_warning(
> -_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
> +_("Warning: log recovery of an obfuscated metadata image can leak "
> +"unobfuscated metadata and/or cause image corruption. Please mount "
> +"the source filesystem to clean the log or disable obfuscation, if possible."));
>  		break;

Thanks Jan, just one very minor nit having read this again... could we
put the "if possible" closer to the part about mounting the source
image? Otherwise it reads to me that it might not be technically
possible to disable obfuscation, which is not the case (though the user
may not want to do that as a matter of policy). For example:

"... Please mount the source filesystem to clean the log, if possible,
or disable obfuscation."

With that tweak:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	case -1:
>  		/* log detection error */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
