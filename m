Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C06847CBF
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 00:31:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80D00304048
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 22:31:20 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OLN3TZAeSP9yT9rv for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 22:31:13 -0800 (PST)
Date: Mon, 21 Dec 2015 17:31:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] reflink: more tests
Message-ID: <20151221063111.GO19802@dastard>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
	<20151219091131.15320.12391.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219091131.15320.12391.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Sat, Dec 19, 2015 at 01:11:31AM -0800, Darrick J. Wong wrote:
> Add more tests for unaligned copy-on-write things, and explicitly
> test the ability to pass "len == 0" to mean reflink/dedupe all
> the way to the end of the file".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> +_cleanup()
> +{
> +    cd /
> +    rm -rf "$tmp".* "$TESTDIR"
> +}
.....
> +
> +TESTDIR="$TEST_DIR/test-$seq"
> +rm -rf "$TESTDIR"
> +mkdir "$TESTDIR"

This use of TESTDIR is highly confusing. When I see TESTDIR I think
that it's the mount point of the test device, not potentially some
directory on the scratch device.

I see that this occurs through lots of tests, not just these new
ones. Can you do a pass across the tests with, say, sed and rename
all these to something less confusing? e.g. "testdir", in lower
case, makes it clear that it's a local variable, not the global test
device mount point.... (i.e. test local variables are lower case,
exported test harnes variables are upper case ;)

Separate patch/pull req is fine.

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
