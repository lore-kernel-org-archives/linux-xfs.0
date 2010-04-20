Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K6Tv61010192 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 01:29:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEFAD2D6E18
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 23:28:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	XOIHlB2hCyITkdEu for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 23:28:12 -0700 (PDT)
Date: Tue, 20 Apr 2010 16:28:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: access quotainfo structure directly
Message-ID: <20100420062809.GE15130@dastard>
References: <20100418001041.865247520@bombadil.infradead.org>
	<20100418001057.704530594@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100418001057.704530594@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Apr 17, 2010 at 08:10:42PM -0400, Christoph Hellwig wrote:
> Access fields in m_quotainfo directly instead of hiding them behind the
> XFS_QI_* macros.  Add local variables for the quotainfo pointer in places
> where we have lots of them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. I was half way through doing this myself ;)

Reviewed-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
