Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 517537F37
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 03:18:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0C88AC001
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 01:18:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id FseVXnroaR4DAJAw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 01:18:39 -0700 (PDT)
Date: Thu, 1 Aug 2013 01:18:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 43/49] xfs: return log item size in IOP_SIZE
Message-ID: <20130801081838.GA18711@infradead.org>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-44-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374215120-7271-44-git-send-email-david@fromorbit.com>
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

On Fri, Jul 19, 2013 at 04:25:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To begin optimising the CIL commit process, we need to have IOP_SIZE
> return both the number of vectors and the size of the data pointed
> to by the vectors. This enables us to calculate the size ofthe
> memory allocation needed before the formatting step and reduces the
> number of memory allocations per item by one.
> 
> WhIle there, kill the IOP_SIZE macro.

Instead of killing a single of those here add a patch earlier in the
series that kills all IO_* macros.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
