Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AF787CBF
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 16:26:25 -0500 (CDT)
Message-ID: <5228F700.6070901@sgi.com>
Date: Thu, 05 Sep 2013 16:26:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 23/55] xfs: introduce xfs_rtalloc_defs.h
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-24-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-24-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> There are quite a few realtime device definitions shared with
> userspace. Move them from xfs_rtalloc.h to xfs_rt_alloc_defs.h
> so we don't need to share xfs_rtalloc.h with userspace anymore.
>
> This removes the final __KERNEL__ region from the XFS kernel
> codebase. Yay!
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


No change in this patch from previous post. Synced files look good.

xfsprogs equivalent of the for 3.12 kernel patch 08/50.

move shared items from xfs_rtalloc.h to xfs_format.h.
xfs_rtalloc.h is now kernel-only, remove from xfsprogs.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
