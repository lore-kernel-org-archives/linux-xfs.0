Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FHMdNC048530 for <xfs@oss.sgi.com>; Fri, 15 May 2009 12:22:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E04D19D0C03
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 10:22:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HxBRmjsoGxvt0Ten for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 10:22:47 -0700 (PDT)
Date: Fri, 15 May 2009 13:22:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: split inode flushing from xfs_sync_inodes_ag
Message-ID: <20090515172246.GC14804@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.298098000@bombadil.infradead.org>
	<921ca19c0905142152u2a8012a9jba6f1d5b856df7ad@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <921ca19c0905142152u2a8012a9jba6f1d5b856df7ad@mail.gmail.com>
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
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 15, 2009 at 10:22:31AM +0530, Sujit Karataparambil wrote:
> here also should there be an
> xfs_sync_inode_data(ip, flags);
> xfs_iflush(ip, XFS_IFLUSH_SYNC);
> 
> in out_unlock.

No.  We only want to perform the iflush if all the preconditions are met
in the !SYNC_WAIT case.  And we certainly do not want to do a data
writeout from the metadata flush case - for one thing it does require
the iolock, but most importantly the point of this series is to separate
the two actions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
