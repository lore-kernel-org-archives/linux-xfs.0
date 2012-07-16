Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GHYncx259591 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 12:34:49 -0500
Message-ID: <500450B6.7020201@sgi.com>
Date: Mon, 16 Jul 2012 12:34:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: merge xfs_itobp into xfs_imap_to_bp
References: <20120703162122.GA16775@infradead.org>
In-Reply-To: <20120703162122.GA16775@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/03/12 11:21, Christoph Hellwig wrote:
> All callers of xfs_imap_to_bp want the dinode pointer, so let's calculate it
> inside xfs_imap_to_bp.  Once that is done xfs_itobp becomes a fairly pointless
> wrapper which can be replaced with direct calls to xfs_imap_to_bp.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---

Originally posted late March 2012. Still looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
