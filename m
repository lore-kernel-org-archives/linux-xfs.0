Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB21llGK244843 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 19:47:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA54F1BB301
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 17:49:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	cfYJDBJR0PX5fX3A for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 17:49:30 -0800 (PST)
Date: Thu, 2 Dec 2010 12:49:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/14] xfs: convert log grant heads to LSN notation
Message-ID: <20101202014927.GO16922@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-4-git-send-email-david@fromorbit.com>
	<20101201124234.GB612@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201124234.GB612@infradead.org>
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

On Wed, Dec 01, 2010 at 07:42:35AM -0500, Christoph Hellwig wrote:
> The patch looks good to me, but I really hate overloading the lsn types
> and helpers.  Just add duplicated of CYCLE_LSN/BLOCK_LSN and
> xlog_assign_lsn for a new type as use them.

Ok, will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
