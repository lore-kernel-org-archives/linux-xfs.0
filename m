Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03F597CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 13:50:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93010AC004
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 11:50:12 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DnTpYApoAmYIWniH for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 11:50:09 -0800 (PST)
Date: Tue, 9 Feb 2016 06:50:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: mode di_mode to vfs inode
Message-ID: <20160208195008.GH27429@dastard>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-10-git-send-email-david@fromorbit.com>
	<20160208094239.GD4487@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208094239.GD4487@infradead.org>
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

On Mon, Feb 08, 2016 at 01:42:39AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 08, 2016 at 03:24:21PM +1100, Dave Chinner wrote:
> > -	ASSERT(!(S_ISREG(ip->i_d.di_mode) && whichfork == XFS_DATA_FORK));
> > +	ASSERT(!(S_ISREG(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK));
> 
> Maybe it's worth adding XFS_ISDIR/REG/.. helpers for all these checks?

Makes sense - I think I'll do that as a followup patch, though,
along with further icdinode cleanups.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
