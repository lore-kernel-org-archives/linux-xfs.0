Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81JMA5a035116 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 14:22:10 -0500
Subject: Re: [PATCH 03/11] xfs: move more delwri setup into
	xfs_buf_delwri_queue
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110823082912.320240070@bombadil.infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082912.320240070@bombadil.infradead.org>
Date: Thu, 1 Sep 2011 14:22:09 -0500
Message-ID: <1314904929.2903.61.camel@doink>
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

On Tue, 2011-08-23 at 04:28 -0400, Christoph Hellwig wrote:
> Do not transfer a reference held by the caller to the buffer on the list,
> or decrement it in xfs_buf_delwri_queue, but instead grab a new reference
> if needed, and let the caller drop its own reference.  Also move setting
> of the XBF_DELWRI and XBF_ASYNC flags into xfs_buf_delwri_queue, and
> only do it if needed.  Note that for now xfs_buf_unlock already has
> XBF_DELWRI, but that will change in the following patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Definite improvement.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
