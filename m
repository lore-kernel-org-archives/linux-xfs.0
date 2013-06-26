Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D1F97F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:50:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 770BC8F8037
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 17:50:34 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DTmySx9WH6GmZlUs for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 17:50:33 -0700 (PDT)
Date: Wed, 26 Jun 2013 10:50:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix README, FSTYP options
Message-ID: <20130626005029.GY29376@dastard>
References: <20130625153423.513e4074@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130625153423.513e4074@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 25, 2013 at 03:34:23PM -0400, Dwight Engen wrote:
> commit cbcc88fb changed test selection to use shell globs, so fixup the
> examples given in the README file.
> 
> add options for FSTYPs supported by _scratch_mkfs().

To tell the truth, I'd prefer to get rid of the -xfs/-udf/... etc
options rather than propoagate them further. We autodetect the FSTYP
just fine on Linux via blkid probing of $TEST_DEV. Hence in reality,
the only CLI option we need is for NFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
