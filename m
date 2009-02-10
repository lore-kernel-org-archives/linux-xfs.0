Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AK1CmY072149 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 14:01:12 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 588EB304092
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 12:00:36 -0800 (PST)
Message-Id: <C670BF63-E9B0-4526-B197-8F05CE0D1563@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090210194515.812431000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 2/2] xfs: reject swapext ioctl on swapfiles
Date: Tue, 10 Feb 2009 14:00:35 -0600
References: <20090210194422.767988000@bombadil.infradead.org>
	<20090210194515.812431000@bombadil.infradead.org>
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


On Feb 10, 2009, at 1:44 PM, Christoph Hellwig wrote:

> Swapfiles are magic - I/O is directly initialized by the VM without
> involving the filesystem.  Swapping out extents underneath the VM thus
> can cause severe problems.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
