Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QMd3m1146152 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 17:39:03 -0500
Subject: Re: [PATCH 1/3] xfs: flag all buffers as metadata
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110726150644.GA18000@infradead.org>
References: <20110726150633.GA17400@infradead.org>
	<20110726150644.GA18000@infradead.org>
Date: Tue, 26 Jul 2011 17:38:55 -0500
Message-ID: <1311719935.11557.12.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2011-07-26 at 11:06 -0400, Christoph Hellwig wrote: 
> Now that REQ_META bios aren't treated specially in the CFQ I/O schedule
> anymore, we can tag all buffers as metadata to make blktrace traces more
> meaningful.  Note that we use buffers also to zero out partial blocks
> in the preallocation / hole punching code, and while they operate on
> data blocks the zeros written certainly aren't data.  I think this case
> is borderline metadata enough to not bother special casing it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good.  I plan to re-base the xfs master branch
after 3.1-rc1 is out, so I'll wait until after that to
commit this (and the others in this series).

If you want me to do something different, let me know.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
