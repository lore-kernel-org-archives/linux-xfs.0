Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6AF737F3F
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 18:05:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38EB4304039
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 16:05:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	zLnJzLTj22NuVoRk for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 16:05:45 -0700 (PDT)
Date: Fri, 21 Jun 2013 09:05:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 39/48] mkfs.xfs: validate options for CRCs up front.
Message-ID: <20130620230534.GV29376@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-40-git-send-email-david@fromorbit.com>
	<20130620211747.GB7800@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130620211747.GB7800@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 20, 2013 at 04:17:47PM -0500, Geoffrey Wehrman wrote:
> On Fri, Jun 07, 2013 at 10:26:02AM +1000, Dave Chinner wrote:
> | From: Dave Chinner <dchinner@redhat.com>
> | 
> | With CRC enabled filesystems, certain options are now not optional
> | and so are always enabled. Validate these options up front and
> | abort if options are specified that cannot be set.
> | 
> | Signed-off-by: Dave Chinner <dchinner@redhat.com>
> | ---
> |  mkfs/xfs_mkfs.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
> |  1 file changed, 56 insertions(+), 5 deletions(-)
> | 
> | diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> | index 291bab4..9987dde 100644
> | --- a/mkfs/xfs_mkfs.c
> | +++ b/mkfs/xfs_mkfs.c
> ...
> | @@ -1754,6 +1754,57 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
> |  		logversion = 2;
> |  	}
> |  
> | +	/*
> | +	 * Now we have blocks and sector sizes set up, check parameters that are
> | +	 * no longer optional for CRC enabled filesystems.  Catch them up front
> | +	 * here before doing anything else.
> | +	 */
> | +	if (crcs_enabled) {
> | +		/* minimum inode size is 512 bytes, ipflag checked later */
> | +		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
> | +			fprintf(stderr,
> | +_("Minimum inode size for CRCs is %d bytes\n"),
> | +				1 << XFS_DINODE_DFL_CRC_LOG);
> | +			usage();
> | +		}
> 
> I am not satisfied with the explanation for not allowing 256 byte inodes
> with CRCs, and I am requesting that this limitation not be implemented.
> I have no issue with making the default inode size 512 bytes, but
> removing the option for 256 byte inodes is an issue, especially with the
> initial implementation.  Making the minimum inode size 256 is fine.

As I said on the call, it makes no sense to support 256 byte inodes
for CRC enabled filesystems for either a performance or a support
point of view. For the purpose of this discussion on the list, I'll
redo the calculations from first principles as the inode core size
has grown since these checks were originally done way back in 2008-
2009 so everyone can see why it doesn't make sense.

To start with, the inode core size for version 1/2 inodes (i.e.
without CRCs) is 100 bytes (including the di_next_unlinked field).
With the 8 byte alignment rounding that the forks need, that gives
us a literal area size of 152 bytes.

Back in 2008-2009, the new v3 inode format did not have all the self
describing metadata, and so the core size increased to about 140
bytes. This left roughly 112 bytes of literal space available.

With the addition of the extra self describing metadata, the new v3
inode has grown to it's current size of 176 bytes, bring the literal
area down to 80 bytes.  That's smaller than I realised it was....

The minimum physical inode fork sizes are defined in xfs_types.h:

/*
 * Min numbers of data/attr fork btree root pointers.
 */
#define MINDBTPTRS      3
#define MINABTPTRS      2

And their sizes are defined in xfs_bmap_btree.h:

#define XFS_BMDR_SPACE_CALC(nrecs) \
        (int)(sizeof(xfs_bmdr_block_t) + \
               ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))

So:
	minimum data fork size = XFS_BMDR_SPACE_CALC(3)
			       = 4 + 3 * (8 + 8)
			       = 52 bytes


	minimum attr fork size = XFS_BMDR_SPACE_CALC(2)
			       = 36 bytes

And when we align these to 8 byte, we have minimum sizes of 56 bytes
and 40 bytes for the data and attr forks respectively. That means we
need at least 96 bytes of literal space available in the inode

So, we have:
			literal space
		required		available
inode size			v2	old v3	final v3
256		  96		156	112	  80
512		  96		408	368	 336

And so for the final v3 inode format there is only be 80 bytes of
literal space available, which is not enough to fit minimally sized
data and attr forks simultaneously with a 256 byte inode size. i.e.
it's not a physically valid configuration.

IOWs, there's nothing to debate - 256 byte inodes in v3 format is
not physically possible with the current on-disk format
definitions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
