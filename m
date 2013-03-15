Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A56E27FC7
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 00:44:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 633B78F8035
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 22:44:18 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Dr5uMx2tdEote325 for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 22:44:16 -0700 (PDT)
Date: Fri, 15 Mar 2013 16:43:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfstests patches
Message-ID: <20130315054350.GC2559@dastard>
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<514205DC.9040902@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <514205DC.9040902@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 12:16:12PM -0500, Rich Johnston wrote:
> On 03/13/2013 09:57 AM, Eric Sandeen wrote:
> >2 pretty simple ones, and a new btrfs test
> >
> >[PATCH 1/3] xfstests: add 274 to the prealloc group
> >[PATCH 2/3] xfstests: keep newlines out of SCRATCH_DEV_POOL
> >[PATCH 3/3] xfstests: btrfs tests for basic informational commands
> >
> >_______________________________________________
> >xfs mailing list
> >xfs@oss.sgi.com
> >http://oss.sgi.com/mailman/listinfo/xfs
> >
> 
> This series has been committed.

Rich, can you please be careful to check the test numbers being used
in patches that are sent to the list before you commit them?

> >[PATCH 3/3] xfstests: btrfs tests for basic informational commands

This test was numbered 313, and so now we have tests 001-306 and 313
in the repository.  I noticed that Another of Eric's recent patches
is numbered 315, so it will also need renumbering before commit.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
