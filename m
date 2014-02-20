Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E7A17FBA
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 15:39:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCB70AC009
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 13:39:48 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sU8O1mmHD0YH1gpP for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 13:39:46 -0800 (PST)
Date: Fri, 21 Feb 2014 08:39:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] libxfs: contiguous buffers are not discontigous
Message-ID: <20140220213943.GP4916@dastard>
References: <1392875722-4390-1-git-send-email-david@fromorbit.com>
	<1392875722-4390-2-git-send-email-david@fromorbit.com>
	<5306521A.8010207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5306521A.8010207@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 01:06:02PM -0600, Eric Sandeen wrote:
> On 2/19/14, 11:55 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When discontiguous directory buffer support was fixed in xfs_repair,
> > (dd9093d xfs_repair: fix discontiguous directory block support)
> > it changed to using libxfs_getbuf_map() to support mapping
> > discontiguous blocks, and the prefetch code special cased such
> > discontiguous buffers.
> > 
> > The issue is that libxfs_getbuf_map() marks all buffers, even
> > contiguous ones - as LIBXFS_B_DISCONTIG, and so the prefetch code
> > was treating every buffer as discontiguous. This causes the prefetch
> > code to completely bypass the large IO optimisations for dense areas
> > of metadata. Because there was no obvious change in performance or
> > IO patterns, this wasn't noticed during performance testing.
> > 
> > However, this change mysteriously fixed a regression in xfs/033 in
> > the v3.2.0-alpha release, and this change in behaviour was
> > discovered as part of triaging why it "fixed" the regression.
> > Anyway, restoring the large IO prefetch optimisation results
> > a reapiron a 10 million inode filesystem dropping from 197s to 173s,
> > and the peak IOPS rate in phase 3 dropping from 25,000 to roughly
> > 2,000 by trading off a bandwidth increase of roughly 100% (i.e.
> > 200MB/s to 400MB/s). Phase 4 saw similar changes in IO profile and
> > speed increases.
> > 
> > This, however, re-introduces the regression in xfs/033, which will
> > now be fixed in a separate patch.
> 
> Thanks for finding this.  I was getting close.  ;)
> 
> It seems fine, although a little unexpected; why do we ever
> create a map of 1?  It feels a little odd to call getbuf_map
> with only 1 item, and then short-circuit it.  Should this
> be something more obvious in the callers?

Because we have application code that is building buffer maps from
extent maps, and so having a API for both
contigous and discontiguous buffers makes sense. That's the way we
do it in the kernel - everything now uses the _map paths - but the
userspace code is a much larger surface area to change over and so
it's only being done in the places that matter first...

> Wel, I guess it's pretty much consistent w/ the same behavior
> in libxfs_readbuf_map()... *shrug*

Right. And like I said, it's also how the kernel does stuff, which
is why the libxfs_readbuf_map code functions like it does. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
