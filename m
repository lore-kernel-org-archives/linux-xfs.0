Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA5557F51
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 15:43:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0474304043
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 13:43:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	K7hTAwinaadB7Bs3 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 13:43:26 -0800 (PST)
Date: Mon, 24 Feb 2014 08:43:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Message-ID: <20140223214322.GF4317@dastard>
References: <1392908861-3563-1-git-send-email-linkinjeon@gmail.com>
	<20140222170930.GE26637@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140222170930.GE26637@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, bpm@sgi.com, adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Ashish Sangwan <a.sangwan@samsung.com>

On Sat, Feb 22, 2014 at 12:09:30PM -0500, Theodore Ts'o wrote:
> On Fri, Feb 21, 2014 at 12:07:41AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > 
> > This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for Ext4.
> > 
> > The semantics of this flag are following:
> > 1) It collapses the range lying between offset and length by removing any data
> >    blocks which are present in this range and than updates all the logical
> >    offsets of extents beyond "offset + len" to nullify the hole created by
> >    removing blocks. In short, it does not leave a hole.
> > 2) It should be used exclusively. No other fallocate flag in combination.
> > 3) Offset and length supplied to fallocate should be fs block size aligned
> >    in case of xfs and ext4.
> > 4) Collaspe range does not work beyond i_size.
> > 
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Tested-by: Dongsu Park <dongsu.park@profitbricks.com>
> 
> In terms of how to get this upstream, it looks like if we do something
> like this, we can let this patch go via the ext4 tree and we don't
> need to worry about whether the vfs level changes have gone in our
> not.
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ad13359..d7a78ed 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -46,6 +46,10 @@
>  
>  #include <trace/events/ext4.h>
>  
> +#ifndef FALLOC_FL_COLLAPSE_RANGE
> +#define FALLOC_FL_COLLAPSE_RANGE	0x08
> +#endif
> +
>  /*
>   * used by extent splitting.
>   */

You're more than welcome to do that, Ted. Just wait until we get the
VFS part into the XFS tree first ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
