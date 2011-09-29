Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8TEB40h196402 for <xfs@oss.sgi.com>; Thu, 29 Sep 2011 09:11:04 -0500
Subject: Re: [PATCH 1/5] xfsprogs: libxcmd: don't clobber fs_table on realloc()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110929005946.GA26863@infradead.org>
References: <1317207432-8464-1-git-send-email-aelder@sgi.com>
	<08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
	<20110929005946.GA26863@infradead.org>
Date: Thu, 29 Sep 2011 09:10:55 -0500
Message-ID: <1317305455.3049.2.camel@doink>
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

On Wed, 2011-09-28 at 20:59 -0400, Christoph Hellwig wrote:
> On Wed, Sep 28, 2011 at 05:57:08AM -0500, Alex Elder wrote:
> > In fs_table_insert(), realloc() is called to resize the global
> > fs_table.  If it fails, it overwrites a previously valid fs_table
> > pointer with NULL.
> > 
> > Instead, assign the return value to a local temporary and overwrite
> > fs_table only if the realloc() call succeeds.  The only defined
> > errno value for a realloc() failure is ENOMEM, so return that
> > explicitly in the event it fails.
> 
> Looks good.  Did you encounter this issue in real life?

No, just by inspection.

I'm working on fixing a different problem, and to do
so I need to rearrange things a bit.  Along the way
I found a bunch of little annoyances like this one,
so I figured I might as well fix them while I'm in
there.
  
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks a lot for the reviews.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
