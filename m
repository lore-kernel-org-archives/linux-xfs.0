Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NBoLGe090075 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 06:50:31 -0500
Date: Wed, 23 Mar 2011 07:53:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: xfs_trans_read_buf() should return an error on
	failure
Message-ID: <20110323115321.GA11612@infradead.org>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1300860870-15471-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Wed, Mar 23, 2011 at 05:14:28PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When inside a transaction and we fail to read a buffer,
> xfs_trans_read_buf returns a null buffer pointer and no error.
> xfs_do_da_buf() checks the error return, but not the buffer, and as
> a result this read failure condition causes a panic when it attempts
> to dereference the non-existant buffer.
> 
> Make xfs_trans_read_buf() return the same error for this situation
> regardless of whether it is in a transaction or not. This means
> every caller does not need to check both the error return and the
> buffer before proceeding to use the buffer.

Most callers seem to fine because they always pass 0 as flags,
or handle a NULL bp return.

The exception is xfs_imap_to_bp, which can get a trylock flag via
xfs_itobp and xfs_iflush, which needs a fix for this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
