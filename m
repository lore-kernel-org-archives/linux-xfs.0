Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85BVmOu037264 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 06:31:48 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id fcaD39MqOrnKr7zV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Sep 2012 04:32:46 -0700 (PDT)
Date: Wed, 5 Sep 2012 12:32:42 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 020/102] xfs: warn if direct reclaim tries to writeback
	pages
Message-ID: <20120905113242.GL11266@suse.de>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<1345698180-13612-21-git-send-email-david@fromorbit.com>
	<20120827181742.GA13970@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120827181742.GA13970@infradead.org>
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

On Mon, Aug 27, 2012 at 02:17:42PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 23, 2012 at 03:01:38PM +1000, Dave Chinner wrote:
> > From: Mel Gorman <mgorman@suse.de>
> > 
> > Upstream commit: 94054fa3fca1fd78db02cb3d68d5627120f0a1d4
> > 
> > Direct reclaim should never writeback pages.  For now, handle the
> > situation and warn about it.  Ultimately, this will be a BUG_ON.
> 
> Is this actually the case on 3.0-stable?
> 

No, it is not. AFAIK, 3.0-stable does not contain [ee72886d: mm: vmscan:
do not writeback filesystem pages in direct reclaim] which is the absolute
minimum required for commit [94054fa3: xfs: warn if direct reclaim tries
to writeback pages] to make sense.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
