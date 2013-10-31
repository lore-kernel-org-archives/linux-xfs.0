Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A64EE7F76
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 09:47:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 946DF8F8039
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 07:47:40 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7l3ynJps4RfjaCJ0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 07:47:39 -0700 (PDT)
Date: Thu, 31 Oct 2013 07:47:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/30] libxfs: bmap btree owner swap support
Message-ID: <20131031144739.GG22359@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-8-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 03:30:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For CRC enabled filesystems, we can't just swap inode forks from one
> inode to another when defragmenting a file - the blocks in the inode
> fork bmap btree contain pointers back to the owner inode. Hence if
> we are to swap the inode forks we have to atomically modify every
> block in the btree during the transaction.
> 
> This patch brings across the kernel code for doing the owner
> swap of an entire fork - something that we are likely to end up
> needing in xfs_repair when reparenting stray inodes to lost+found -
> without all the associated swap extents transaction and recovery
> cruft as those parts are not needed in userspace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
