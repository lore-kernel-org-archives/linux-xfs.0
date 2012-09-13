Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D8Gd8d115752 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 03:16:39 -0500
Date: Thu, 13 Sep 2012 04:17:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: stop the sync worker before xfs_unmountfs
Message-ID: <20120913081742.GA23181@infradead.org>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com> <20120830223504.GE15292@dastard>
	<5040FF25.1010501@sgi.com> <20120901230824.GB6896@infradead.org>
	<20120912183347.GO3274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120912183347.GO3274@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Sep 12, 2012 at 01:33:47PM -0500, Ben Myers wrote:
> See what you think of this.  Not heavily tested yet, and not pretty... but it
> is fairly minimal. 
> 
> Pull startup and shutdown of the sync worker out of xfs_syncd_init and
> xfs_syncd_stop into their callers.  In the case of unmount, move shutdown of
> the xfs_sync_worker before teardown of the log in xfs_unmountfs.  This prevents
> occasional crashes on unmount like so:
> 
> PID: 21602  TASK: ee9df060  CPU: 0   COMMAND: "kworker/0:3"                                                                                                                               
>  #0 [c5377d28] crash_kexec at c0292c94                                                                                                                                                    

Can you remove the trailing whitespaces in these lines?  They make
reading the changelog on a normal 80 character wide terminal pretty
hard.

The changes look fine to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
