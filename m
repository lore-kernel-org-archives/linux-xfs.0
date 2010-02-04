Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14HZ6x8079462 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 11:35:07 -0600
Date: Thu, 4 Feb 2010 12:36:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: xfs_fs_write_inode() can fail to write
	inodes synchronously V2
Message-ID: <20100204173614.GA9498@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-10-git-send-email-david@fromorbit.com>
	<20100203112753.GA19996@infradead.org>
	<20100203205648.GA23116@infradead.org>
	<20100203230235.GB5332@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203230235.GB5332@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, bpm@sgi.com, xfs@oss.sgi.com

FYI I did some benchmarking on this, and the syncmodes 2 and 5 of
fs_mark, which use sys_sync regress almost 10% on my test setup
with this patch.  The barriers are only a small part of it,
from instrumentation it seems like the constant log forces don't
really help.  Now given that we only get data integrity writes
from sync_filesystem do we really need to bother with catching
all that pending I/O here?  It would be much easier to rely
on ->sync_fs to do that for us once, which is does anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
