Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 18:13:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m721DVv5022110
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 18:13:31 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27DE6EF0C34
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 18:14:44 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id PN8bTZHTJPa5s2Ya for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 18:14:44 -0700 (PDT)
Date: Sat, 2 Aug 2008 11:14:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/21] implement generic xfs_btree_updkey
Message-ID: <20080802011442.GL6201@disturbed>
References: <20080729193110.GM19104@lst.de> <20080730050936.GM13395@disturbed> <20080801194452.GF1263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801194452.GF1263@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2008 at 09:44:52PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 30, 2008 at 03:09:36PM +1000, Dave Chinner wrote:
> > And even then I think we might not need an error variable - it can
> > only return EFSCORRUPTED, so:
> > 
> > #ifdef DEBUG
> > 		if (xfs_btree_check_block(cur, block, level, bp)) {
> > 			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > 			return EFSCORRUPTED;
> > 		}
> > #endif
> > 
> > Would remove the need for the error variable.
> 
> I'm not a big fan of losing detailed error information.  Depending
> on how the bigger btree blocks work out we might return other errors
> here in the near future.

Fair enough.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
