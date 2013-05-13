Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 224B97F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 19:44:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B00A304032
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 17:44:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eW8PKdRzlaq1DBek for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 17:44:41 -0700 (PDT)
Date: Mon, 13 May 2013 10:44:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfstests: add a new test case for ext4 indirect-based
	file
Message-ID: <20130513004439.GJ32675@dastard>
References: <1368358464-11173-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368358464-11173-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Rich Johnston <rjohnston@sgi.com>, Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sun, May 12, 2013 at 07:34:24PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After applied this commit (864688d3), xfstests #255 will not test a
> file system that cannot support fallocate(2), such as a indirect-based
> file in ext4.  So we need to add a new generic test case to test it.
> 
> The difference between #255 and this test case is only to use pwrite to
> allocate blocks.  Other filesystems should survive in this test case.
> In the mean time, a new argument '-u' is added into _test_generic_punch
> not to run unwritten tests.
> 
> Meanwhile this commit fixes a minor problem in #255 that testfile should
> use $seq.$$ as testfile.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Rich Johnston <rjohnston@sgi.com>

This will need to be rebased on top of Eric's patch that removes the
need to pass -F to xfs_io for non-xfs filesystems....

> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -114,3 +114,4 @@
>  309 auto quick
>  310 auto
>  311 auto metadata log
> +314 auto quick prealloc

Why would you add it to the prealloc group? The whole point of the
test is that it doesn't use prealloc, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
