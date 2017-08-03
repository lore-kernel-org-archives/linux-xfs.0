Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752434AbdHCLyL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 07:54:11 -0400
Date: Thu, 3 Aug 2017 07:54:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] common/xfs: add iomap_dio_actor() to the dmesg filter
Message-ID: <20170803115409.GE62447@bfoster.bfoster>
References: <20170731042825.6250-1-eguan@redhat.com>
 <20170731042825.6250-2-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170731042825.6250-2-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jul 31, 2017 at 12:28:25PM +0800, Eryu Guan wrote:
> The warning in fs/iomap.c::iomap_dio_actor() could be triggered when
> mixing dio and mmap I/O on the same sparse file. Several tests could
> hit this warning now, like generic/095 generic/224 and generic/446.
> So add this expected warning to whitelist too.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/xfs | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 47b4e1ba4b7f..4995f8ba8dd8 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -596,10 +596,12 @@ _filter_xfs_dmesg()
>  	local warn4="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_aio_read.*"
>  	local warn5="WARNING:.*fs/iomap\.c:.*iomap_dio_rw.*"
>  	local warn6="WARNING:.*fs/xfs/xfs_aops\.c:.*__xfs_get_blocks.*"
> +	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
>  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
>  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
>  	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
>  	    -e "s#$warn4#Intentional warnings in xfs_file_aio_read#" \
>  	    -e "s#$warn5#Intentional warnings in iomap_dio_rw#" \
> -	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#"
> +	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
> +	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#"
>  }
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
