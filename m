Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DFC67F61
	for <xfs@oss.sgi.com>; Sun,  2 Aug 2015 18:42:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE754AC01A
	for <xfs@oss.sgi.com>; Sun,  2 Aug 2015 16:42:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oKZRlwQwUZJJK9rM for <xfs@oss.sgi.com>;
	Sun, 02 Aug 2015 16:42:53 -0700 (PDT)
Date: Mon, 3 Aug 2015 09:42:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/4] xfsprogs: Prefix LIST_... macros to XFS_LIST_...
Message-ID: <20150802234250.GT16638@dastard>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
	<1437397018-12864-2-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437397018-12864-2-git-send-email-jtulak@redhat.com>
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

On Mon, Jul 20, 2015 at 02:56:55PM +0200, Jan Tulak wrote:
> OS X has some conflicting LIST_ macros, so prefix the XFS ones.

What macros, and how do we get them included in the build? I
shouldn't need to go and use google to work out why a change is
beign made....

> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  include/list.h  | 6 +++---
>  repair/phase6.c | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/list.h b/include/list.h
> index 3f087a4..7e9f748 100644
> --- a/include/list.h
> +++ b/include/list.h
> @@ -27,10 +27,10 @@ struct list_head {
>  	struct list_head *prev;
>  };
>  
> -#define LIST_HEAD_INIT(name) { &(name), &(name) }
> +#define XFS_LIST_HEAD_INIT(name) { &(name), &(name) }
>  
> -#define LIST_HEAD(name) \
> -		struct list_head name = LIST_HEAD_INIT(name)
> +#define XFS_LIST_HEAD(name) \
> +		struct list_head name = XFS_LIST_HEAD_INIT(name)
>  
>  #define INIT_LIST_HEAD(list) list_head_init(list)
>  static inline void list_head_init(struct list_head *list)

This is supposed to match what is required for libxfs/ so we don't
have to modify the kernel code we bring across. Without knowing
exactly how we are including conflicting definitions from the OS X
include files, it's really hard to suggest other possible
solutions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
