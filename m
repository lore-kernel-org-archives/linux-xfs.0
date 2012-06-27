Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5RHiqbT223293 for <xfs@oss.sgi.com>; Wed, 27 Jun 2012 12:44:53 -0500
Date: Wed, 27 Jun 2012 13:44:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: cleanup the mount options
Message-ID: <20120627174448.GA3278@infradead.org>
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: hch@infradead.org, bpm@sgi.com, xfs@oss.sgi.com

On Thu, Jun 28, 2012 at 12:57:23AM +0800, Wanlong Gao wrote:
> remove the mount options macro, use tokens instead.
> Futher cleanup will use xfs_*_opt in xfs instead,
> but it may be hard to be merged in one patch.

Thanks a lot!

I like the use of the option parse a lot, this has been long overdue.

But is there any good reason to add the xfs_*_opt macros?  They make
reading and especially grepping the code a lot harder, so there better
be a good reason for them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
