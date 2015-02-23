Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F12B7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 15:58:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ACA38F80CB
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 13:58:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vvDuZpPFiyppVcxP for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 13:58:04 -0800 (PST)
Date: Tue, 24 Feb 2015 08:58:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid firstused overflow in attr3 leaf header with
	64k blocks
Message-ID: <20150223215802.GV4251@dastard>
References: <1424722050-24149-1-git-send-email-bfoster@redhat.com>
	<54EB8E5D.8080905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54EB8E5D.8080905@sandeen.net>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Feb 23, 2015 at 02:32:29PM -0600, Eric Sandeen wrote:
> On 2/23/15 2:07 PM, Brian Foster wrote:
> > The attr3 leaf header has a 16-bit firstused field that tracks the first
> > used entry offset. This field is initialized to the block size in
> > xfs_attr3_leaf_create() and updated accordingly in
> > xfs_attr3_leaf_add_work() when new attributes are added.
> > 
> > The initialization of firstused overflows if the block size exceeds
> > 16-bits. E.g., xfstests test generic/117 causes assert failures on a
> > -bsize=64k fs on ppc64 because ichdr.firstused evaluates to 0.
> 
> cool :)
> 
> > Update the firstused initialization to not exceed the maximum value of
> > an unsigned short. This avoids the overflow to 0 and allows firstused to
> > be updated appropriately on subsequent xattr addition. Also update the
> > freemap size calculation to use the actual block size rather than the
> > potentially minimized version stored in firstused.
> 
> I'm a little scared by this; does this truncated value risk going to disk?
> (Yes, I think so.)  Is that ok?	 Does that ... mean we lose a byte of space
> we'd otherwise have?  Maybe that's ok ...
> 
> FWIW, I think the same problem exists in xfs_attr3_leaf_compact():
> 
>         /* Initialise the incore headers */
>         ichdr_src = *ichdr_dst; /* struct copy */
>         ichdr_dst->firstused = args->geo->blksize;
> 
> and xfs_attr3_leaf_unbalance():
> 
>                 tmphdr.firstused = state->args->geo->blksize;

And a loop in xfs_attr3_leaf_remove() that does:

		tmp = args->geo->blksize;
		.....
		ichdr.firstused = tmp;

so if the the loop in between does not modify tmp...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
