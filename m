Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0969A7CA1
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 21:10:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCC3030404E
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 19:10:28 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gypo3B2g7vRcPHhH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2016 19:10:26 -0700 (PDT)
Date: Wed, 28 Sep 2016 19:09:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block devices
Message-ID: <20160929020953.GV14092@birch.djwong.org>
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
	<147510959149.8940.2897845352082568677.stgit@birch.djwong.org>
	<62c7d047-166c-75e0-5b00-f2bfdcf03cb1@sandisk.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <62c7d047-166c-75e0-5b00-f2bfdcf03cb1@sandisk.com>
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
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org

On Wed, Sep 28, 2016 at 06:42:14PM -0700, Bart Van Assche wrote:
> On 09/28/16 17:39, Darrick J. Wong wrote:
> >+	if (end > isize) {
> >+		if (mode & FALLOC_FL_KEEP_SIZE) {
> >+			len = isize - start;
> >+			end = start + len - 1;
> >+		} else
> >+			return -EINVAL;
> >+	}
> 
> If FALLOC_FL_KEEP_SIZE has been set and end == isize the above code won't
> reduce end to isize - 1. Shouldn't "end > isize" be changed into "end >=
> isize" ?

Oops.  Will fix and send out a v2.

> >+	switch (mode) {
> >+	case FALLOC_FL_ZERO_RANGE:
> >+	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
> >+		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
> >+					    GFP_KERNEL, false);
> >+		if (error)
> >+			return error;
> >+		break;
> >+	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
> >+		/* Only punch if the device can do zeroing discard. */
> >+		if (!blk_queue_discard(q) || !q->limits.discard_zeroes_data)
> >+			return -EOPNOTSUPP;
> >+		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
> >+					     GFP_KERNEL, 0);
> >+		if (error)
> >+			return error;
> >+		break;
> >+	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
> >+		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
> >+					     GFP_KERNEL, 0);
> >+		if (error)
> >+			return error;
> >+		break;
> >+	default:
> >+		return -EOPNOTSUPP;
> >+	}
> 
> Have you considered to move "if (error) return error" out of the switch
> statement?

Sure, I could do that.

> >+	/*
> >+	 * Invalidate again; if someone wandered in and dirtied a page,
> >+	 * the caller will be given -EBUSY;
> >+	 */
> >+	return invalidate_inode_pages2_range(mapping,
> >+					     start >> PAGE_SHIFT,
> >+					     end >> PAGE_SHIFT);
> 
> A comment might be appropriate here that since end is inclusive and since
> the third argument of invalidate_inode_pages2_range() is inclusive that
> rounding down will yield the correct result.

/methot the documentation of invalidate_inode_pages2_range was clear
enough on that point, but I could throw that into the comment too.

--D
> 
> Bart.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
