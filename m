Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2JjC7G196428 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 14:45:14 -0500
Date: Wed, 2 Nov 2011 15:45:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
Message-ID: <20111102194507.GA14429@infradead.org>
References: <1320156842.30281.28.camel@deadeye>
	<1320256339.3145.30.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320256339.3145.30.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

We should validate that the value isn't negative in xfs_iformat_*,
although we currently don't do that.  It already verified that it
fits into the XFS_DFORK_DSIZE, which should take care of fitting
into 32-bits.  Adding another explicit check probably won't hurt,
given that XFS_DFORK_DSIZE is calculated dynamically based on the
fork offset.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
