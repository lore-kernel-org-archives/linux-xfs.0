Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 464077CB4
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 06:48:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F01498F8035
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 04:48:49 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tGikPyH6Rwa08fXH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 04:48:47 -0800 (PST)
Date: Tue, 1 Mar 2016 04:48:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: update icsb freeblocks counter after extent
	deletion
Message-ID: <20160301124847.GA3540@infradead.org>
References: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
	<1456756170-51248-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456756170-51248-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 29, 2016 at 09:29:29AM -0500, Brian Foster wrote:
> xfs_bunmapi() currently updates the icsb fdblocks counter, unreserves
> quota, etc. before the extent is deleted by xfs_bmap_del_extent(). The
> function has problems dividing up the indirect reserved blocks for
> scenarios where a single delalloc extent is split in two. Particularly,
> there aren't always enough blocks reserved for multiple extents in a
> single extent reservation.
> 
> The solution to this problem is to allow the extent removal code to
> steal from the deleted extent to meet indirect reservation requirements.
> Move the block of code in xfs_bmapi() that updates the icsb fdblocks
> counter to after the call to xfs_bmap_del_extent() to allow the codepath
> to update the extent record before the free blocks are accounted. Also,
> reshuffle the code slightly so the delalloc accounting occurs near the
> xfs_bmap_del_extent() call to provide context for the comments.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
