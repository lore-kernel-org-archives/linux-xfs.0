Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L7Jamf110255 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 02:19:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29D7E151077E
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 00:22:17 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id fHGABwUgyHnFIwah for <xfs@oss.sgi.com>;
	Mon, 21 Jun 2010 00:22:17 -0700 (PDT)
Date: Mon, 21 Jun 2010 03:22:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: remove block number from inode lookup code
Message-ID: <20100621072216.GE1361@infradead.org>
References: <1277078341-19087-1-git-send-email-david@fromorbit.com>
	<1277078341-19087-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1277078341-19087-5-git-send-email-david@fromorbit.com>
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
Cc: security@kernel.org, xfs@oss.sgi.com

On Mon, Jun 21, 2010 at 09:59:01AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The block number comes from bulkstat based inode lookups to shortcut
> the mapping calculations. We ar enot able to trust anything from
> bulkstat, so drop the block number as well so that the correct
> lookups and mappings are always done.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
