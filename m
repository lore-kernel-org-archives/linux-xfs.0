Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 406B07F4E
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 00:28:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE86FAC003
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:28:50 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id uGoaAPr6rJEOPacT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 22:28:45 -0700 (PDT)
Date: Tue, 27 May 2014 22:28:45 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/16] xfs: move directory block translatiosn to
	xfs_da_btree.h
Message-ID: <20140528052845.GA3816@infradead.org>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-3-git-send-email-david@fromorbit.com>
	<20140527104638.GE1440@infradead.org>
	<20140527230636.GE8554@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140527230636.GE8554@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, May 28, 2014 at 09:06:36AM +1000, Dave Chinner wrote:
> Fair call - they really are dir2 specific, so probably should be in
> xfs_dir2_priv.h, not xfs_da_btree.h.
> 
> OK, I can update this patch to do that. I'll need to repost the
> series, because I'll have to rework a significant number of the
> patches...

I'd be fine with fixing that after the series, but let me review some
more of the patches first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
