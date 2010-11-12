Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACNOakW171604 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:24:36 -0600
Subject: Re: [PATCH v2 3/9] xfsrestore: cache path lookups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163643.571496225@sgi.com>
References: <20101105163500.747192954@sgi.com>
	<20101105163643.571496225@sgi.com>
Date: Fri, 12 Nov 2010 17:25:11 -0600
Message-ID: <1289604311.2315.908.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
> 
> In order to resolve a pathname, xfsrestore must work from an inode
> number (from the dump) and recurse up the directory entry tree that it
> has constructed. Each level of recursion requires a seek and read to
> get the name of the dirent, and possibly a mmap of a section of the
> directory entry tree if it is not already mapped (and in that case,
> possibly a munmap of another section). It's quite common to resolve
> pathnames in the same directory consecutively, so simply caching the
> parent directory pathname from the previous lookup saves quite a bit
> of overhead.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

I think an assertion would do in a place I show below,
but it's nothing to worry about.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  restore/tree.c |   41 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 5 deletions(-)
> 
> Index: xfsdump-kernel.org/restore/tree.c
> ===================================================================
> --- xfsdump-kernel.org.orig/restore/tree.c
> +++ xfsdump-kernel.org/restore/tree.c

. . .

> @@ -3475,6 +3486,13 @@ Node2path_recurse( nh_t nh, char *buf, i
>  		return bufsz;
>  	}
>  
> +	/* if we have a cache hit, no need to recurse any further
> +	 */
> +	if ( nh == cache.nh && bufsz > cache.len ) {

Since a nh basically encodes the entire path,
the check that the buffer is big enough should
not be necessary, and could probably be inserted
instead:
		ASSERT(bufsz > cache.len);

> +		strcpy( buf, cache.buf );
> +		return bufsz - cache.len;
> +	}
> +
>  	/* extract useful node members
>  	 */
>  	np = Node_map( nh );

 . . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
