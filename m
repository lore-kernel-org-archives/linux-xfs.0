Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1C4E7F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 20:28:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C526304043
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 18:28:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xHYhDE6Hf66oIX0W for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 18:28:27 -0700 (PDT)
Date: Thu, 30 May 2013 11:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] xfs: add fsgeom flag for v5 superblock support.
Message-ID: <20130530012825.GI29466@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-9-git-send-email-david@fromorbit.com>
	<51A61A55.1000306@sandeen.net> <20130529214301.GB20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130529214301.GB20028@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, May 29, 2013 at 04:43:01PM -0500, Ben Myers wrote:
> Hi Eric,
> 
> On Wed, May 29, 2013 at 10:10:13AM -0500, Eric Sandeen wrote:
> > On 5/27/13 1:38 AM, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently userspace has no way of determining that a filesystem is
> > > CRC enabled. Add a flag to the XFS_IOC_FSGEOMETRY ioctl output to
> > > indicate that the filesystem has v5 superblock support enabled.
> > > This will allow xfs_info to correctly report the state of the
> > > filesystem.
> > 
> > 
> > Looks fine,
> > 
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Ben, having this in place for for the next point release will let
> > userspace work & testing proceed w/o the need for a patched
> > kernel... if you could consider pulling it in that'd be great.
> 
> Sounds reasonable.  I'll check it out.
> 
> > Dave, just out of curiosity, most other features sort of match between
> > the "_has_*" and the flag names, is there a reason for the
> > crc <-> sbv5 difference?  Just semantics, but just curious.
> > 
> > (i.e. xfs_sb_version_hasprojid32bit checks XFS_SB_VERSION2_PROJID32BIT,
> > but xfs_sb_version_hascrc checks XFS_SB_VERSION_5)
> > 
> > Answering my own question maybe, I guess SB_VERSION_5 was conceived
> > with crc already in place, so there's no need for a feature flag on
> > top of the sb version, right...?
> 
> Seems like we're also out of space in xfs_fsop_geom.flags. 

Nowhere near it, actually ;). flags is a __u32, this is only the
16th flag.

> There may even be
> people who prefer to use v5 super blocks without crcs turned on, so maybe
> conflating the two ideas here is undesireable.

The flag is indicating that there is a different format on disk, not
that crcs are enabled or not. Userspace needs to know about that
different format, and right now *userspace* assumes v5 superblocks
mean CRCs are enabled because that's part of the definition of the
features that a v5 superblock has.

If in future that changes (hint: it won't) then we can add a
separate flag to indicate whether CRCs are enabled or not when the
feature flag to disable them is added to the superblock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
