Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA9L53wx224119
	for <linux-xfs@oss.sgi.com>; Mon, 9 Nov 2009 15:05:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39C3170F99
	for <linux-xfs@oss.sgi.com>; Mon,  9 Nov 2009 13:05:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5AR1sOwdGdxwAGWI for
	<linux-xfs@oss.sgi.com>; Mon, 09 Nov 2009 13:05:20 -0800 (PST)
Date: Mon, 9 Nov 2009 16:05:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: NULL mp->m_log in 2.6.31 xfs_log_move_tail
Message-ID: <20091109210519.GA9698@infradead.org>
References: <87ws1z8mbf.fsf@coraid.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ws1z8mbf.fsf@coraid.com>
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
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-xfs@oss.sgi.com

On Mon, Nov 09, 2009 at 03:39:32PM -0500, Ed Cashin wrote:
> A colleague has seen oopses in 2.6.31 when an XFS is mounted on an AoE
> target that becomes unresponsive and is marked as "down" by the aoe
> driver.  The aoe driver starts failing all new I/O requests after
> failing all current requests when the device is down.

And the oops happens when unmounting the devices?  That's at least how
the trace looks like.   If that's the case I suspect we tear down the
log a bit too early - I'll do an audit of the log shutdown path how this
could happen.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
