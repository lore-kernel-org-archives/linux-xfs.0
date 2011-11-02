Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2KMdii198195 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 15:22:40 -0500
Message-ID: <1320265355.3145.53.camel@doink>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
From: Alex Elder <aelder@sgi.com>
Date: Wed, 2 Nov 2011 15:22:35 -0500
In-Reply-To: <20111102194507.GA14429@infradead.org>
References: <1320156842.30281.28.camel@deadeye>
	<1320256339.3145.30.camel@doink> <20111102194507.GA14429@infradead.org>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Wed, 2011-11-02 at 15:45 -0400, Christoph Hellwig wrote:
> We should validate that the value isn't negative in xfs_iformat_*,
> although we currently don't do that.  It already verified that it
> fits into the XFS_DFORK_DSIZE, which should take care of fitting
> into 32-bits.  Adding another explicit check probably won't hurt,
> given that XFS_DFORK_DSIZE is calculated dynamically based on the
> fork offset.
> 

That's true, but there are other places where it gets
updated, yet not defensively validated.  For example,
in xfs_dir2_shrink_inode(), if:
    fsbno > (INT64_MAX >> mp->m_sb.sb_blocklog)
then the (signed) di_size field would be assigned
a value that exceeded its max representable value,
producing unreliable (implementation-defined) results.
That may well be an impossible situation, but it's
not obvious without really looking at the code.

It's a bit of a can of worms, which is why I suggested
just testing for this (unlikely) condition in
xfs_readlink() for now.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
