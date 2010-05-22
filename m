Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4M06vKH038106 for <xfs@oss.sgi.com>; Fri, 21 May 2010 19:06:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC005365512
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 17:09:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	301Cqt3vzE1aqJsx for <xfs@oss.sgi.com>;
	Fri, 21 May 2010 17:09:16 -0700 (PDT)
Date: Sat, 22 May 2010 10:09:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] writeback: tracing and wbc->nr_to_write fixes
Message-ID: <20100522000913.GZ8120@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<20100521150504.GA4598@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100521150504.GA4598@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, May 21, 2010 at 11:05:04AM -0400, Christoph Hellwig wrote:
> What happened to this series?  Getting the trace events in will
> defintively help with tuning the writeback code, and we'll also need
> the nr_to_write issue fixed some way.

I've been snowed under trying to get several different things done
all at the same time, so this has slipped. I'm trying to get back to
it early next week. The nr_to_pages fix is badly needed, as that
causes severe fragmentation in XFS for the exact workloads it fixes
the severe fragmentation in ext4....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
