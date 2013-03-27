Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7FC187F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 16:11:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6EF8230408C
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 14:11:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yNy7yyO6TaaeF0DD for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 14:11:02 -0700 (PDT)
Date: Thu, 28 Mar 2013 07:54:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327205407.GU6369@dastard>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327134606.GJ5861@thunk.org>
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

On Wed, Mar 27, 2013 at 09:46:06AM -0400, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 08:23:07AM -0500, Rich Johnston wrote:
> > All xfstest developers,
> > 
> > Thanks again for all your time in submitting and reviewing patches
> > for xfstests.  The latest patchset posted here:
> > 
> > http://oss.sgi.com/archives/xfs/2013-03/msg00467.html
> > 
> > requires all current patches to be re-factored.
> 
> Given that we are now segregating patches into subdirectories, is it
> correct in the future tests should be named descriptively, instead of
> using 3 digit NNN numbers (which has been a major pain from a central
> assignment perspective)?

Support for named tests have not yet been added. From the check
script:

SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
