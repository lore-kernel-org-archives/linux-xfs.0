Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24M2vgW200536 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 16:02:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF63513F8EEB
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 14:04:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	XRhixJrRGfi912LP for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 14:04:24 -0800 (PST)
Date: Fri, 5 Mar 2010 09:04:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsqa: define resblks for tests near ENOSPC
Message-ID: <20100304220421.GJ14317@discord.disaster>
References: <1267667254-7971-1-git-send-email-david@fromorbit.com>
	<20100304135623.GB31753@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100304135623.GB31753@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Mar 04, 2010 at 08:56:23AM -0500, Christoph Hellwig wrote:
> On Thu, Mar 04, 2010 at 12:47:34PM +1100, Dave Chinner wrote:
> > +	# fix the reserve block pool to a known size so that the enospc
> > +	# calculations work out correctly.
> > +	xfs_io -x -c "resblks 1024" $SCRATCH_MNT > /dev/null 2>&1
> 
> What about a _scratch_resvblks helper - that means we could also
> add noops for non-xfs filesystems there easily.

Good idea. I'll rework the patch to do this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
