Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AFAC7F50
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 16:00:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE0D58F8037
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 14:00:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0wbBxXV8ASdnFXKc for <xfs@oss.sgi.com>;
	Thu, 26 Mar 2015 14:00:12 -0700 (PDT)
Date: Fri, 27 Mar 2015 07:59:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: disallow ro->rw remount on norecovery mount
Message-ID: <20150326205958.GD28129@dastard>
References: <55146612.1070306@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55146612.1070306@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 26, 2015 at 03:03:30PM -0500, Eric Sandeen wrote:
> There's a bit of a loophole in norecovery mount handling right
> now: an initial mount must be readonly, but nothing prevents
> a mount -o remount,rw from producing a writable, unrecovered
> xfs filesystem.
> 
> It might be possible to try to perform a log recovery when this
> is requested, but I'm not sure it's worth the effort.  For now,
> simply disallow this sort of transition.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Good catch.

Shouldn't this also check for a ro block device, and disallow the
rw remount if the block dev is ro?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
