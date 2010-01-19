Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0JNBZQl224179 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 17:11:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 024A41C63BC3
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 15:12:33 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	ikpv4LQAcFjbRIYd for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 15:12:33 -0800 (PST)
Date: Wed, 20 Jan 2010 10:12:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] [PATCH] xfs: remove duplicate buffer flags
Message-ID: <20100119231230.GD14035@discord.disaster>
References: <20100119095643.378866749@bombadil.infradead.org>
	<20100119095654.708720933@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100119095654.708720933@bombadil.infradead.org>
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

On Tue, Jan 19, 2010 at 04:56:44AM -0500, Christoph Hellwig wrote:
> Currently we define aliases for the buffer flags in various namespaces,
> which only adds confusion.  Remove all but the XBF_ flags to clean this
> up a bit.
> 
> Note that we still abuse XFS_B_ASYNC/XBF_ASYNC for some non-buffer uses,
> but I'll clean that up later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. This has been on my "things for a rainy day" list for
quite some time.

Reviewed-by: Dave Chinner <david@fromorbit.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
