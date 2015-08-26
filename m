Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 332AF7F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 17:01:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12471304066
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 15:01:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9rMfr6y80KgwCq14 for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 15:01:39 -0700 (PDT)
Date: Thu, 27 Aug 2015 08:01:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfsprogs: avoid dependency on linux
	XATTR_SIZE/LIST_MAX
Message-ID: <20150826220122.GD3902@dastard>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-2-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1440590555-20463-2-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, Aug 26, 2015 at 02:02:26PM +0200, Jan Tulak wrote:
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Explanation of the change?

> ---
>  libhandle/handle.c       |  6 ++++--
>  libhandle/jdm.c          |  6 ++++--
>  libxfs/xfs_attr_remote.c |  2 +-
>  libxfs/xfs_format.h      | 11 ++++++++++-
>  4 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index b1c0c10..d532f44 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
....
> diff --git a/libhandle/jdm.c b/libhandle/jdm.c
> index d804423..db7d1fe 100644
> --- a/libhandle/jdm.c
> +++ b/libhandle/jdm.c
> @@ -21,6 +21,8 @@
>  #include "handle.h"
>  #include "jdm.h"
>  #include "parent.h"
> +#include "xfs/xfs_arch.h"
> +#include "xfs/xfs_format.h"

I don't think you need the xfs/ prefix now.

> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index bb7cc04..2380084 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -60,6 +60,14 @@ struct xfs_ifork;
>  #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
>  
>  /*
> + * Avoid dependency on linux values of XATTR.
> + * It has to be on the beginning of this file, because we use these Values
> + * later in this header file.
> + */

This is an explanation of why the change is being made, not what
the definitions are for. This belongs in the commit message, not
the code.

> +#define XFS_XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */

We try to avoid comments like these for defines (they tend only to
be added to structure definitions now).

/*
 * The size of a single extended attribute on disk is limited by
 * the size of index values within the attribute entries themselves.
 * These are be16 fields, so we can only support attribute data
 * sizes up to 2^16 bytes in length.
 */
#define XFS_XATTR_SIZE_MAX	(1 << 16)


> +#define XFS_XATTR_LIST_MAX 65536    /* size of extended attribute namelist (64k) */

XATTR_LIST_MAX is not an on-disk format definition - it's a syscall
buffer size limit and is defined by the OS. This belongs in the
platform headers, such as:

#ifndef XATTR_LIST_MAX
#define XATTR_LIST_MAX	65536
#endif

And so in a common header (e.g. include/xfs.h after including the
platform headers):

#define XFS_XATTR_LIST_MAX	XATTR_LIST_MAX

IOWs, this is really two separate patches - one for the
XFS_XATTR_SIZE_MAX change (which also needs to go back to the
kernel) and one for XFS_XATTR_LIST_MAX (which is purely userspace).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
