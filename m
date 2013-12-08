Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA2CF7F86
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:32:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B75168F8040
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:32:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DXdn4JHqtLPXMWrd for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:31:57 -0800 (PST)
Date: Mon, 9 Dec 2013 09:31:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfs: remove xfs_iunlock_map_shared
Message-ID: <20131208223152.GC31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.352433582@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203128.352433582@bombadil.infradead.org>
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

On Fri, Dec 06, 2013 at 12:30:08PM -0800, Christoph Hellwig wrote:
> We can just use xfs_iunlock without any loss of clarity.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense, gets rid of an unecessary wrapper.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
