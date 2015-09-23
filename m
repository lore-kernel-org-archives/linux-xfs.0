Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 091977F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 22:15:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8897AAC00A
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 20:15:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8CxhFOhEA6RKlq0b for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 20:15:34 -0700 (PDT)
Date: Wed, 23 Sep 2015 13:15:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/14] xfsprogs: prefix XATTR_LIST_MAX with XFS_
Message-ID: <20150923031532.GN3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-5-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442311164-12921-5-git-send-email-jtulak@redhat.com>
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
Cc: xfs@oss.sgi.com

On Tue, Sep 15, 2015 at 11:59:14AM +0200, Jan Tulak wrote:
> WILL CHANGE THE COMMIT MESSAGE.

OK?

> All right, I make the renaming with define - though I'm not sure
> that with the ifdef for OS X and SIZE_MAX moved to a standalone patch
> we need it - shouldn't be this change rather dropped?
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  include/xfs.h      | 2 ++
>  libhandle/handle.c | 4 ++--
>  libhandle/jdm.c    | 4 ++--
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index bc94068..8ee0106 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -53,6 +53,8 @@
>  # define ASSERT(EX)	((void) 0)
>  #endif
>  
> +#define XFS_XATTR_LIST_MAX XATTR_LIST_MAX
> +

This does not belong here - it is a limit that applies to the ioctl
API and so must be the same in userspace and the kernel. Such
definitions belong in libxfs/xfs_fs.h, and should respect local OS
limits if defined. e.g. something like:

#ifdef XATTR_LIST_MAX
#define XFS_XATTR_LIST_MAX XATTR_LIST_MAX
#else
#define XFS_XATTR_LIST_MAX 65536
#endif

Will work on both the kernel and userspace side. This will also need
a kernel side patch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
