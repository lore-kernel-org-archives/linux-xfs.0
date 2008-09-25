Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 16:50:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PNo85h004032
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:50:08 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BAF34854C4
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:51:42 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 7aPnZ47BqjBAVbnp for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 16:51:42 -0700 (PDT)
Date: Fri, 26 Sep 2008 09:50:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9] CRC support for superblock, ag headers, log and
	btree blocks
Message-ID: <20080925235030.GE27997@disturbed>
References: <20080925225613.GA9822@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925225613.GA9822@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Sep 26, 2008 at 12:56:13AM +0200, Christoph Hellwig wrote:
> Here's an updated crc series for various metadata structures.  We're still
> looking at the magic number in the log recovery case because getting down
> a buffer type for the other structures wasn't quite as easy as for the
> btree block.  I'll probably look into that again once we're done with all
> data structures.

FWIW, I note that you haven't done anything with the AGFL yet. I was
considering 2 different approaches. The first was to put the CRC for
the AGFL into the AGF so that the internals of the AGFL do not change.
However, that means we have interesting synchronisation problems
with the CRC, so I don't think that will fly.

The other option was to reduce the number of slots in the AGFL by
one and use the last slot to hold the CRC. I think that is OK to do;
the AGFL can change size with different secotr size support, so I
don't see this being a big problem. Nor do I think that we ever fill
the AGFL up to it's full 128 slots during any transaction, so
reducing the size by one should be safe.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
