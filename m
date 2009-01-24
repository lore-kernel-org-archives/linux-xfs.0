Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0ODuZsF014201 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 07:56:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A5411BA9945
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 05:55:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ANTL4eQ2UWUv2HPB for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 05:55:52 -0800 (PST)
Date: Sat, 24 Jan 2009 08:55:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump spec file & version update
Message-ID: <20090124135521.GB20316@infradead.org>
References: <1232777766.13684.22.camel@verge.scott.net.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1232777766.13684.22.camel@verge.scott.net.au>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 24, 2009 at 05:16:06PM +1100, Nathan Scott wrote:
> Update xfsdump version to 3.0.0 to denote the slightly
> @@ -1,3 +1,12 @@
> +xfsdump-3.0.0 (24 Jan 2009)

We should probably wait until the day we actually cut the tarball to
put a date in here.

> +	- Bump major package version number to signify changed
> +	  dependencies and moved binaries (xfs_fsr and estimate
> +	  have moved into xfsprogs).
> +	- xfsdump should no longer make use of internal XFS
> +	  headers and libraries, in particular no use of libxfs
> +	  is permitted in this package anymore (such detailed
> +	  on-disk format knowledge is the realm of xfsprogs).

There also were a couple of other updated.  I'll send another patch
to put them in.

Otherwise looks good to me.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
