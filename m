Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BAHhNH129660 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 04:17:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D69D1C40EAF
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 02:18:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ggsp201BtEwUYBCo for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 02:18:38 -0800 (PST)
Date: Mon, 11 Jan 2010 05:18:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: reclaim inodes under a write lock
Message-ID: <20100111101836.GA26465@infradead.org>
References: <1263167508-9346-1-git-send-email-david@fromorbit.com>
	<1263167508-9346-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263167508-9346-2-git-send-email-david@fromorbit.com>
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

On Mon, Jan 11, 2010 at 10:51:45AM +1100, Dave Chinner wrote:
> Make the inode tree reclaim walk exclusive to avoid races with
> concurrent sync walkers and lookups. This is a version of
> a patch posted by Christoph Hellwig that avoids all the code
> duplication.

looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

FYI: I would rename xfs_reclaim_inode_now to just xfs_reclaim_inode,
but unless Alex wants to edit it let's just get the patch in for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
