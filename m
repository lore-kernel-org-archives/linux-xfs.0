Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBHEEdKh233175 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 08:14:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39A64145BDC3
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 06:16:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IoYtw6bBFdCVduuU for
	<xfs@oss.sgi.com>; Fri, 17 Dec 2010 06:16:34 -0800 (PST)
Date: Fri, 17 Dec 2010 09:16:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: use AIL bulk delete function to implement
	single delete
Message-ID: <20101217141633.GB30830@infradead.org>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
	<1292214743-18073-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292214743-18073-10-git-send-email-david@fromorbit.com>
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

On Mon, Dec 13, 2010 at 03:32:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We now have two copies of AIL delete operations that are mostly
> duplicate functionality. The single log item deletes can be
> implemented via the bulk updates by turning xfs_trans_ail_delete()
> into a simple wrapper. This removes all the duplicate delete
> functionality and associated helpers.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

The same comment about just taking the address as for the previous patch
applies.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
