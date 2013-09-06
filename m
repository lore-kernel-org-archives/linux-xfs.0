Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 216D129DFB
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 15:37:47 -0500 (CDT)
Message-ID: <522A3D16.3010709@sgi.com>
Date: Fri, 06 Sep 2013 15:37:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: factor all the kmalloc-or-vmalloc fallback
	allocations
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
	<1378119180-31380-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378119180-31380-3-git-send-email-david@fromorbit.com>
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

On 09/02/13 05:53, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> We have quite a few places now where we do:
>
> 	x = kmem_zalloc(large size)
> 	if (!x)
> 		x = kmem_zalloc_large(large size)
>
> and do a similar dance when freeing the memory. kmem_free() already
> does the correct freeing dance, and kmem_zalloc_large() is only ever
> called in these constructs, so just factor it all into
> kmem_zalloc_large() and kmem_free().
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Good start on the allocation changes.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
