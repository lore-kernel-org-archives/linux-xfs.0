Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1CB77F50
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 02:34:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A88EB8F8070
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 00:34:38 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EccMcJGZVpBY6N9S for <xfs@oss.sgi.com>;
	Fri, 07 Mar 2014 00:34:33 -0800 (PST)
Date: Fri, 7 Mar 2014 19:34:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH] xfs: make superblock version checks reflect reality
Message-ID: <20140307083430.GQ6851@dastard>
References: <1394088890-10713-1-git-send-email-david@fromorbit.com>
	<20140306180534.GA305@infradead.org>
	<20140306225541.GL6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140306225541.GL6851@dastard>
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
Cc: xfs@oss.sgi.com

On Fri, Mar 07, 2014 at 09:55:41AM +1100, Dave Chinner wrote:
> On Thu, Mar 06, 2014 at 10:05:34AM -0800, Christoph Hellwig wrote:
> > On Thu, Mar 06, 2014 at 05:54:50PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We only support filesystems that have v2 directory support, and than
> > > means all the checking and handling of superblock versions prior to
> > > this support being added is completely unnecessary overhead.
> > > 
> > > Strip out all the version 1-3 support, sanitise the good version
> > > checking to reflect the supported versions, update all the feature
> > > supported functions and clean up all the support bit definitions to
> > > reflect the fact that we no longer care about Irix bootloader flag
> > > regions for v4 feature bits.
> > 
> > Good idea in general, I like it.
.....
> > >  static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
> > >  {
> > > -	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> > > -		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> > > -		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
> > > +	return !!(sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT);
> > >  }
> > 
> > As we reject filesystems without the nlink bit we should just be able
> > to kill all code protected by xfs_sb_version_hasnlink checks, shouldn't
> > we?
> > Same for addnlink.
> > dirv2 is another candidate.
> 
> Yes, that's true - but I think those are good candidates for
> separate patches that follow up on this one.

Ok, we don't reject filesystems that don't have the NLINK bit set.
Older filesystems that have only v1 inodes won't have that bit
set, and we didn't set NLINK by default in mkfs until late 2007.
Hence we need to keep some form of NLINK support around.

The alternative is to simply set the bit in the superblock if it is
not set, and then just assume everywhere that it is set and we are
using v2 inodes. That will get rid of the hasnlink/addnlink code
needed to modify the superblock when the link count goes above
MAX_NLINK_1, and will result in filesystems always converting v1
inodes to v2 inodes on writeback of dirty inodes. I don't see a
problem with taking this approach, bt maybe I'm missing something?

For the dirv2 function, it's only used for checking at mount time,
so if that is handled bu xfs_sb_good_version() we no longer need
it....

Your thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
