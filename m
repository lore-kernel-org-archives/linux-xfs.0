Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57A9B7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:47:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B769304059
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:47:35 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WQQAxyTqWzKST9Ny for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 21:47:32 -0800 (PST)
Date: Wed, 13 Jan 2016 16:47:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: check on-disk structure sizes
Message-ID: <20160113054730.GQ10456@dastard>
References: <20160111234644.GB7831@birch.djwong.org>
	<20160112140122.GC12156@bfoster.bfoster>
	<20160113012945.GC2455@birch.djwong.org>
	<5695C01F.7030807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5695C01F.7030807@sandeen.net>
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

On Tue, Jan 12, 2016 at 09:10:23PM -0600, Eric Sandeen wrote:
> 
> 
> On 1/12/16 7:29 PM, Darrick J. Wong wrote:
> > On Tue, Jan 12, 2016 at 09:01:22AM -0500, Brian Foster wrote:
> >> On Mon, Jan 11, 2016 at 03:46:44PM -0800, Darrick J. Wong wrote:
> >>> Check on-disk structure sizes against known values.
> >>> Use this to catch inadvertent changes in structure size due to padding
> >>> and alignment issues, etc.
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> ---
> >>
> >> What's the need for this in userspace? Not a big deal really, but it
> >> seems like it serves the fundamental purpose sufficiently in the kernel.
> > 
> > The primary point is to make sure that we didn't make any errors with the
> > on-disk structures when porting libxfs changes.  The kernel build is the first
> > line of defense since it tends to big get changes first, but I figure a
> > defensive build check for xfsprogs won't harm anyone...
> 
> Does it need to actually be in the code?
> 
> $ pahole -s fs/xfs/xfs.ko | grep -w "xfs_dsb\|xfs_agf\|xfs_agi\|xfs_agfl"
> xfs_agf	224	0
> xfs_agfl	40	0
> xfs_agi	336	0
> xfs_dsb	264	0
> 
> pahole needs a binary w/ debuginfo, but maybe this could just be hooked up
> in the Makefiles?

As I've pointed out previously to Darrick: xfstests:/tests/xfs/122

Make that build again, update it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
