Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfDWVX3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Apr 2019 17:23:29 -0400
Date: Tue, 23 Apr 2019 16:23:26 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 11/10] libfrog: fix memory leak in bitmap_free
Message-ID: <20190423212326.GC19757@redhat.com>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <20190423210409.GC178290@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423210409.GC178290@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Tue, Apr 23, 2019 at 02:04:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Free the bitmap struct before we null out the caller's pointer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  libfrog/bitmap.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
> index aecdba0d..450ebe0a 100644
> --- a/libfrog/bitmap.c
> +++ b/libfrog/bitmap.c
> @@ -104,6 +104,7 @@ bitmap_free(
>  		free(ext);
>  	}
>  	free(bmap->bt_tree);
> +	free(bmap);
>  	*bmapp = NULL;
>  }
>  
