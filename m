Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8MsRGe004748 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 16:54:27 -0600
Date: Mon, 8 Dec 2008 17:54:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH] XFS_TRANS_DEBUG fixes
Message-ID: <20081208225426.GA22003@infradead.org>
References: <4938D3E0.5050501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4938D3E0.5050501@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 05, 2008 at 06:10:24PM +1100, Lachlan McIlroy wrote:
> Some of the things I had to do to get it to work (and could be done some other
> way) are:
> - all buffers that are logged need to be mapped into kernel space so the
>    debugging code can make a copy of the buffer data and compare it later.
>    The easiest way to do that is to make all buffers mapped in xfs_bug_get_flags()
>    when XFS_TRANS_DEBUG is set.

Need a comment similar to this next to the place that sets the flag.

> - Some bit setting functions (btst()/bset()/bfset()) appear to be missing so
>    I've coded up some trivial versions.  There maybe some linux kernel functions
>    that do the same thing.

Just use the Linu set_bit / clear_bit / test_bit / test_and_set_bit /
test_and_clear_bit helpers, or the __ prefixed versions if you don't
need atomicy.  Note that they want to have pointers to unsigned long
passed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
