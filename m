Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35AF37F50
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 16:39:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B34B8F8049
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 14:39:03 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8ZzXNYZaf7MBQ4SX for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 14:39:01 -0700 (PDT)
Date: Wed, 23 Apr 2014 07:38:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140422213857.GM18672@dastard>
References: <534EC073.8090006@sandeen.net>
 <534EC282.7010905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534EC282.7010905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 16, 2014 at 12:48:50PM -0500, Eric Sandeen wrote:
> XFS_ERROR was designed long ago to trap return values,
> but it's not runtime configurable, it's not consistently used,
> and we can do the same thing today with systemtap, using
> something like:
> 
> probe module("xfs").function("xfs_*").return { if (@defined($return) && $return == VALUE) { ... } }
> 
> Just nuke XFS_ERROR and associated bits.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Eric, given the rebasing impact of this change on other pending
work, I think we should plan to merge this just prior to the next
upstream merge. Perhaps regenerate it against the for-next branch
a week before the merge window is likely to open, and then apply
it? That way we (well, I) don't have to spend a alrge proportion of
this merge window fixing up patch mismatches vs the master branch?

Is that an acceptible approach for everyone?

(Note: I'm assuming Christoph is OK with this given the ftrace
scripts we can use to replace this macro...)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
