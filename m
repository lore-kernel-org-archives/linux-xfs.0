Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JLstLf056010 for <xfs@oss.sgi.com>; Thu, 19 May 2011 16:54:55 -0500
Subject: Re: [PATCH 3/4] xfs: add a reference count to the CIL context
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110504190011.508745503@bombadil.infradead.org>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.508745503@bombadil.infradead.org>
Date: Thu, 19 May 2011 16:54:54 -0500
Message-ID: <1305842094.2825.89.camel@doink>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2011-05-04 at 14:55 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-cil-ctx-refcounting)
> For the upcoming asynchronoyus discard support we need to be able to delay
> freeing the CIL context until the last discard request that reference it
> has completed.  Add a reference count to the CIL context, and only clear
> the busy extents and free the CIL context structure when it reaches zero,
> and a work item to allow freeing it from irq context.
> 
> Note that this means delaying the clearing of the busy extents for a little
> bit even on non-discard mounts, but with the new busy extent trim/reuse
> code there is no real life impact of this change.

It will affect allocation patterns but it's really hard to say
whether it will make them worse or better...

> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good.  Encapsulating the context initialization
was a good step even without the new work item field.  One
little thing below.

Reviewed-by: Alex Elder <aelder@sgi.com>

PS  I've run out of time and will have to review the
    fourth patch in this series tomorrow.

> Index: xfs/fs/xfs/xfs_log_cil.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_cil.c	2011-05-03 12:00:49.000000000 +0200
> +++ xfs/fs/xfs/xfs_log_cil.c	2011-05-03 12:17:19.399350953 +0200
> @@ -20,7 +20,7 @@
>  #include "xfs_types.h"
>  #include "xfs_bit.h"
>  #include "xfs_log.h"
> -#include "xfs_inum.h"
> +#include "xfs_inum.h" 
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log_priv.h"

Kill this hunk.  (You added a space at end-of-line.)

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
