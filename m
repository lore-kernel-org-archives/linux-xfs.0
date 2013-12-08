Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB7947F98
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:36:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2EA08F8039
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:36:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CHXYBFoBKktZjlOr for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:36:33 -0800 (PST)
Date: Mon, 9 Dec 2013 09:36:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/11] xfs: reinstate the ilock in xfs_readdir
Message-ID: <20131208223628.GF31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.786826439@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203128.786826439@bombadil.infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 12:30:11PM -0800, Christoph Hellwig wrote:
> From: Ben Myers <bpm@sgi.com>
> 
> Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
> xfs_readdir because we might have to read the extent list in from disk.  This
> keeps other threads from reading from or writing to the extent list while it is
> being read in and is still in a transitional state.
> 
> This has been associated with "Access to block zero" messages on directories
> with large numbers of extents resulting from excessive filesytem fragmentation,
> as well as extent list corruption.  Unfortunately no test case at this point.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
