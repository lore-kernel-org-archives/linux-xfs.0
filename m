Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 629097F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 19:29:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EADAFAC002
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 17:29:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZduODMvw3ELZjlAW for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 17:29:45 -0700 (PDT)
Date: Mon, 14 Apr 2014 10:29:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic: add fallocate() checks to generic/300
Message-ID: <20140414002942.GD27694@dastard>
References: <20140411214307.GC10174@wallace>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140411214307.GC10174@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 11, 2014 at 05:43:07PM -0400, Eric Whitney wrote:
> Generic/300 fails when run on a test filesystem that does not support
> fallocate(). It uses fio's falloc ioengine to generate part of its I/O
> load and both allocates blocks and punches holes.  This causes EOPNOTSUPP
> failures when the test is run on indirect block-mapped ext4 filesystems
> or pre-3.14 ext4 filesystems created with bigalloc.
> 
> Verify that the test filesystem supports fallocate() before proceeding
> with the test, checking for both block allocation and hole punching
> capabilities.  Also, delete any pre-existing test output.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Makes sense. Same for the second patch, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
