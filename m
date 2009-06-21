Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5LJGWfQ182093 for <xfs@oss.sgi.com>; Sun, 21 Jun 2009 14:16:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81AEA30FEFC
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2009 12:16:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9uLJ6qr3EH449RAX for
	<xfs@oss.sgi.com>; Sun, 21 Jun 2009 12:16:59 -0700 (PDT)
Date: Sun, 21 Jun 2009 15:16:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: basic fallocate boundary tests
Message-ID: <20090621191657.GA19596@infradead.org>
References: <4A370C2C.6030404@sandeen.net>
	<20090620175824.GA3984@infradead.org>
	<4A3D55C3.6020902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A3D55C3.6020902@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jun 20, 2009 at 04:33:55PM -0500, Eric Sandeen wrote:
> hmm this is really testing that xfs_io in particular has fallocate...
> so maybe like this?
> 
> diff --git a/common.rc b/common.rc
> index 39350b3..55aecd6 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -704,6 +704,18 @@ _require_user()
>      [ "$?" == "0" ] || _notrun "$qa_user user not defined."
>  }
>  
> +# check that xfs_io, glibc, kernel, and filesystem all (!) support
> +# fallocate
> +#
> +_require_xfs_io_falloc()
> +	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $TEST_DIR/$tmp.io 2>&1`
> +	rm -f $TEST_DIR/$tmp.io 2>&1 > /dev/null
> +	echo $testio | grep -q "not found" && \
> +		_notrun "xfs_io fallocate support is missing"
> +	echo $testio | grep -q "Operation not supported" && \
> +		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
> +}

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
