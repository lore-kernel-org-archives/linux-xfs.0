Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DLIrOC223140 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 16:18:53 -0500
Date: Thu, 13 Sep 2012 16:19:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfs: stop the sync worker before xfs_unmountfs
Message-ID: <20120913211957.GT3274@sgi.com>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com> <20120830223504.GE15292@dastard>
	<5040FF25.1010501@sgi.com> <20120901230824.GB6896@infradead.org>
	<20120912183347.GO3274@sgi.com>
	<20120913081742.GA23181@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120913081742.GA23181@infradead.org>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Sep 13, 2012 at 04:17:42AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 12, 2012 at 01:33:47PM -0500, Ben Myers wrote:
> > See what you think of this.  Not heavily tested yet, and not pretty... but it
> > is fairly minimal. 
> > 
> > Pull startup and shutdown of the sync worker out of xfs_syncd_init and
> > xfs_syncd_stop into their callers.  In the case of unmount, move shutdown of
> > the xfs_sync_worker before teardown of the log in xfs_unmountfs.  This prevents
> > occasional crashes on unmount like so:
> > 
> > PID: 21602  TASK: ee9df060  CPU: 0   COMMAND: "kworker/0:3"                                                                                                                               
> >  #0 [c5377d28] crash_kexec at c0292c94                                                                                                                                                    
> 
> Can you remove the trailing whitespaces in these lines?  They make
> reading the changelog on a normal 80 character wide terminal pretty
> hard.

Yeah.  Sorry about that.  Cleaned up.

> The changes look fine to me,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,
	Ben


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
