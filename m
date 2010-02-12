Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLMiAI030907 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:22:44 -0600
Date: Fri, 12 Feb 2010 16:23:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dmapi: Fix a build warning
Message-ID: <20100212212359.GB6084@infradead.org>
References: <201002122056.o1CKuruK025550@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201002122056.o1CKuruK025550@stout.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 12, 2010 at 02:56:53PM -0600, Alex Elder wrote:
> Fix a build warning.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  libdm/getdents.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: dmapi/libdm/getdents.c
> ===================================================================
> --- dmapi.orig/libdm/getdents.c
> +++ dmapi/libdm/getdents.c
> @@ -72,7 +72,9 @@ extern int __have_no_getdents64;
>  # endif
>  #endif
>  
> -#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
> +#ifndef offsetof
> +# define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
> +#endif /* ! offsetof */

Looks fine, but as we really should have offsetoff we might just
kill it entirely.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
