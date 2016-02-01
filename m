Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5598B7CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 15:22:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38A0D8F8033
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 13:22:55 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LdSmuXzU0RaEOMEZ for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 13:22:52 -0800 (PST)
Date: Tue, 2 Feb 2016 08:22:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Split default quota limits by quota type V3
Message-ID: <20160201212238.GV6033@dastard>
References: <1454000266-22541-1-git-send-email-cmaiolino@redhat.com>
	<56AA51B7.7030403@sandeen.net> <20160201095707.GB8141@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160201095707.GB8141@redhat.com>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Feb 01, 2016 at 10:57:07AM +0100, Carlos Maiolino wrote:
> On Thu, Jan 28, 2016 at 11:36:55AM -0600, Eric Sandeen wrote:
> > On 1/28/16 10:57 AM, Carlos Maiolino wrote:
> > >  		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
> > >  
> > > -		/*
> > > -		 * The warnings and timers set the grace period given to
> > > -		 * a user or group before he or she can not perform any
> > > -		 * more writing. If it is zero, a default is used.
> > > -		 */
> > 
> > Not sure why you removed this comment?
> > 
> Regarding this comment, I think it's just redundant with the previous comment, I
> left it in the code for the V4 though, I believe Dave can rip it off if it is
> really redundant.

No, please don't ask me to do make random patch edits on commit -
it's your job as a patch submitter to get it right. I will sometimes
do this for simple patches or patches that come from a
never-seen-before-and-never-seen-again patch submitter, but for a
regular developer submitting non-trivial patches I won't change the
patches because the issue hasn't been sorted out during peer review.

Work it out with Eric, get a reviewed-by tag, and I'll apply it as
reviewed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
