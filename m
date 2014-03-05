Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F344F7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 15:40:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC6C2304032
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 13:40:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	weBA1Blyzj8AGa32 for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 13:40:08 -0800 (PST)
Date: Thu, 6 Mar 2014 08:40:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: inode log reservations are still too small
Message-ID: <20140305214002.GI6851@dastard>
References: <1393981893-2497-1-git-send-email-david@fromorbit.com>
	<1393981893-2497-3-git-send-email-david@fromorbit.com>
	<20140305171441.GD11667@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140305171441.GD11667@infradead.org>
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

On Wed, Mar 05, 2014 at 09:14:41AM -0800, Christoph Hellwig wrote:
> The fix looks correct, but care to remind me where we account for the
> xlog_op_header for all non-buf, non-inode transaction?

We don't. We need to, I just haven't had the time to audit the rest
of the reservations to fix them all up yet. AFAIA, only the quota
off transactions don't have any slack in them for xlog_op_header
space - all the others that are incorrect probably have enough
overhead from the buffer overhead roundup to cover the lack ophdr
accounting on things like dquots.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
