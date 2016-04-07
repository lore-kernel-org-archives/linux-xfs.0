Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F5BB7CAF
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:48:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF7E08F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:48:58 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bq461arUwtseM2Ht (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 16:48:38 -0700 (PDT)
Date: Thu, 7 Apr 2016 16:48:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/259: handle minimum block size more precisely
Message-ID: <20160407234837.GA1439@infradead.org>
References: <1460027155-4222-1-git-send-email-eguan@redhat.com>
	<20160407213231.GD761@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160407213231.GD761@dastard>
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
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 08, 2016 at 07:32:31AM +1000, Dave Chinner wrote:
> > diff --git a/tests/xfs/259 b/tests/xfs/259
> > index 16c1935..3150ff3 100755
> > --- a/tests/xfs/259
> > +++ b/tests/xfs/259
> > @@ -51,9 +51,7 @@ testfile=$TEST_DIR/259.image
> >  # Test various sizes slightly less than 4 TB. Need to handle different
> >  # minimum block sizes for CRC enabled filesystems, but use a small log so we
> >  # don't write lots of zeros unnecessarily.
> > -xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.mkfs > /dev/null
> > -. $tmp.mkfs
> 
> This tests the configuration of the test device, which is not
> controlled by the test harness, so can be different to the
> configuration being used for the scratch device.
> 
> > -if [ $_fs_has_crcs -eq 1 ]; then
> > +if [ $XFS_MKFS_CRC_DEFAULT -eq 1 ]; then
> 
> IOWs, this is not an not equivalent test.

And I think that's the whole point of this change :)

Previously it tested what the TEST_DIR did, which was wrong for this
test.  Now it tests what mkfs does by default (including for the scratch
dev), which is what we really want here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
