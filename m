Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752129AbdGMPqi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jul 2017 11:46:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8C87783F46
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2017 15:46:38 +0000 (UTC)
Date: Thu, 13 Jul 2017 10:46:34 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_io: Print filesystem statfs flags in 'statfs' command
Message-ID: <20170713154634.GA13105@redhat.com>
References: <20170703082830.22967-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170703082830.22967-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 03, 2017 at 10:28:30AM +0200, Carlos Maiolino wrote:
> Sometimes printing the flags from the statfs structure is useful, so,
> make statfs command print them.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  io/stat.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/io/stat.c b/io/stat.c
> index 783eb2e..060ff83 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -199,6 +199,7 @@ statfs_f(
>  		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
>  		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
>  		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
> +		printf(_("statfs.f_fflags = 0x%llx\n"), (long long) st.f_flags);
>  	}
>  	if (file->flags & IO_FOREIGN)
>  		return 0;
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
