Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 22:47:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5K5lOkS016551
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 22:47:24 -0700
Date: Fri, 20 Jun 2008 07:48:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] check for invalid flags in xfs_attrlist_by_handle
Message-ID: <20080620054813.GA25244@lst.de>
References: <20080531075829.GA5424@lst.de> <485B431F.2070905@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485B431F.2070905@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jun 20, 2008 at 03:41:51PM +1000, Timothy Shimmin wrote:
> Fair enough.
> Actually, I think we only use ATTR_ROOT and ATTR_SECURE for the
> namespace flags.
> So you could probably use: XFS_ATTR_NSP_ARGS
> xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS_MASK	 (ATTR_ROOT | ATTR_SECURE)
> xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS(flags) ((flags) & XFS_ATTR_NSP_ARGS_MASK)
> and something like:
> 
> if (!XFS_ATTR_NSP_ARGS(al_hreq.flags))
>          return -XFS_ERROR(EINVAL);
> 
> Though would probably then need to include the right header (xfs_attr_leaf.h) for it...

Makes sense.  I'll revise the patch and send an updated version after
running it through QA.
