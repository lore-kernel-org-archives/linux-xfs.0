Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 588AB7FFB
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 01:44:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 387BB8F80B9
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 23:44:24 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UaBMg4VdzkUZy8YC for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 23:44:18 -0800 (PST)
Date: Fri, 30 Jan 2015 18:44:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/9] xfs: XFS_IOCTL_SETXATTR can run in user namespaces
Message-ID: <20150130074416.GC4251@dastard>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-7-git-send-email-david@fromorbit.com>
	<20150129153515.GF17652@laptop.bfoster>
	<20150129235315.GG6282@dastard>
	<20150130030411.GA22916@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150130030411.GA22916@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: iustin@k1024.org, xfs@oss.sgi.com

On Thu, Jan 29, 2015 at 10:04:11PM -0500, Brian Foster wrote:
> On Fri, Jan 30, 2015 at 10:53:15AM +1100, Dave Chinner wrote:
> > On Thu, Jan 29, 2015 at 10:35:15AM -0500, Brian Foster wrote:
> > > Why not use != here? Looks fine, anyways:
> > 
> > Because ^ has an implicit cast of the variables to boolean (i.e flag
> > set or not), whereas != will only work if XFS_XFLAG_PROJINHERIT =
> > XFS_DIFLAG_PROJINHERIT. Given that the moment we add more DIFLAGs to
> > the xfs inode, the current "XFLAG value must match DIFLAG value"
> > rule is going to be broken, I think that logical evaluation is a
> > much safer practice for these types of comparisons.
> > 
> 
> Hrm, I'm not following how a boolean cast occurs here. Isn't ^ a bitwise
> operation?

Ah, yes, you are right. I'mi not sure what type of crack I was
smoking this morning (or when I wrote it). I'll fix it up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
