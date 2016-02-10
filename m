Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C2047CA3
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 03:05:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2D498F8049
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 01:05:09 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JbFvocT3OyUh2c9g (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 01:05:06 -0800 (PST)
Date: Wed, 10 Feb 2016 01:05:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8 v4] xfs: get rid of xfs_cluster_write
Message-ID: <20160210090506.GA1508@infradead.org>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455094043-9694-1-git-send-email-david@fromorbit.com>
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

Seems like only 4 patches made it through..

On Wed, Feb 10, 2016 at 07:47:15PM +1100, Dave Chinner wrote:
> 
> Hi folks,
> 
> This is the 4th version of this series to followup on review
> comments from Brian and Christoph. There are three new patches in
> this series. Patch 2/8 is split out from patch 3/8 to document the
> removal of the ioend cancelling code, spearate from the introduction
> of the writepage context. Patches 7 and 8 are new patches (as in the
> first time I've posted them) to demonstrate how to remove the IO
> completion dependency on recording the bufferehads attached to the
> ioend. This is the first step in removing bufferheads from the
> writepage IO path - these are FYI patches, not patches I want to
> have committed immediately.
> 
> The changes all run through xfstests on 4k and 1k block size
> filesystems fine, and I think i addressed all the review comments.
> Patch 6/8 changed enough that I removed Brian's reviewed-by from it
> and so it will need to be looked at completely again.
> 
> -Dave.
> 
> Version 4:
> - split xfs_ioend_cancel removal into it's own patch (patch 2)
> - cleaned up submission of ioends to be consistent w.r.t. success
>   and error paths (patch 3)
> - made variables names less verbose (patch 6)
> - got rid of xfs_writepage_submit() (patch 6)
> - use a struct list_head for ioend chaining (patch 6)
> - consolidated ioend submission paths to use common code (patch 6)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
