Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A04C7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 18:44:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E5E78F8039
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 16:44:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GlhRNqV8gUweAuqm for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 16:44:44 -0800 (PST)
Date: Wed, 4 Dec 2013 11:44:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] xfs: remove the inode log format from the inode
	log item
Message-ID: <20131204004438.GG10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084001.431063269@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084001.431063269@bombadil.infradead.org>
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

On Fri, Nov 29, 2013 at 12:39:27AM -0800, Christoph Hellwig wrote:
> No need to keep the inode log format around all the time, we can easily
> generate it at iop_format time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ignoring the previously mentioned structure alignment issue, this
change looks good. Overall, the inode log item is reduced in size by
about 72 bytes. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
