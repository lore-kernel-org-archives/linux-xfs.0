Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OH39HA067844 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 12:03:09 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HshsSG5rpKVJ4XJU (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 10:03:03 -0700 (PDT)
Date: Sat, 24 Mar 2012 13:03:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: avoid shutdown hang in xlog_wait()
Message-ID: <20120324170302.GB21708@infradead.org>
References: <1332467263-12985-1-git-send-email-david@fromorbit.com>
	<1332467263-12985-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332467263-12985-3-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, Mar 23, 2012 at 12:47:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a shutdown is triggered from failing to find an item in the AIL
> during delete, we can be called from either metadata IO completion
> context or from log IO completion context. In the case of log IO
> completion context, we must indicate that this is a log error so
> that the forced shutdown does not attempt to flush the log.
> 
> To flush the log whilst in log IO completion will cause a deadlock
> as the shutdown won't proceed until log IO completes, and log Io
> cannot complete because it has blocked waiting for itself to
> complete....
> 
> We delete items in the AIL from log IO completion when we are
> unpinning in-memory only items, or items that do not require
> writeback to remove from the AIL (e.g. EFI/EFD items). Hence there
> are several locations that need this treatment.

Looks good.  I wonder if it might be simple to simply pass a flags
argument to xfs_ail_delete(_bulk) which tells which kind of shutdown
to do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
