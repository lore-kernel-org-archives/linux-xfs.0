Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 168E87FC6
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 22:01:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 037A8304039
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 20:01:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	aj4RLQ1nKlDPJtXh for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 20:00:59 -0700 (PDT)
Date: Thu, 11 Apr 2013 13:00:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reserve fields in inode for parent ptr and alloc
	policy
Message-ID: <20130411030057.GF10481@dastard>
References: <20130410182438.268267840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130410182438.268267840@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 10, 2013 at 01:24:24PM -0500, Mark Tinguely wrote:
> Reserve fields in new inode layout for parent pointer and
> allocation policy.

Not without a design review - there is no way we are going to
blindly reserve space in any on-disk structure without first having
a solid design, published proof-of-concept code and agreement that
the format changes being proposed are the right way to proceed.

Where are the design docs/code for these features?

> 		----
> The inode will hold the parent information for the first
> link to a file. Information for the other links will be
> held in extended attribute entries.
> 
> The "di_parino" is the inode of the parent directory. The
> directory information for this entry is located the parent
> directory with "di_paroff" offset. 
> 
> The di_parino/di_paroff concept code is running.

How does it handle hard links? (i.e. multiple parents)

Also, inode number is not enough for unique identification of the
parent - generation number is also required.

FWIW, lets go back to the (was almost finished) parent pointer
code from 2009:

http://oss.sgi.com/archives/xfs/2009-01/msg01068.html

That uses xattrs to store parent information - inode #, generation
#, and a counter - for each parent. It requires a counter because
you can have the same inode hard linked into the same parent
directory multiple times:

typedef struct xfs_parent_eaname_rec {
       __be64  p_ino;
       __be32  p_gen;
       __be32  p_cnt;
} xfs_parent_eaname_rec_t;

And a transaction appended to the the inode create, link, rename and
remove operations to manage the xattrs so all cases involving hard
links work just fine.

Indeed, the single di_parino/di_paroff concept was one of the
original designs considered because of it's simplicity, but it was
rejected because of that very simplicity - it cannot handle common
use cases involving hardlinks.

Release early, release often?

> 		----
> The "di_allocpolicy" will be used to remember the allocation
> policy associated with this inode.

This is exactly what we have padding in the inode for - so that
future additions to the on-disk inode can be added via feature bits
to indicate the fields are present. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
