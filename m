Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8F197F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 04:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D4F658F8065
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 02:32:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VubJqkPjIj07cice for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 02:32:27 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UXTNz-0008E5-NG
	for xfs@oss.sgi.com; Wed, 01 May 2013 19:31:39 +1000
Date: Wed, 1 May 2013 19:31:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfstests: various fixes
Message-ID: <20130501093139.GN10481@dastard>
References: <1367397123-2530-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367397123-2530-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Wed, May 01, 2013 at 06:31:58PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> These are various fixes for xfstests.
> 
> The first patch is an infrastructure regression fix, resulting from
> the patchset that split up the tests into subdirectories. It also
> moves all the check.* output files to the result directory rather
> than leaving them in the root directory of xfstests.
> 
> The second is a bunch of changes to generic/310 that should have
> been done in the review cycle. It now works reliably for me.
> 
> The last 3 patches fix bugs in tests that result in files being left
> in the root directory of xfstests.

FWIW, with the V2 xfsprogs kernel sync tarball I've posted and these
fixes to xfstests, I'm down to only 3 failures in xfstests for 4k
block size filesystem tests:

Failures: generic/233 shared/298 xfs/296

generic/233 appears to be a small quota accounting mismatch,
probably related to speculative preallocation. Not a major issue.

shared/298 is failing due to the ENOSPC problem Eric posted patches
to fix. Test bug.

xfs/296 is failing due to an unresolved xfsdump issue w.r.t
restoring security attributes. Unresolved.

So, I'm much happier now about the state of xfsprogs and xfstests
than I was this morning.  I'll be happier still when I fix the fsx
failures on 512 byte block size filesystems, because that will bring
my 512 byte block size filesystem tests to close to the same level.
That's for tomorrow, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
