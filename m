Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FCF57CA8
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:49:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B678AC001
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:49:04 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5tYfUFzqS6tfKVfP for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:49:03 -0800 (PST)
Date: Wed, 17 Feb 2016 18:48:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/15] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160217074821.GD19486@dastard>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-12-git-send-email-david@fromorbit.com>
	<20160217073204.GB16363@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217073204.GB16363@infradead.org>
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

On Tue, Feb 16, 2016 at 11:32:04PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 17, 2016 at 06:20:48PM +1100, Dave Chinner wrote:
> > +
> > +	sbversion |= XFS_SB_VERSION_NLINKBIT;
> > +	setlink_inode(id, be32_to_cpu(dip->di_nlink), type == DBM_DIR, security);
> > +
> 
> So we always convert to v2 inodes here.  Given that's it's xfs_check
> it's only in-core so harmless, but a comment here might be useful.

Yeah, probably. I'll have to look at this a bit closer - I think I
assumed that we're always going to have v2 inode format here (like
we do in the kernel), but that may not be true. I'll have a closer
look.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
