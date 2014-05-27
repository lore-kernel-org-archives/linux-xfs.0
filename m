Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BCCFA7F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 18:07:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98E198F8094
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 16:07:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KJqkRVdALkwgPcTI for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 16:06:58 -0700 (PDT)
Date: Wed, 28 May 2014 09:06:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/16] xfs: move directory block translatiosn to
	xfs_da_btree.h
Message-ID: <20140527230636.GE8554@dastard>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-3-git-send-email-david@fromorbit.com>
	<20140527104638.GE1440@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527104638.GE1440@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, May 27, 2014 at 03:46:38AM -0700, Christoph Hellwig wrote:
> On Fri, May 23, 2014 at 10:03:38AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because they aren't actually part of the on-disk format, and so
> > shouldn't be in xfs_da_format.h.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Maybe it's time to rename the functions and types from xfs_dir2_* to
> xfs_da_* as we already do for some?  If not this should stay in dir2
> headers.

Fair call - they really are dir2 specific, so probably should be in
xfs_dir2_priv.h, not xfs_da_btree.h.

OK, I can update this patch to do that. I'll need to repost the
series, because I'll have to rework a significant number of the
patches...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
