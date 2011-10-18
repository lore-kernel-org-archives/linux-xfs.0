Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IEhfNc102920 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 09:43:41 -0500
Message-ID: <1318949016.3776.9.camel@doink>
Subject: Re: [PATCH] xfs: constify xfs_item_ops
From: Alex Elder <aelder@sgi.com>
Date: Tue, 18 Oct 2011 09:43:36 -0500
In-Reply-To: <20111018091144.GA13240@infradead.org>
References: <20111018091144.GA13240@infradead.org>
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

On Tue, 2011-10-18 at 05:11 -0400, Christoph Hellwig wrote:
> The log item ops aren't nessecarily the biggest exploit vector, but marking
> them const is easy enough.  Also remove the unused xfs_item_ops_t typedef
> while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
