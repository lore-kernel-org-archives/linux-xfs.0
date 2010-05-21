Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LF4Lrw013681 for <xfs@oss.sgi.com>; Fri, 21 May 2010 10:04:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7E3A1DF621C
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 08:06:41 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id BADdIozhpa0ro98v for <xfs@oss.sgi.com>;
	Fri, 21 May 2010 08:06:41 -0700 (PDT)
Date: Fri, 21 May 2010 11:06:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] writeback: initial tracing support
Message-ID: <20100521150640.GB4598@infradead.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271731314-5893-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 20, 2010 at 12:41:51PM +1000, Dave Chinner wrote:
> From: From: Jens Axboe <jens.axboe@oracle.com>
> 
> Trace queue/sched/exec parts of the writeback loop.

If you move the CREATE_TRACE_POINTS into fs-writeback.c and include
<trace/events/writeback.h> after the sturcture defintions there's no
need to move them to a header.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
