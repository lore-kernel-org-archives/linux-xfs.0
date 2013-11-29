Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBC637F52
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 20:07:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9DB948F804C
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 18:07:14 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id zoPWqQdZbE921f7o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 18:07:13 -0800 (PST)
Date: Fri, 29 Nov 2013 02:07:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131129020703.GR10323@ZenIV.linux.org.uk>
References: <20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
	<20131129014648.GU10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129014648.GU10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 12:46:48PM +1100, Dave Chinner wrote:
> > 	* d_count(dentry) is -128
> 
> void lockref_mark_dead(struct lockref *lockref)
> {
>         assert_spin_locked(&lockref->lock);
>         lockref->count = -128;
> }

... done once refcount reaches zero and we decide to evict the sucker.
Which, for dentry that happens to be
	* pwd of at least one process
	* root of at least one process
	* root dentry of a filesystem that contains at least one
binary being executed
means that we have dropped several references too many.  Thus the
comment about unbalanced dput() somewhere; the question is _where_ had
that dput() been.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
