Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA2G0kJF034693 for <xfs@oss.sgi.com>; Tue, 2 Nov 2010 11:00:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FD79145E5E
	for <xfs@oss.sgi.com>; Tue,  2 Nov 2010 09:02:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WlPwMXwpr7yQnNsU for
	<xfs@oss.sgi.com>; Tue, 02 Nov 2010 09:02:09 -0700 (PDT)
Date: Tue, 2 Nov 2010 12:02:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.32] scheduling while atomic
Message-ID: <20101102160201.GA924@infradead.org>
References: <4CCED8B2.2030604@nangu.tv>
 <20101102001244.GP2715@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101102001244.GP2715@dastard>
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
Cc: Martin Hamrle <martin.hamrle@nangu.tv>, xfs@oss.sgi.com

On Tue, Nov 02, 2010 at 11:12:44AM +1100, Dave Chinner wrote:
> With a trace like that, it's almost certain that you've blown
> the stack and that is why the system is crashing. Can you turn on
> stack depth checking (might require a kernel rebuild) so we can tell
> if these problems are a result of overruning the stack?

Even better move on to a recent kernel - we're now preventing the
VM from reentering the filesystem for reclaim, which should take
care of all practical stack overlfow issues.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
