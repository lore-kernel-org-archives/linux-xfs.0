Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB17LsFb249094 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 01:21:54 -0600
Date: Thu, 1 Dec 2011 02:21:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
Message-ID: <20111201072149.GA1319@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<20111130235641.GX29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111130235641.GX29840@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 30, 2011 at 05:56:41PM -0600, Ben Myers wrote:
> Christoph,
> 
> I feel that the ordering of the accesses to l_grant_head and the writeq
> list may be important in the lockless path, and notice that they used to
> be in opposite order.  It could use a comment explaining why (if) it is
> ok.

Do you mean moving the xlog_space_left after the first
list_empty_careful check in xlog_grant_log_space?  It doesn't matter
given that we re-check the available space after each wakeup.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
