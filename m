Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfBUSHw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Feb 2019 13:07:52 -0500
Date: Thu, 21 Feb 2019 19:09:13 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] t_attr_corruption: fix xattr.h include problems
Message-ID: <20190221180913.GB9874@suse.cz>
Reply-To: dsterba@suse.cz
References: <20190220172005.GJ6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220172005.GJ6477@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Feb 20, 2019 at 09:20:05AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Apparently newer versions of libattr (which haven't yet been picked up
> by Debian or Ubuntu) don't ship xattr.h anymore, because we're supposed
> to use the libc version in sys/xattr.h.  So do that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  src/t_attr_corruption.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/t_attr_corruption.c b/src/t_attr_corruption.c
> index 1fa5e41f..f26611f9 100644
> --- a/src/t_attr_corruption.c
> +++ b/src/t_attr_corruption.c
> @@ -27,7 +27,7 @@
>  #include <string.h>
>  #include <stdint.h>
>  #include <unistd.h>
> -#include <attr/xattr.h>
> +#include <sys/xattr.h>

Works for me, thanks

Reviewed-by: David Sterba <dsterba@suse.com>
