Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53751 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfGXXW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 19:22:28 -0400
Date: Thu, 25 Jul 2019 09:21:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
Message-ID: <20190724232117.GB7777@dread.disaster.area>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <156394157450.1850719.464315342783936237.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394157450.1850719.464315342783936237.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 23, 2019 at 09:12:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the iomap code are moving to fs/iomap/ we have to add new entries
> to the aiodio dmesg filter to reflect this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/filter |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/filter b/common/filter
> index ed082d24..26fc2132 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -555,6 +555,7 @@ _filter_aiodio_dmesg()
>  	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
>  	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"

There's two different warnings that need capturing here.

>  	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
> +	local warn10="WARNING:.*fs/iomap/direct-io\.c:.*iomap_dio_actor.*"
>  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
>  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
>  	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
> @@ -563,7 +564,8 @@ _filter_aiodio_dmesg()
>  	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
>  	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
>  	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
> -	    -e "s#$warn9#Intentional warnings in dio_complete#"
> +	    -e "s#$warn9#Intentional warnings in dio_complete#" \
> +	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"

Why not just change the regex in warn7/warn8 just to catch anything
under fs/iomap rather than explictly specifying fs/iomap.c?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
