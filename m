Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4P5ekmW228822 for <xfs@oss.sgi.com>; Tue, 25 May 2010 00:40:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E7EC1DF9DC8
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 22:43:06 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	yrdHxAjBmIrRfyUq for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 22:43:06 -0700 (PDT)
Date: Tue, 25 May 2010 15:42:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: convert more trace events to DEFINE_EVENT
Message-ID: <20100525054254.GG12087@dastard>
References: <4BFA3815.7070000@cn.fujitsu.com>
	<1274758614.22648.205.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274758614.22648.205.camel@gandalf.stny.rr.com>
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
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Dave Chinner <dchinner@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Mon, May 24, 2010 at 11:36:54PM -0400, Steven Rostedt wrote:
> On Mon, 2010-05-24 at 16:25 +0800, Li Zefan wrote:
> > Use DECLARE_EVENT_CLASS, and save ~15K:
> > 
> >    text    data     bss     dec     hex filename
> >  171949   43028      48  215025   347f1 fs/xfs/linux-2.6/xfs_trace.o.orig
> >  156521   43028      36  199585   30ba1 fs/xfs/linux-2.6/xfs_trace.o
> > 
> > No change in functionality.
> > 
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

I'll get this pushed through the XFS tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
