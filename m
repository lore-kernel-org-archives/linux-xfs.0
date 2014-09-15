Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5327B7F4E
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2014 17:55:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F4E08F8068
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2014 15:55:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uB2AwDjotk8E6hcu for <xfs@oss.sgi.com>;
	Mon, 15 Sep 2014 15:55:39 -0700 (PDT)
Date: Tue, 16 Sep 2014 08:55:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/5] clean up collapse range and handle post-eof
	delalloc
Message-ID: <20140915225535.GF4267@dastard>
References: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
	<20140911044243.GA10111@dastard>
	<20140911152012.GB54638@bfoster.bfoster>
	<20140911211915.GA4322@dastard>
	<20140912195128.GA42029@bfoster.bfoster>
	<20140912200536.GB42029@bfoster.bfoster>
	<20140915014654.GD4267@dastard>
	<20140915131822.GA4143@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140915131822.GA4143@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2014 at 09:18:22AM -0400, Brian Foster wrote:
> On Mon, Sep 15, 2014 at 11:46:54AM +1000, Dave Chinner wrote:
> > xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > XFS has been having trouble with stray delayed allocation extents
> > beyond EOF for a long time. Recent changes to the collapse range
> > code has triggered erroneous EBUSY errors on page invalidtion for
> > block size smaller than page size filesystems. These
> > have been caused by dirty buffers beyond EOF on a partial page which
> > do not get written to disk during a sync.
> > 
> > The issue is that write-ahead in xfs_cluster_write() finds such a
> > partial page and handles it by leaving the page dirty but pushing it
> > into a writeback state. This used to work just fine, as the
> > write_cache_pages() code would then find the dirty partial page in
> > the next mapping tree lookup as the dirty tag is still set.
> > 
> > Unfortunately, when we moved to a mark and sweep approach to
> > writeback to fix other writeback sync issues, we broken this. THe
> > act of marking the page as under writeback now clears the TOWRITE
> > tag in the radix tree, even though the page is still dirty. This
> > causes the TOWRITE tag to be cleared, and hence the next lookup on
> > the mapping tree does not find the dirty partial page and so doesn't
> > try to write it again.
> > 
> > This same writeback bug was found recently in ext4 and fixed in
> > commit 1c8349a ("ext4: fix data integrity sync in ordered mode")
> > without communication to the wider filesystem community. We can use
> > exactly the same fix here so the TOWRITE flag is not cleared on
> > partial page writes.
> > 
> > cc: stable@vger.kernel.org # dependent on 1c8349a17137b93f0a83f276c764a6df1b9a116e
> > Root-cause-found-by: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Looks good and fixes the collapse failure in my test.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> I suppose we should prepend the collapse rework series with this patch
> to avoid the regression as it pertains to collapse (obviously the
> failure to retain towrite goes further back).

Agreed, I will do that.

> I'll continue testing with this. Are you still seeing an increase in
> such failures with the xfs_free_file_space() patch or has this quieted
> those down?

To early to sayi for sure, but signs are good - I've had xfstests
actually complete without any stray delalloc asserts occurring on
1k block size filesystems for the first time in a couple of weeks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
