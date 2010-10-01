Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o91DtqRv079846 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 08:55:53 -0500
Subject: Re: [PATCH 1/3] [PATCH 1/3] xfs: remove XFS_MOUNT_NO_PERCPU_SB
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100930022600.975540107@bombadil.infradead.org>
References: <20100930022553.391390964@bombadil.infradead.org>
	<20100930022600.975540107@bombadil.infradead.org>
Date: Fri, 01 Oct 2010 08:56:40 -0500
Message-ID: <1285941400.5119.453.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-09-29 at 22:25 -0400, Christoph Hellwig wrote:

> Fail the mount if we can't allocate memory for the per-CPU counters.
> This is consistent with how we handle everything else in the mount
> path and makes the superblock counter modification a lot simpler.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
