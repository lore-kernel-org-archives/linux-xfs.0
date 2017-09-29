Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30850 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdI2Eph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2017 00:45:37 -0400
Date: Thu, 28 Sep 2017 21:45:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] common/xfs: add iomap_dio_complete() to the dmesg filter
Message-ID: <20170929044531.GU5020@magnolia>
References: <20170929041327.1346-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170929041327.1346-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Sep 29, 2017 at 12:13:27PM +0800, Eryu Guan wrote:
> Kernel commit 332391a9935d ("fs: Fix page cache inconsistency when mixing
> buffered and AIO DIO") moved the WARN_ON_ONCE() into iomap_dio_complete(),
> along with the page cache invalidation. Let's add iomap_dio_complete() to the
> filter whitelist too, so this expected warning when mixing direct I/O with
> buffered I/O won't fail tests.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  common/xfs | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/common/xfs b/common/xfs
> index def28bfc7309..c869aaca4512 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -610,11 +610,13 @@ _filter_xfs_dmesg()
>  	local warn5="WARNING:.*fs/iomap\.c:.*iomap_dio_rw.*"
>  	local warn6="WARNING:.*fs/xfs/xfs_aops\.c:.*__xfs_get_blocks.*"
>  	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
> +	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
>  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
>  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
>  	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
>  	    -e "s#$warn4#Intentional warnings in xfs_file_aio_read#" \
>  	    -e "s#$warn5#Intentional warnings in iomap_dio_rw#" \
>  	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
> -	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#"
> +	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
> +	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#"
>  }
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
