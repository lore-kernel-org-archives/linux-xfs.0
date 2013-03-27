Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DA847F54
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:11:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1CF0DAC012
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:11:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ckH2H1sKLPbYZm8W for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 14:11:04 -0700 (PDT)
Date: Thu, 28 Mar 2013 08:02:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327210236.GV6369@dastard>
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
	<5153217B.5070909@sgi.com> <20130327190512.GA22889@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327190512.GA22889@thunk.org>
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

On Wed, Mar 27, 2013 at 03:05:12PM -0400, Theodore Ts'o wrote:
> What do you think about renaming the existing tests from NNN to
> NNN-descriptive-name?  That way it will be easier for people who are
> trying to track regressions, since they can easily map from the new
> more descriptive name to the old test number for comparison purposes
> (i.e., to see whether a failure is a regression or not, etc.)

When named test support is done, then we could do this.

> Would you be open to changes which did this?  I'd suggest sending the
> changes as a shell script to minimize the chances of patch conflicts.
> It will cause people to need to regenerate their patches, but that
> means now would be the time to do this, when everyone will need to be
> fixing up their outstanding changes anyway.  :-)

There's more than just the rename of the file. group files have to
change, there's the possibility that the group list and test list
handling will need to be completely rewritten, the way test names
are output will need work, the result summaries will need to be
reformatted to be legible, etc.

So it's not just a case of renaming a file - there's still quite a
lot of infrastructure work needed before we can start using names
rather then sequence numbers for tests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
