Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BMX5jX256251 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:33:05 -0500
Subject: Re: [PATCH 05/11] xfs: add a proper transaction pointer to struct
	xfs_buf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110710205017.667546845@bombadil.infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.667546845@bombadil.infradead.org>
Date: Mon, 11 Jul 2011 17:33:04 -0500
Message-ID: <1310423584.7019.57.camel@doink>
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

On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> Replace the typeless b_fspriv2 and the ugly macros around it with a properly
> typed transaction pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

So it looks like you do two things.
- make it a real pointer (which it should be), when it's
  used to keep track of the transaction a buffer is
  associated with; and
- eliminate the use of this field storing cast 1's and 2's
  for verifying the way log buffers are used.

I don't see much value in the second one, and the first
is the way it should be, so this looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
