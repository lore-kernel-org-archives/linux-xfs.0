Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B4E529DF9
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 11:32:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58EFC304039
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 09:32:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id v24mO20GE8iJFlyw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 09:31:59 -0800 (PST)
Date: Wed, 20 Nov 2013 09:31:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't perform discard if the given range length is
	less than block size
Message-ID: <20131120173157.GA31744@infradead.org>
References: <528C6E15.3030801@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528C6E15.3030801@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Nov 20, 2013 at 04:08:53PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> For discard operation, we should return EINVAL if the given range length
> is less than a block size, otherwise it will go through the file system
> to discard data blocks as the end range might be evaluated to -1, e.g,
> # fstrim -v -o 0 -l 100 /xfs7
> /xfs7: 9811378176 bytes were trimmed
> 
> This issue can be triggered via xfstests/generic/288.

Thanks for catching this.

> Also, it seems to get the request queue pointer via bdev_get_queue()
> instead of the hard code pointer dereference is not a bad thing.

I don't think bdev_get_queue is overly useful, but if there's not
other comments on that patch feel free to change it.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
