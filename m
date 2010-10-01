Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o91Dtqio079847 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 08:55:53 -0500
Subject: Re: [PATCH 2/3] [PATCH 2/3] xfs: do not use xfs_mod_incore_sb for
	per-cpu counters
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100930022601.268875972@bombadil.infradead.org>
References: <20100930022553.391390964@bombadil.infradead.org>
	<20100930022601.268875972@bombadil.infradead.org>
Date: Fri, 01 Oct 2010 08:56:46 -0500
Message-ID: <1285941406.5119.454.camel@doink>
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
> plain text document attachment
> (xfs-dont-use-xfs_mod_incore_sb-for-percpu-counters)
> Export xfs_icsb_modify_counters and always use it for modifying the per-cpu
> counters.  Remove support for per-cpu counters from xfs_mod_incore_sb to
> simplify it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
