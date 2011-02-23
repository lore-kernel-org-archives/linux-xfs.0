Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NNhHbx091050 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 17:43:17 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 586F272D11D
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 15:46:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9Efb5M0XWVueAKwQ for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 15:46:00 -0800 (PST)
Date: Thu, 24 Feb 2011 10:45:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: inode flags check should use flags
Message-ID: <20110223234558.GL3166@dastard>
References: <1298500151-27017-1-git-send-email-david@fromorbit.com>
	<1298500306.2453.28.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298500306.2453.28.camel@doink>
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

On Wed, Feb 23, 2011 at 04:31:46PM -0600, Alex Elder wrote:
> On Thu, 2011-02-24 at 09:29 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The RT bitmap inode format flag check should use the flag, not the
> > bit definition. As a result, it is incorrectly detecting inodes with
> > the prealloc flag set as has having an invalid bit set.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com> 
> 
> Looks good.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

pushed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
