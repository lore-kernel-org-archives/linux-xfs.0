Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAH7Pocq023508 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 01:25:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 949C925DD55
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 23:25:45 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1f0Mh3PE0ncHjiNr for <xfs@oss.sgi.com>;
	Wed, 16 Nov 2011 23:25:45 -0800 (PST)
Date: Thu, 17 Nov 2011 02:25:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111117072543.GA3733@infradead.org>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.686729205@bombadil.infradead.org>
	<20111116232430.GB7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111116232430.GB7046@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 17, 2011 at 10:24:30AM +1100, Dave Chinner wrote:
> Don't need the undef here anymore as the #define is in the header
> file and not local to the function.

I'll fix it up.

> Can't say I'm a great fan of this - making the workqueue code use
> kstrdup() would be a much better better solution, IMO, just like was
> done a while for the SLAB cache names to solve exactly the same
> problem....

Tejun has a patch to make the name argument to alloc_workqueue both
dynamically allocated and varags format.  That'll fix it, but we can't
rely on it yet.  I will switch over to it later in the 3.3 cycle.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
