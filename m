Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAU8sBgn175358 for <xfs@oss.sgi.com>; Wed, 30 Nov 2011 02:54:11 -0600
Date: Wed, 30 Nov 2011 03:54:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] xfs fixes for Linux 3.2-rc3
Message-ID: <20111130085406.GA19064@infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111129192300.GW29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111129192300.GW29840@sgi.com>
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

On Tue, Nov 29, 2011 at 01:23:00PM -0600, Ben Myers wrote:
> > The last one is the biggest and fixes the log space hang
> > first reported by Alex and then debugged by Chandra.
> 
> This last one is pretty big.  Could it wait for 3.3?

It's not that big, and if we manage to push it out ASAP it's not even
that late in the cycle.  Given that people are getting fast hardware
managing to hit all kinds of weird AIL and log reservation hangs that
had been hidden forever I'd much prefer to get it out into the field
ASAP.  That also includes a -stable backport, btw.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
