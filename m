Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GLk3hK021551 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 15:46:03 -0600
Date: Thu, 16 Feb 2012 15:46:09 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 00/12] log grant code cleanups
Message-ID: <20120216214609.GB7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141346.986825692@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph,

On Mon, Dec 12, 2011 at 09:13:47AM -0500, Christoph Hellwig wrote:
> This series removes the opportunistic log space wakeups which had no
> use but hiding real races for far too long, and applies various bits
> of refactoring to the log grant code to make it smaller and more readable.

This patch set looks just about ready to go.  The only changes I'd like
to see are some commit messages where they are missing, and I have a
question about patch 11 related to usage t_ocnt on the log ticket.

Really nice cleanups.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
