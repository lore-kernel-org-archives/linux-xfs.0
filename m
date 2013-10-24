Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA1B17F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 10:42:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 662A9AC005
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 08:42:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id CRoCZjrqtuW04GgY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 08:42:22 -0700 (PDT)
Date: Thu, 24 Oct 2013 08:42:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131024154220.GA19055@infradead.org>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
	<20131024084803.GA28144@infradead.org>
	<20131024103751.GS2797@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024103751.GS2797@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 09:37:51PM +1100, Dave Chinner wrote:
> Sure, if you want to. But doing that shouldn't prevent this fix from
> being committed in the mean time, especially as other filesystems
> already use this method for avoiding these problems.

I'd much prefer aiming for the proper fix first.  If for some reason we
can't get it done in time the workaround can be applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
