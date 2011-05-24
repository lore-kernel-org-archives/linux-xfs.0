Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O1p9rD038383 for <xfs@oss.sgi.com>; Mon, 23 May 2011 20:51:10 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C815416567E3
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 18:51:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GoepvCiLLntkZZ64 for <xfs@oss.sgi.com>;
	Mon, 23 May 2011 18:51:07 -0700 (PDT)
Date: Tue, 24 May 2011 11:51:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests:Make 225 compare map and fiemap at each block.
Message-ID: <20110524015105.GE32466@dastard>
References: <1306134423-10028-1-git-send-email-xiaoqiangnk@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1306134423-10028-1-git-send-email-xiaoqiangnk@gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, josef@redhat.com, xfs@oss.sgi.com

On Mon, May 23, 2011 at 03:07:03PM +0800, Yongqiang Yang wrote:
> Due to my carelessness,  I induced a ugly patch to ext4's fiemap, as a result
> delayed-extents that did not start at the head block of a page was ignored
> in ext4 with 1K block, but 225 could not find it. 

When ext4 is using 1k block sizes, fiemap-tester does not find
problems that may exist on ext4 with delayed allocation extents on
the first block of a page.

> So I looked into the 225
> and could not figure out logic in compare_map_and_fiemap(), which seemed to
> mix extents with blocks.

Once again, "I don't understand it" is not a reason for a whoelsale
rewrite.

> Then I made 225 compare map and fiemap at each block,
> the new 225 can find the bug I induced and another bug in ext4 with 1k block,
> which ignored delayed-extents after a hole, which did not start at the head
> block of a page.

Which means that the first paragraph should read:

"When ext4 is using 1k block sizes, fiemap-tester does not find
problems that may exist on ext4 with delayed allocation extents on
the first block of a page or directly after a hole."

That's a concise description of the overall problem you are fixing
in this patch. Next you need to describe the different changes being
made in the patch and the bugs they are fixing.  There appear to be:

	- an off-by one in map array allocation
	- zeroing the end block in the map array
	- making check_weird_fs_hole() verify bytes read by pread()
	- moving truncate/seek of the test file around
	- changing the way map/fiemap are compared

Also, you haven't addressed any of the comments I made in my
original review:

	- removing the changelog from the header comment
	- adding comments on check_data/check_hole explaining what
	  they are checking
	- explaining why the existing map/fiemap compare couldn't
	  detect the problems with delayed extents on ext4? i.e.
	  what's the bug that you are fixing so we can determine if
	  it really does need a rewrite to fix?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
