Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47010 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbdF2P75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 11:59:57 -0400
Date: Thu, 29 Jun 2017 08:59:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_spaceman: fix potential memory leak by malloc in
 scan_ag
Message-ID: <20170629155948.GC5874@birch.djwong.org>
References: <20170629155256.3607-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629155256.3607-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Jun 29, 2017 at 10:52:56AM -0500, Bill O'Donnell wrote:
> scan_ag mallocs memory that is potentially leaked. Add a free
> to alleviate the potential leak.
> 
> Fixes CoverityScan CID#1413772 (RESOURCE_LEAK)

/me feels like the coverity tags he's seen tend to take the format of:

    Addresses-Coverity-ID: 1091173
or
    Detected by CoverityScan, CID#1419681 ("Explicit null dereferenced")

though to be honest I don't know that there's really a standard.

<shrug> It probably ought to use one of the two more common formats, but
maybe I can just ask Eric to prettyplease fix it on the way in. :)

> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  spaceman/freesp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/spaceman/freesp.c b/spaceman/freesp.c
> index 22aec821..367c95d1 100644
> --- a/spaceman/freesp.c
> +++ b/spaceman/freesp.c
> @@ -239,7 +239,9 @@ scan_ag(
>  			printf(_("%10u %10llu %10llu\n"), agno, freeexts,
>  					freeblks);
>  	}
> +	free(fsmap);
>  }
> +
>  static void
>  aglistadd(
>  	char		*a)
> -- 
> 2.13.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
