Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 814BA7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 06:38:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B3998F8033
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 04:38:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dxVi5YhdS5LEuMvQ for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 04:38:52 -0800 (PST)
Date: Fri, 28 Feb 2014 13:38:47 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
	range
In-Reply-To: <20140227193533.GB30131@dastard>
Message-ID: <alpine.LFD.2.00.1402281324580.2231@localhost.localdomain>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-6-git-send-email-lczerner@redhat.com>
	<20140225205349.GD13647@dastard>
	<alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
	<20140225215011.GF13647@dastard>
	<alpine.LFD.2.00.1402261520070.2243@localhost.localdomain>
	<20140226220106.GC29907@dastard>
	<alpine.LFD.2.00.1402271257590.2247@localhost.localdomain>
	<20140227193533.GB30131@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1662510946-1393591129=:2231"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1662510946-1393591129=:2231
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 28 Feb 2014, Dave Chinner wrote:

> Date: Fri, 28 Feb 2014 06:35:33 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
>     range
> 
> On Thu, Feb 27, 2014 at 01:03:09PM +0100, Lukáš Czerner wrote:
> > On Thu, 27 Feb 2014, Dave Chinner wrote:
> > > > xfs/242 fails on ppc64 with latest linus tree
> > > 
> > > OK, that's a different kettle of fish. It's using 64k pages, right?
> > 
> > 64k pages, yes.
> ....
> > > Yeah, ok, the data in all the files is correct - the md5sums all
> > > match. What's different? Just about all unwritten extents are now
> > > written (i.e. data) or contain some portion of written extents.
> > > 
> > > So, ZERO_RANGE has the following size threshold for converting
> > > blocks to unwritten extents vs just zeroing them:
> > > 
> > > 	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
> > > 
> > > So if this is a 64k page size machine, it's going to have different
> > > extent layout compared to a 4k page size machine. The file data will
> > > still be the same, the difference will be zeroed blocks instead of
> > > unwritten blocks, and that's exactly what we see.
> > > 
> > > IOWs, the result in terms of data the application sees is correct,
> > > just the extent layout representing that zeroed data is different.
> > 
> > Ok, so that's yet another difference between xfs and ext4 code which
> > makes having generic test even more complicated.
> 
> It actually makes the need for a generic test more important. A
> generic test should handle the differences between block/page size
> behaviours - the issue is that xfs/242 was written and tested on 4k
> page machines, not 64k page machines.
> 
> We've already got the "multiple" code in _generic_test_punch to
> increase the size of the regions being worked on, so the simple fix
> here is to increase the sizes so that 64k page and 4k page behaviour
> is the same and results in the same extent layout. This is the
> normal way tests evolve as people run them on different hardware and
> configurations....
> 
> > So as I said before
> > I'll make the generic test (using _filter_hole_fiemap) and then ext4
> > specific test as well to really make sure that the extent
> > manipulation is right.
> 
> Which ignores the fact that if you turn off zeroout on ext4 then a
> generic test can also determine that the extent manipulation is
> correct. I really don't see the need for an ext4 specific test
> here...

I disagree, you assume that there is not a problem with the zeroout
code. And if there is, then the test would not be able to catch
that. And yes, bug in the zeroout code might affect zero range as
well even though we do not normally do zeroout on zero range except
block unaligned edges of the range.

Also ext4 does not need different testing for different page sizes.
That said I usually do ppc64 testing to test the operations with
granularity smaller than page size (sub page size zero out etc..).
With your proposal this goes away because we would actually test the
operation on larger extents - that's not helpful at all.

-Lukas

> 
> Cheers,
> 
> Dave.
> 
--8323328-1662510946-1393591129=:2231
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1662510946-1393591129=:2231--
