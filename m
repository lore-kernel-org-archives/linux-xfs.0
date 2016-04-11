Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2348D7CA1
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 19:05:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FD93AC003
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 17:04:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	q17WUd7ZIK6et1jw for <xfs@oss.sgi.com>;
	Sun, 10 Apr 2016 17:04:54 -0700 (PDT)
Date: Mon, 11 Apr 2016 10:02:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/259: handle minimum block size more precisely
Message-ID: <20160411000238.GB9088@dastard>
References: <1460027155-4222-1-git-send-email-eguan@redhat.com>
	<20160407213231.GD761@dastard>
	<20160407234837.GA1439@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160407234837.GA1439@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 07, 2016 at 04:48:37PM -0700, Christoph Hellwig wrote:
> On Fri, Apr 08, 2016 at 07:32:31AM +1000, Dave Chinner wrote:
> > > diff --git a/tests/xfs/259 b/tests/xfs/259
> > > index 16c1935..3150ff3 100755
> > > --- a/tests/xfs/259
> > > +++ b/tests/xfs/259
> > > @@ -51,9 +51,7 @@ testfile=$TEST_DIR/259.image
> > >  # Test various sizes slightly less than 4 TB. Need to handle different
> > >  # minimum block sizes for CRC enabled filesystems, but use a small log so we
> > >  # don't write lots of zeros unnecessarily.
> > > -xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.mkfs > /dev/null
> > > -. $tmp.mkfs
> > 
> > This tests the configuration of the test device, which is not
> > controlled by the test harness, so can be different to the
> > configuration being used for the scratch device.
> > 
> > > -if [ $_fs_has_crcs -eq 1 ]; then
> > > +if [ $XFS_MKFS_CRC_DEFAULT -eq 1 ]; then
> > 
> > IOWs, this is not an not equivalent test.
> 
> And I think that's the whole point of this change :)
> 
> Previously it tested what the TEST_DIR did, which was wrong for this
> test.  Now it tests what mkfs does by default (including for the scratch
> dev), which is what we really want here.

Which is not at all clear from the patch description.

Seriously, though, this does not belong in common/config. We already
have a helper function to check what mkfs supports (i.e.
 _scratch_mkfs_xfs_supported()), and if we just want a bare check
then factor this into a _mkfs_xfs_supported() and supply the
parameters specific to the test.

Indeed, this is basically what we do with _require_xfs_mkfs_crc();
the same thing should be done, but without the "notrun" if -m crc
s not supported...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
