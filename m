Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:50506 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935153AbcI3AS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 20:18:58 -0400
Date: Fri, 30 Sep 2016 10:18:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 43/63] xfs: teach get_bmapx about shared extents and the
 CoW fork
Message-ID: <20160930001853.GI27872@dastard>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503149320.30303.9720221974285402096.stgit@birch.djwong.org>
 <20160929170537.GI4546@infradead.org>
 <20160929174059.GX14092@birch.djwong.org>
 <20160929195112.GA26321@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929195112.GA26321@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 12:51:12PM -0700, Christoph Hellwig wrote:
> On Thu, Sep 29, 2016 at 10:40:59AM -0700, Darrick J. Wong wrote:
> > There are a few xfstests that check the contents of the CoW extent fork
> > to make sure it's working properly.  How about a compromise -- leave the
> > flag in, but return -EINVAL unless CONFIG_XFS_DEBUG=y ?
> 
> Personally I'd prefer to remove it.  Maybe we'll need Dave as a tie
> breaker?

Well, I kinda see it like reporting delalloc extents - they are
in-memory, but we can report them to userspace even though they will
change shortly.  I don't think it's generally useful, but right now
we need all the validation checks we can get.

<shrug>

Ok, Darrick, let's make it debug only right now so those tests work
while we get this code all sorted. And then plan to remove it before
we remove the EXPERIMENTAL flag from reflink?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
