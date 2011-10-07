Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97MIFbA002325 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 17:18:15 -0500
Subject: Re: [PATCH 2/4] xfs: force the log if we encounter pinned buffers
	in .iop_pushbuf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006183549.598050900@bombadil.infradead.org>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.598050900@bombadil.infradead.org>
Date: Fri, 7 Oct 2011 17:18:11 -0500
Message-ID: <1318025891.2810.78.camel@doink>
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
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Thu, 2011-10-06 at 14:32 -0400, Christoph Hellwig wrote:
> We need to check for pinned buffers even in .iop_pushbuf given that inode
> items flush into the same buffers that may be pinned directly due operations
> on the unlinked inode list operating directly on buffers.  To do this add a
> return value to .iop_pushbuf that tells the AIL push about this and use
> the existing log force mechanisms to unpin it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Stefan Priebe <s.priebe@profihost.ag>
> Tested-by: Stefan Priebe <s.priebe@profihost.ag>

Looks ok to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
