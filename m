Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LF1bIW013544 for <xfs@oss.sgi.com>; Fri, 21 May 2010 10:01:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 683C136369D
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 08:03:56 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id wn9hfY8AI9IvKeBY for <xfs@oss.sgi.com>;
	Fri, 21 May 2010 08:03:56 -0700 (PDT)
Date: Fri, 21 May 2010 11:03:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Check new inode size is OK before preallocating
Message-ID: <20100521150351.GA3493@infradead.org>
References: <1274420879-2391-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274420879-2391-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, May 21, 2010 at 03:47:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The new xfsqa test 228 tries to preallocate more space than the
> filesystem contains. it should fail, but instead triggers an assert
> about lock flags.  The failure is due to the size extension failing
> in vmtruncate() due to rlimit being set. Check this before we start
> the preallocation to avoid allocating space that will never be used.
> 
> Also the path through xfs_vn_allocate already holds the IO lock, so
> it should not be present in the lock flags when the setattr fails.
> Hence the assert needs to take this into account. This will prevent
> other such callers from hitting this incorrect ASSERT.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

Can you also add a check to 228 to ensure the space doesn't stay
allocate when the test fails, to catch the old XFS behaviour.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
