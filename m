Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7A6F7FD8
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 15:46:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F47AAC006
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 13:46:13 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qSUHaHYy3FXkz5sY for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 13:46:11 -0800 (PST)
Date: Wed, 4 Feb 2015 08:46:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: struct xfs_sb is no longer tied to the on-disk
	format
Message-ID: <20150203214608.GJ4251@dastard>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-2-git-send-email-david@fromorbit.com>
	<20150202084102.GA28121@infradead.org>
	<20150202193020.GJ6282@dastard>
	<20150203213744.GA31631@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150203213744.GA31631@infradead.org>
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

On Tue, Feb 03, 2015 at 01:37:44PM -0800, Christoph Hellwig wrote:
> On Tue, Feb 03, 2015 at 06:30:21AM +1100, Dave Chinner wrote:
> > > I'd expect to move it close to stuct xfs_mount, and maybe even merge
> > > it into that in the long run.
> > 
> > I guess moving the structure there is fine, but we still want all
> > the version functions to be shared with userspace, which then makes
> > for an interesting set of dependencies. Any other ideas?
> 
> Are they really worth the sharing?  If they are worth it we'll
> need somethign that can expect a xfs_sb/xfs_mount to be defined.

I suppose we could stop sharing them - they change rarely enough
and it's only a few lines of code for each new feature that would
then need to be duplicated. Not a huge burden...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
