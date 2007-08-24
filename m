Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 18:22:07 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7O1M04p032115
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 18:22:04 -0700
Date: Fri, 24 Aug 2007 03:21:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/17] move v_trace from bhv_vnode to xfs_inode
Message-ID: <20070824012158.GA25534@lst.de>
References: <20070823193834.GG8050@lst.de> <20070824000523.GA72985246@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824000523.GA72985246@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Aug 24, 2007 at 10:05:23AM +1000, David Chinner wrote:
> given that vn_count() returns the linux inode i_count, shouldn't
> we put that here as well rather than killing it? It is sometimes
> useful to see what is happening with the reference count in the
> traces....

True.  It'll need a little helper because the linux inode might
be zero in some places.
