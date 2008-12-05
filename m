Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB53qP0G031481 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 21:52:25 -0600
Message-ID: <4938A58F.6090109@sgi.com>
Date: Fri, 05 Dec 2008 14:52:47 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Remove XFS_BUF_SHUT() and friends
References: <49378654.2050707@sgi.com> <20081204132746.GA27400@infradead.org>
In-Reply-To: <20081204132746.GA27400@infradead.org>
Reply-To: lachlan@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Dec 04, 2008 at 06:27:16PM +1100, Lachlan McIlroy wrote:
>> Code does nothing so remove it.
> 
> Looks good to me.  Does anyone remember why this flag was set on IRIX?

During a forced shutdown we would go through all incore buffers and mark
them B_STALE/B_ERROR/B_SHUT and then call biodone() on them.  The code in
xfs_buf_iodone_callbacks() that checks for B_SHUT is to avoid a double
biodone() I think.  We don't have the code in the Linux port that scans
through all the incore buffers on a forced shutdown but we still have one
case in xfs_iflush_cluster().  In any case it's not doing anything.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
