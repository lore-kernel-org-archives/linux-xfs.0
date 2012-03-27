Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RG3Ep6108459 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:03:14 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	81QEBuPQFaePuNwV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:03:04 -0700 (PDT)
Date: Tue, 27 Mar 2012 12:03:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120327160300.GA22555@infradead.org>
References: <1332841605-3538-1-git-send-email-david@fromorbit.com>
	<20120327143127.GA11434@infradead.org>
	<20120327155759.GB28707@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327155759.GB28707@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 27, 2012 at 11:57:59AM -0400, Vivek Goyal wrote:
> On Tue, Mar 27, 2012 at 10:31:27AM -0400, Christoph Hellwig wrote:
> > Vivek, does CFQ still need any hints for this sort of handoff?
> > 
> 
> Christoph, I don't understand the issue enough to comment on it.
> 
> Had a quick look at the patch. Looks like some action (writing log), has
> been moved to a worker thread.  And in some cases (log force triggered
> flush, whatever it is), we seem to prefer to do it from the submitter's
> context.

Yes.  This is to workaround the old problem of cfq getting utterly
confused if cooperating I/O beeing submitted from different threads.

The case in the previous version of this patch was:

 - thread doing the fsync will write out data, and wait for it
 - then we'd force the log by kicking a workqueue and waiting for it

quite similar to the ext3/4 fsync issues that we had long discussions
about.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
