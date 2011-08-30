Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U7ATjA119726 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 02:10:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 681DD124E2B
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 00:10:28 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Zz2zb36MmhttefdA for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 00:10:28 -0700 (PDT)
Date: Tue, 30 Aug 2011 03:10:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS metadata flushing design - current and future
Message-ID: <20110830071027.GA9566@infradead.org>
References: <20110827080321.GA16661@infradead.org>
	<20110829010149.GE3162@dastard>
	<20110829123318.GA12928@infradead.org>
	<20110830012820.GI3162@dastard>
	<20110830050959.GA8667@infradead.org>
	<20110830070641.GR3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830070641.GR3162@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 30, 2011 at 05:06:42PM +1000, Dave Chinner wrote:
> 
> The advantage of using our own list is that we can still then sort
> them (might be thousands of buffers we queue in a single pass)
> before submitting them for IO.  The on-stack plugging doesn't allow
> this at all, IIUC, as itis really just a FIFO list above the IO
> scheduler queues....

The on-stack plugging already sorts - manually in that code for the
request queues (not interesting for us), and currently by block number
as well using the elevator.  But the current code is more of a
guideline, I have some fairly big changes for the that area of block
layer in the pipeline.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
