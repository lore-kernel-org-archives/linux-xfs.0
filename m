Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 487437F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 19:50:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 296858F8035
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 17:50:30 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bBUdECfPomlpI4zN for <xfs@oss.sgi.com>;
	Fri, 22 Feb 2013 17:50:28 -0800 (PST)
Date: Sat, 23 Feb 2013 12:50:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 0/6] speculative preallocation quota throttling
Message-ID: <20130223015015.GH26081@dastard>
References: <1361373019-30891-1-git-send-email-bfoster@redhat.com>
	<5127D060.5050806@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5127D060.5050806@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Feb 22, 2013 at 02:09:04PM -0600, Mark Tinguely wrote:
> 
> 	-- since I am being a grouch ... ---
> I wish I had caught in the review for commit a1e16c26 that
> xfs_iomap_eof_prealloc_initial_size() is returning an int rather
> than xfs_fsblock_t for consistency.

Which is a bug, not an inconsistency. It means that alloc_blocks may
not return the right thing at the 2^31/2^32 FSB boundary.

Don't grouch like you can't possibly fix it, just send a patch. :P
The code isn't upstream yet, so we've got the entire 3.9-rc cycle to
fix it... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
