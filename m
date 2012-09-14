Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8E16VdZ246047 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 20:06:31 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ah0GB5GSQCrVBrOs for <xfs@oss.sgi.com>;
	Thu, 13 Sep 2012 18:07:37 -0700 (PDT)
Date: Fri, 14 Sep 2012 11:07:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: stop the sync worker before xfs_unmountfs
Message-ID: <20120914010729.GQ11511@dastard>
References: <20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com> <20120830223504.GE15292@dastard>
	<5040FF25.1010501@sgi.com> <20120901230824.GB6896@infradead.org>
	<20120912183347.GO3274@sgi.com> <20120912231406.GJ11511@dastard>
	<20120913164344.GV25175@sgi.com> <20120913211847.GS3274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120913211847.GS3274@sgi.com>
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

On Thu, Sep 13, 2012 at 04:18:47PM -0500, Ben Myers wrote:
> Cancel work of the xfs_sync_worker before teardown of the log in
> xfs_unmountfs.  This prevents occasional crashes on unmount like so:

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
