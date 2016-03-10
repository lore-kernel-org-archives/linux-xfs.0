Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9CB87CA3
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 16:09:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9DFFA8F8040
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 14:09:53 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0qCiji7nAi3h0AIT for <xfs@oss.sgi.com>;
	Thu, 10 Mar 2016 14:09:47 -0800 (PST)
Date: Fri, 11 Mar 2016 09:09:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/16] xfs: rmap btree add more reserved blocks
Message-ID: <20160310220945.GY30721@dastard>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
	<1457410578-30233-4-git-send-email-david@fromorbit.com>
	<20160310142207.GD29058@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160310142207.GD29058@infradead.org>
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

On Thu, Mar 10, 2016 at 06:22:07AM -0800, Christoph Hellwig wrote:
> Sorry for the second reply to the same mail - I expect this defintion to
> be in patch 7, where it logically belongs..
> 
> > +#define	XFS_RMAP_BLOCK(mp) \
> >  	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
> >  	 XFS_FIBT_BLOCK(mp) + 1 : \
> >  	 XFS_IBT_BLOCK(mp) + 1)
> 
> Is there any good reason for the variable offset for the rmap block.
> Yes, it saves one otherwise unused block per AG, but fixed offsets
> for metadata make a format much easier to understand.

The root btree blocks are not a fixed location. The moment the tree
splits to the root we get a new root block and the old root is now
at a lower level of the tree. IOWs, it doesn't matter if there is a
hole at the time of growfs/mkfs laying out the initial tree roots
because they are going to move around anyway.

Also, it depends on the sector vs block size as to where these are
initially located, too. A disk with 512 byte sectors and 4k block
size results in the root btree blocks being located from fsb 2-7.
On a 4k sector/4k block size fs has the root btree blocks located
from fsb 4-9.

Hence I really don't think it matters if the initial location
changes depenedent on features and geometry as you have to look it
up with xfs_db anyway to find it even on a pristine new
filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
