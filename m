Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43HJDCh022118 for <xfs@oss.sgi.com>; Tue, 3 May 2011 12:19:13 -0500
Subject: Re: [PATCH v2] xfstests: support post-udev device mapper nodes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110503084359.GA21704@infradead.org>
References: <20110503084359.GA21704@infradead.org>
Date: Tue, 3 May 2011 12:22:46 -0500
Message-ID: <1304443366.2853.24.camel@doink>
MIME-Version: 1.0
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

On Tue, 2011-05-03 at 04:43 -0400, Christoph Hellwig wrote:
> Because of udevs complaining device mapper now creates /dev/dm-N as the real
> device nodes, and just symlinks the /dev/mapper/ names to it.  This would be
> easy if everything used the /dev/mapper clear names, but most system utilities
> translate them back to the /dev/mapper/ names and thus confuse various test
> cases.  Add support to _is_block_dev to read symlinks, and add documentation
> on how to run xfstests on device mapper volumes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
