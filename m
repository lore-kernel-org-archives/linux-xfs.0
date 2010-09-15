Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F0GYHd155729 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:16:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DD3A17F51F1
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:17:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AatHPAnLHGpDS04R for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:17:23 -0700 (PDT)
Date: Tue, 14 Sep 2010 20:17:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/18] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20100915001722.GA24145@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-8-git-send-email-david@fromorbit.com>
	<20100914145447.GE3400@infradead.org>
	<20100915001423.GJ15695@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100915001423.GJ15695@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 15, 2010 at 10:14:23AM +1000, Dave Chinner wrote:
> Oh, I missed that one in the twisty passages of the setattr code.
> I'll do another (more careful) pass across all the callers, and for
> those that are outside a transaction I'll add a separate call to
> xfs_mark_inode_dirty_sync() for them.

I'd prefer to be on the safe side - rename xfs_ichgtime to
xfs_trans_inode_chgtime or similar, and assert that the added
transaction-argument is non-zero and the inode is locked and added
to the transactions.  That way it's easier to spot which timestamp
updates are transactional and which not.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
