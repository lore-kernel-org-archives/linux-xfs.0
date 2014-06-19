Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CECF529DF8
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 16:14:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5AD08AC002
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 14:14:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	q2YXRi38APuB4Mqs for <xfs@oss.sgi.com>;
	Thu, 19 Jun 2014 14:14:17 -0700 (PDT)
Date: Fri, 20 Jun 2014 07:14:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] repair: support more than 25 ACLs
Message-ID: <20140619211414.GS9508@dastard>
References: <1403156032-18525-1-git-send-email-david@fromorbit.com>
	<1403156032-18525-2-git-send-email-david@fromorbit.com>
	<20140619130144.GA9043@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140619130144.GA9043@bfoster.bfoster>
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

On Thu, Jun 19, 2014 at 09:01:45AM -0400, Brian Foster wrote:
> On Thu, Jun 19, 2014 at 03:33:51PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > v5 superblock supports many more than 25 ACLs on an inode, but
> > xfs_repair still thinks that the maximum is 25. Fix it and update
> > the ACL definitions to match the kernel definitions. Also fix the
> > remote attr maximum size off-by-one that the maximum number of v5
> > ACLs tickles.
> > 
> > Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> This mostly looks good to me, though it seems like it could at least
> split into a couple patches. A minor question below...

I wrote it as a single patch to make it easy for Michael to test,
and I found several issues along the way...

> >  libxfs/xfs_attr_remote.c |  2 +-
> >  repair/attr_repair.c     | 74 ++++++++++++++++++++++++++++++++----------------
> >  repair/attr_repair.h     | 46 +++++++++++++++++++++---------
> >  3 files changed, 84 insertions(+), 38 deletions(-)
> > 
> > diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
> > index 5cf5c73..08b983b 100644
> > --- a/libxfs/xfs_attr_remote.c
> > +++ b/libxfs/xfs_attr_remote.c
> > @@ -85,7 +85,7 @@ xfs_attr3_rmt_verify(
> >  	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
> >  		return false;
> >  	if (be32_to_cpu(rmt->rm_offset) +
> > -				be32_to_cpu(rmt->rm_bytes) >= XATTR_SIZE_MAX)
> > +				be32_to_cpu(rmt->rm_bytes) > XATTR_SIZE_MAX)
> 
> Corresponds to kernel commit:
> 
> bba719b5 xfs: fix off-by-one error in xfs_attr3_rmt_verify

Yup, I'll note that.

> > @@ -1624,7 +1639,16 @@ xfs_acl_from_disk(struct xfs_acl **aclp, struct xfs_acl_disk *dacl)
> >  
> >  
> >  	end = &dacl->acl_entry[0] + count;
> > -	acl = malloc((int)((char *)end - (char *)dacl));
> > +	size = sizeof(dacl->acl_cnt) + (count * sizeof(struct xfs_acl_entry));
> > +	if (size != (int)((char *)end - (char *)dacl)) {
> > +		do_warn(_("ACL count (%d) does not match buffer size (%d/%d)\n"),
> > +			  count, size, (int)((char *)end - (char *)dacl));
> > +		*aclp = NULL;
> > +		return EINVAL;
> > +	}
> 
> This size check seems superfluous. In what scenario could it fail?

Kernel writes a corrupted ACL? Cosmic ray causes a single bit error
in a sector on a non-crc filesystem? We do checks like these on
variable size structures in many other places - not just ACLs - for
verifying internal consistency of the structure we are parsing....

> >  
> > +/*
> > + * The number of ACL entries allowed is defined by the on-disk format.
> > + * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
> > + * limited only by the maximum size of the xattr that stores the information.
> > + */
> > +#define XFS_ACL_MAX_ENTRIES(mp) \
> > +	(xfs_sb_version_hascrc(&mp->m_sb) \
> > +		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
> > +						sizeof(struct xfs_acl_entry) \
> > +		: 25)
> > +
> > +#define XFS_ACL_MAX_SIZE(mp) \
> > +	(sizeof(struct xfs_acl) + \
> > +		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
> >  
> 
> Mostly corresponds to kernel commit:
> 
> 0a8aa193 xfs: increase number of ACL entries for V5 superblocks

Mostly, but it's a completely separate set of definitions to the
kernel and libxfs. Maybe at some point we should revisit that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
