Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C26E7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 18:47:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B720AC002
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 16:47:22 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ALyXdNb1vUPEky2L for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 16:47:21 -0800 (PST)
Date: Wed, 4 Dec 2013 11:47:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/10] xfs: remove the dquot log format from the dquot
	log item
Message-ID: <20131204004706.GH10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084001.650006317@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084001.650006317@bombadil.infradead.org>
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

On Fri, Nov 29, 2013 at 12:39:28AM -0800, Christoph Hellwig wrote:
> No need to keep the dquot log format around all the time, we can easily
> generate it at iop_format time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
