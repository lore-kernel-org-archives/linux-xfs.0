Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 738967F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:47:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4370A8F8033
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 11:47:23 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id tAFFWHZItvdqmJ34 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 11:47:21 -0800 (PST)
Date: Mon, 4 Jan 2016 11:47:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/11] reflink: more tests
Message-ID: <20160104194708.GA28357@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
	<20151219091131.15320.12391.stgit@birch.djwong.org>
	<20151221063111.GO19802@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151221063111.GO19802@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Dec 21, 2015 at 05:31:11PM +1100, Dave Chinner wrote:
> On Sat, Dec 19, 2015 at 01:11:31AM -0800, Darrick J. Wong wrote:
> > Add more tests for unaligned copy-on-write things, and explicitly
> > test the ability to pass "len == 0" to mean reflink/dedupe all
> > the way to the end of the file".
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf "$tmp".* "$TESTDIR"
> > +}
> .....
> > +
> > +TESTDIR="$TEST_DIR/test-$seq"
> > +rm -rf "$TESTDIR"
> > +mkdir "$TESTDIR"
> 
> This use of TESTDIR is highly confusing. When I see TESTDIR I think
> that it's the mount point of the test device, not potentially some
> directory on the scratch device.
> 
> I see that this occurs through lots of tests, not just these new
> ones. Can you do a pass across the tests with, say, sed and rename
> all these to something less confusing? e.g. "testdir", in lower
> case, makes it clear that it's a local variable, not the global test
> device mount point.... (i.e. test local variables are lower case,
> exported test harnes variables are upper case ;)
> 
> Separate patch/pull req is fine.

No problem.  Will give it a spin on the test harness before sending.

(Yikes, it's a 272K patch...)

--D

> 
> Cheers,
> 
> dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
