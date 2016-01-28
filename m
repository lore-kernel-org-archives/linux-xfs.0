Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D31DE7CA2
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 14:54:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C43688F804B
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 12:54:05 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id lRp4oI4Gv7LEGvKk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 12:54:03 -0800 (PST)
Date: Thu, 28 Jan 2016 12:53:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160128205333.GF20038@birch.djwong.org>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160128131656.GB14876@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jan 28, 2016 at 05:16:56AM -0800, Christoph Hellwig wrote:
> Any chance to get a review for this?  It should really help
> with sorting out the buffered I/O COW code.

It looks reasonable to me.  I separated the dio and buffered CoW remap paths a
couple of weeks ago, because it seems that IO errors only get passed back as a
return value from __blockdev_direct_IO, therefore the remapping has to be done
from xfs_vm_do_dio anyway because we don't want to remap if the write fails.
Just yesterday I removed the "is_cow" flag from the ioend, so now we're back to
having a separate XFS_IO_COW ioend type.

So... reflink doesn't need the patch but OTOH directio doesn't really need 
the overhead of allocating an ioend anyway. :)

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
