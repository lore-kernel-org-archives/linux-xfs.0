Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F99E7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:42:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59B4730404E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:42:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wJLgwg9CFJBDlilt for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:41:58 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:41:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/9] repair: ensure prefetched buffers have CRCs validated
Message-ID: <20140416004145.GB15995@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-4-git-send-email-david@fromorbit.com>
	<20140415194000.GB3470@laptop.bfoster>
	<20140415214642.GN15995@dastard>
	<20140415220559.GE3470@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140415220559.GE3470@laptop.bfoster>
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

On Tue, Apr 15, 2014 at 06:06:00PM -0400, Brian Foster wrote:
> On Wed, Apr 16, 2014 at 07:46:42AM +1000, Dave Chinner wrote:
> > On Tue, Apr 15, 2014 at 03:40:00PM -0400, Brian Foster wrote:
> > > Should we always expect an unchecked buffer to be read with an ops
> > > vector before being written? Even if so, this might look cleaner if we
> > > didn't encode the possibility of running a read verifier on a dirty
> > > buffer. I presume that would always fail as the crc is updated in the
> > > write verifier.
> > 
> > It should fail, and that's a good thing because writing to an
> > unchecked buffer would indicate that we didn't validate it properly
> > in the first place. Hence I thought that doing it this way leaves
> > a canary that traps other problem usage with unchecked buffers.
> > 
> > Realistically, we shouldn't be writing unchecked buffers - prefetch
> > doesn't touch buffers, it just does IO, and so someone else has to
> > read the buffers before they can be dirtied. If it's read without an
> > ops structure then modified and read again with an ops structure,
> > we'll catch it...
> > 
> 
> Ah, I see. That sounds good, but a small comment there with the
> reasoning to allow a read verifier to run on a dirty buffer would be
> nice. :)

Ok, I'll add one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
