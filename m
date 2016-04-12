Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75CCB7CA2
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:01:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 491C8304075
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 14:01:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lkC99jRn2qB0faHP for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 14:01:04 -0700 (PDT)
Date: Wed, 13 Apr 2016 07:01:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/259: handle minimum block size more precisely
Message-ID: <20160412210101.GA10643@dastard>
References: <1460027155-4222-1-git-send-email-eguan@redhat.com>
	<20160407213231.GD761@dastard>
	<20160407234837.GA1439@infradead.org>
	<20160411000238.GB9088@dastard>
	<20160411113811.GH10345@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160411113811.GH10345@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 11, 2016 at 07:38:11PM +0800, Eryu Guan wrote:
> On Mon, Apr 11, 2016 at 10:02:38AM +1000, Dave Chinner wrote:
> > Which is not at all clear from the patch description.
> > 
> > Seriously, though, this does not belong in common/config. We already
> > have a helper function to check what mkfs supports (i.e.
> >  _scratch_mkfs_xfs_supported()), and if we just want a bare check
> > then factor this into a _mkfs_xfs_supported() and supply the
> > parameters specific to the test.
> > 
> > Indeed, this is basically what we do with _require_xfs_mkfs_crc();
> > the same thing should be done, but without the "notrun" if -m crc
> > s not supported...
> 
> Looking into _require_xfs_mkfs_crc() and _scratch_mkfs_xfs_supported(),
> I noticed that they are not the helpers I want. They are testing whether
> mkfs.xfs supports CRC (or other mkfs options), what I want is what's the
> default behavior of mkfs.xfs (CRC enabled or not).

All this, just to avoid testing on an invalid block size when CRCs
are enabled. I really don't see why this needs changes to generic
infrastructure - it's a test specific problem.

How about you simply reverse the block size order that is tested,
and capture the output of the actual mkfs command that is being
tested, and determine if 512 byte block sizes should be tested
based on that output? i.e.

for b in 4096 2038 1024 512; do
	if [ $b -eq 512 -a $_fs_has_crcs -ne 1 ]; then
		break;
	fi
....
	mkfs -b $b ....
	. $tmp.mkfs
done

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
