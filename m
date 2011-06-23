Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NLLhYU217924 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 16:21:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A38211BF43E1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 14:21:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	cdxLBa6Tgl0mpKCV for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2011 14:21:42 -0700 (PDT)
Date: Thu, 23 Jun 2011 17:21:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: clear XFS_IDIRTY_RELEASE on truncate down
Message-ID: <20110623212141.GB18901@infradead.org>
References: <1308792901-22880-1-git-send-email-david@fromorbit.com>
	<1308792901-22880-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1308792901-22880-3-git-send-email-david@fromorbit.com>
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

On Thu, Jun 23, 2011 at 11:35:00AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When an inode is truncated down, speculative preallocation is
> removed from the inode. This should also reset the state bits for
> controlling whether preallocation is subsequently removed when the
> file is next closed. The flag is not being cleared, so repeated
> operations on a file that first involve a truncate (e.g. multiple
> repeated dd invocations on a file) give different file layouts for
> the second and subsequent invocations.
> 
> Fix this by clearing the XFS_IDIRTY_RELEASE state bit when the
> XFS_ITRUNCATED bit is detected in xfs_release() and hence ensure
> that speculative delalloc is removed on files that have been
> truncated down.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
