Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755221AbcLVJW5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 04:22:57 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C250C208FE
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 09:22:56 +0000 (UTC)
Date: Thu, 22 Dec 2016 10:22:53 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_quota: Fix test for wrapped id from GETNEXTQUOTA
Message-ID: <20161222092253.h4ecy6soe5qfi7uf@eorzea.usersys.redhat.com>
References: <44762cf0-ec69-4cb0-ee08-d5889f24df4b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44762cf0-ec69-4cb0-ee08-d5889f24df4b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 21, 2016 at 09:13:08AM -0600, Eric Sandeen wrote:
> dump_file and report_mount can be called with null *oid if
> we aren't asking for the GETNEXTQUOTA interface, so we
> should only test for the GETNEXTQUOTA wrap if *oid is
> non-null.  Otherwise we'll deref a null pointer in the
> test.
> 
> This only happens for certain invocations of reporting,
> which apparently are not covered by any regression tests
> at this point, at least on new kernels which contain
> GETNEXTQUOTA.


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Addresses-Coverity-ID: 1397415
> Addresses-Coverity-ID: 1397416
> Brown-paper-bag-worn-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/quota/report.c b/quota/report.c
> index fc02302..3833dd6 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -98,12 +98,12 @@ dump_file(
>  		return 0;
>  	}
>  
> -	if (oid)
> +	if (oid) {
>  		*oid = d.d_id;
> -
> -	/* Did kernelspace wrap? */
> -	if (*oid < id)
> -		return 0;
> +		/* Did kernelspace wrap? */
> +		if (*oid < id)
> +			return 0;
> +	}
>  
>  	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
>  	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
> @@ -361,12 +361,12 @@ report_mount(
>  		return 0;
>  	}
>  
> -	if (oid)
> +	if (oid) {
>  		*oid = d.d_id;
> -
> -	/* Did kernelspace wrap? */
> -	if (*oid < id)
> -		return 0;
> +		/* Did kernelspace wrap? */
> +		if (* oid < id)
> +			return 0;
> +	}
>  
>  	if (flags & TERSE_FLAG) {
>  		count = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
