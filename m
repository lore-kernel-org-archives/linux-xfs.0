Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBbQJN206057 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:37:26 -0500
Date: Sun, 24 Jul 2011 07:37:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] xfs: Remove the macro XFS_BUFTARG_NAME
Message-ID: <20110724113724.GC26332@infradead.org>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003408.21069.44409.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311364181.2771.114.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311364181.2771.114.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 02:49:41PM -0500, Alex Elder wrote:
> On Thu, 2011-07-21 at 17:34 -0700, Chandra Seetharaman wrote:
> > Remove the definition and usages of the macro XFS_BUFTARG_NAME.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
> Wow, I hadn't looked at the definition of
> xfs_buf_target_name() before.  It's not safe
> (using a pointer to since-released stack space),
> though in practice it's going to be fine.
> 
> Defining it as an inline function with a static
> buffer would at least avoid that, though it
> means it's not reentrant either.

IMHO the right fix is to just kill it off entirely.  All XFS messages
now have the filesystem name prefixed to them, and while we can have
up to three devices, all these error messages can only hit either
the main or the log device, and it's obvious from the context which
one we did hit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
