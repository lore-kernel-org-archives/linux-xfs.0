Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VAWb3e167930 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 05:32:37 -0500
Date: Tue, 31 Jul 2012 06:32:34 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
Message-ID: <1945505398.1250534.1343730754291.JavaMail.root@redhat.com>
In-Reply-To: <20120730214946.GG2877@dastard>
Subject: Re: [PATCH 1/1] xfs: check for possible overflow in xfs_ioc_trim
MIME-Version: 1.0
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
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org, Ben Myers <bpm@sgi.com>, lczerner@redhat.com

> > +
> > +	if (range.start > ULLONG_MAX - BBSIZE)
> > +		return -XFS_ERROR(EINVAL);
> > +
> 
> There's no point checking for overflow on the range start - what we
> need to check is whether it is larger than the size of the
> filesystem. We do that after the conversion of range.start to basic
> blocks, so that check needs to be promoted to before this. i.e.
> 
> 	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
> 		return -XFS_ERROR(EINVAL);
> 
> >  	start = BTOBB(range.start);
> >  	end = start + BTOBBT(range.len) - 1;
> >  	minlen = BTOBB(max_t(u64, granularity, range.minlen));
> 
> And that will prevent the overflow in BTOBB() just as effectively...

You're right, that's a far better way, I'll change it so.

Thanks!

Tomas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
