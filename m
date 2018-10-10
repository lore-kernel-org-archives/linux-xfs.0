Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44778 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbeJJWGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 18:06:35 -0400
Date: Wed, 10 Oct 2018 07:44:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfsprogs: document changes for 4.19.0-rc0
Message-ID: <20181010144403.GL28243@magnolia>
References: <20181010071023.6765-1-david@fromorbit.com>
 <20181010071023.6765-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010071023.6765-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 06:10:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because 'make deb' breaks without them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  debian/changelog | 7 +++++++
>  doc/CHANGES      | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 01639f9efeec..ef129e278948 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,10 @@
> +xfsprogs (4.19.0-rc0-1) unstable; urgency=low
> +
> +  * New upstream pre-release
> +  * Merge libxfs changes from kernel-4.19
> +
> + -- Nathan Scott <nathans@debian.org>  Wed, 10 Oct 2018 17:52:48 +1100
> +
>  xfsprogs (4.18.0-1) unstable; urgency=low
>  
>    * New upstream release
> diff --git a/doc/CHANGES b/doc/CHANGES
> index 3c1e39469008..1c41bd90a1c5 100644
> --- a/doc/CHANGES
> +++ b/doc/CHANGES
> @@ -1,3 +1,10 @@
> +xfsprogs-4.18.0-rc0 (10 Oct 2018)

4.19-rc0, right?

--D

> +	- Majority of 4.18 libxfs changes merged from kernel
> +	- Big sparse static checker cleanup (Eric Sandeen)
> +	- mkfs.xfs discard fixes (Jan Tulak)
> +	- xfs_io readv/writev cleanup (Zorro Lang)
> +	- libxfs transaction commit error checking (Darrick Wong)
> +
>  xfsprogs-4.18.0 (24 Aug 2018)
>  	- Tweak SPDX license in xfs_cksum.h (Darrick Wong)
>  
> -- 
> 2.17.0
> 
