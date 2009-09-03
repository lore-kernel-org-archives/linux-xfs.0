Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n83KuB4a131539 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 15:56:21 -0500
Received: from goalpost.americas.sgi.com (goalpost.americas.sgi.com
	[128.162.232.54])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E36E58F8049
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 13:57:08 -0700 (PDT)
Date: Thu, 3 Sep 2009 15:49:40 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 00/14] repair memory usage reductions
Message-ID: <20090903204940.GB24510@sgi.com>
References: <20090902175531.469184575@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090902175531.469184575@bombadil.infradead.org>
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

On Wed, Sep 02, 2009 at 01:55:31PM -0400, Christoph Hellwig wrote:
| This is a respin of the patches Barry Naujok wrote at SGI for reducing
| the memory usage in repair.  I've split it up, fixed a few small bugs
| and added two preparatory cleanups - but all the real work is Barry's.
| There has been lots of heavy testing on large filesystems by Barry
| on the original patches, and quite a lot of testing on slightly smaller
| filesystems by me.  These were all ad-hoc tests as XFSQA coverage is
| rather low on repair.  My plan is to add various additional testcase
| for XFSQA both for intentional corruptions as well as reproducing past
| reported bugs before we'll release these patches in xfsprogs.  But I think
| it would be good if we could get them into the development git tree to
| get wider coverage already.

How do these changes affect xfs_repair I/O performance?  Barry changes
were previously withheld within SGI due to a regression in performance.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
