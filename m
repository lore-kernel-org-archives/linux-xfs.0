Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFKkX6p027607 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 14:46:33 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	K4zByu1W7MlyGvoj for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 12:48:37 -0800 (PST)
Date: Fri, 16 Nov 2012 07:48:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/32 V2] xfs: verify dquot blocks as they are read from
	disk
Message-ID: <20121115204830.GG14281@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-18-git-send-email-david@fromorbit.com>
	<20121114065013.GE1710@dastard> <50A52CA3.3060604@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A52CA3.3060604@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 15, 2012 at 11:55:47AM -0600, Mark Tinguely wrote:
> On 11/14/12 00:50, Dave Chinner wrote:
> >xfs: verify dquot blocks as they are read from disk
> >
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Add a dquot buffer verify callback function and pass it into the
> >buffer read functions. This checks all the dquots in a buffer, but
> >cannot completely verify the dquot ids are correct. Also, errors
> >cannot be repaired, so an additional function is added to repair bad
> >dquots in the buffer if such an error is detected in a context where
> >repair is allowed.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >Reviewed-by: Phil White<pwhite@sgi.com>
> >---
> >V2: quotacheck wasn't verifying dquots as they were read from disk
> >
> 
> FYI:
> 
> The xfs_quota program does not generate output with V2 which causes
> xfstest 050 to fails.

I don't think that has anything to do with this patch orthechange
for V2 - V2 only changes quotacheck behaviour, and that doesn't
impact xfs_quota behaviour. The test passes just fine here:

$ sudo ./check 050
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-2 3.7.0-rc5-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

050 14s ... 15s
Ran: 050
Passed all 1 tests

So perhaps there's something else going wrong on your machine?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
