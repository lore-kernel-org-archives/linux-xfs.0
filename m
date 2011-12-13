Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDLPBhu174307 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 15:25:11 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E6F91F4B51C
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 13:25:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	j6sz6VRk1XLRNTYQ for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 13:25:09 -0800 (PST)
Date: Wed, 14 Dec 2011 08:25:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/11] xfs: cleanup xfs_iomap_eof_align_last_fsb
Message-ID: <20111213212507.GB3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155917.831271819@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155917.831271819@bombadil.infradead.org>
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

On Thu, Dec 08, 2011 at 10:57:57AM -0500, Christoph Hellwig wrote:
> Replace the nasty if, else if, elseif condition with more natural C flow
> that expressed the logic we want here better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Lots neater.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
