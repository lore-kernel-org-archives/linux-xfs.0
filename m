Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA70D7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:32:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DB21AC003
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:32:19 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id G8wp4cyJAau9uXJN (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 10:32:11 -0700 (PDT)
Date: Thu, 5 May 2016 13:32:08 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1926435280.1998700.1462469528484.JavaMail.zimbra@redhat.com>
In-Reply-To: <1462310947-16132-3-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
	<1462310947-16132-3-git-send-email-hch@lst.de>
Subject: Re: [PATCH 02/14] fs: introduce iomap infrastructure
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

----- Original Message -----
> Add infrastructure for multipage buffered writes.  This is implemented
> using an main iterator that applies an actor function to a range that
> can be written.
> 
> This infrastucture is used to implement a buffered write helper, one
> to zero file ranges and one to implement the ->page_mkwrite VM
> operations.  All of them borrow a fair amount of code from fs/buffers.
> for now by using an internal version of __block_write_begin that
> gets passed an iomap and builds the corresponding buffer head.
> 
> The file system is gets a set of paired ->iomap_begin and ->iomap_end
> calls which allow it to map/reserve a range and get a notification
> once the write code is finished with it.
> 
> Based on earlier code from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> +		/*
> +		 * For unwritten regions, we always need to ensure that
> +		 * sub-block writes cause the regions in the block we are not
> +		 * writing to are zeroed. Set the buffer as new to ensre this.

Minor typo: s/ensre/ensure/ above.

Reviewed-off-by: Bob Peterson <rpeterso@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
