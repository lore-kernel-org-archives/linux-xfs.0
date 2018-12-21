Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64356 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389028AbeLUWFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Dec 2018 17:05:35 -0500
Date: Sat, 22 Dec 2018 09:05:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] iomap: take responsibility for the filesystem iomap
 code
Message-ID: <20181221220532.GG4205@dastard>
References: <20181220053622.GD27176@magnolia>
 <20181220190401.GD27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220190401.GD27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Amir Goldstein <amir73il@gmail.com>

On Thu, Dec 20, 2018 at 11:04:01AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> XFS is the primary user of the filesystem iomap code, so we (the XFS
> community, specifically) will explicitly take responsibility for its
> maintenance.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: maintain alphabetization, add Christoph as a Real Person patch
> mailing target.  Still looking for acks from Christoph & Dave...

> ---
>  MAINTAINERS |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3318f30903b2..a3ccbeebb377 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7783,6 +7783,17 @@ L:	linux-serial@vger.kernel.org
>  S:	Maintained
>  F:	drivers/tty/serial/ioc3_serial.c
>  
> +IOMAP FILESYSTEM LIBRARY
> +M:	Christoph Hellwig <hch@infradead.org>
> +M:	linux-xfs@vger.kernel.org
> +M:	linux-fsdevel@vger.kernel.org
> +L:	linux-xfs@vger.kernel.org
> +L:	linux-fsdevel@vger.kernel.org
> +T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> +S:	Supported
> +F:	fs/iomap.c
> +F:	include/linux/iomap.h

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
