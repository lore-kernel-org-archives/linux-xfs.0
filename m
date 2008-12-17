Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHEKghF023893 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 08:20:42 -0600
Date: Wed, 17 Dec 2008 09:20:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove XFS_BUF_SHUT() and friends
Message-ID: <20081217142040.GB22023@infradead.org>
References: <49378654.2050707@sgi.com> <20081204132746.GA27400@infradead.org>
	<4938A58F.6090109@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4938A58F.6090109@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 05, 2008 at 02:52:47PM +1100, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
> > On Thu, Dec 04, 2008 at 06:27:16PM +1100, Lachlan McIlroy wrote:
> >> Code does nothing so remove it.
> > 
> > Looks good to me.  Does anyone remember why this flag was set on IRIX?
> 
> During a forced shutdown we would go through all incore buffers and mark
> them B_STALE/B_ERROR/B_SHUT and then call biodone() on them.  The code in
> xfs_buf_iodone_callbacks() that checks for B_SHUT is to avoid a double
> biodone() I think.  We don't have the code in the Linux port that scans
> through all the incore buffers on a forced shutdown but we still have one
> case in xfs_iflush_cluster().  In any case it's not doing anything.

Ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
