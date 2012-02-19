Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JLH9jm027404 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 15:17:09 -0600
Date: Sun, 19 Feb 2012 16:17:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/12] log grant code cleanups
Message-ID: <20120219211706.GB22831@infradead.org>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20120216214609.GB7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120216214609.GB7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 03:46:09PM -0600, Ben Myers wrote:
> Christoph,
> 
> On Mon, Dec 12, 2011 at 09:13:47AM -0500, Christoph Hellwig wrote:
> > This series removes the opportunistic log space wakeups which had no
> > use but hiding real races for far too long, and applies various bits
> > of refactoring to the log grant code to make it smaller and more readable.
> 
> This patch set looks just about ready to go.  The only changes I'd like
> to see are some commit messages where they are missing, and I have a
> question about patch 11 related to usage t_ocnt on the log ticket.

For the "share ..." commits I can't really think of any commit message
that actually makes sense - the subject seems to describe what the patch
does more than enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
