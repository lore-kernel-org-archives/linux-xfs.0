Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6697uK2098917 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 04:07:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27A1B4F2D9
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 02:07:54 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DbeAsbAwgR0EhPIm for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2011 02:07:54 -0700 (PDT)
Date: Wed, 6 Jul 2011 05:07:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/27] xfs: use generic get_unaligned_beXX helpers
Message-ID: <20110706090754.GI19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.763430916@bombadil.infradead.org>
	<20110706034421.GQ1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706034421.GQ1026@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jul 06, 2011 at 01:44:21PM +1000, Dave Chinner wrote:
> Hmmmm. I wonder if it is a hold-over from the days of 4GB AGs?

Probably.

> That would have meant inode numbers used 6 bits for the chunk index,
> 2^22 - 2^6 for the agbno and 2^32 for the agno, which gives 54 bits
> maximum inode number and so XFS_MAXINUMBER @ 56 bits makes sense, as
> does the zero high byte in the dir2 inode number.
> 
> Now we have 2^30 bits for the agbno+chunk index, and 32 bits for the
> agno, so inode numbers can reach 62 bits, which is outside the range
> of the 56-bit MAXINUMBER limit.
> 
> So my questions are now this:
> 	- did we lose that checking when we converted the rest of
> 	  the directory code to use the generic byte swapping
> 	  functions?

The history lesson tells us:

Before my commit

	"Fix and streamline directory inode number handling"

we didn't do any capping for them in Linux since the early days
of adding byte swaping support.  However my commit was modelled
after the original IRIX code, which had the same behaviour as my
code in the same XFS_DI_LO/HI helpers.

Even back then XFS_GET_DIR_INO8/XFS_SET_DIR_INO8 were only
used by the dir2_sf code, but the dirv1 used a similar XFS_GET_DIR_INO
macro for all read accesses, which had the same limitation.  Writes
on the other hand were done using XFS_DIR_SF_PUT_DIRINO (even for
non-shortform directories), which did not discard the most significant
bytes.

> 	- do we need to increase XFS_MAXINUMBER to reflect the
> 	  current reality of 1TB AGs and simply ignore the zero high
> 	  byte restriction?

I think so.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
