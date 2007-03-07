Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Mar 2007 04:40:40 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l27CeZ6p011221
	for <xfs@oss.sgi.com>; Wed, 7 Mar 2007 04:40:36 -0800
Date: Wed, 7 Mar 2007 13:38:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: stop using kmalloc in xfs_buf_get_noaddr
Message-ID: <20070307123824.GA3996@lst.de>
References: <20070307101324.GC30587@lst.de> <45EEACA0.4050206@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EEACA0.4050206@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org, linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 05:44:24PM +0530, Shailendra Tripathi wrote:
> Hi Christoph,
> 	     Did you do some testing for recovery when end of the physical 
> 	     log is seen ?

I ran xfsqa over it, which should catch this case.

> 	     When you will be dealing with striped ICLOG buffers or big 
> 	     sized ICLOGs, header size might range from 512 to 2k. Also, this header 
> might be split into 2 parts at the end of physical log. Then, you don't 
> have page size buffer. Please verify that XFS_BUF_SETP_PTRs work correctly 
> for those cases.
> 	 Same thing is true when data section is split around physical log. 
> 	 You can get one part which is not PAGE sized. 	

I should have made my wording more clear, we always do PAGE_SIZE +
buffer allocations.  After XFS_BUF_SETP_PTR the actually used buffer
might be smaller.  I tested XFS_BUF_SETP_PTR manually with
artifical test code aswell, and made sure it still works.
Long term I have a plan to replace XFS_BUF_SETP_PTR with better
schemes, but that's irrelevant for this patch.
