Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3DHOv7E206688 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 12:24:57 -0500
Subject: Re: [PATCH] xfstests: allow deeper symlink recursion in 005
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110410200332.GA29662@infradead.org>
References: <20110410200332.GA29662@infradead.org>
Date: Wed, 13 Apr 2011 12:24:46 -0500
Message-ID: <1302715486.2648.134.camel@doink>
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

On Sun, 2011-04-10 at 16:03 -0400, Christoph Hellwig wrote:
> Recent kernels allow more than 40 nested symlinks, so up the limit
> to still reproduce a failure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, and I confirm it fixes the output mismatch on 005.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
