Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 883497F3F
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 18:40:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72FC28F8039
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 16:40:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gfC4FeooIdebykt0 for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 16:40:03 -0800 (PST)
Date: Wed, 4 Dec 2013 11:40:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/10] xfs: format logged extents directly into the CIL
Message-ID: <20131204004000.GF10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084001.243588401@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084001.243588401@bombadil.infradead.org>
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

On Fri, Nov 29, 2013 at 12:39:26AM -0800, Christoph Hellwig wrote:
> With the new iop_format scheme there is no need to have a temporary buffer
> to format logged extents into, we can do so directly into the CIL.  This
> also allows to remove the shortcut for big endian systems that probably
> hasn't gotten a lot of test coverage for a long time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Very nice! Lots of cruft just disappears here :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
