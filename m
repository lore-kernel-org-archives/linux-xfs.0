Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 148147CA3
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:30:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E860D8F8039
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:30:04 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BZZMMttJHM5xBpUF for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2016 00:30:02 -0800 (PST)
Date: Wed, 17 Feb 2016 19:30:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/15] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160217083000.GG19486@dastard>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-12-git-send-email-david@fromorbit.com>
	<20160217073204.GB16363@infradead.org>
	<20160217074821.GD19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217074821.GD19486@dastard>
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

On Wed, Feb 17, 2016 at 06:48:21PM +1100, Dave Chinner wrote:
> On Tue, Feb 16, 2016 at 11:32:04PM -0800, Christoph Hellwig wrote:
> > On Wed, Feb 17, 2016 at 06:20:48PM +1100, Dave Chinner wrote:
> > > +
> > > +	sbversion |= XFS_SB_VERSION_NLINKBIT;
> > > +	setlink_inode(id, be32_to_cpu(dip->di_nlink), type == DBM_DIR, security);
> > > +
> > 
> > So we always convert to v2 inodes here.  Given that's it's xfs_check
> > it's only in-core so harmless, but a comment here might be useful.
> 
> Yeah, probably. I'll have to look at this a bit closer - I think I
> assumed that we're always going to have v2 inode format here (like
> we do in the kernel), but that may not be true. I'll have a closer
> look.

having a closer look, the XFS_SB_VERSION_NLINKBIT that is set here
in sbversion is never used, so I just removed it. I also changed it
back to using the converted in-memory link count so it's always
going to be correct now. Now it is just:

+       setlink_inode(id, xino.i_d.di_nlink, type == DBM_DIR, security);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
