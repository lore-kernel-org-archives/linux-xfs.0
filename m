Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o259K86P237751 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 03:20:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EE9B13FAC3A
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 01:21:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id X8VEpkuX2mV8sOsO for
	<xfs@oss.sgi.com>; Fri, 05 Mar 2010 01:21:36 -0800 (PST)
Date: Fri, 5 Mar 2010 04:21:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfsqa: define resblks for tests near ENOSPC
Message-ID: <20100305092136.GB1499@infradead.org>
References: <1267667254-7971-1-git-send-email-david@fromorbit.com>
	<20100304135623.GB31753@infradead.org>
	<20100304220421.GJ14317@discord.disaster>
	<20100305020333.GN14317@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100305020333.GN14317@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 05, 2010 at 01:03:33PM +1100, Dave Chinner wrote:
> 
> Several tests assume a certain amount of disk space free after the
> reserve block pool is filled. Changing the default size of the
> reserve block pool breaks these tests because there is less space
> available that first thought.
> 
> Change these tests to specify a known reserve block pool size of
> 1024 blocks to ensure that they continue to work correctly even if
> the default size changes.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
