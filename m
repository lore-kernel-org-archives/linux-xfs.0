Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 380F67F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 20:11:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 245B1304039
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 18:11:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GQOtfRDaqL6WNw4B for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 18:11:44 -0700 (PDT)
Date: Thu, 30 May 2013 11:11:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] xfs: add fsgeom flag for v5 superblock support.
Message-ID: <20130530011142.GH29466@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-9-git-send-email-david@fromorbit.com>
	<51A61A55.1000306@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A61A55.1000306@sandeen.net>
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

On Wed, May 29, 2013 at 10:10:13AM -0500, Eric Sandeen wrote:
> On 5/27/13 1:38 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently userspace has no way of determining that a filesystem is
> > CRC enabled. Add a flag to the XFS_IOC_FSGEOMETRY ioctl output to
> > indicate that the filesystem has v5 superblock support enabled.
> > This will allow xfs_info to correctly report the state of the
> > filesystem.
> 
> 
> Looks fine,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Ben, having this in place for for the next point release will let
> userspace work & testing proceed w/o the need for a patched
> kernel... if you could consider pulling it in that'd be great.
> 
> Dave, just out of curiosity, most other features sort of match between
> the "_has_*" and the flag names, is there a reason for the
> crc <-> sbv5 difference?  Just semantics, but just curious.
> 
> (i.e. xfs_sb_version_hasprojid32bit checks XFS_SB_VERSION2_PROJID32BIT,
> but xfs_sb_version_hascrc checks XFS_SB_VERSION_5)
> 
> Answering my own question maybe, I guess SB_VERSION_5 was conceived
> with crc already in place, so there's no need for a feature flag on
> top of the sb version, right...?

Exactly. New features that require feature flags will end up
following the flag/function name convention, but it's not necessary
in this case because V5 sb = CRCs enabled.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
