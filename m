Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H4HuOd204041 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 22:17:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC27713B0879
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 20:19:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	3JKyEVULZwPrmNIh for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 20:19:13 -0800 (PST)
Date: Wed, 17 Feb 2010 15:19:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix xfs_fsblock_t tracing
Message-ID: <20100217041910.GM28392@discord.disaster>
References: <20100215220219.GA4890@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215220219.GA4890@infradead.org>
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

On Mon, Feb 15, 2010 at 05:02:19PM -0500, Christoph Hellwig wrote:
> Using a static buffer in xfs_fmtfsblock means we can corrupt traces if
> multiple CPUs hit this code path at the same.  Just remove xfs_fmtfsblock
> for now and print the block number purely numerical.  If we want the
> NULLFSBLOCK and NULLSTARTBLOCK formatting back the best way would be
> a decoding plugin in the trace-cmd userspace command.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
