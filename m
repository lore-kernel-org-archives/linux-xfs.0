Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KI20b7100971 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 13:02:00 -0500
Subject: Re: [PATCH 2/4] xfstests: add _require_attrs
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101015222902.GB3781@infradead.org>
References: <20101015222820.GA3655@infradead.org>
	<20101015222902.GB3781@infradead.org>
Date: Wed, 20 Oct 2010 13:03:11 -0500
Message-ID: <1287597791.2284.99.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, 2010-10-15 at 18:29 -0400, Christoph Hellwig wrote:
> Add a new helper to check if extended attributes are supported.  It
> errors out if any of the attr tools are not found, or if a filesystem
> does not support setting attributes.
> 
> Remove the opencoded checks for the attr tools from various tests
> now that we do them in common code.

Generally this looks good.

I was going to just make a few suggestions and ask you
to fix them before committing, but  I think there are
enough that I think it would be good to re-submit this.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

. . .

> Index: xfstests-dev/021
> ===================================================================
> --- xfstests-dev.orig/021	2010-10-15 12:52:08.000000000 +0000
> +++ xfstests-dev/021	2010-10-15 14:11:10.000000000 +0000

This file calls "attr" and "getfattr" directly in one spot each,
rather than using "${ATTR_PROG}" and "${GETFATTR_PROG}".  This
conceivably means that the one used (or attempted) could disagree
with the one that _require_attrs checks for.

Can you fix these references?

. . .

> Index: xfstests-dev/062
> ===================================================================
> --- xfstests-dev.orig/062	2010-10-15 12:52:08.000000000 +0000
> +++ xfstests-dev/062	2010-10-15 14:11:22.000000000 +0000

Same problem in this file--it consistently calls setfattr
and getfattr directly rather than using their corresponding
variables.
 
. . .

> Index: xfstests-dev/093
> ===================================================================
> --- xfstests-dev.orig/093	2010-10-15 12:52:09.000000000 +0000
> +++ xfstests-dev/093	2010-10-15 12:52:59.000000000 +0000

Same problem here, with the use of attr directly.


It looks like tests 097 and 098 should call
_require_attr also.  And then change their direct
references to "attr" to use "${ATTR_PROG}" as well.

. . .

> Index: xfstests-dev/115
> ===================================================================
> --- xfstests-dev.orig/115	2010-10-15 12:52:09.000000000 +0000
> +++ xfstests-dev/115	2010-10-15 14:12:21.000000000 +0000

This file should not call attr directly.

. . .

> Index: xfstests-dev/136
> ===================================================================
> --- xfstests-dev.orig/136	2010-10-15 12:52:33.000000000 +0000
> +++ xfstests-dev/136	2010-10-15 14:12:35.000000000 +0000

This file should not call attr directly.

. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
