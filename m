Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G20A1l230135 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:00:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CA1317DB6D5
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:00:09 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Gc0QvHJu5A63mA1X for <xfs@oss.sgi.com>;
	Fri, 15 Jul 2011 19:00:09 -0700 (PDT)
Date: Fri, 15 Jul 2011 22:00:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/12] xfs: Remove the macro XFS_BUF_ERROR and family
Message-ID: <20110716020008.GD589@infradead.org>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716012122.6629.95933.sendpatchset@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110716012122.6629.95933.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 15, 2011 at 06:21:22PM -0700, Chandra Seetharaman wrote:
> Remove the definitions and usage of the macros XFS_BUF_ERROR,
> XFS_BUF_GETERROR and XFS_BUF_ISERROR.

Looks fine, although I'd prefer to just use bp->b_error directly instead
of xfs_buf_geterror when we know that bp is non-zero.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
