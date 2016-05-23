Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A9A37CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 09:44:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78335AC003
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 07:44:28 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id W4SxBFG5XXyod8C8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 May 2016 07:44:26 -0700 (PDT)
Date: Mon, 23 May 2016 07:44:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: make several functions static
Message-ID: <20160523144425.GA9319@infradead.org>
References: <3ec4e394-1885-6f3e-f909-c9a77a72668b@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3ec4e394-1885-6f3e-f909-c9a77a72668b@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, May 19, 2016 at 02:16:25PM -0500, Eric Sandeen wrote:
> Al Viro noticed that xfs_lock_inodes should be static, and
> that led to ... a few more.
> 
> These are just the easy ones, others require moving functions
> higher in source files, so that's not done here to keep
> this review simple.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> We aren't using STATIC anymore ... right?

We're moving away from it at least, although not very stringently..

> FWIW cross-applying to xfsprogs picks up a handful of these
> as well, and it's still happy too.

Yeah - seems like none of them is of the odd static in kernel but not in
xfsprogs kind.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
