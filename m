Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QKXNX9163025 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 14:33:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24B9F154A2B7
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 12:35:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7wC7KVISnDxYPbmI for
	<xfs@oss.sgi.com>; Wed, 26 Jan 2011 12:35:47 -0800 (PST)
Date: Wed, 26 Jan 2011 15:35:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfstests: Speed up test 042
Message-ID: <20110126203547.GD19159@infradead.org>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295927937-20634-5-git-send-email-david@fromorbit.com>
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

On Tue, Jan 25, 2011 at 02:58:57PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> test 042 generates a worst-case fragmented filesystem and uses it to
> test xfs_fsr. It uses small 4k files to generate the hole-space-hole
> pattern that fragments free space badly. It is much faster to
> generate the same pattern by creating a single large file and
> punching holes in it.  Also, instead of writing large files to
> create unfragmented space, just use preallocation so we don't have
> to write the data to disk.
> 
> These changes reduce the runtime of the test on a single SATA drive
> from 106s to 27s.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
