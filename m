Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2PLxErh258368 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 16:59:14 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AD4D142C14C
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:02:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JSrg40DHRS8hO1M2 for <xfs@oss.sgi.com>;
	Fri, 25 Mar 2011 15:02:20 -0700 (PDT)
Date: Sat, 26 Mar 2011 09:02:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: preallocation transactions do not need to be
	synchronous
Message-ID: <20110325220216.GN26611@dastard>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-2-git-send-email-david@fromorbit.com>
	<1301086836.2537.679.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301086836.2537.679.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 25, 2011 at 04:00:36PM -0500, Alex Elder wrote:
> On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Preallocation and hole punch transactions are currently synchronous
> > and this is causing performance problems in some cases. The
> > transactions don't need to be synchronous as we don't need to
> > guarantee the preallocation is persistent on disk until a
> > fdatasync, fsync, sync operation occurs. If the file is opened
> > O_SYNC or O_DATASYNC, only then should the transaction be issued
> > synchronously.
> 
> There's a minor (but important) bug in this.  Other than that
> this looks good.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Already fixed and reposted.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
