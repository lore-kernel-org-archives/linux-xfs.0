Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33838 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388269AbeGXCxo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jul 2018 22:53:44 -0400
Date: Mon, 23 Jul 2018 18:49:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: add -d to short help for write command
Message-ID: <20180724014930.GQ4813@magnolia>
References: <fba33a51-50c1-ade6-79d2-f7ceaceb372f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fba33a51-50c1-ade6-79d2-f7ceaceb372f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 23, 2018 at 06:25:27PM -0700, Eric Sandeen wrote:
> And note in the man page that -c and -d are exclusive.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/db/write.c b/db/write.c
> index 5ef76bcd..bbaa609d 100644
> --- a/db/write.c
> +++ b/db/write.c
> @@ -38,7 +38,7 @@ static int	write_f(int argc, char **argv);
>  static void     write_help(void);
>  
>  static const cmdinfo_t	write_cmd =
> -	{ "write", NULL, write_f, 0, -1, 0, N_("[-c] [field or value]..."),
> +	{ "write", NULL, write_f, 0, -1, 0, N_("[-c|-d] [field or value]..."),
>  	  N_("write value to disk"), write_help };
>  
>  void
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 10f2beb9..a1ee3514 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -837,7 +837,7 @@ and
>  bits respectively, and their string equivalent reported
>  (but no modifications are made).
>  .TP
> -.BI "write [\-c] [\-d] [" "field value" "] ..."
> +.BI "write [\-c|\-d] [" "field value" "] ..."
>  Write a value to disk.
>  Specific fields can be set in structures (struct mode),
>  or a block can be set to data values (data mode),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
