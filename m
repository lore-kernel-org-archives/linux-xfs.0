Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3EtlV6167443 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 08:55:47 -0600
Date: Tue, 3 Nov 2009 09:55:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reset the i_iolock lock class in the reclaim path
Message-ID: <20091103145559.GC32542@infradead.org>
References: <20091019040526.GC21115@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83AE5D@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE5D@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, xfs@oss.sgi.com

On Mon, Nov 02, 2009 at 03:54:02PM -0600, Alex Elder wrote:
> The comment in xfs_fs_clear_inode() is very informative, but
> it may be emphasizing a lot of detail that doesn't really
> help the reader at this spot in the code.  What about wording
> something more like this:
>     The iolock is used by the file system to coordinate
>     reads, writes, and block truncates.  Up to this point
>     the lock protected concurrent accesses by users of
>     the inode.  But from here forward we're doing some final
>     processing of the inode because we're done with it,
>     and although we reuse the iolock for protection it is
>     really a distinct lock class (in the lockdep sense) from
>     before.  To keep lockdep happy (and basically indicate
>     what we are doing), we explicitly re-init the iolock here.

Fine with me.  Do you want a respin or will you fix up the comment on the
fly?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
