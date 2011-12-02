Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2Bqmo5070499 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 05:52:49 -0600
Date: Fri, 2 Dec 2011 06:51:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
Message-ID: <20111202115141.GA21643@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<20111130235641.GX29840@sgi.com>
	<20111201072149.GA1319@infradead.org>
	<20111201195128.GZ29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111201195128.GZ29840@sgi.com>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Thu, Dec 01, 2011 at 01:51:28PM -0600, Ben Myers wrote:
> Process A reads from the grant reserve head at 2641 (and there currently is enough space)
> Process B wakes at either 2646 or 2650, in xlog_reserveq_wait, locks, and reads from the grant reserve head (and currently there is enough space)
> Process B removes itself from the list 
> Process A reads from the reservq list and finds it to be empty
> Process A finds that there was enough space at 2646
> Process B returns from xlog_reserveq_wait, unlocks, grants space at 2656, returns
> Process A grants log space at 2656, and returns
> 
> AFAICS there is nothing that prevents these guys from granting the same
> space when you approach free_bytes >= need_bytes concurrently. 
> 
> This lockless stuff is always a mind job for me.  I'll take another look at
> some of the other aspects of the patch.  Even if it doesn't resolve my
> question about the lockless issue, it seems to resolve Chandra's race.

Indeed, I think we have this race.  Then again I I think we had
exactly the same one before, too.  The only way to fix it would be
to do a sort of double cmpxchg that only moves the grant head forward
if it's still in available space vs the tails lsn.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
