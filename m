Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7FB87F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 19:42:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95FDC8F8059
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 17:42:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fqRsKM3oVHzPFaiE for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 17:42:17 -0700 (PDT)
Date: Thu, 30 May 2013 10:42:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130530004215.GD29466@dastard>
References: <20130517104529.GA12490@luxor.wired.org>
	<20130519011354.GE6495@dastard>
	<20130520170710.GA2591@luxor.wired.org>
	<20130521000208.GF24543@dastard>
	<20130523143456.GB19815@luxor.wired.org>
	<20130529135641.GB4889@luxor.wired.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130529135641.GB4889@luxor.wired.org>
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
To: Paolo Pisati <p.pisati@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, May 29, 2013 at 03:56:41PM +0200, Paolo Pisati wrote:
> On Thu, May 23, 2013 at 04:34:56PM +0200, Paolo Pisati wrote:
> > On Tue, May 21, 2013 at 10:02:09AM +1000, Dave Chinner wrote:
> > > 
> > > And that fix I mentioned will be useless if you don't apply the
> > > patch that avoids the vmap allocation problem....
> > 
> > 
> > ok, so i recompiled a kernel+aforementioend fix, i repartitioned my disk and i
> > ran the swift-bench for 2 days in a row until i got this:
> 
> i'm testing a 3.5.y kernel plus those 3 patches:
> 
> 549142a xfs: don't use speculative prealloc for small files
> f0843f4 xfs: limit speculative prealloc size on sparse files
> 454da09 xfs: inode allocation should use unmapped buffers.
> 
> and i can confirm that:
> 
> -using a small fs (2G) i cannot reproduce any -ENOSPC or vmalloc() problem
> anymore, the benchmark runs until running out of inodes 
> 
> -using a bigger fs (~250G), two days and my tests are still running good

Ok, good to know. The first patch you list there hasn't even been
reviewed yet, so it might take some time before that is ready for
-stable backport.

Also, there are a bunch of fixes needed to the second patch you have
there (f0843f4 xfs: limit speculative prealloc...) that would also
be necessary for a -stable backport. i.e:

e8108ce xfs: fix xfs_iomap_eof_prealloc_initial_size type
e114b5f xfs: increase prealloc size to double that of the previous extent
e78c420 xfs: fix potential infinite loop in xfs_iomap_prealloc_size()

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
