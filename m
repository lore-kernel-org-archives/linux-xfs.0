Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934027AbeALQqh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 11:46:37 -0500
Date: Fri, 12 Jan 2018 08:45:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_logprint: fix v3 inode formatting
Message-ID: <20180112164552.GV5602@magnolia>
References: <831989ff-14a7-5c22-2b9c-457033a99945@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <831989ff-14a7-5c22-2b9c-457033a99945@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jan 12, 2018 at 10:32:38AM -0600, Eric Sandeen wrote:
> Line up flags2/cowextsize line with all the others, using
> tabs.
> 
> Fixes: 1fe708d60 ("xfs_logprint: support cowextsize reporting in log contents")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index c80bf34..cdaf77b 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -273,7 +273,7 @@ xlog_recover_print_inode_core(
>  	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
>  	       (int)di->di_flags, di->di_gen);
>  	if (di->di_version == 3) {
> -		printf(_("flags2 0x%llx cowextsize 0x%x\n"),
> +		printf(_("		flags2 0x%llx cowextsize 0x%x\n"),
>  			(unsigned long long)di->di_flags2, di->di_cowextsize);
>  	}
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
