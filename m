Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8EECB7F53
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 09:06:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C641304053
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 07:06:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id gNqpTpdMR3UXZdBq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 07:06:49 -0700 (PDT)
Date: Wed, 12 Jun 2013 07:06:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 24/27] xfs: move xfs_bmap_punch_delalloc() to xfs_aops.c
Message-ID: <20130612140649.GC28988@infradead.org>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-25-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371032567-21772-25-git-send-email-david@fromorbit.com>
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

On Wed, Jun 12, 2013 at 08:22:44PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is only used in that file, and delayed allocation is only used
> in the kernel. Hence it has to be removed from xfs_bmap.c in
> userspace, so to minimise the differences between kernel and
> userspace, move this function out of xfs_bmap.c.

Why not call it just xfs_punch_delalloc_range?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
