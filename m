Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08Mgs1P014792 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 16:42:55 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9258117C08B2
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 14:42:53 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	qmapCbJPK71hoVm6 for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 14:42:53 -0800 (PST)
Date: Fri, 9 Jan 2009 09:42:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: fix compile of xfs_btree_readahead_lblock on m68k
Message-ID: <20090108224247.GI9448@disturbed>
References: <20090108184222.244013000@bombadil.infradead.org>
	<20090108184429.823470000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090108184429.823470000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Thu, Jan 08, 2009 at 01:42:23PM -0500, Christoph Hellwig wrote:
> Change the left/right variables to the proper always 64bit xfs_dfsbo_t
> type because otherwise compilation fails for Geert on m68k without
> CONFIG_LBD:
> 
> | fs/xfs/xfs_btree.c: In function 'xfs_btree_readahead_lblock':
> | fs/xfs/xfs_btree.c:736: warning: comparison is always true due to limited range of data type
> | fs/xfs/xfs_btree.c:741: warning: comparison is always true due to limited range of data type
> 
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
