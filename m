Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A0I4p7174315 for <xfs@oss.sgi.com>; Sun, 9 Jan 2011 18:18:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31E82FC709E
	for <xfs@oss.sgi.com>; Sun,  9 Jan 2011 16:20:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	R3eHJBaJAoC1BN92 for <xfs@oss.sgi.com>;
	Sun, 09 Jan 2011 16:20:14 -0800 (PST)
Date: Mon, 10 Jan 2011 11:20:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: add FITRIM support
Message-ID: <20110110002011.GC28803@dastard>
References: <20110107130204.GA12134@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110107130204.GA12134@infradead.org>
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

On Fri, Jan 07, 2011 at 08:02:04AM -0500, Christoph Hellwig wrote:
> Allow manual discards from userspace using the FITRIM ioctl.  This is not
> intended to be run during normal workloads, as the freepsace btree walks
> can cause large performance degradation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
