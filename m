Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48MhXtt035089 for <xfs@oss.sgi.com>; Tue, 8 May 2012 17:43:33 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	C3vk4AqB7P8Gy5Uf for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 15:43:31 -0700 (PDT)
Date: Wed, 9 May 2012 08:43:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/3] xfs: make largest supported offset less shouty
Message-ID: <20120508224330.GK5091@dastard>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<20120429125729.GU9541@dastard> <20120508181540.GN16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120508181540.GN16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, May 08, 2012 at 01:15:40PM -0500, Ben Myers wrote:
> On Sun, Apr 29, 2012 at 10:57:29PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > XFS_MAXIOFFSET() is just a simple macro that resolves to
> > mp->m_maxioffset. It doesn't need to exist, and it just makes the
> > code unnecessarily loud and shouty.
> > 
> > Make it quiet and easy to read.
> 
> Yep, looks good.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

I've got new versions that use s_maxbytes whih I need to post....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
