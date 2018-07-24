Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388399AbeGXR56 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 13:57:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8856F407577D
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 16:50:37 +0000 (UTC)
Date: Tue, 24 Jul 2018 11:50:34 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_db: add -d to short help for write command
Message-ID: <20180724165034.GA4083@redhat.com>
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

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

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
