Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASG5Lr7192322 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 10:05:21 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Zac3NIe4GEOUdH1S (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 08:07:38 -0800 (PST)
Date: Wed, 28 Nov 2012 11:07:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix splice/direct-IO deadlock
Message-ID: <20121128160736.GA14888@infradead.org>
References: <1354068768-4316-1-git-send-email-david@fromorbit.com>
	<1354068768-4316-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1354068768-4316-3-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 28, 2012 at 01:12:48PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> lockdep reports splice vs direct-io write lock inversions due to
> generic_file_splice_write() taking the inode->i_mutex inside
> XFS_IOLOCK_EXCL context. These lock contexts are inverted, hence can
> deadlock.  Remove the XFS_IOLOCK_EXCL locking context from the outer
> function and drive it inwards to the actor function that only locks
> the inode when the lock is really needed,

punctuation?

Otherwise the patch looks fine, but I'd love to understand why the
generic code thes te I_MUTEX_CHILD annotation and we can get away
without it.

Also can you add a testcase for this to xfstests?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
