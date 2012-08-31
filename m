Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7VNU1AE251121 for <xfs@oss.sgi.com>; Fri, 31 Aug 2012 18:30:01 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gNF3e7bsrnFgb5vb for <xfs@oss.sgi.com>;
	Fri, 31 Aug 2012 16:30:55 -0700 (PDT)
Date: Sat, 1 Sep 2012 09:30:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfstests: rename USE_BIG_LOOPFS to be more generic
Message-ID: <20120831233051.GE13691@dastard>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
	<1343291989-14987-3-git-send-email-david@fromorbit.com>
	<503CCF3F.5050608@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <503CCF3F.5050608@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 28, 2012 at 09:01:35AM -0500, Rich Johnston wrote:
> On 07/26/2012 03:39 AM, Dave Chinner wrote:
> >From: Dave Chinner <dchinner@redhat.com>
> >
> >USE_BIG_LOOPFS is really misnamed - it can be used on real devices just as
> >easily as loop devices. It really means we are testing a large scratch device
> >and that we should enable the special filesystem filling and checking options
> >that enable xfstests to be run sanely on large XFS filesystems.
> >
> >Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >---
> >  004       |    2 +-
> >  015       |    2 +-
> >  030       |    2 +-
> >  031       |    2 +-
> >  032       |    2 +-
> >  033       |    4 ++--
> >  041       |    2 +-
> >  049       |    2 +-
> >  083       |    2 +-
> >  092       |    2 +-
> >  148       |    2 +-
> >  149       |    2 +-
> >  common    |    2 +-
> >  common.rc |   12 ++++++------
> >  setup     |    5 +++--
> >  15 files changed, 23 insertions(+), 22 deletions(-)
> >
> 
> >  MOUNT_OPTIONS="$MOUNT_OPTIONS -o inode64"
> >  _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
> >diff --git a/148 b/148
> >index 76cbf37..7bb1722 100755
> >--- a/148
> >+++ b/148
> >@@ -66,8 +66,8 @@ _check_ag()
> >  _supported_fs xfs
> >  _supported_os IRIX Linux
> 
> #RCJ As long as you are making changes to this file, please remove
> Linux from the _supported_os as xfs_prepair64 is an IRIX specific
> binary.

Such a change belongs in a separate patch, not intermingled with a
patch in a series that has nothing to do with xfs_prepair64....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
