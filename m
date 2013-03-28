Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0756F7F52
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 19:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95E5CAC011
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 17:35:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Db905fequ3cROxJE for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 17:35:49 -0700 (PDT)
Date: Thu, 28 Mar 2013 11:35:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130328003547.GX6369@dastard>
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
	<20130327205407.GU6369@dastard> <20130327214804.GA28143@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327214804.GA28143@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Rich Johnston <rjohnston@sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 27, 2013 at 05:48:04PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 28, 2013 at 07:54:07AM +1100, Dave Chinner wrote:
> > 
> > Support for named tests have not yet been added. From the check
> > script:
> > 
> > SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
> 
> Ah, I thought support for named tests was there.  For right now,
> though, if we have test ext4/123 and btrfs/123, that's OK and they are
> considered separate tests, right?  Or do we still need to keep the
> numbers unique for now?

Test numbers within a subdir are unique. So yes, ext4/123 and
btrfs/123 are recognised as different tests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
