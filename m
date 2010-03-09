Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o29Bkogl136131 for <xfs@oss.sgi.com>; Tue, 9 Mar 2010 05:46:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3020514094ED
	for <xfs@oss.sgi.com>; Tue,  9 Mar 2010 03:48:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	uK0KAyljwybdafPG for <xfs@oss.sgi.com>;
	Tue, 09 Mar 2010 03:48:21 -0800 (PST)
Date: Tue, 9 Mar 2010 22:48:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9] Log and transaction cleanups, factoring and bug fixes
Message-ID: <20100309114818.GN28189@discord.disaster>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<20100309113919.GA5479@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100309113919.GA5479@infradead.org>
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

On Tue, Mar 09, 2010 at 06:39:19AM -0500, Christoph Hellwig wrote:
> With the whole series (and my posted cleanups) applied I get the
> following XFSQA 113 failure (and a similar one before):
> 
> [ 2064.763171] Assertion failed: xfs_lic_are_all_free(licp), file: fs/xfs/xfs_trans.c, line: 1432

Yeah, that's a bogus assert. I found it yesterday on test 113 ;)

The issue is that test 113 is the first QA test that is
semi-reliably creating a transaction with more than one chunk of log
item descriptors. The original assert was:

	ASSERT(!xfs_lic_are_all_free(licp));

before it called xfs_trans_chunk_committed() and ran the commit
processing on all the items in the chunk. It then freed the chunk.
This makes sense - there should be items in the chunk being freed.

I made the bogus assumption when cleaning up the code that after
committed processing on all the items that all the items in the
chunk would be marked as freed. However, nothing cleans up the log
item descriptors in the committed item processing, so the items in
the chunk are all still marked as used.

The fix is to either remove the assert or invert the condition....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
