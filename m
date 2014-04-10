Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1DBE7F87
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:33:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73F6AAC001
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:33:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id yhYpO5eQD0VDjvAD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 05:33:33 -0700 (PDT)
Date: Thu, 10 Apr 2014 05:33:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: zeroing space needs to punch delalloc blocks
Message-ID: <20140410123332.GA15577@infradead.org>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
	<1397106053-7489-5-git-send-email-david@fromorbit.com>
	<20140410104001.GG17641@infradead.org>
	<20140410122259.GC27519@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410122259.GC27519@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 10:22:59PM +1000, Dave Chinner wrote:
> XFS_B_TO_FSB gives the same result given that we've already rounded
> start_boundary to block granularity....

It does, but XFS_B_TO_FSBT is one less operation, and it's the better
example for a start offset when people start copy & pasting it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
