Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 692F17CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 20:06:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 490FB8F8064
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 18:06:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	q87Ll7VMP2LSOsyH for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 18:06:33 -0700 (PDT)
Date: Thu, 21 Mar 2013 12:06:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: add a new test case for ext4 indirect-based
	file
Message-ID: <20130321010630.GG17758@dastard>
References: <1363683183-7392-1-git-send-email-wenqing.lz@taobao.com>
	<51489267.7080202@sandeen.net> <20130320054555.GB4017@gmail.com>
	<51494B26.6020204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51494B26.6020204@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Wed, Mar 20, 2013 at 12:37:42AM -0500, Eric Sandeen wrote:
> On 3/20/13 12:45 AM, Zheng Liu wrote:
> >>> +f6aeca13ec49e5b266cd1c913cd726e3
> >>> > > +	12. unwritten -> data -> unwritten
> >> > 
> >> > It's a little odd that the output contains "unwritten" when this test
> >> > is explicitly for testing *without* unwritten extents.  Should this be
> >> > cleaned up a little in common.punch, maybe?
> > I will try to define a new function called _test_indirect_punch() to
> > test punching hole without unwritten extent.
> 
> It's just the helper which prints "unwritten" regardless of what
> is passed as "$alloc_cmd" to _test_generic_punch, right... so there's
> nothing wrong with the test, really - it's just odd output.
> 
> I'm not sure it's worth a big copy & paste just to change
> the output text, but if you can think of something simple to clean
> it up, it might be worth it.

No, definitely not worth duplicating code. In fact, seeing as it's
just informational output, I'd be inclined to ignore it as it's
never going to cause the test to fail.

This is one of the reasons I tend not to like these "pretty output"
lines in the actual test output. If you need more verbose
information for debugging, that's what $seq.full is for....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
