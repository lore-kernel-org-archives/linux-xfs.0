Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AA617F37
	for <xfs@oss.sgi.com>; Fri, 25 Jan 2013 18:47:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B6B84AC008
	for <xfs@oss.sgi.com>; Fri, 25 Jan 2013 16:47:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mHwQZGTR7ictYBHW for <xfs@oss.sgi.com>;
	Fri, 25 Jan 2013 16:47:11 -0800 (PST)
Date: Sat, 26 Jan 2013 11:47:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole
	feature in fallocate
Message-ID: <20130126004707.GG2667@dastard>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
	<1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
	<20130125033201.GD28908@thunk.org>
	<20130125035912.GA15806@gmail.com>
	<20130125042122.GG28908@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130125042122.GG28908@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

[cc xfs@oss.sgi.com]

On Thu, Jan 24, 2013 at 11:21:22PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 25, 2013 at 11:59:12AM +0800, Zheng Liu wrote:
> > 
> > I wonder that maybe we need to submit a patch to let xfstest understand
> > that a filesystem supports extents or not because after applied this
> > patch indirect-based file in ext4 has supported seek_data/hole and hole
> > punching.  I usually run xfstest automatically, and every time I need
> > to check the result of #255 and #285 manually.  That is annoying for me.
> 
> I would think the right thing to do is to have xfstests make sure it
> understands that fallocate working with FALLOC_FL_PUNCH_HOLE does not
> imply that fallocate without the FALLOC_FL_PUNCH_HOLE flag OR'ed in
> will work.

We already have this capabiity in xfstests via
_require_xfs_io_falloc_punch and _require_xfs_io_falloc. That,
however,  doesn't mean the tests that use these calls do the correct
requirement checks. That's the problem with 255 - it doesn't call
_require_xfs_io_falloc.

As to 285, the seek_sanity_test does it's own check for seek
hole/data support, and error out if it fails. This needs to be
turned into an equivalent _require_seek_hole_data (e.g. by running
"seek_sanity_test -t" to test for support) and 285 needs to the call
the _require_seek_hole_data before running the test proper.

Please send patches to xfs@oss.sgi.com....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
