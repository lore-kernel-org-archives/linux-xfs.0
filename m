Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FFCF7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 18:40:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53CE530404E
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 16:40:38 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ozTso4oCidSYdfpy for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2016 16:40:36 -0700 (PDT)
Date: Wed, 7 Sep 2016 09:40:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 34/71] xfs: support bmapping delalloc extents in the CoW
	fork
Message-ID: <20160906234001.GN30056@dastard>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216814006.867.6404376654574855233.stgit@birch.djwong.org>
	<20160906152553.GA9760@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906152553.GA9760@infradead.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, Sep 06, 2016 at 08:25:53AM -0700, Christoph Hellwig wrote:
> FYI, this has some major conflicts with the iomap updates - we'll need
> to know from Dave which one should go in first.

I've already got the iomap updates in my local tree, so they will go
in first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
