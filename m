Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98E427F99
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 09:49:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26556AC009
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 07:49:12 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Duuu5COSoCj7xpPi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 07:49:11 -0700 (PDT)
Date: Thu, 31 Oct 2013 07:49:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/30] xfs: remove newlines from strings passed to
	__xfs_printk
Message-ID: <20131031144910.GK22359@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-12-git-send-email-david@fromorbit.com>
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

On Wed, Oct 30, 2013 at 03:31:02PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> __xfs_printk adds its own "\n".  Having it in the original string
> leads to unintentional blank lines from these messages.
> 
> Ported from kernel commit 08e96e1a.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
