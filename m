Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UFR8w9081461 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 10:27:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78E6E1428183
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:27:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2rJNtfe9IpfDAEM1 for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:27:56 -0700 (PDT)
Date: Thu, 30 Jul 2009 11:27:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: actually hook up 198, make it generic
Message-ID: <20090730152756.GB27914@infradead.org>
References: <4A708FF7.5@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A708FF7.5@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Jul 29, 2009 at 01:07:51PM -0500, Eric Sandeen wrote:
> Not entirely sure how I managed this, but 198 was not in groups
> so was never run - and wasn't in the makefile, so was never built.
> Oops.
> 
> Fix that up, make it a generic test, and move it to the
> aio-dio-regress subdir.

Hah, great one.

>  # This should actually run on anything that supports O_DIRECT + AIO...
> -_supported_fs xfs
> +_supported_fs generic

maybe also remove that comment now that it's generic.

> --- /dev/null
> +++ b/src/aio-dio-regress/aiodio_sparse2.c
> @@ -0,0 +1,384 @@
> +/* gcc -g -Wall -O2 aiodio_sparse.c -o aiodio_sparse -laio */
> +
> +/*
> + * From http://developer.osdl.org/daniel/AIO/TESTS/aiodio_sparse.c
> + * With patch from https://bugzilla.redhat.com/attachment.cgi?id=142124
> + * (Bug https://bugzilla.redhat.com/show_bug.cgi?id=217098)
> + */

Did we manage to get a proper copyright / license statement for this
one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
