Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 221FC7CA1
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 14:29:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6B73304048
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 12:29:53 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CrJF1QYQPMg7mhzq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2016 12:29:49 -0700 (PDT)
Date: Tue, 27 Sep 2016 12:29:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 58/71] xfs: garbage collect old cowextsz reservations
Message-ID: <20160927192919.GK14092@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216829394.867.16281333542262043955.stgit@birch.djwong.org>
	<20160924194234.GA1878@infradead.org>
	<20160926215209.GE14092@birch.djwong.org>
	<20160927185021.GA8623@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160927185021.GA8623@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 27, 2016 at 11:50:21AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 26, 2016 at 02:52:09PM -0700, Darrick J. Wong wrote:
> > The two functions /could/ be merged but I'm hesitant to combine them
> > because they run as different workqueue items.
> > 
> > Setting speculative_cow_prealloc_lifetime to a (much) higher value than
> > speculative_prealloc_lifetime has been useful for combatting CoW
> > fragmentation on VM hosts where the VMs experience bursty write
> > behaviors and we can keep the utilization ratios low enough that we
> > don't start to run out of space.  IOWs, it benefits us to keep the CoW
> > fork reservations around for as long as we can unless we run out of
> > blocks or hit inode reclaim.
> 
> Ok, so there is a good use case for it.  It just felt to me like
> there was a little bit too much duplication, that's why I asked.

I'll add a brief explanation of this to the patch changelog to
record the justification.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
