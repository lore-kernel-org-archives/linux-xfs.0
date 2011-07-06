Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66370cw062821 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:07:01 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E9734C292
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:06:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gQXiMccYx7M8cI4B for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:06:59 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:06:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/27] xfs: cleanup the defintion of struct
	xfs_dir2_data_entry
Message-ID: <20110706030657.GO1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.386730624@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094606.386730624@bombadil.infradead.org>
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

On Fri, Jul 01, 2011 at 05:43:41AM -0400, Christoph Hellwig wrote:
> Remove the tag member which is at a variable offset after the actual
> name, and make name a real variable sized C99 array instead of the incorrect
> one-sized array which confuses (not only) gcc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
