Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LHDK7q014815 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 12:13:20 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 06/14] repair: use a btree instead of a radix tree for
	theprefetch queue
Date: Wed, 21 Oct 2009 12:12:33 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADEB@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175840.740632507@bombadil.infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On , Christoph Hellwig wrote:
> Currently the prefetch queue in xfs_repair uses a radix tree implementation
> derived from the Linux kernel one to manage it's prefetch queue.
> 
> The radix tree implement is not very memory efficient for sparse indices,
> so replace it with a btree implementation that is much more efficient.
> This is not that important for the prefetch queue but will be very important
> for the next memory optimization patches which need a tree to store things
> like the block map which are very sparse, and we do not want to deal with
> two tree implementations (or rather three given that we still have avl.c
> around)
> 
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I set up some code around this to test it, and ended up going
on a wild goose chase for a bug that it turns out only happens
if you happen to simplify things so that BTREE_KEY_MAX is 2.

So, well, don't do that, in case you were thinking of it...

Beyond that the code btree code generally looks fine, but
I'll probably have some suggested changes once it's in.
I have a few comments below.  However...

Reviewed-by: Alex Elder <aelder@sgi.com>

General comments/questions
- Is this code worthy of putting into a library, so other
  XFS user space can use it?
- Is the radix tree code worth putting into a library and
  saving, for similar reasons (I didn't look at that code).
- I accept that this uses less memory for sparsely populated
  key space than radix trees; but it would be nice if that
  could be characterized a bit more precisely (i.e., what
  will the range of values that'll be represented be, just
  how sparse is it, and at what point does this really
  pay off?).
- Related to the previous one--it would be good to have
  a little info about why the value 7 was chosen as the
  number of keys per node.  Perhaps I just don't know
  enough of the history (or content of the upcoming
  patches).
- A number of external interfaces defined are not used
  in the (current) xfs_repair code.  (That's OK, but
  they could be removed if they're never expected to
  to be used--e.g. btree_peek_prev(), and btree_peek_next()).


. . .

> Index: xfsprogs-dev/repair/btree.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfsprogs-dev/repair/btree.c	2009-08-20 00:06:44.000000000 +0000
> @@ -0,0 +1,1234 @@
> +/*
> + * Copyright (c) 2007, Silicon Graphics, Inc. Barry Naujok <bnaujok@sgi.com>
> + * All Rights Reserved.

. . .

> +#include <libxfs.h>
> +#include "btree.h"
> +
> +

Note that the value of BTREE_KEY_MAX *must* be greater than 2, or
this code will not work.  Maybe nobody should be trying to use 2
here anyway, but I would like to see a comment, e.g., /* Must be 3 or more */

> +#define BTREE_KEY_MAX		7
> +#define BTREE_KEY_MIN		(BTREE_KEY_MAX / 2)
> +
> +#define BTREE_PTR_MAX		(BTREE_KEY_MAX + 1)

. . .

> Index: xfsprogs-dev/repair/prefetch.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/prefetch.c	2009-08-20 00:05:36.000000000 +0000
> +++ xfsprogs-dev/repair/prefetch.c	2009-08-20 00:14:08.000000000 +0000
. . .

> @@ -570,7 +566,7 @@
>  		return NULL;
> 
>  	pthread_mutex_lock(&args->lock);
> -	while (!args->queuing_done || args->primary_io_queue.height) {

There is a btree_is_empty(btree_root) function, you might
as well use it here (it is clearer what you're doing anyway).

> +	while (!args->queuing_done || btree_find(args->primary_io_queue, 0, NULL)) {
> 
>  #ifdef XR_PF_TRACE
>  		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
> @@ -696,8 +692,8 @@
>  #endif
>  	pthread_mutex_lock(&args->lock);
> 
> -	ASSERT(args->primary_io_queue.height == 0);
> -	ASSERT(args->secondary_io_queue.height == 0);

btree_is_empty() would be better here also.

> +	ASSERT(btree_find(args->primary_io_queue, 0, NULL) == NULL);
> +	ASSERT(btree_find(args->secondary_io_queue, 0, NULL) == NULL);
> 
>  	args->prefetch_done = 1;
>  	if (args->next_args)

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
