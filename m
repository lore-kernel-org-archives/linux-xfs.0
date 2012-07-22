Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6M5TXZP101880 for <xfs@oss.sgi.com>; Sun, 22 Jul 2012 00:29:33 -0500
Message-ID: <500B8FAA.8030804@oracle.com>
Date: Sun, 22 Jul 2012 13:29:14 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4] xfs: probe data buffer from page cache for unwritten
	extents
References: <50091696.4000903@oracle.com> <5009A786.3080500@sgi.com>
	<500A4B24.40908@oracle.com> <20120722045703.GA17235@infradead.org>
In-Reply-To: <20120722045703.GA17235@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hi Christoph,

On 07/22/2012 12:57 PM, Christoph Hellwig wrote:
> On Sat, Jul 21, 2012 at 02:24:36PM +0800, Jie Liu wrote:
>>> Output:
>>>
>>> HOLE/DATA at 512K 786432 / 528384   <- undiscovered hole here
>>> HOLE/DATA at 516K 786432 / 528384   <- okay, data but we should
>>>                                         return next page as hole.
>>> HOLE/DATA at 520K 532480 / 819200   <- hole is discovered because
>>>                                        there is no trailing data
>> Oops! for xfs_seek_hole(), I should use min_t() to pre-claculate
>> offset before searching page cache.
>> Thanks for your prompt feedback.  I'll do some extra tests and post
>> the revised soon.
> Yes, the above test cases should go into xfstests.
Should we keep 285 unchanged and introduce a new test 28? which is 
dedicated to ensuring the refinements works as expected?
I have added some new test cases to Mark's test program yesterday, looks 
it will grow even bigger if I can think out some other
corner cases(will send them to Mark).

Thanks,
-Jeff
>
> Thanks to both of you to spend all the effort on this feature.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
