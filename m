Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0O8vRqQ072243 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 02:57:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C05CE154690E
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 00:59:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zGkbEXO1luVfPUxh for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 00:59:49 -0800 (PST)
Date: Mon, 24 Jan 2011 03:59:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: speculative delayed allocation uses
	rounddown_power_of_2 badly
Message-ID: <20110124085949.GB26744@infradead.org>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
	<1295411400-15614-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295411400-15614-2-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Jan 19, 2011 at 03:29:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> rounddown_power_of_2() returns an undefined result when passed a
> value of zero. The specualtive delayed allocation code is doing this
> when the inode is zero length. Hence occasionally the preallocation
> is much, mcuh large than is necessary (e.g. 8GB for a 270 _byte_

	^^^^^^^^^ typo

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
