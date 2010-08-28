Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7S02vJQ118061 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 19:02:57 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AF831E57292
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 17:03:33 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id WdMAySFGaJgCrbs1 for
	<xfs@oss.sgi.com>; Fri, 27 Aug 2010 17:03:33 -0700 (PDT)
Message-ID: <4C785254.2020708@sandeen.net>
Date: Fri, 27 Aug 2010 19:03:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Test to ensure that the EOFBLOCK_FL gets
	set/unset	correctly.
References: <1282941224-5805-1-git-send-email-alal@google.com>
	<20100827233216.GJ705@dastard>
In-Reply-To: <20100827233216.GJ705@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Akshay Lal <alal@google.com>

Dave Chinner wrote:

> I'm not sure this really is a generic test - it's testing an ext4
> specific bug. We've got other generic tests that exercise fallocate,
> and some filesystems (like XFS) don't have special bits to say there
> are extents beyond EOF and checking a filesystem repeated won't
> report any problems.  So perhaps if should be '_supported_fs ext4'


Oops we're giving conflicting advice :)  I thought a test that
exercises blocks-past-eof-filling at various boundaries made
sense in general, even if the specific regression test is ext4-specific.

Seems like at least ocfs2/btrfs might benefit from the basic exercise,
so I was recommending that it be generic.

I don't think there is any other test that makes a point of
allocating X blocks past eof and then filling them exactly,
overwriting/extending past them, etc.  Seems like a good addition
in general.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
